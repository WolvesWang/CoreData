//
//  WBHTTPChannel.m
//  CoreData
//
//  Created by wangwenbing on 2017/3/2.
//  Copyright © 2017年 Centit. All rights reserved.
//
#import "AFURLSessionManager.h"
#import "WBHTTPChannel.h"
#import <arpa/inet.h>
#import "WBURLAuthenticationChallenge.h"

#define WBHTTPCHANNEL_USE_IP_ADDRESS  1  // 是否使用IP地址
#define MOCK_SERVER_TESTING 0
#define MOCK_SERVER_URL @"http://private-d6a4e0-360flythunderdomerest.apiary-mock.com/360fly/" //模拟服务器地址

typedef NSURLSessionAuthChallengeDisposition(^AFURLSessionTaskDidReciveAuthticationChallengeBlock)(NSURLSession *session,
NSURLSessionTask *task, NSURLAuthenticationChallenge *challenge, NSURLCredential * __autoreleasing * credential);

@interface WBHTTPChannel ()

//NSURLSessionDelegate

 /* If implemented, when a connection level authentication challenge
 * has occurred, this delegate will be given the opportunity to
 * provide authentication credentials to the underlying
 * connection. Some types of authentication will apply to more than
 * one request on a given connection to a server (SSL Server Trust
 * challenges).  If this delegate message is not implemented, the
 * behavior will be to use the default handling, which may involve user
 * interaction.
 */
/*
- (void)URLSession:(NSURLSession *)session didReceiveChallenge:(NSURLAuthenticationChallenge *)challenge
 completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition disposition, NSURLCredential * _Nullable credential))completionHandler;

 */

@property (atomic, readwrite, assign) NSTimeInterval shortTimeoutInterval;


@property (atomic, readwrite, strong) AFURLSessionManager *downloadSessionManger;



@property (atomic, readwrite, copy) NSString *identifier;

@property (atomic, readwrite, assign) FLYChannelConnectionStatus status;
@end

@interface WBHTTPChannel (WBRequest) <WBDeviceProtocol>

@end

@implementation WBHTTPChannel

- (instancetype)initWithIdentifier:(NSString *)identifier baseURL:(NSURL *)url address:(NSArray *)address
{
    
    #if FLYHTTPCHANNEL_USE_IP_ADDRESS
    NSMutableCharacterSet *invalidCharacterSet = [[NSCharacterSet decimalDigitCharacterSet] mutableCopy];
    
    [invalidCharacterSet addCharactersInString:@"."];
    [invalidCharacterSet invert];
    NSString *urlString = @"";
    NSString *host = [url host];
    NSRange range = [host rangeOfCharacterFromSet:invalidCharacterSet];
    
    if (NSNotFound != range.location) {
        // Resolve the hostname to an IP Address.
        NSURLComponents *urlComponents = [NSURLComponents componentsWithURL:url resolvingAgainstBaseURL:NO];
        //		NSArray *addresses = IPAddressesFromHostname(host);
        
        if (0 < [addresses count]) {
            struct sockaddr *addressGeneric;
            
            NSData *ipData = [addresses objectAtIndex:0];
            addressGeneric = (struct sockaddr *)ipData.bytes;
            
            switch( addressGeneric->sa_family ) {
                case AF_INET: {
                    struct sockaddr_in *ip4;
                    char dest[INET_ADDRSTRLEN];
                    ip4 = (struct sockaddr_in *) [ipData bytes];
                    urlString = [NSString stringWithCString: inet_ntop(AF_INET, &ip4->sin_addr, dest, sizeof dest) encoding: NSUTF8StringEncoding];
                }
                    break;
                    
                case AF_INET6: {
                    struct sockaddr_in6 *ip6;
                    char dest[INET6_ADDRSTRLEN];
                    ip6 = (struct sockaddr_in6 *) [ipData bytes];
                    urlString = [NSString stringWithCString: inet_ntop(AF_INET6, &ip6->sin6_addr, dest, sizeof dest) encoding: NSUTF8StringEncoding];
                }
                    break;
                default:
                    break;
            }
            
            
            
            [urlComponents setHost:urlString];
            
            url = [urlComponents URL];
        }
    }
#endif

#if MOCK_SERVER_TESTING
    self = [super initWithBaseURL:[NSURL URLWithString:MOCK_SERVER_URL] sessionConfiguration:nil];
#else
    self = [super initWithBaseURL:url sessionConfiguration:nil];
#endif
    if (self) {
       /*
        是否需要账号，密码进行认证
       
         
        [self setSessionDidReceiveAuthenticationChallengeBlock:^NSURLSessionAuthChallengeDisposition(NSURLSession * _Nonnull session, NSURLAuthenticationChallenge * _Nonnull challenge, NSURLCredential *__autoreleasing  _Nullable * _Nullable credential) {
            NSURLSessionAuthChallengeDisposition result = FLYURLAuthenticationChallenge(challenge, credential);
            
            return result;
            
        }];
        
        [self setTaskDidReceiveAuthenticationChallengeBlock:^NSURLSessionAuthChallengeDisposition(NSURLSession * _Nonnull session, NSURLSessionTask * _Nonnull task, NSURLAuthenticationChallenge * _Nonnull challenge, NSURLCredential *__autoreleasing  _Nullable * _Nullable credential) {
            
            NSURLSessionAuthChallengeDisposition result = FLYURLAuthenticationChallenge(challenge, credential);
            
            return result;
        }];
       
         */
        [self setIdentifier:identifier];
        [self setShortTimeoutInterval:5.0];
#if FLYHTTPCHANNEL_USE_IP_ADDRESS
        
        struct sockaddr_in address;
        memset((char *) &address, sizeof(struct sockaddr_in), 0);
        address.sin_family = AF_INET;
        address.sin_len = sizeof(struct sockaddr_in);
        
        int conversionResult = inet_pton(AF_INET, [[url host] UTF8String], &(address.sin_addr));
        if (1 != conversionResult) {
            NSAssert1(conversionResult != 1, @"Failed to convert the IP address string into a sockaddr_in: %@", [url host]);
        }
        
        AFNetworkReachabilityManager *reachabilityManager = [AFNetworkReachabilityManager managerForAddress:&address];
#else
        AFNetworkReachabilityManager *reachabilityManager = [AFNetworkReachabilityManager managerForDomain:[url host]];
#endif
        
        [self setReachabilityManager:reachabilityManager];
        
        [reachabilityManager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
   
            
            switch (status) {
                case AFNetworkReachabilityStatusNotReachable:
                    
                    break;
                case AFNetworkReachabilityStatusReachableViaWiFi:
                    
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"FLYDeviceHTTPReachabilityStatusNotification" object:nil];
                    break;
                case AFNetworkReachabilityStatusUnknown:
                default:
                    break;
            }
            
        }];
        [reachabilityManager startMonitoring];
        
        // Prepare the session manager with appropriate serializers
        AFJSONRequestSerializer *jsonRequestSerializer = [AFJSONRequestSerializer serializerWithWritingOptions:0];
        
        [self setRequestSerializer:jsonRequestSerializer];
        
        AFJSONResponseSerializer *jsonSerializer = [AFJSONResponseSerializer serializer];
        AFImageResponseSerializer *imageSerializer = [AFImageResponseSerializer serializer];
        /*
         
        FLYH264ThumbnailResponseSerializer *thumbnailPP = [FLYH264ThumbnailResponseSerializer thumbnailResponseSerializerWithMaximumSize:CGSizeZero];
         */
        AFCompoundResponseSerializer *compoundSerializer = [AFCompoundResponseSerializer compoundSerializerWithResponseSerializers:@[jsonSerializer, imageSerializer]];
        
        [self setResponseSerializer:compoundSerializer];
    }
    return self;
}

- (NSUInteger)hash
{
    return [[self identifier] hash];
}

- (BOOL)isEqual:(WBHTTPChannel *)object
{
    if([object isKindOfClass:[WBHTTPChannel class]])
    {
        return [[self identifier] isEqual:[object identifier]];
    }
    return [super isEqual:object];
}


- (void)requestInfo {
    NSDictionary *dict = @{@"1":@"3",@"love": @"小米"};
    
    NSLog(@"%@",dict);
    
}
@end

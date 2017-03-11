//
//  WBHTTPListenter.m
//  CoreData
//
//  Created by wangwenbing on 2017/3/3.
//  Copyright © 2017年 Centit. All rights reserved.
//

#import "WBHTTPListenter.h"

#import "WBHTTPChannel.h"
#import "WBIPAddressUtility.h"
#import "NSNetService+ReconfirmRecord.h"
#import "Reachability.h"
#import <SystemConfiguration/CaptiveNetwork.h>

#import <arpa/inet.h>

#define FLY_NETSERVICE_DELEGATE_LOGGING	0

static NSString *kFLYHTTPListenerServiceType = @"_360fly._tcp.";
NSString *FLYHTTPChannelDidAppearNotification = @"FLYHTTPChannelDidAppearNotification";
NSString *FLYHTTPChannelDidDisappearNotification = @"FLYHTTPChannelDidDisappearNotification";
NSString *FLYHTTPChannelInvalidateAllHTTPChannelsNotification = @"FLYHTTPChannelInvalidateAllHTTPChannelsNotification";

@interface WBHTTPListenter ()

@property (atomic, readonly, strong) NSArray *devices;
@property (atomic, readwrite, strong) NSNetServiceBrowser *nsBrowser;
@property (atomic, readwrite, strong) NSMapTable *deviceMap;
@property (atomic, readwrite, copy) NSString *lastConnectedNetworkSSID;
@property (atomic, readwrite, strong) Reachability *reachability;

@end

@implementation WBHTTPListenter

+ (NSString *)currentConnectedNetworkBSSID;
{
    return [[WBHTTPListenter sharedHTTPListener] networkInfoForKey:@"BSSID"];
}

+ (NSString *)currentConnectedNetworkSSID;
{
    return [[WBHTTPListenter sharedHTTPListener] networkInfoForKey:@"SSID"];
}

- (NSString *)networkInfoForKey:(NSString *)key;
{
    NSAssert(([key isEqualToString:@"BSSID"] || [key isEqualToString:@"SSID"]), @"key should be either BSSID or SSID");
    
    CFArrayRef interfacesCF = CNCopySupportedInterfaces();
    NSArray *interfaces = (__bridge NSArray *)interfacesCF;
    NSMutableArray *connectedNetworkInfos = [NSMutableArray array];
    
    if (nil != interfaces) {
        for (NSString *interface in interfaces) {
            CFStringRef interfaceCF = (__bridge CFStringRef)interface;
            CFDictionaryRef networkInfoCF = CNCopyCurrentNetworkInfo(interfaceCF);
            NSDictionary *networkInfo = (__bridge NSDictionary *)networkInfoCF;
            
            if (nil != networkInfo) {
                NSString *connectedNetworkInfo = [networkInfo objectForKey:key];
                
                if (nil != connectedNetworkInfo) {
                    [connectedNetworkInfos addObject:connectedNetworkInfo];
                }
                
                CFRelease(networkInfoCF);
            }
        }
        
        CFRelease(interfacesCF);
    }
    
    NSString *currentConnectedNetworkInfo = nil;
    
    if (0 < [connectedNetworkInfos count]) {
        currentConnectedNetworkInfo = [connectedNetworkInfos objectAtIndex:0];
        
        if (1 < [connectedNetworkInfos count]) {
            NSLog(@"%@ %@ More than one SSID available: %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd), connectedNetworkInfos);
        }
    }
    
    return currentConnectedNetworkInfo;
}

- (void)reconfirmNetworkServiceRecordForDevice:(WBHTTPChannel *)httpChannel;
{
#if FLY_NETSERVICE_DELEGATE_LOGGING
    NSLog(@"%s", __PRETTY_FUNCTION__);
#endif
    
    NSMapTable *deviceMap = [self deviceMap];
    
    @synchronized(deviceMap) {
        NSEnumerator *keyEnumerator = [deviceMap keyEnumerator];
        NSNetService *netService = nil;
        
        while (nil != (netService = [keyEnumerator nextObject])) {
           WBHTTPChannel *netServiceHTTPChannel = [deviceMap objectForKey:netService];
            
            if (YES == [netServiceHTTPChannel isEqual:httpChannel]) {
                [netService reconfirmRecord];
            }
        }
    }
    
    return;
}

- (void)reconfirmRecords;
{
#if FLY_NETSERVICE_DELEGATE_LOGGING
    NSLog(@"%s", __PRETTY_FUNCTION__);
#endif
    
    NSMapTable *deviceMap = [self deviceMap];
    
    @synchronized(deviceMap) {
        NSEnumerator *keyEnumerator = [deviceMap keyEnumerator];
        NSNetService *netService = nil;
        
        while (nil != (netService = [keyEnumerator nextObject])) {
            [netService reconfirmRecord];
        }
    }
    return;
}

- (BOOL)checkIfWiFiNetworkAvailable;
{
    static NSString *lastConnectedNetworkSSID = nil;
    NSString *currentConnectedNetworkSSID = [WBHTTPListenter currentConnectedNetworkSSID];
    
    // If the last network is nil, the current network is nil or the last and the
    // current are not the same network invalidate all known network services.
    if (nil == lastConnectedNetworkSSID || nil == currentConnectedNetworkSSID) {
#if FLY_NETSERVICE_DELEGATE_LOGGING
        NSLog(@"%@ %@ invalidateKnownNetServices last: %@ current: %@ different: %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd), lastConnectedNetworkSSID, currentConnectedNetworkSSID, [lastConnectedNetworkSSID isEqualToString:currentConnectedNetworkSSID] ? @"NO" : @"YES");
#endif
        
        [self reconfirmRecords];
    }
    
    lastConnectedNetworkSSID = currentConnectedNetworkSSID;
    
    BOOL result = (nil != currentConnectedNetworkSSID);
    
    return result;
}

+ (WBHTTPListenter *)sharedHTTPListener;
{
    static WBHTTPListenter *sharedHTTPListener = nil;
    static dispatch_once_t once;
    
    dispatch_once(&once, ^{
        sharedHTTPListener = [[WBHTTPListenter alloc] init];
    });
    
    return sharedHTTPListener;
}

+ (NSSet *)keyPathsForValuesAffectingDevices
{
    return [NSSet setWithObject:@"deviceMap"];
}

+ (BOOL)automaticallyNotifiesObserversOfDevices
{
    return NO;
}

- (instancetype)init;
{
    self = [super init];
    
    if (nil != self) {
        NSNetServiceBrowser *browser = [[NSNetServiceBrowser alloc] init];
        [browser setDelegate:self];
        [self setNsBrowser:browser];
        
        [self setDeviceMap:[NSMapTable strongToStrongObjectsMapTable]];
        
        NSNotificationCenter *defaultCenter = [NSNotificationCenter defaultCenter];
        
        [defaultCenter addObserver:self selector:@selector(reachabilityChanged:) name:kReachabilityChangedNotification object:nil];
        
        Reachability *reachability = [Reachability reachabilityWithHostName:@"360fly.com"];
        
        [self setReachability:reachability];
    }
    
    return self;
}

- (void)dealloc;
{
    NSNotificationCenter *defaultCenter = [NSNotificationCenter defaultCenter];
    
    [defaultCenter removeObserver:self];
    
    return;
}

- (void)reachabilityChanged:(NSNotification *)notification;
{
#if FLY_NETSERVICE_DELEGATE_LOGGING
    NSLog(@"%s", __PRETTY_FUNCTION__);
#endif
    
    [self checkIfWiFiNetworkAvailable];
    
    return;
}

- (void)startScanning;
{
#if FLY_NETSERVICE_DELEGATE_LOGGING
    NSLog(@"%s", __PRETTY_FUNCTION__);
#endif
    
    [self checkIfWiFiNetworkAvailable];
    
    NSMapTable *deviceMap = [self deviceMap];
    
    @synchronized(deviceMap) {
        [deviceMap removeAllObjects];
    }
    
    [self.nsBrowser searchForServicesOfType:kFLYHTTPListenerServiceType inDomain:@""];
    
    return;
}

- (void)stopScanning;
{
#if FLY_NETSERVICE_DELEGATE_LOGGING
    NSLog(@"%s", __PRETTY_FUNCTION__);
#endif
    
    NSNetServiceBrowser *browser = [self nsBrowser];
    [browser stop];
    
    return;
}

- (NSArray *)devices
{
    NSMutableArray *devices = [NSMutableArray array];
    NSMapTable *deviceMap = [self deviceMap];
    
    @synchronized(deviceMap) {
        for (id object in deviceMap) {
            if (![object isKindOfClass:[NSNull class]]) {
                [devices addObject:object];
            }
        }
    }
    
    [devices sortUsingComparator:^NSComparisonResult(WBHTTPChannel *obj1, WBHTTPChannel *obj2) {
        return [[obj1 identifier] compare:[obj2 identifier]];
    }];
    
    return devices;
}

- (NSURL *)baseURLForDeviceFromService:(NSNetService *)service
{
    NSURL *deviceURL = nil;
    
    // Make a device for service
    if ([service hostName]) {
        NSURLComponents *urlComp = [[NSURLComponents alloc] init];
        
        [urlComp setScheme:@"https"];
        [urlComp setPath:@"/360fly/"];
        [urlComp setHost:[service hostName]];
        
        NSInteger port = [service port];
        
        // error case, port should always be supplied
        if (-1 == port) {
            [urlComp setScheme:@"http"];
        }
        // 360fly standard
        else if (443 == port || 80 == port) {
            [urlComp setScheme:@"https"];
        }
        // Bullet
        else if (8080 == port) {
            [urlComp setScheme:@"http"];
        }
        
        // http, https automatically use the correct ports
        if (-1 != port && 80 != port && 443 != port) {
            [urlComp setPort:@([service port])];
        }
        
        //		NSData *txtData = [service TXTRecordData];
        //		NSDictionary *dict = [NSNetService dictionaryFromTXTRecordData:txtData];
        //
        //		if (dict) {
        //			NSData *pathData = nil;
        //			NSData *schemeData = nil;
        //
        //			if ((pathData = dict[@"path"])) {
        //				NSString *pathStr = [NSString stringWithUTF8String:[pathData bytes]];
        //				[urlComp setPath:pathStr];
        //			}
        //			if ((schemeData = dict[@"scheme"])) {
        //				NSString *schemeStr = [NSString stringWithUTF8String:[schemeData bytes]];
        //				[urlComp setScheme:schemeStr];
        //			}
        //		}
        
        deviceURL = [urlComp URL];
    }
    
    return deviceURL;
}

#pragma mark - NSNetServiceBrowserDelegate

/* Sent to the NSNetServiceBrowser instance's delegate for each service discovered. If there are more services, moreComing will be YES. If for some reason handling discovered services requires significant processing, accumulating services until moreComing is NO and then doing the processing in bulk fashion may be desirable.
 */
- (void)netServiceBrowser:(NSNetServiceBrowser *)netServiceBrowser didFindService:(NSNetService *)netService moreComing:(BOOL)moreComing
{
#if FLY_NETSERVICE_DELEGATE_LOGGING
    NSString *serviceName = [NSString stringWithFormat:@"%@.%@%@", [netService name], [netService type], [netService domain]];
    
    NSLog(@"%s %@", __PRETTY_FUNCTION__, serviceName);
#endif
    
    [netService setDelegate:self];
    [netService resolveWithTimeout:5.0];
    
    NSMapTable *deviceMap = [self deviceMap];
    
    @synchronized(deviceMap) {
        [deviceMap setObject:[NSNull null] forKey:netService];
    }
    
    return;
}

/* Sent to the NSNetServiceBrowser instance's delegate when a previously discovered service is no longer published.
 */
- (void)netServiceBrowser:(NSNetServiceBrowser *)netServiceBrowser didRemoveService:(NSNetService *)netService moreComing:(BOOL)moreComing
{
#if FLY_NETSERVICE_DELEGATE_LOGGING
    NSString *serviceName = [NSString stringWithFormat:@"%@.%@%@", [netService name], [netService type], [netService domain]];
    
    NSLog(@"%s %@", __PRETTY_FUNCTION__, serviceName);
#endif
    
    NSMapTable *deviceMap = [self deviceMap];
    
    @synchronized(deviceMap) {
        WBHTTPChannel *device = [deviceMap objectForKey:netService];
        
        if (nil != device && YES == [device isKindOfClass:[WBHTTPChannel class]]) {
            NSNotificationCenter *defaultCenter = [NSNotificationCenter defaultCenter];
            
            [defaultCenter postNotificationName:FLYHTTPChannelDidDisappearNotification object:device];
        }
        else {
            if(device != nil) {
                NSLog(@"%s found a non FLYHTTPChannel in the device map (%@)", __PRETTY_FUNCTION__, [device class]);
                
            } else {
                NSLog(@"%s no device to remove HTTPChannel", __PRETTY_FUNCTION__);
            }
        }
        
        [self willChangeValueForKey:@"devices"];
        [deviceMap removeObjectForKey:netService];
        [self didChangeValueForKey:@"devices"];
    }
    
    return;
}

#pragma mark - NSNetServiceDelegate

- (void)netServiceWillResolve:(NSNetService *)netService;
{
#if FLY_NETSERVICE_DELEGATE_LOGGING
    NSString *serviceName = [NSString stringWithFormat:@"%@.%@%@", [netService name], [netService type], [netService domain]];
    
    NSLog(@"%s %@", __PRETTY_FUNCTION__, serviceName);
#endif
    
    return;
}

- (void)netService:(NSNetService *)netService didNotResolve:(NSDictionary *)errorDict;
{
#if FLY_NETSERVICE_DELEGATE_LOGGING
    NSString *serviceName = [NSString stringWithFormat:@"%@.%@%@", [netService name], [netService type], [netService domain]];
    
    NSLog(@"%s %@ error: %@", __PRETTY_FUNCTION__, serviceName, errorDict);
#endif
    
    [netService reconfirmRecord];
    
    return;
}
- (BOOL)networkDeviceOnline:(struct sockaddr*)addr
{
    SCNetworkReachabilityFlags  flags = 0;
    SCNetworkReachabilityRef    netReachability;
    BOOL                        retrievedFlags = NO;
    
    netReachability  = SCNetworkReachabilityCreateWithAddress(NULL, addr);
    if (netReachability) {
        retrievedFlags = SCNetworkReachabilityGetFlags(netReachability, &flags);
        CFRelease(netReachability);
    }
    if (!retrievedFlags || !flags) {
        return NO;
    }
    return YES;
}
- (BOOL)containValidIPAddress:(NSArray<NSData*> *)addresses
{
    // Perform appropriate logic to ensure that [netService addresses]
    // contains valid IPv4 address to connect to the service
    
    for (NSData* myData in addresses) {
#if FLY_NETSERVICE_DELEGATE_LOGGING
        NSString *addressString;
        int port=0;
#endif
        struct sockaddr *addressGeneric;
        
        addressGeneric = (struct sockaddr *) [myData bytes];
        switch( addressGeneric->sa_family ) {
            case AF_INET: {
                struct sockaddr_in *ip4;
                char dest[INET_ADDRSTRLEN];
                ip4 = (struct sockaddr_in *) [myData bytes];
#if FLY_NETSERVICE_DELEGATE_LOGGING
                port = ntohs(ip4->sin_port);
                addressString = [NSString stringWithFormat: @"IP4: %s Port: %d", inet_ntop(AF_INET, &ip4->sin_addr, dest, sizeof dest),port];
                NSLog(@"%s found 360fly camera at %@", __PRETTY_FUNCTION__, addressString);
#endif
                if( inet_ntop(AF_INET, &ip4->sin_addr, dest, sizeof dest) != 0 && [self networkDeviceOnline:addressGeneric] == YES)
                    return YES;
            }
                break;
                
            case AF_INET6: { // TODO: check valid IPv6 address
#if FLY_NETSERVICE_DELEGATE_LOGGING
                struct sockaddr_in6 *ip6;
                ip6 = (struct sockaddr_in6 *) [myData bytes];
                port = ntohs(ip6->sin6_port);
                char dest[INET6_ADDRSTRLEN];
                addressString = [NSString stringWithFormat: @"IP6: %s Port: %d",  inet_ntop(AF_INET6, &ip6->sin6_addr, dest, sizeof dest),port];
                NSLog(@"%s found 360fly camera at %@", __PRETTY_FUNCTION__, addressString);
#endif
            }
                break;
            default:
                break;
        }
    }
    return NO;
}
- (void)netServiceDidResolveAddress:(NSNetService *)netService;
{
#if FLY_NETSERVICE_DELEGATE_LOGGING
    NSString *serviceName = [NSString stringWithFormat:@"%@.%@%@", [netService name], [netService type], [netService domain]];
    
    NSLog(@"%s %@", __PRETTY_FUNCTION__, serviceName);
#endif
    NSCharacterSet *whiteSpaceCS = [NSCharacterSet whitespaceCharacterSet];
    NSMutableDictionary *txtDictionary = [NSMutableDictionary dictionary];
    
    if( [self containValidIPAddress:[netService addresses]] == NO){
        return;
    }
    
    @synchronized(self) {
        NSData *txtRecordData = [netService TXTRecordData];
        if (nil == txtRecordData) {
            return;
        }
        
        NSDictionary *dictionaryFromTXTRecordData = [NSNetService dictionaryFromTXTRecordData:txtRecordData];
        if (nil == dictionaryFromTXTRecordData) {
            return;
        }
        
        /* deviceID: Wi-Fi MAC address for device*/
        NSData *deviceID = [dictionaryFromTXTRecordData objectForKey:@"deviceid"];
        NSString *mac = nil;
        if (nil != deviceID && 0 < [deviceID length]) {
            
            mac = [[[NSString alloc] initWithData:deviceID encoding:NSUTF8StringEncoding] stringByTrimmingCharactersInSet:whiteSpaceCS];
        } else {
            mac = [NSString stringWithFormat:@"XX:XX:XX:XX:XX:XX"];
        }
        
        /* TXT Version */
        NSData *txtVersion = [dictionaryFromTXTRecordData objectForKey:@"txtvers"];
        if (0 < [txtVersion length]) {
            NSString *txtVersionString = [[[NSString alloc] initWithData:txtVersion encoding:NSUTF8StringEncoding] stringByTrimmingCharactersInSet:whiteSpaceCS];
            NSNumber *txtVersionNumber = [NSNumber numberWithInteger:txtVersionString.integerValue];
            if (txtVersionNumber) {
                [txtDictionary setObject:txtVersionNumber forKey:@"txtvers"];
            } else {
                [txtDictionary setObject:[NSNumber numberWithInt:1] forKey:@"txtvers"];
            }
        }
        
        /* HW Version */
        NSData *hardwareRevision = [dictionaryFromTXTRecordData objectForKey:@"hw_version"];
        if (0 < [txtVersion length]) {
            NSString *hardwareRevisionString = [[[NSString alloc] initWithData:hardwareRevision encoding:NSUTF8StringEncoding] stringByTrimmingCharactersInSet:whiteSpaceCS];
            if (hardwareRevisionString) {
                [txtDictionary setObject:hardwareRevisionString forKey:@"hw_version"];
            }
        }
        
        /* Model Number */
        NSData *modelNumber = [dictionaryFromTXTRecordData objectForKey:@"model_no"];
        if (0 < [txtVersion length]) {
            NSString *modelNumberString = [[[NSString alloc] initWithData:modelNumber encoding:NSUTF8StringEncoding] stringByTrimmingCharactersInSet:whiteSpaceCS];
            if (modelNumberString) {
                [txtDictionary setObject:modelNumberString forKey:@"model_no"];
            }
        }
        
        /* SW Version */
        NSData *softwareRevision = [dictionaryFromTXTRecordData objectForKey:@"sw_version"];
        if (0 < [txtVersion length]) {
            NSString *softwareRevisionString = [[[NSString alloc] initWithData:softwareRevision encoding:NSUTF8StringEncoding] stringByTrimmingCharactersInSet:whiteSpaceCS];
            if (softwareRevisionString) {
                [txtDictionary setObject:softwareRevisionString forKey:@"sw_version"];
            }
        }
        
        /* Serial Number */
        NSData *serialNumber = [dictionaryFromTXTRecordData objectForKey:@"serial_no"];
        if (0 < [txtVersion length]) {
            NSString *serialNumberString = [[[NSString alloc] initWithData:serialNumber encoding:NSUTF8StringEncoding] stringByTrimmingCharactersInSet:whiteSpaceCS];
            // Length check here is to avoid a bug in Firefly firmware < 1.8.3 that causes wrong serial number to be reported via mDNS
            if (serialNumberString && serialNumberString.length > 8) {
                [txtDictionary setObject:serialNumberString forKey:@"serial_no"];
            }
        }
        
        /* Name */
        NSString *name = [netService name];
        if (name) {
            [txtDictionary setObject:name forKey:@"name"];
        }
        
        NSString *identifier = [mac substringWithRange:NSMakeRange(6, 11)];
        if (nil != identifier) {
            NSURL *deviceURL = [self baseURLForDeviceFromService:netService];
            
            if (nil != deviceURL) {
                WBHTTPChannel *device = [[WBHTTPChannel alloc] initWithIdentifier:identifier baseURL:deviceURL address:netService.addresses];
                
                NSMapTable *deviceMap = [self deviceMap];
                
                @synchronized(deviceMap) {
                    [self willChangeValueForKey:@"devices"];
                    [deviceMap setObject:device forKey:netService];
                    [self didChangeValueForKey:@"devices"];
                }
                
#if FLY_NETSERVICE_DELEGATE_LOGGING
                NSString *serviceName = [NSString stringWithFormat:@"%@.%@%@", [netService name], [netService type], [netService domain]];
                NSArray *ipAddresses = IPAddressesFromSockaddrArray([netService addresses], NO);
                id argument = [ipAddresses count] == 1 ? [ipAddresses firstObject] : ipAddresses;
                
                NSLog(@"%s %@ HTTPChannelDidAppear: %@ %@", __PRETTY_FUNCTION__, identifier, serviceName, argument);
#endif
                
                NSNotificationCenter *defaultCenter = [NSNotificationCenter defaultCenter];
                
                [defaultCenter postNotificationName:FLYHTTPChannelDidAppearNotification object:device userInfo:dictionaryFromTXTRecordData];
            }
        }
    }
    
    return;
}

- (void)netService:(NSNetService *)netService didUpdateTXTRecordData:(NSData *)data;
{
#if FLY_NETSERVICE_DELEGATE_LOGGING
    NSString *serviceName = [NSString stringWithFormat:@"%@.%@%@", [netService name], [netService type], [netService domain]];
    
    NSLog(@"%s %@", __PRETTY_FUNCTION__, serviceName);
#endif
    
    return;
}

- (void)netServiceDidStop:(NSNetService *)netService;
{
#if FLY_NETSERVICE_DELEGATE_LOGGING
    NSString *serviceName = [NSString stringWithFormat:@"%@.%@%@", [netService name], [netService type], [netService domain]];
    
    NSLog(@"%s %@", __PRETTY_FUNCTION__, serviceName);
#endif
    
    return;
}
@end

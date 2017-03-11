//
//  WBIPAddressUtility.m
//  CoreData
//
//  Created by wangwenbing on 2017/3/3.
//  Copyright © 2017年 Centit. All rights reserved.
//

#import "WBIPAddressUtility.h"
#import <arpa/inet.h>
#import <netinet/in.h>
#import <netinet6/in6.h>

NSArray *IPAddressesFromSockaddrArray(NSArray *sockaddrArray, BOOL includeIPv6)
{
    NSMutableArray *addresses = [NSMutableArray array];
    
    for (NSData *data in sockaddrArray) {
        NSUInteger dataLength = [data length];
        
        if (16 == dataLength) {
            struct sockaddr_in address4;
            
            [data getBytes:&address4 length:sizeof(struct sockaddr_in)];
            
            if (AF_INET == address4.sin_family) {
                NSString *stringAddress = [NSString stringWithUTF8String:inet_ntoa(address4.sin_addr)];
                
                [addresses addObject:stringAddress];
            }
        }
        else if (28 == dataLength && YES == includeIPv6) {
            struct sockaddr_in6 address6;
            
            [data getBytes:&address6 length:sizeof(struct sockaddr_in6)];
            
            if (AF_INET6 == address6.sin6_family) {
                NSMutableString *mutableAddress = nil;
                
                for (uint32_t i = 0; i < 8; i++) {
                    uint16_t value = address6.sin6_addr.__u6_addr.__u6_addr16[i];
                    
                    if (nil == mutableAddress) {
                        mutableAddress = [NSMutableString stringWithFormat:@"%0.4X", value];
                    }
                    else {
                        [mutableAddress appendFormat:@":%0.4X", value];
                    }
                }
                
                NSString *immutableAddress = [NSString stringWithString:mutableAddress];
                
                [addresses addObject:immutableAddress];
            }
        }
    }
    
    return [NSArray arrayWithArray:addresses];
}

NSArray	*IPAddressesFromHostname(NSString *hostname)
{
    CFHostRef hostRef = CFHostCreateWithName(kCFAllocatorDefault, (__bridge CFStringRef)hostname);
    NSArray *addresses = nil;
    
    if (NULL != hostRef) {
        CFStreamError error = { 0, 0 };
        Boolean result = CFHostStartInfoResolution(hostRef, kCFHostAddresses, &error);
        
        if (TRUE == result) {
            Boolean resolved = NO;
            CFArrayRef coreAddresses = CFHostGetAddressing(hostRef, &resolved);
            
            if (TRUE == resolved) {
                NSArray *nsAddresses = (__bridge NSArray *)coreAddresses;
                
                addresses = IPAddressesFromSockaddrArray(nsAddresses, YES);
            }
            else {
                NSLog(@"IPAddressesFromHostname(%@): CFHostGetAddressing resolution failure", hostname);
            }
        }
        else {
            NSLog(@"IPAddressesFromHostname(%@): CFHostStartInfoResolution failure domain: %ld error: %d", hostname, error.domain, (int)error.error);
        }
        
        CFRelease(hostRef);
    }
    
    if (0 == [addresses count]) {
        addresses = nil;
    }
    
    return addresses;
}

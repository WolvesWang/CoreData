//
//  NSNetService+ReconfirmRecord.m
//  CoreData
//
//  Created by wangwenbing on 2017/3/3.
//  Copyright © 2017年 Centit. All rights reserved.
//

#import "NSNetService+ReconfirmRecord.h"

#import <dns_sd.h>
#import <net/if.h>

uint32_t FLYInterfaceIndex(char *interfaceName)
{
    uint32_t interfaceIndex = 0;
    uint32_t i = 0;
    struct if_nameindex *nameindex = if_nameindex();
    
    while (nameindex[i].if_name != NULL) {
        if (0 == strcmp(interfaceName, nameindex[i].if_name)) {
            interfaceIndex = nameindex[i].if_index;
            
            break;
        }
        
        i++;
    }
    if_freenameindex(nameindex);
    return interfaceIndex;
}

@implementation NSNetService (ReconfirmRecord)

- (void)reconfirmRecord;
{
    // serviceName should be in the form
    // "name.service.protocol.domain.".  For example:
    // "MyLaptop._ftp._tcp.local."
    NSString *serviceName = [NSString stringWithFormat:@"%@.%@%@", [self name], [self type], [self domain]];
    NSArray *serviceNameComponents = [serviceName componentsSeparatedByString:@"."];
    NSUInteger serviceNameComponentsCount = [serviceNameComponents count];
    
    NSLog(@"%s %@", __PRETTY_FUNCTION__, serviceName);
    
    if ( (serviceNameComponentsCount >= 5) && ([serviceNameComponents[serviceNameComponentsCount - 1] length] == 0) ) {
        NSString *protocol = [serviceNameComponents[2] lowercaseString];
        
        if (YES == [protocol isEqualToString:@"_tcp"] || YES == [protocol isEqualToString:@"_udp"]) {
            NSMutableData *recordData = [[NSMutableData alloc] init];
            
            for (NSString *label in serviceNameComponents) {
                const char *labelString = [label UTF8String];
                
                if (strlen(labelString) >= 64) {
                    NSLog(@"%s label too long %s", __PRETTY_FUNCTION__, labelString);
                    
                    recordData = nil;
                    
                    break;
                }
                else {
                    // cast is safe because of length check
                    uint8_t labelStringLength = (uint8_t) strlen(labelString);
                    
                    [recordData appendBytes:&labelStringLength length:sizeof(labelStringLength)];
                    [recordData appendBytes:labelString length:labelStringLength];
                    
                    if ([recordData length] >= 256) {
                        NSLog(@"%s record data too long (%lu)", __PRETTY_FUNCTION__, (unsigned long)[recordData length]);
                        
                        recordData = nil;
                        
                        break;
                    }
                }
            }
            
            if (nil != recordData) {
                uint32_t en0InterfaceIndex = FLYInterfaceIndex("en0");
                NSString *fullname = [NSString stringWithFormat:@"%@%@", [self type], [self domain]];
                const char *fullnameString = [fullname UTF8String];
                // cast is safe because of recordData length check above
                uint16_t recordDataLength = [recordData length];
                const void *recordDataBytes = [recordData bytes];
                DNSServiceErrorType errorType = DNSServiceReconfirmRecord(0, en0InterfaceIndex, fullnameString, kDNSServiceType_PTR, kDNSServiceClass_IN, recordDataLength, recordDataBytes);
                
                if (errorType != kDNSServiceErr_NoError) {
                    NSLog(@"%s DNSServiceReconfirmRecord Error: %d", __PRETTY_FUNCTION__, errorType);
                }
            }
        }
    }
    
    return;
}

@end

//
//  WBIPAddressUtility.h
//  CoreData
//
//  Created by wangwenbing on 2017/3/3.
//  Copyright © 2017年 Centit. All rights reserved.
//

#ifndef _WBIPAddressUtility__
#define _WBIPAddressUtility__


#import <Foundation/Foundation.h>


NSArray *IPAddressesFromSockaddrArray(NSArray *sockaddrArray, BOOL includeIPv6);
NSArray	*IPAddressesFromHostname(NSString *hostname);

#endif /* WBIPAddressUtility_h */

//
//  WBHTTPListenter.h
//  CoreData
//
//  Created by wangwenbing on 2017/3/3.
//  Copyright © 2017年 Centit. All rights reserved.
//

#import <Foundation/Foundation.h>

@class WBHTTPChannel;
@interface WBHTTPListenter : NSObject <NSNetServiceDelegate, NSNetServiceBrowserDelegate>

+ (NSString *)currentConnectedNetworkSSID;
+ (NSString *)currentConnectedNetworkBSSID;

+ (WBHTTPListenter *)sharedHTTPListener;
- (BOOL)checkIfWiFiNetworkAvailable;
- (void)startScanning;
- (void)stopScanning;

- (void)reconfirmNetworkServiceRecordForDevice:(WBHTTPChannel *)httpChannel;
@end

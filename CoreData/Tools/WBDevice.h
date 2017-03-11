//
//  WBDevice.h
//  CoreData
//
//  Created by wangwenbing on 2017/3/3.
//  Copyright © 2017年 Centit. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WBHTTPChannel.h"
@interface WBDevice : NSObject

@property (nonatomic, readwrite, strong) WBHTTPChannel *httpChannel;



@end

@interface WBDevice (WBDeviceProtocol)<WBDeviceHTTPProtocol,WBDeviceProtocol,WBDeviceBTLEProtocol>


@end

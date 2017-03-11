//
//  WBHTTPChannel.h
//  CoreData
//
//  Created by wangwenbing on 2017/3/2.
//  Copyright © 2017年 Centit. All rights reserved.
//

#import "AFHTTPSessionManager.h"
#import "AFNetworking/AFNetworking.h"
#import "AFHTTPSessionManager+WBNetworking.h"
#import "WBDeviceProtocol.h"

@interface WBHTTPChannel : AFHTTPSessionManager<WBDeviceHTTPProtocolWithProperties>
/*
 在协议中声明的属性，在使用的时候，要再重新声明定义
 */
// Temporary properties


@property (atomic, readonly, copy) NSString *identifier;



-(instancetype)initWithIdentifier:(NSString *)identifier baseURL:(NSURL *)url
                          address:(NSArray *)address;
@end

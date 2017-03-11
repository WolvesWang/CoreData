//
//  WBDevice.m
//  CoreData
//
//  Created by wangwenbing on 2017/3/3.
//  Copyright © 2017年 Centit. All rights reserved.
//

#import "WBDevice.h"

#import "WBHTTPChannel.h"

@implementation WBDevice

- (instancetype)init {
    if (self = [super init]) {
        WBHTTPChannel *httpChannel = [[WBHTTPChannel alloc] init];
        [self setHttpChannel:httpChannel];
    }
    return self;
    
}


- (void)setHttpChannel:(WBHTTPChannel *)httpChannel;
{
    if (httpChannel != _httpChannel) {
        WBHTTPChannel *oldHttpChannel = _httpChannel;
        
        [self willChangeValueForKey:@"httpChannel"];
        _httpChannel = httpChannel;
        [self didChangeValueForKey:@"httpChannel"];
        if (oldHttpChannel != nil) {
            
        }
        
        if (nil != httpChannel) {
            
        }
        
    }
}
@end

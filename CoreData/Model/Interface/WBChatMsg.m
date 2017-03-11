//
//  WBChatMsg.m
//  CoreData
//
//  Created by wangwenbing on 2017/3/1.
//  Copyright © 2017年 Centit. All rights reserved.
//

#import "WBChatMsg.h"

@implementation WBChatMsg

#pragma mark  NSCoding

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [super encodeWithCoder:aCoder];
    [aCoder encodeObject:self.dest forKey:@"dest"];
    [aCoder encodeObject:self.content forKey:@"content"];
    [aCoder encodeObject:self.contentType forKey:@"contentType"];
}

- (nullable instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        self.dest = [aDecoder decodeObjectForKey:@"dest"];
        self.content = [aDecoder decodeObjectForKey:@"content"];
        self.contentType = [aDecoder decodeObjectForKey:@"contentType"];
    }
    return self;
}

#pragma mark    NSCopying

- (id)copyWithZone:(NSZone *)zone {
    
    WBChatMsg *copyValue = [[[self class] allocWithZone:zone] init];
    copyValue.dest = [self.dest copyWithZone:zone];
    copyValue.content = [self.content copyWithZone:zone];
    copyValue.contentType = [self.contentType copyWithZone:zone];
    
    return copyValue;
}

@end

@implementation WBChatMsgRsp

#pragma mark
- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.code forKey:@"code"];
    [aCoder encodeObject:self.desc forKey:@"desc"];
    
}

- (nullable instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super init]) {
        self.code = [aDecoder decodeObjectForKey:@"code"];
        self.desc = [aDecoder decodeObjectForKey:@"desc"];
    }
    return self;
}

- (id)copyWithZone:(NSZone *)zone
{
    WBChatMsgRsp *copyValue = [[[self class] allocWithZone:zone] init];
    copyValue.code = [self.code copyWithZone:zone];
    copyValue.desc = [self.desc copyWithZone:zone];
    
    //copyValue->_code = self.code;
    //copyValue->_desc = self.desc;
    return copyValue;
}
@end

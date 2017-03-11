//
//  WBMvsMessage.m
//  CoreData
//
//  Created by wangwenbing on 2017/3/1.
//  Copyright © 2017年 Centit. All rights reserved.
//

#import "WBMvsMessage.h"

@implementation WBMvsMessage

#pragma mark NSCoding

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [super encodeWithCoder:aCoder];
    
    [aCoder encodeObject:self.src forKey:@"src"];
    [aCoder encodeObject:self.dest forKey:@"dest"];
    [aCoder encodeObject:self.time forKey:@"time"];
    [aCoder encodeObject:self.content forKey:@"content"];
    [aCoder encodeObject:self.type forKey:@"type"];
    [aCoder encodeObject:self.contentType forKey:@"contentType"];
    
}

- (nullable instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        self.src = [aDecoder decodeObjectForKey:@"src"];
        self.dest = [aDecoder decodeObjectForKey:@"dest"];
        self.time = [aDecoder decodeObjectForKey:@"time"];
        self.content = [aDecoder decodeObjectForKey:@"content"];
        self.type = [aDecoder decodeObjectForKey:@"type"];
        self.contentType = [aDecoder decodeObjectForKey:@"contentType"];
    }
    return self;
}

#pragma mark    NSCopying

- (id)copyWithZone:(NSZone *)zone {
    
    WBMvsMessage *copyValue = [[[self class] allocWithZone:zone] init];
    copyValue.src = [self.src copyWithZone:zone];
    copyValue.dest = [self.dest copyWithZone:zone];
    copyValue.time = [self.time copyWithZone:zone];
    copyValue.content = [self.content copyWithZone:zone];
    copyValue.type = [self.type copyWithZone:zone];
    copyValue.contentType = [self.contentType copyWithZone:zone];
    
    return copyValue;
}

@end

@implementation WBMvsMessageRep


#pragma mark
- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [super encodeWithCoder:aCoder];
    [aCoder encodeObject:self.code forKey:@"code"];
    [aCoder encodeObject:self.desc forKey:@"desc"];
    
}

- (nullable instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        self.code = [aDecoder decodeObjectForKey:@"code"];
        self.desc = [aDecoder decodeObjectForKey:@"desc"];
    }
    return self;
}

- (id)copyWithZone:(NSZone *)zone
{
    WBMvsMessageRep *copyValue = [[[self class] allocWithZone:zone] init];
    copyValue.code = [self.code copyWithZone:zone];
    copyValue.desc = [self.desc copyWithZone:zone];
    return copyValue;
}

@end

//
//  Foundation+Log.m
//  CoreData
//
//  Created by wangwenbing on 2017/3/8.
//  Copyright © 2017年 Centit. All rights reserved.
//

#import <Foundation/Foundation.h>

@implementation NSDictionary (Log)

- (NSString *)descriptionWithLocale:(id)locale
{
    NSMutableString *str = [NSMutableString string];
    
    [str appendString:@"{\n"];
    
    [self enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        
        [str appendFormat:@"\t%@ = %@,\n", key ,obj];
    }];
    
    [str appendString:@"}"];
    
    NSRange range = [str rangeOfString:@"," options:NSBackwardsSearch];
    if (range.length != 0) {
        [str deleteCharactersInRange:range];
    }
    
    return str;
}

@end

@implementation NSArray (Log)

- (NSString *)descriptionWithLocale:(id)locale
{
    NSMutableString *str = [NSMutableString string];
    
    [str appendString:@"[\n"];
    
    [self enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        [str appendFormat:@"%@,\n",obj];
    }];
    
    [str appendString:@"]"];
    
    NSRange range = [str rangeOfString:@"," options:NSBackwardsSearch];
    
    if (range.length != 0) {
        
        [str deleteCharactersInRange:range];
    }
    
    return str;
}
@end

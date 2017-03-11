//
//  ProductCategory.m
//  CoreData
//
//  Created by wangwenbing on 2017/3/2.
//  Copyright © 2017年 Centit. All rights reserved.
//

#import "ProductCategory.h"
#import "Person.h"
@implementation ProductCategory

// Array + Nested
+ (Class)children_class // 起名字必须与Key相对应
{
    return [ProductCategory class];
}

- (NSDictionary *)map
{
    NSMutableDictionary *map = [NSMutableDictionary dictionaryWithDictionary:[super map]];
    [map setValue:@"name" forKey:@"name"];
    [map setValue:@"children" forKey:@"children"];
    [map setValue:@"person" forKey:@"person"];
    return [NSDictionary dictionaryWithDictionary:map];
}

@end

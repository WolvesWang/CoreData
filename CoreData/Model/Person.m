//
//  Person.m
//  CoreData
//
//  Created by wangwenbing on 2017/3/2.
//  Copyright © 2017年 Centit. All rights reserved.
//

#import "Person.h"

@implementation Person
//可以根据CoreData的map原理，自定义映射模型 （字典）《--》Json

- (NSDictionary *)map
{
    NSMutableDictionary *map = [NSMutableDictionary dictionaryWithDictionary:[super map]];
    [map setValue:@"firstName" forKey:@"firstName"];
    [map setValue:@"lastName" forKey:@"lastName"];// Key 与 value 可相同。
    /*
     [map setValue:@"first_name" forKey:@"firstName"];
     [map setValue:@"last_name" forKey:@"lastName"];
     */
    return [NSDictionary dictionaryWithDictionary:map];
}
@end

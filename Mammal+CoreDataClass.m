//
//  Mammal+CoreDataClass.m
//  CoreData
//
//  Created by wangwenbing on 2017/3/6.
//  Copyright © 2017年 Centit. All rights reserved.
//

#import "Mammal+CoreDataClass.h"

@implementation Mammal
+ (void)initialize {
    if (self == [Mammal class]) {
        
        UIImageTransformer *imageTransformer = [[UIImageTransformer alloc] init];
        [NSValueTransformer setValueTransformer:imageTransformer forName:@"UIImageTransformer"];
        
        UIColorTransformer *colorTransformer = [[UIColorTransformer alloc] init];
        [NSValueTransformer setValueTransformer:colorTransformer forName:@"UIColorTransformer"];
        
        NSArrayTransformer *arrayTransformer = [[NSArrayTransformer alloc] init];
        [NSValueTransformer setValueTransformer:arrayTransformer forName:@"NSArrayTransformer"];
        
        NSDictionaryTransformer *dictionaryTransformer = [[NSDictionaryTransformer alloc] init];
        [NSValueTransformer setValueTransformer:dictionaryTransformer forName:@"NSDictionaryTransformer"];
        
    }
}
@end


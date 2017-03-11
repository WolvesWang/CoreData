//
//  ProductCategory.h
//  CoreData
//
//  Created by wangwenbing on 2017/3/2.
//  Copyright © 2017年 Centit. All rights reserved.
//

#import "Jastor.h"

@class Person;
@interface ProductCategory : Jastor

@property (nonatomic, copy) NSString *name;

@property (nonatomic, strong) NSArray *children;

@property (nonatomic, strong) Person *person;

@end

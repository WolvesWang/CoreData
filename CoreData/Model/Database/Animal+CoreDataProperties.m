//
//  Animal+CoreDataProperties.m
//  CoreData
//
//  Created by wangwenbing on 2017/3/6.
//  Copyright © 2017年 Centit. All rights reserved.
//

#import "Animal+CoreDataProperties.h"

@implementation Animal (CoreDataProperties)

+ (NSFetchRequest<Animal *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"Animal"];
}

@dynamic eatFood;
@dynamic sleepDec;

@end

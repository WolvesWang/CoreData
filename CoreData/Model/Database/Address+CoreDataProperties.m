//
//  Address+CoreDataProperties.m
//  CoreData
//
//  Created by wangwenbing on 2017/3/10.
//  Copyright © 2017年 Centit. All rights reserved.
//

#import "Address+CoreDataProperties.h"

@implementation Address (CoreDataProperties)

+ (NSFetchRequest<Address *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"Address"];
}

@dynamic culture;
@dynamic name;
@dynamic visitor;
@dynamic scenic;
@end

//
//  Bird+CoreDataProperties.m
//  CoreData
//
//  Created by wangwenbing on 2017/3/6.
//  Copyright © 2017年 Centit. All rights reserved.
//

#import "Bird+CoreDataProperties.h"

@implementation Bird (CoreDataProperties)

+ (NSFetchRequest<Bird *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"Bird"];
}

@dynamic feed;
@dynamic fly;
@dynamic speed;
@end

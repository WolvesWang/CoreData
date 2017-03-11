//
//  Job+CoreDataProperties.m
//  CoreData
//
//  Created by wangwenbing on 2017/3/6.
//  Copyright © 2017年 Centit. All rights reserved.
//

#import "Job+CoreDataProperties.h"

@implementation Job (CoreDataProperties)

+ (NSFetchRequest<Job *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"Job"];
}

@dynamic jobID;
@dynamic jobName;
@dynamic employees;

@end

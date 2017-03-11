//
//  Employee+CoreDataProperties.m
//  CoreData
//
//  Created by wangwenbing on 2017/3/7.
//  Copyright © 2017年 Centit. All rights reserved.
//

#import "Employee+CoreDataProperties.h"

@implementation Employee (CoreDataProperties)

+ (NSFetchRequest<Employee *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"Employee"];
}

@dynamic email;
@dynamic empID;
@dynamic empName;
@dynamic extensionNumber;
@dynamic mobilephone;
@dynamic sex;
@dynamic job;
@dynamic organization;
@dynamic address;

@end

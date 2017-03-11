//
//  Origanization+CoreDataProperties.m
//  CoreData
//
//  Created by wangwenbing on 2017/3/6.
//  Copyright © 2017年 Centit. All rights reserved.
//

#import "Origanization+CoreDataProperties.h"

@implementation Origanization (CoreDataProperties)

+ (NSFetchRequest<Origanization *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"Origanization"];
}

@dynamic orgID;
@dynamic orgName;
@dynamic employees;
@dynamic leaders;
@dynamic subOrgs;
@dynamic superOrg;

@end

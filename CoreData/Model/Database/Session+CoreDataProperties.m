//
//  Session+CoreDataProperties.m
//  CoreData
//
//  Created by wangwenbing on 2017/3/6.
//  Copyright © 2017年 Centit. All rights reserved.
//

#import "Session+CoreDataProperties.h"

@implementation Session (CoreDataProperties)

+ (NSFetchRequest<Session *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"Session"];
}

@dynamic sessionID;
@dynamic sessionType;
@dynamic unReadNumber;
@dynamic fromEmplyee;
@dynamic lastMessage;

@end

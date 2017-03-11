//
//  Employee+CoreDataClass.h
//  CoreData
//
//  Created by wangwenbing on 2017/3/7.
//  Copyright © 2017年 Centit. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Address, Job, Origanization;

NS_ASSUME_NONNULL_BEGIN

@interface Employee : NSManagedObject

@end

NS_ASSUME_NONNULL_END

#import "Employee+CoreDataProperties.h"

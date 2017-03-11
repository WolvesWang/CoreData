//
//  Job+CoreDataProperties.h
//  CoreData
//
//  Created by wangwenbing on 2017/3/6.
//  Copyright © 2017年 Centit. All rights reserved.
//

#import "Job+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface Job (CoreDataProperties)

+ (NSFetchRequest<Job *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *jobID;
@property (nullable, nonatomic, copy) NSString *jobName;
@property (nullable, nonatomic, retain) NSSet<Employee *> *employees;

@end

@interface Job (CoreDataGeneratedAccessors)

- (void)addEmployeesObject:(Employee *)value;
- (void)removeEmployeesObject:(Employee *)value;
- (void)addEmployees:(NSSet<Employee *> *)values;
- (void)removeEmployees:(NSSet<Employee *> *)values;

@end

NS_ASSUME_NONNULL_END

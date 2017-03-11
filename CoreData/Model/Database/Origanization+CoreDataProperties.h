//
//  Origanization+CoreDataProperties.h
//  CoreData
//
//  Created by wangwenbing on 2017/3/6.
//  Copyright © 2017年 Centit. All rights reserved.
//

#import "Origanization+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface Origanization (CoreDataProperties)

+ (NSFetchRequest<Origanization *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *orgID;
@property (nullable, nonatomic, copy) NSString *orgName;
@property (nullable, nonatomic, retain) NSSet<Employee *> *employees;
@property (nullable, nonatomic, retain) NSSet<Employee *> *leaders;
@property (nullable, nonatomic, retain) Origanization *subOrgs;
@property (nullable, nonatomic, retain) Origanization *superOrg;

@end

@interface Origanization (CoreDataGeneratedAccessors)

- (void)addEmployeesObject:(Employee *)value;
- (void)removeEmployeesObject:(Employee *)value;
- (void)addEmployees:(NSSet<Employee *> *)values;
- (void)removeEmployees:(NSSet<Employee *> *)values;

- (void)addLeadersObject:(Employee *)value;
- (void)removeLeadersObject:(Employee *)value;
- (void)addLeaders:(NSSet<Employee *> *)values;
- (void)removeLeaders:(NSSet<Employee *> *)values;

@end

NS_ASSUME_NONNULL_END

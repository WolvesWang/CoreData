//
//  Employee+CoreDataProperties.h
//  CoreData
//
//  Created by wangwenbing on 2017/3/7.
//  Copyright © 2017年 Centit. All rights reserved.
//

#import "Employee+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface Employee (CoreDataProperties)

+ (NSFetchRequest<Employee *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *email;
@property (nullable, nonatomic, copy) NSString *empID;
@property (nullable, nonatomic, copy) NSString *empName;
@property (nullable, nonatomic, copy) NSString *extensionNumber;
@property (nullable, nonatomic, copy) NSString *mobilephone;
@property (nullable, nonatomic, retain) NSNumber *sex;
@property (nullable, nonatomic, retain) Job *job;
@property (nullable, nonatomic, retain) Origanization *organization;
@property (nullable, nonatomic, retain) NSSet<Address *> *address;

@end

@interface Employee (CoreDataGeneratedAccessors)

- (void)addAddressObject:(Address *)value;
- (void)removeAddressObject:(Address *)value;
- (void)addAddress:(NSSet<Address *> *)values;
- (void)removeAddress:(NSSet<Address *> *)values;

@end

NS_ASSUME_NONNULL_END

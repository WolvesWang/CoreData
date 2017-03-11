//
//  Address+CoreDataProperties.h
//  CoreData
//
//  Created by wangwenbing on 2017/3/10.
//  Copyright © 2017年 Centit. All rights reserved.
//

#import "Address+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface Address (CoreDataProperties)

+ (NSFetchRequest<Address *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *culture;
@property (nullable, nonatomic, copy) NSString *name;
@property (nullable, nonatomic, copy) NSString *visitor;
@property (nullable, nonatomic, retain) NSNumber *scenic;

@end

NS_ASSUME_NONNULL_END

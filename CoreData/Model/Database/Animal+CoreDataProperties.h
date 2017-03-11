//
//  Animal+CoreDataProperties.h
//  CoreData
//
//  Created by wangwenbing on 2017/3/6.
//  Copyright © 2017年 Centit. All rights reserved.
//

#import "Animal+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface Animal (CoreDataProperties)

+ (NSFetchRequest<Animal *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *eatFood;
@property (nullable, nonatomic, copy) NSString *sleepDec;

@end

NS_ASSUME_NONNULL_END

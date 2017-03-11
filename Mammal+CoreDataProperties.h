//
//  Mammal+CoreDataProperties.h
//  CoreData
//
//  Created by wangwenbing on 2017/3/6.
//  Copyright © 2017年 Centit. All rights reserved.
//

#import "Mammal+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface Mammal (CoreDataProperties)

+ (NSFetchRequest<Mammal *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *suckle;
@property (nullable, nonatomic, copy) NSString *walk;
@property (nullable, nonatomic, copy) NSString *habit;
@property (nullable, nonatomic, retain) NSObject *icon;
@property (nullable, nonatomic, retain) NSObject *color;
@property (nullable, nonatomic, retain) NSObject *numbersArray;
@property (nullable, nonatomic, retain) NSObject *lifeDictionary;

@end

NS_ASSUME_NONNULL_END

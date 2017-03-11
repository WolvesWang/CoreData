//
//  Bird+CoreDataProperties.h
//  CoreData
//
//  Created by wangwenbing on 2017/3/6.
//  Copyright © 2017年 Centit. All rights reserved.
//

#import "Bird+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface Bird (CoreDataProperties)

+ (NSFetchRequest<Bird *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *feed;
@property (nullable, nonatomic, copy) NSString *fly;
@property (nullable, nonatomic, copy) NSString *speed;
@end

NS_ASSUME_NONNULL_END

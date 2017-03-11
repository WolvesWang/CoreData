//
//  Message+CoreDataProperties.h
//  CoreData
//
//  Created by wangwenbing on 2017/3/6.
//  Copyright © 2017年 Centit. All rights reserved.
//

#import "Message+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface Message (CoreDataProperties)

+ (NSFetchRequest<Message *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *content;
@property (nullable, nonatomic, copy) NSDate *dateTime;
@property (nullable, nonatomic, retain) NSNumber *isReaded;
@property (nullable, nonatomic, retain) NSNumber *type;
@property (nullable, nonatomic, retain) Employee *fromEmployee;
@property (nullable, nonatomic, retain) Session *session;

@end

NS_ASSUME_NONNULL_END

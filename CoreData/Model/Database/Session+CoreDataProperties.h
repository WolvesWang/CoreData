//
//  Session+CoreDataProperties.h
//  CoreData
//
//  Created by wangwenbing on 2017/3/6.
//  Copyright © 2017年 Centit. All rights reserved.
//

#import "Session+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface Session (CoreDataProperties)

+ (NSFetchRequest<Session *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *sessionID;
@property (nullable, nonatomic, retain) NSNumber *sessionType;
@property (nullable, nonatomic, retain) NSNumber *unReadNumber;
@property (nullable, nonatomic, retain) Employee *fromEmplyee;
@property (nullable, nonatomic, retain) Message *lastMessage;

@end

NS_ASSUME_NONNULL_END

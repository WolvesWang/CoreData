//
//  Person.h
//  CoreData
//
//  Created by wangwenbing on 2017/3/2.
//  Copyright © 2017年 Centit. All rights reserved.
//

#import "Jastor.h"

@interface Person : Jastor
// 假设数据模型为Person
@property (nonatomic, copy) NSString *firstName;
@property (nonatomic, copy) NSString *lastName;


@end

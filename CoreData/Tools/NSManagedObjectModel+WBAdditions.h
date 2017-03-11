//
//  NSManagedObjectModel+WBAdditions.h
//  CoreData
//
//  Created by wangwenbing on 2017/3/7.
//  Copyright © 2017年 Centit. All rights reserved.
//

#import <CoreData/CoreData.h>

@interface NSManagedObjectModel (WBAdditions)
+ (NSArray *)mhw_allModelPaths;
- (NSString *)mhw_modelName;
@end

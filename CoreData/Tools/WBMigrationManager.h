//
//  WBMigrationManager.h
//  CoreData
//
//  Created by wangwenbing on 2017/3/7.
//  Copyright © 2017年 Centit. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
@class WBMigrationManager;

@protocol WBMigrationManagerDelegate <NSObject>

@optional

- (void)migrationManager:(WBMigrationManager *)migrationManager migrationProgress:(float)migrationProgress;

- (NSArray *)migrationManager:(WBMigrationManager *)migrationManager mappingModelForSourceModel:(NSManagedObjectModel *)sourceModel;

@end

@interface WBMigrationManager : NSObject

@property (nonatomic, weak) NSObject<WBMigrationManagerDelegate> *delegate;

- (BOOL)progressivelyMigrateURL:(NSURL *)sourceStoreURL
                         ofType:(NSString *)type
                        toModel:(NSManagedObjectModel *)finalModel
                          error:(NSError **)error;
@end

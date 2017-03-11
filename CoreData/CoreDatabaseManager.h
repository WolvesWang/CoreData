//
//  CoreDatabaseManager.h
//  CoreData
//
//  Created by wangwenbing on 2017/3/2.
//  Copyright © 2017年 Centit. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WBMigrationManager.h"
@class WBMvsMessage;

@interface CoreDatabaseManager : NSObject<WBMigrationManagerDelegate>
+ (instancetype)sharedInstance;

- (BOOL)isMigrationNeeded;
- (BOOL)migrate:(NSError *__autoreleasing *)error;

- (NSURL *)sourceStoreURL;

- (void)insertNewChatMessage:(WBMvsMessage *)mvsMessage isRelationships:(BOOL)flag;
@end

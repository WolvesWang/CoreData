//
//  AppDelegate.h
//  CoreData
//
//  Created by wangwenbing on 2017/2/28.
//  Copyright © 2017年 Centit. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong) NSPersistentContainer *persistentContainer;

@property (strong, readonly) NSManagedObjectContext *viewContext;
@property (strong, readonly) NSManagedObjectModel *managedObjectModel;
@property (strong, readonly) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)saveContext;
/*
 - (NSURL *)applicationDocumentsDirectory;
 
 - (NSString *)currentUserImageDocumentsDirectory;
 - (NSString *)currentUserAudioDocumentsDirectory;
 - (NSString *)currentUserVideoDocumentsDirectory;
 */


@end


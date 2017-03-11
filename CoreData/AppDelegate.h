//
//  AppDelegate.h
//  CoreData
//
//  Created by wangwenbing on 2017/2/28.
//  Copyright © 2017年 Centit. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>


//实现TCP长链接
#import "CocoaAsyncSocket.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong) NSPersistentContainer *persistentContainer;

@property (strong, readonly) NSManagedObjectContext *viewContext;
@property (strong, readonly) NSManagedObjectModel *managedObjectModel;
@property (strong, readonly) NSPersistentStoreCoordinator *persistentStoreCoordinator;

//-------------TCP
@property (nonatomic, copy, readonly) NSString *strIP;
@property (nonatomic, copy, readonly) NSString *deviceID;
@property (nonatomic, assign, readonly) NSInteger nPort;
@property (nonatomic, strong, readonly) GCDAsyncSocket *appAsyncSocket;
@property (nonatomic, strong) NSDictionary *useInfo;
@property (nonatomic, strong) NSDictionary *serverInfo;


- (void)saveContext;

- (void)writeObject:(id)msgObj withMessageID:(NSInteger)msgID;
/*
 - (NSURL *)applicationDocumentsDirectory;
 
 - (NSString *)currentUserImageDocumentsDirectory;
 - (NSString *)currentUserAudioDocumentsDirectory;
 - (NSString *)currentUserVideoDocumentsDirectory;
 */


@end


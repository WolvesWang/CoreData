//
//  AppDelegate.m
//  CoreData
//
//  Created by wangwenbing on 2017/2/28.
//  Copyright © 2017年 Centit. All rights reserved.
//

#import "AppDelegate.h"
#import "WBMvsMessage.h"

#import "Message+CoreDataClass.h"
#import "Employee+CoreDataClass.h"
#import "CoreDatabaseManager.h"

#import "Bird+CoreDataClass.h"
#import "Mammal+CoreDataClass.h"
#import "Address+CoreDataClass.h"
@interface AppDelegate ()

@property (strong, nonatomic) NSManagedObjectContext *viewContext;
@property (strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (strong, nonatomic) NSPersistentStore *persistentStore;


@property (nonatomic, strong) NSDictionary *dataDictionary;


@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    [self persistentContainer];
    [self insertAnimal];
    self.dataDictionary = @{@"src": @"GuGuiJun",
                            @"dest": @"WangWenBing",
                            @"time" : @"2017-3-1 11:00:32",
                            @"content" : @"backlog",
                            @"type" : @1,
                            @"contentType" : @0,
                            @"address" : @"HeNan",
                            @"email": @"wang_wb@centit.com",
                            @"empID" : @"001",
                            @"empName" : @"WangWenBing",
                            @"extensionNumber" : @"loder",
                            @"mobilephone" : @"18705153964",
                            @"sex": @0,
                            @"job": @"soft"};
    WBMvsMessage *mvsMessage = [[WBMvsMessage alloc] initWithDictionary:_dataDictionary];
    
    CoreDatabaseManager *databaseManager = [CoreDatabaseManager sharedInstance];
    
    NSLog(@"%@",NSHomeDirectory());
    NSFileManager *fileManager = [NSFileManager defaultManager];
    for (NSBundle *bundle in [NSBundle allBundles]) {
        NSURL *oldStoreURL = [bundle URLForResource:@"Model1" withExtension:@"sqlite"];
        NSLog(@"old: %@", oldStoreURL);
        if (oldStoreURL) {
            [fileManager removeItemAtURL:databaseManager.sourceStoreURL error:nil];
            [fileManager copyItemAtURL:oldStoreURL
                                 toURL:databaseManager.sourceStoreURL
                                 error:nil];
            break;
        }
    }
    
    if (databaseManager.isMigrationNeeded) {
        [databaseManager migrate:nil];
    }
    
    [databaseManager insertNewChatMessage:mvsMessage isRelationships:YES];
       
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    // Saves changes in the application's managed object context before the application terminates.
    [self saveContext];
}


#pragma mark - Core Data stack

@synthesize persistentContainer = _persistentContainer;

/*
////////////////////////-------兼容iOS 9.0---------------////////////////////////////////////////////////////////
 - (NSURL *)applicationDocumentsDirectory
 {
 // The directory the application uses to store the Core Data store file. This code uses a directory named "com.company.DataTest" in the application's documents directory.
 [self currentUserPathWithComponent:nil];
 return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
 }
 
 - (NSString *)currentUserPathWithComponent:(NSString *)component {
 NSString *userDocument = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
 
 NSString *loginName = @"WangWenbing";//[self.userInfo valueForKey:@"loginName"];
 if (loginName) {
 userDocument = [userDocument stringByAppendingPathComponent:loginName];
 }
 
 if (component) {
 userDocument = [userDocument stringByAppendingPathComponent:component];
 }
 
 BOOL isDirectory = YES;
 if ([[NSFileManager defaultManager] fileExistsAtPath:userDocument isDirectory:&isDirectory] && isDirectory) {
 return userDocument ;
 }
 
 NSError *error = nil;
 if (![[NSFileManager defaultManager] createDirectoryAtPath:userDocument withIntermediateDirectories:YES attributes:nil error:&error]) {
 NSLog(@"Create '%@' failed...", userDocument);
 
 return nil;
 }
 
 return userDocument;
 }
 
 - (NSString *)currentUserImageDocumentsDirectory {
 
 return [self currentUserPathWithComponent:@"Image"];
 }
 
 - (NSString *)currentUserAudioDocumentsDirectory {
 return [self currentUserPathWithComponent:@"Audio"];
 }
 
 - (NSString *)currentUserVideoDocumentsDirectory {
 return [self currentUserPathWithComponent:@"Video"];
 }
 
- (NSManagedObjectContext *)viewContext {
    // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.)
    if (_viewContext != nil) {
        return _viewContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (!coordinator) {
        return nil;
    }
    _viewContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
    [_viewContext setPersistentStoreCoordinator:coordinator];
    return _viewContext;
}

- (NSManagedObjectModel *)managedObjectModel {
    // The managed object model for the application. It is a fatal error for the application not to be able to find and load its model.
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"CoreData" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    NSString *loginName = @"WangWenbing";// [self.userInfo valueForKey:@"loginName"];
    if (!loginName) {
        return nil;
    }
    
    // The persistent store coordinator for the application. This implementation creates and returns a coordinator, having added the store for the application to it.
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    // Create the coordinator and store
    
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    //根据用户登录信息创建不同的数据文件
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:loginName isDirectory:YES];
    storeURL = [storeURL URLByAppendingPathComponent:[NSString stringWithFormat:@"%@_CoreData.sqlite",@"WangWenBing"]];// 存的是IP
    NSLog(@"### Store Data Path: %@", storeURL);
    NSError *error = nil;
    NSString *failureReason = @"There was an error creating or loading the application's saved data.";
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        // Report any error we got.
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[NSLocalizedDescriptionKey] = @"Failed to initialize the application's saved data";
        dict[NSLocalizedFailureReasonErrorKey] = failureReason;
        dict[NSUnderlyingErrorKey] = error;
        error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];
        // Replace this with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}


 
 ////////////////////////-------兼容iOS 9.0---------------///////////////////////////////////////////////
 
*/
- (NSPersistentContainer *)persistentContainer {
    // The persistent container for the application. This implementation creates and returns a container, having loaded the store for the application to it.
    @synchronized (self) {
        if (_persistentContainer == nil) {
            _persistentContainer = [[NSPersistentContainer alloc] initWithName:@"CoreData"];
            [_persistentContainer loadPersistentStoresWithCompletionHandler:^(NSPersistentStoreDescription *storeDescription, NSError *error) {
                
////                //---------/iOS 10.0  轻量级数据迁移
//                NSDictionary *options = nil;
//                if ([[CoreDatabaseManager sharedInstance] isMigrationNeeded]) {
//                    options = @{
//                                NSInferMappingModelAutomaticallyOption : @YES,
//                                
//                                NSSQLitePragmasOption: @{@"journal_mode": @"DELETE"}
//                                };
//                } else {
//                    options = @{
//                                NSInferMappingModelAutomaticallyOption: @YES,
//                                NSSQLitePragmasOption: @{@"journal_mode": @"WAL"}
//                                };
//                }
//                NSDictionary *options = @{
//                                          NSSQLitePragmasOption:@{@"journal_mode": @"DELETE"},
//                                          
//                                          NSMigratePersistentStoresAutomaticallyOption : @(YES),
//                                          NSInferMappingModelAutomaticallyOption : @(YES)
//                                          };
//                NSFileManager *fileManager = [NSFileManager new];
//                [fileManager removeItemAtPath:storeDescription.URL.path error:nil];
//                if (![_persistentStoreCoordinator addPersistentStoreWithType:storeDescription.type configuration:nil URL:storeDescription.URL options:options error:&error]) {
//                    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
//                    dict[NSLocalizedDescriptionKey] = @"Failed to initialize the application's saved data";

//                }
                //---------/ iOS 10.0 轻量级数据迁移
                
            
                
                
                if (error != nil) {
                    // Replace this implementation with code to handle the error appropriately.
                    // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                    
                    /*
                     Typical reasons for an error here include:
                     * The parent directory does not exist, cannot be created, or disallows writing.
                     * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                     * The device is out of space.
                     * The store could not be migrated to the current model version.
                     Check the error message to determine what the actual problem was.
                    */
                    NSLog(@"Unresolved error %@, %@", error, error.userInfo);
                    abort();
                }
            }];
        }
    }
    
    /*
     ---------------///兼容 iOS 9.0  ///--------------------------------------------
     
     _managedObjectModel = [self managedObjectModel];
     _viewContext = [self viewContext];
     _persistentStoreCoordinator = [self persistentStoreCoordinator];
     
    ---------------///兼容 iOS 9.0  ///--------------------------------------------
     */
    //     iOS 10.0
    _managedObjectModel = _persistentContainer.managedObjectModel;
    _viewContext = _persistentContainer.viewContext;
    _persistentStoreCoordinator = _persistentContainer.persistentStoreCoordinator;

    return _persistentContainer;
}

#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext *context = self.persistentContainer.viewContext;
    NSError *error = nil;
    if ([context hasChanges] && ![context save:&error]) {
        // Replace this implementation with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, error.userInfo);
        abort();
    }
}


- (void)insertAnimal
{
    Mammal *mammal = [NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass([Mammal class]) inManagedObjectContext:self.persistentContainer.viewContext];
    mammal.eatFood = @"我喜欢吃草";
    mammal.sleepDec = @"早睡早起身体好";
    mammal.suckle = @"你是喝羊奶长大的";
//    mammal.walk = @"我喜欢在草原上奔跑";
//    mammal.icon = [UIImage imageNamed:@"dd_emotion.png"];// 尽量存路径 加密 存coreData
//    mammal.color = [UIColor yellowColor];
//    mammal.numbersArray = @[@"羊",@"狗",@"马"];
//    mammal.lifeDictionary = @{@"life": @[@"eat", @"drink", @"feel"]};
    
    Bird *bird = [NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass([Bird class]) inManagedObjectContext:self.persistentContainer.viewContext];
    bird.eatFood = @"我喜欢吃种子";
    bird.sleepDec = @"我喜欢在树上睡";
//    bird.feed = @"我饿极的时候，还会吃粮食";
//    bird.fly = @"我自由自在的在天上飞";
//    bird.speed = @"我的时速每小时10千米";
    
    /*
     Address *address = [NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass([Address class]) inManagedObjectContext:self.persistentContainer.viewContext];
     address.name = @"10";
     address.visitor = @"100";
     address.culture = @"1000";
     */
    
    [self saveContext];
}

@end

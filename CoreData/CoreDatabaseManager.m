//
//  CoreDatabaseManager.m
//  CoreData
//
//  Created by wangwenbing on 2017/3/2.
//  Copyright © 2017年 Centit. All rights reserved.
//

#import "CoreDatabaseManager.h"
#import "AppDelegate.h"
#import "Message+CoreDataClass.h"
#import "Employee+CoreDataClass.h"
#import "Session+CoreDataClass.h"
#import "WBMvsMessage.h"
#import "NSFileManager+WBAdditions.h"
#import "NSManagedObjectModel+WBAdditions.h"
#import <CoreData/CoreData.h>



@interface CoreDatabaseManager ()

@property (nonatomic, strong) AppDelegate *delegate;

@end


@implementation CoreDatabaseManager

static CoreDatabaseManager *databaseManager = nil;



+ (instancetype)sharedInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        databaseManager = [[self alloc] init];
    });
    return databaseManager;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (databaseManager == nil) {
            databaseManager = [super allocWithZone:zone];
        }
    });
    return databaseManager;
}

- (instancetype)init
{
    if (self = [super init]) {
        //进行一些初始化操作
        self.delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    }
    return self;
}

/*
 // 可以采用这一种封装方式， 将更灵活
 - (void)insertNewChatMessage:(Class)class isRelationships:(BOOL)flag completion:(WBCompletionHandle)success failure:(WBFailureHandle)failure
 
 Class -- 可以为模型类，还可以为字典
 */
- (void)insertNewChatMessage:(WBMvsMessage *)mvsMessage isRelationships:(BOOL)flag
{
    
    Message *messageInfo = [NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass([Message class]) inManagedObjectContext:self.delegate.persistentContainer.viewContext];
    Employee *employeeInfo = (Employee *)messageInfo.fromEmployee;
    messageInfo.content = [mvsMessage valueForKey:@"content"];
    messageInfo.dateTime = [NSDate date];
    messageInfo.isReaded = [NSNumber numberWithBool:NO];
    messageInfo.type = [NSNumber numberWithInteger:1];
    // 可以设置 employeeInfo的值
    if (!flag) {
        
       /*
        NSError *error = nil;
        BOOL result = [self.delegate.persistentContainer.viewContext save:&error];
        if (!result) {
        
        if (failure) {
        failure(nil,error);
        }
        } else {
        
        if (success) {
        success(YES,nil);
        }
        }
        */
        [self.delegate saveContext];
    }
    else {
        
        //查询本地是否有该用户的信息 --- 因为这几张表相互关联，所以插入Message表的时候，要查询一下其他相关关联的表是否存在
         //查询本地是否存在改用户信息
        NSFetchRequest *fetchEmployee = [[NSFetchRequest alloc] init];
        [fetchEmployee setEntity:[NSEntityDescription entityForName:NSStringFromClass([Employee class]) inManagedObjectContext:self.delegate.persistentContainer.viewContext]];
        NSPredicate *employeePredicate = [NSPredicate predicateWithFormat:@"empName=%@",[mvsMessage valueForKey:@"dest"]];
        [fetchEmployee setPredicate:employeePredicate];
        
        Employee *fromWho = [[self.delegate.persistentContainer.viewContext executeFetchRequest:fetchEmployee error:nil] lastObject];
        
        if (fromWho) {
            messageInfo.fromEmployee = fromWho;
        
        }
        else {
            // 网上请求，并插入这张表
            //TODO:根据loginName从服务器获取该用户信息并写入本地数据库4.17.9
            fromWho = [NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass([Employee class]) inManagedObjectContext:self.delegate.persistentContainer.viewContext];
            
            // 网络强求赋值
                  
                    fromWho.email = @"1023903061";
                    fromWho.empID = @"001";
                    fromWho.empName = @"WangWenbing";
                    fromWho.extensionNumber = @"loder";
                    fromWho.mobilephone = @"18913382275";
                    fromWho.sex = @1;
            
     
        }
        //查询本地是否存在session表
//        [self.delegate saveContext];
        // 保存信息，同步数据

        NSFetchRequest *fetchSession = [[NSFetchRequest alloc] init];
        [fetchSession setEntity:[NSEntityDescription entityForName:NSStringFromClass([Session class]) inManagedObjectContext:self.delegate.persistentContainer.viewContext]];
        NSPredicate *sessionPredicate = [NSPredicate predicateWithFormat:@"sessionType=%@",[NSNumber numberWithInt:1]];
        [fetchSession setPredicate:sessionPredicate];
        
        Session *session = [[self.delegate.persistentContainer.viewContext executeFetchRequest:fetchSession error:nil] lastObject];
        
        if (session) {
            session.lastMessage = messageInfo;
            messageInfo.session = session;
            session.fromEmplyee = fromWho;
        }
        else {
            session = [NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass([Session class]) inManagedObjectContext:self.delegate.persistentContainer.viewContext];
            
            session.sessionID = @"xxx";
            session.lastMessage = messageInfo;
            session.fromEmplyee = fromWho;
            session.sessionType = [NSNumber numberWithInt:1];
            session.unReadNumber = @(NO);
            messageInfo.session = session;
        }
        
        [self.delegate saveContext];
    
       
    }

}

- (BOOL)isMigrationNeeded
{
    NSError *error = nil;
    
    // Check if we need to migrate
    NSDictionary *sourceMetadata = [self sourceMetadata:&error];
    BOOL isMigrationNeeded = NO;
    
    if (sourceMetadata != nil) {
        NSManagedObjectModel *destinationModel = self.delegate.managedObjectModel;
        // Migration is needed if destinationModel is NOT compatible
        isMigrationNeeded = ![destinationModel isConfiguration:nil
                                   compatibleWithStoreMetadata:sourceMetadata];
    }
    NSLog(@"isMigrationNeeded: %d", isMigrationNeeded);
    return isMigrationNeeded;
}

- (BOOL)migrate:(NSError *__autoreleasing *)error
{
    // Enable migrations to run even while user exits app
    __block UIBackgroundTaskIdentifier bgTask;
    bgTask = [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:^{
        [[UIApplication sharedApplication] endBackgroundTask:bgTask];
        bgTask = UIBackgroundTaskInvalid;
    }];
    
    WBMigrationManager *migrationManager = [WBMigrationManager new];
    migrationManager.delegate = self;
    
    BOOL OK = [migrationManager progressivelyMigrateURL:[self sourceStoreURL] ofType:[self sourceStoreType] toModel:self.delegate.managedObjectModel error:error];
    if (OK) {
        NSLog(@"migration complete");
    }
    
    // Mark it as invalid
    [[UIApplication sharedApplication] endBackgroundTask:bgTask];
    bgTask = UIBackgroundTaskInvalid;
    return OK;
}

- (NSURL *)sourceStoreURL
{
    
    return [self.delegate.persistentContainer.persistentStoreDescriptions lastObject].URL;
;
}

- (NSString *)sourceStoreType
{
    return NSSQLiteStoreType;
}

- (NSDictionary *)sourceMetadata:(NSError **)error
{
    return [NSPersistentStoreCoordinator metadataForPersistentStoreOfType:[self sourceStoreType] URL:[self sourceStoreURL] options:nil error:error];
}
#pragma mark -
#pragma mark - MHWMigrationManagerDelegate

- (void)migrationManager:(WBMigrationManager *)migrationManager migrationProgress:(float)migrationProgress
{
    NSLog(@"migration progress: %f", migrationProgress);
}

- (NSArray *)migrationManager:(WBMigrationManager *)migrationManager
  mappingModelsForSourceModel:(NSManagedObjectModel *)sourceModel
{
    NSMutableArray *mappingModels = [@[] mutableCopy];
    NSString *modelName = [sourceModel mhw_modelName];
    if ([modelName isEqual:@"Model3"]) {
        // Migrating to Model3
        NSArray *urls = [[NSBundle bundleForClass:[self class]]
                         URLsForResourcesWithExtension:@"cdm"
                         subdirectory:nil];
        for (NSURL *url in urls) {
            if ([url.lastPathComponent rangeOfString:@"Model3ToModel"].length != 0) {
                NSMappingModel *mappingModel = [[NSMappingModel alloc] initWithContentsOfURL:url];
                if ([url.lastPathComponent rangeOfString:@"4"].length != 0) {
                    // User first so we create new relationship
                    [mappingModels insertObject:mappingModel atIndex:0];
                } else {
                    [mappingModels addObject:mappingModel];
                }
            }
        }
    }
    return mappingModels;
}
@end

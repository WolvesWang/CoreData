//
//  ViewController.m
//  CoreData
//
//  Created by wangwenbing on 2017/2/28.
//  Copyright © 2017年 Centit. All rights reserved.
//

#import "ViewController.h"
#import "WBChatMsg.h"
#import "ProductCategory.h"
#import "Person.h"
#import "Session+CoreDataClass.h"
#import "Employee+CoreDataClass.h"
#import "Message+CoreDataClass.h"
#import "Mammal+CoreDataClass.h"

#import "AppDelegate.h"
#import "WBDevice.h"
#import "BHRExtensions.h"
@interface ViewController ()<NSFetchedResultsControllerDelegate, UITableViewDelegate, UITableViewDataSource>


@property (nonatomic, strong) AppDelegate *appDelegate;
@property (nonatomic, strong) NSFetchedResultsController *fetchResultsController;
@property (nonatomic, strong) Session *session;
@property (weak, nonatomic) IBOutlet UITableView *tableView;


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = [NSString stringWithTestingUID];
    
    self.appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    [fetchRequest setEntity:[NSEntityDescription entityForName:NSStringFromClass([Mammal class]) inManagedObjectContext:self.appDelegate.viewContext]];
//    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"icon!=nil"];
//    [fetchRequest setPredicate:predicate];
    [fetchRequest setResultType:NSDictionaryResultType];
    NSError *error = nil;
    
    NSArray *dataArr = [self.appDelegate.viewContext executeFetchRequest:fetchRequest error:&error];
    
    NSLog(@"%@",dataArr);
    
    

    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(freeFetchedResultsController:) name:@"UILogoutSuccessNotification" object:nil];
    
    [self readData];
    
    
    /*
     WBDevice *device = [[WBDevice alloc] init];
     [device requestInfo]; 没有网络不会回调
     */
    
        
    
    // Do any additional setup after loading the view, typically from a nib.
}
- (NSFetchedResultsController *)fetchResultsController
{
    if (nil != _fetchResultsController) {
        return _fetchResultsController;
    }
    
    NSManagedObjectContext *context = self.appDelegate.viewContext;
    
    if (context == nil) {
        return nil;
    }
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    
    [fetchRequest setEntity:[NSEntityDescription entityForName:NSStringFromClass([Session class]) inManagedObjectContext:context]];
    [fetchRequest setFetchBatchSize:20];
    NSString *strCacheName = [NSString stringWithFormat:@"%@SessionMessage",self.session.sessionID];
    
    NSSortDescriptor *dateSort = [[NSSortDescriptor alloc] initWithKey:@"lastMessage.dateTime" ascending:NO];
    [fetchRequest setSortDescriptors:@[dateSort]];
    
    NSFetchedResultsController *fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:context sectionNameKeyPath:nil cacheName:strCacheName];
    fetchedResultsController.delegate = self;
    
    _fetchResultsController = fetchedResultsController;
    
    NSError *error = nil;
    
    [NSFetchedResultsController deleteCacheWithName:strCacheName];
    
    if (![_fetchResultsController performFetch:&error]) {
        
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        
        abort();
    }
    
    return _fetchResultsController;
}
- (void)freeFetchedResultsController:(NSNotification *)noti
{
    self.fetchResultsController = nil;
}

#pragma mark   UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.fetchResultsController sections].count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    id <NSFetchedResultsSectionInfo> sessionInfo = [[self.fetchResultsController sections] objectAtIndex:section];
    
    return [sessionInfo numberOfObjects];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell = [cell initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
    Session *sessionInfo = [self.fetchResultsController objectAtIndexPath:indexPath];
    Employee *formemployeeInfo = (Employee *)sessionInfo.fromEmplyee;
    Message *lastMessage = (Message *)sessionInfo.lastMessage;
    
    cell.textLabel.text = formemployeeInfo.empName;
    cell.detailTextLabel.text = lastMessage.content;
    
    return cell;
}

#pragma mark ------ UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}


- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        Session *sessionInfo = [self.fetchResultsController objectAtIndexPath:indexPath];
        
//        Message *messageInfo = (Message *)sessionInfo.lastMessage;
//        Employee *employeeInfo = (Employee *)sessionInfo.fromEmplyee;
        
        NSManagedObjectContext *context = self.appDelegate.viewContext;
        
        [context deleteObject:sessionInfo];
//        [context deleteObject:messageInfo];
//        [context deleteObject:employeeInfo];
        NSError *error = nil;
        
        if ( ![context save:&error]) {
            NSLog(@"unResolveError:%@  error:%@",error, [error localizedDescription]);
            abort();
        }
        
    }
}
#pragma mark --NSFetchResultsControllerDelegate

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller
{
    [self.tableView beginUpdates];
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    [self.tableView endUpdates];
    
}

- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id<NSFetchedResultsSectionInfo>)sectionInfo atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type {
    
    switch (type) {
        case NSFetchedResultsChangeInsert:
            [self.tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
        case NSFetchedResultsChangeDelete:
            [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
        default:
            break;
    }
    
}
- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath {
    
    switch (type) {
        case NSFetchedResultsChangeInsert:
            [self.tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            
            break;
        case NSFetchedResultsChangeDelete:
            [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            
            break;
        case NSFetchedResultsChangeMove:{
            
            [self.tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            
            //[self.tableView moveRowAtIndexPath:indexPath toIndexPath:newIndexPath];
        }
           
            
            break;
        case NSFetchedResultsChangeUpdate:
        {
            Session *sessionInfo = [self.fetchResultsController objectAtIndexPath:indexPath];
            Employee *fromEmployee = (Employee *)sessionInfo.fromEmplyee;
            Message *messageInfo = (Message *)sessionInfo.lastMessage;
            
            UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
            cell = [cell initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
            cell.textLabel.text = fromEmployee.empName;
            cell.detailTextLabel.text = messageInfo.content;
            
        }
            break;
        default:
            break;
    }
    
}

/*

- (void)configCoreData
{
    NSManagedObjectModel *model = [NSManagedObjectModel mergedModelFromBundles:nil];
    
    NSPersistentStoreCoordinator *psc = [[NSPersistentStoreCoordinator alloc]initWithManagedObjectModel:model];
    
    NSString *docs = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    
    NSURL *url = [NSURL fileURLWithPath:[docs stringByAppendingPathComponent:@"Person.sqlite"]];//设置数据库的路径和文件名称和类型
    
    
    // 添加持久化存储库，这里使用SQLite作为存储库
    NSError *error = nil;
    NSPersistentStore *store = [psc addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:url options:nil error:&error];
    if (store == nil) { // 直接抛异常
        [NSException raise:@"添加数据库错误" format:@"%@", [error localizedDescription]];
    }
    // 初始化上下文，设置persistentStoreCoordinator属性
    viewContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
    viewContext.persistentStoreCoordinator = psc;
    
    NSLog(@"%@",NSHomeDirectory());//数据库会存在沙盒目录的document文件夹下
}
*/
- (void)readData
{
 
  /*
  @"first_name": @"John",
  @"last_name": @"Doe"
   
   NSDictionary *dictDictionary = @{
   
   @"firstName": @"John",
   @"lastName": @"Doe"
   };
   Person *person = [[Person alloc] initWithDictionary:dictDictionary];

  */
    
    

  
    // Nested + Arrary  = Trees
    NSDictionary *dictDictionary = @{
        @"name": @"1",
        @"children": @[
                     @{ @"name": @"1.1" },
                     @{ @"name": @"1.2",
                     @"children": @[
                                @{ @"name": @"1.2.1",
                                @"children": @[
                                           @{ @"name": @"1.2.1.1" },
                                           @{ @"name": @"1.2.1.2" },
                                           ]
                                },
                                @{ @"name": @"1.2.2" },
                                ]
                     },
                     @{ @"name": @"1.3" }
                     ],
        @"person": @{
                
                @"firstName": @"John",
                @"lastName": @"Doe"
                }
    };
    ProductCategory *category = [[ProductCategory alloc] initWithDictionary:dictDictionary];
    
  
}
- (IBAction)addName:(id)sender {
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

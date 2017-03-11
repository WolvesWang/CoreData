//
//  NSFileManager+WBAdditions.m
//  CoreData
//
//  Created by wangwenbing on 2017/3/7.
//  Copyright © 2017年 Centit. All rights reserved.
//

#import "NSFileManager+WBAdditions.h"

@implementation NSFileManager (WBAdditions)

+ (NSURL *)urlToApplicationSupportDirectory
{
    NSString *applicationSupportDirectory = [NSSearchPathForDirectoriesInDomains(NSApplicationSupportDirectory,
                                                                                 NSUserDomainMask,
                                                                                 YES) objectAtIndex:0];
    BOOL isDir = NO;
    NSError *error = nil;
    NSFileManager *fileManager = [[NSFileManager alloc] init];
    if (![fileManager fileExistsAtPath:applicationSupportDirectory
                           isDirectory:&isDir] && isDir == NO) {
        [fileManager createDirectoryAtPath:applicationSupportDirectory
               withIntermediateDirectories:NO
                                attributes:nil
                                     error:&error];
    }
    return [NSURL fileURLWithPath:applicationSupportDirectory];
}
@end

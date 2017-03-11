//
//  NSUserDefaults+SecureDefaults.h
//  CoreData
//
//  Created by wangwenbing on 2017/3/3.
//  Copyright © 2017年 Centit. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSUserDefaults (SecureDefaults)

+ (id)secureDefaultForKey:(NSString *)key;
+ (void)setSecureDefault:(id <NSObject, NSCoding>)value forKey:(NSString *)key;
+ (void)removeSecureDefaultForKey:(NSString *)key;

@end

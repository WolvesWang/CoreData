//
//  Mammal+CoreDataClass.h
//  CoreData
//
//  Created by wangwenbing on 2017/3/6.
//  Copyright © 2017年 Centit. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Animal+CoreDataClass.h"

@class NSObject;

NS_ASSUME_NONNULL_BEGIN

@interface Mammal : Animal

@end

NS_ASSUME_NONNULL_END

#import "Mammal+CoreDataProperties.h"

#import <UIKit/UIKit.h>

@interface UIImageTransformer : NSValueTransformer

@end


@interface UIColorTransformer : NSValueTransformer

@end

@interface NSArrayTransformer : NSValueTransformer

@end

@interface NSDictionaryTransformer : NSValueTransformer

@end

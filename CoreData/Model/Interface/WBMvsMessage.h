//
//  WBMvsMessage.h
//  CoreData
//
//  Created by wangwenbing on 2017/3/1.
//  Copyright © 2017年 Centit. All rights reserved.
//

#import "Jastor.h"

@interface WBMvsMessage : Jastor <NSCoding, NSCopying>

@property (nonatomic, strong) NSString *src;
@property (nonatomic, strong) NSString *dest;
@property (nonatomic, strong) NSString *time;
@property (nonatomic, strong) NSString *content;
@property (nonatomic, strong) NSNumber *type;
@property (nonatomic, strong) NSNumber *contentType;

@end

@interface WBMvsMessageRep : Jastor <NSCoding, NSCopying>

@property (nonatomic, strong) NSNumber *code;
@property (nonatomic, strong) NSString *desc;

@end

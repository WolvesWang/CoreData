//
//  WBChatMsg.h
//  CoreData
//
//  Created by wangwenbing on 2017/3/1.
//  Copyright © 2017年 Centit. All rights reserved.
//

#import "Jastor.h"

@interface WBChatMsg : Jastor <NSCopying, NSCoding>

@property (strong, nonatomic) NSString *dest;
@property (strong, nonatomic) NSString *content;
@property (strong, nonatomic) NSNumber *contentType;

@end

@interface WBChatMsgRsp : Jastor <NSCopying, NSCoding>

@property (strong, nonatomic) NSNumber *code;
@property (strong, nonatomic) NSString *desc;

@end

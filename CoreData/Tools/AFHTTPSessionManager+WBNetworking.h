//
//  AFHTTPSessionManager+WBNetworking.h
//  CoreData
//
//  Created by wangwenbing on 2017/3/2.
//  Copyright © 2017年 Centit. All rights reserved.
//

#import "AFHTTPSessionManager.h"

@interface AFHTTPSessionManager (WBNetworking)

- (NSURLSessionDataTask *)options:(NSString *)URLString
                       parameters:(id)parameters
                          success:(void(^)(NSURLSessionDataTask *task, id responseObject))success
                          failure:(void(^)(NSURLSessionDataTask *task, NSError *error))failure;

@end

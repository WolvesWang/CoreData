//
//  AFHTTPSessionManager+WBNetworking.m
//  CoreData
//
//  Created by wangwenbing on 2017/3/2.
//  Copyright © 2017年 Centit. All rights reserved.
//

#import "AFHTTPSessionManager+WBNetworking.h"

@interface AFHTTPSessionManager ()


- (NSURLSessionDataTask *)dataTaskWithHTTPMethod:(NSString *)method
                                       URLString:(NSString *)URLString
                                      parameters:(id)parameters
                                  uploadProgress:(nullable void (^)(NSProgress *uploadProgress)) uploadProgress
                                downloadProgress:(nullable void (^)(NSProgress *downloadProgress)) downloadProgress
                                         success:(void (^)(NSURLSessionDataTask *, id))success
                                         failure:(void (^)(NSURLSessionDataTask *, NSError *))failure;


@end

@implementation AFHTTPSessionManager (WBNetworking)
// 扩张一种 发送请求的方式 ---类似与 GET  POST
- (NSURLSessionDataTask *)OPTIONS:(NSString *)URLString
                       parameters:(id)parameters
                          success:(void(^)(NSURLSessionDataTask *task, id responseObject))success
                          failure:(void(^)(NSURLSessionDataTask *task, NSError *error))failure
{
    NSURLSessionDataTask *dataTask = [self dataTaskWithHTTPMethod:@"OPTIONS" URLString:URLString parameters:parameters uploadProgress:nil downloadProgress:nil success:success failure:failure];
    [dataTask resume];
    return dataTask;
}
@end

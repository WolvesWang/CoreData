//
//  WBURLAuthenticationChallenge.m
//  CoreData
//
//  Created by wangwenbing on 2017/3/3.
//  Copyright © 2017年 Centit. All rights reserved.
//

#import "WBURLAuthenticationChallenge.h"
#import <security/Security.h>
#import "WBHTTPChannel.h"

NSURLSessionAuthChallengeDisposition FLYURLAuthenticationChallenge(NSURLAuthenticationChallenge *authenticationChallenge, NSURLCredential *__autoreleasing *credential)
{
    NSURLSessionAuthChallengeDisposition result = NSURLSessionAuthChallengePerformDefaultHandling;
    
    if (nil != authenticationChallenge && NULL != credential) {
        NSURLProtectionSpace *protectionSpace = [authenticationChallenge protectionSpace];
        NSString *authenticationMethod = [protectionSpace authenticationMethod];
        
        if (YES == [authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust]) {
            SecTrustRef serverTrust = [protectionSpace serverTrust];
            
            if (NULL != serverTrust) {
                *credential = [NSURLCredential credentialForTrust:serverTrust];
                
                result = NSURLSessionAuthChallengeUseCredential;
            }
        }
        else if ([authenticationMethod isEqualToString:NSURLAuthenticationMethodHTTPBasic] ||
                 [authenticationMethod isEqualToString:NSURLAuthenticationMethodHTTPDigest]) {
            NSInteger previousFailureCount = [authenticationChallenge previousFailureCount];
            
            if (0 == previousFailureCount) {
                // First time, try the default or stored password
            
                WBHTTPChannel *device = [[WBHTTPChannel alloc] init];
                if (device != nil) {
                    
        
                    
                    NSString *username = nil;//[device username];
                    NSString *password = nil;//[device password];
                    
                    *credential = [NSURLCredential credentialWithUser:username password:password persistence:NSURLCredentialPersistencePermanent];
                    
                    result = NSURLSessionAuthChallengeUseCredential;
                }
                else {
                    result = NSURLSessionAuthChallengeCancelAuthenticationChallenge;
                }
            }
            else {
                
                
                // We always cancel the request in this condition.
                result  = NSURLSessionAuthChallengeCancelAuthenticationChallenge;
                
            }
        }
    }
    
    return result;
}


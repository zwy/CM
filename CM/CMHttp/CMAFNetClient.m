//
//  CMAFNetClient.m
//  CM
//
//  Created by zwy on 14/11/25.
//  Copyright (c) 2014年 zwy. All rights reserved.
//

#import "CMAFNetClient.h"


@implementation CMAFNetClient

+ (instancetype)sharedClient {
    static CMAFNetClient *_sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
//        _sharedClient = [[CMAFNetClient alloc] initWithBaseURL:[NSURL URLWithString:BASE_URL]];
//        _sharedClient.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
        _sharedClient = [CMAFNetClient manager];
        _sharedClient.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"]; 
    });
    
    return _sharedClient;
}

@end

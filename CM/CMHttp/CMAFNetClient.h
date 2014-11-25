//
//  CMAFNetClient.h
//  CM
//
//  Created by zwy on 14/11/25.
//  Copyright (c) 2014年 zwy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AppDelegate.h"

@interface CMAFNetClient : AFHTTPRequestOperationManager

+ (instancetype)sharedClient;

@end

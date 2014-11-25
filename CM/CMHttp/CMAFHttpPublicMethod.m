//
//  CMAFHttpPublicMethod.m
//  CM
//
//  Created by zwy on 14/11/25.
//  Copyright (c) 2014年 zwy. All rights reserved.
//

#import "CMAFHttpPublicMethod.h"

@implementation CMAFHttpPublicMethod

- (void)getTimeLine
{
//    NSDictionary *parameters = @{@"cid": @"1380",@"token":@"bb20b471011fb93510b1c21f8e5115f6",@"uid":@"1223",@"v":@"2"};
    NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:@"1380",@"cid", @"bb20b471011fb93510b1c21f8e5115f6",@"token",@"1223",@"uid",@"2",@"v",nil];
    
    NSString *url = [BASE_URL stringByAppendingString:@"/growth/ilist"];
//    [[CMAFNetClient sharedClient]GET:url parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        NSLog(@"123");
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        NSLog(@"shibai");
//        if (error) {
//            [UIAlertView showAlertViewForRequestOperationWithErrorOnCompletion:operation delegate:nil];
//        }
//    }];
    
    [[CMAFNetClient sharedClient]POST:url parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"123");
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (error) {
            [UIAlertView showAlertViewForRequestOperationWithErrorOnCompletion:operation delegate:nil];
        }
    }];

    
}

@end

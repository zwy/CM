//
//  PublicAddressBookViewController.h
//  CM
//
//  Created by zwy on 14/11/13.
//  Copyright (c) 2014年 zwy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
@interface PublicAddressBookViewController : UIViewController
@property (nonatomic, assign)ABAddressBookRef addressBooks;
@property (retain, nonatomic) NSMutableArray *dataArray;
- (BOOL)checkGetAddressBookAuth;
- (NSMutableArray *)locaAddressBookArray;
@end

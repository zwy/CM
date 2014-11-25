//
//  AppDelegate.h
//  CM
//
//  Created by zwy on 14/11/4.
//  Copyright (c) 2014年 zwy. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <AFNetworking.h>
#import "Header/Header.h"
@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

+ (AppDelegate *)shareDelegate;
@end


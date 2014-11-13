//
//  PublicClassMethod.h
//  CM
//
//  Created by zwy on 14/11/12.
//  Copyright (c) 2014年 zwy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface PublicClassMethod : NSObject

+ (void)alertWithTitle:(NSString *)title msg:(NSString *)aMsg cancelTitle:(NSString *)aCancleTitle tag:(NSInteger)aTag delegate:(id)delegate;
+ (NSInteger)cellAccessoryType:(NSString *)typeStr;
@end

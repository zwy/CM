//
//  ZWYDBHelper.h
//  CM
//
//  Created by zwy on 14/11/12.
//  Copyright (c) 2014年 zwy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ContactItem.h"
@interface ZWYDBHelper : NSObject
//初始化并加载数据
+ (void)initDB;


+ (NSMutableArray *)searchLocaContact;
+ (void)updateContactsWithContactArray:(NSArray *)contactArray;
+ (void)insertContactsWithContactArray:(NSArray *)contactArray;
@end

//
//  ZWYAppMacro.h
//  CM
//
//  Created by zwy on 14/11/13.
//  Copyright (c) 2014年 zwy. All rights reserved.
//

typedef NS_ENUM(NSInteger, ManageType){
    delSameContact = 1,//去重
    mergeContact = 2,//合并
    batchDeleteContact = 3,//批量删除
    deleteInvalidContact = 4,//批量删除
};

#define BASE_URL  @"http://pi.changlianxi.com/"



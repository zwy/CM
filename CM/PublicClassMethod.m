//
//  PublicClassMethod.m
//  CM
//
//  Created by zwy on 14/11/12.
//  Copyright (c) 2014年 zwy. All rights reserved.
//

#import "PublicClassMethod.h"
#import "AppDelegate.h"
@implementation PublicClassMethod


// 弹出alert
+ (void)alertWithTitle:(NSString *)title msg:(NSString *)aMsg cancelTitle:(NSString *)aCancleTitle tag:(NSInteger)aTag delegate:(id)delegate
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
                                                    message:aMsg
                                                   delegate:delegate
                                          cancelButtonTitle:@"确定"
                                          otherButtonTitles:aCancleTitle, nil];
    alert.delegate = delegate;
    alert.tag = aTag;
    [alert show];
}
+ (NSInteger)cellAccessoryType:(NSString *)typeStr
{
    if ([typeStr isEqualToString:CellAccessoryNone]) {
        return UITableViewCellAccessoryNone;
    }
    else if ([typeStr isEqualToString:CellAccessoryDisclosureIndicator]) {
        return UITableViewCellAccessoryDisclosureIndicator;
    }
    else if ([typeStr isEqualToString:CellAccessoryDetailDisclosureButton]) {
        return UITableViewCellAccessoryDetailDisclosureButton;
    }
    else if ([typeStr isEqualToString:CellAccessoryCheckmark]) {
        return UITableViewCellAccessoryCheckmark;
    }
    return UITableViewCellAccessoryNone;
}

@end

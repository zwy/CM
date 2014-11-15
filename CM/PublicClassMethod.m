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

//验证邮箱格式
+ (BOOL)validateEmail:(NSString *)email
{
    //    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSString *emailRegex = @"^([a-z0-9A-Z]+[_-|\\.]?)+[a-z0-9A-Z]@([a-z0-9A-Z]+(-[a-z0-9A-Z]+)?\\.)+[a-z0-9A-Z]{2,}$";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    
    // "^([a-z0-9A-Z]+[_-|\\.]?)+[a-z0-9A-Z]@([a-z0-9A-Z]+(-[a-z0-9A-Z]+)?\\.)+[a-z0-9A-Z]{2,}$";
    return [emailTest evaluateWithObject:email];
}

//获取正常状态的国内手机号
+ (NSString *)turePhoneNumber:(NSString *)phoneNumber
{
    if (phoneNumber) {
        // 去除 空格
        phoneNumber = [phoneNumber stringByReplacingOccurrencesOfString:@" " withString:@""];
        //去除 -
        phoneNumber = [phoneNumber stringByReplacingOccurrencesOfString:@"-" withString:@""];
        // 去除 (  )
        phoneNumber = [phoneNumber stringByReplacingOccurrencesOfString:@"(" withString:@""];
        phoneNumber = [phoneNumber stringByReplacingOccurrencesOfString:@")" withString:@""];
        //
        phoneNumber = [phoneNumber stringByReplacingOccurrencesOfString:@" " withString:@""];
        
        // 去除+86 和0086
        if ([phoneNumber hasPrefix:@"+86"]) {
            NSRange range = [phoneNumber rangeOfString:@"+86"];
            phoneNumber = [phoneNumber substringFromIndex:range.length];
        }
        else if([phoneNumber hasPrefix:@"86"])
        {
            NSRange range = [phoneNumber rangeOfString:@"86"];
            phoneNumber = [phoneNumber substringFromIndex:range.length];
        }
        else if([phoneNumber hasPrefix:@"0086"])
        {
            NSRange range = [phoneNumber rangeOfString:@"0086"];
            phoneNumber = [phoneNumber substringFromIndex:range.length];
        }
        
    }
    return phoneNumber;
}

// 去除字符串左右两边的空格
+ (NSString *)stringByTrimmingWhitespaceWithString:(NSString *)string
{
    if (string == nil) {
        return nil;
    }
    NSString *res = [string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    return res;
}

+ (NSString *)getTheTimesStrYMDHM:(NSDate *)date
{
    NSString *nowDateString = @"";
    NSDate *nowDate = date;
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    nowDateString=[formatter stringFromDate:nowDate];
    
    return nowDateString;
}
@end

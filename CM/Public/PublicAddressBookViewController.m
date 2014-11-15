//
//  PublicAddressBookViewController.m
//  CM
//
//  Created by zwy on 14/11/13.
//  Copyright (c) 2014年 zwy. All rights reserved.
//

#import "PublicAddressBookViewController.h"

@implementation PublicAddressBookViewController




- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self loadAddressBook];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark -
- (void)loadAddressBook
{
    [self checkAddressBook];
    [self createAddressBook];
}
- (void)checkAddressBook
{
    //    self.addressBooks = nil;
    
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 6.0)
    {
        // 如果弹出这个之前还有一个弹出框 则会出现卡死现象
        self.addressBooks = ABAddressBookCreateWithOptions(NULL, NULL);
        
        //等待同意后向下执行
        dispatch_semaphore_t sema = dispatch_semaphore_create(0);
        ABAddressBookRequestAccessWithCompletion(self.addressBooks, ^(bool granted, CFErrorRef error)
                                                 {
                                                     dispatch_semaphore_signal(sema);
                                                 });
        
        dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
        
    }
}
- (void)createAddressBook
{
    
    if (ABAddressBookGetAuthorizationStatus() != kABAuthorizationStatusAuthorized) {
        
        [PublicClassMethod alertWithTitle:@"读取通讯录失败！" msg:@"读取通讯录失败，请到设置->隐私->通讯录，中开启常联系访问通讯录功能" cancelTitle:nil tag:0 delegate:nil];
        
    }
}

- (BOOL)checkGetAddressBookAuth
{
    if (ABAddressBookGetAuthorizationStatus() != kABAuthorizationStatusAuthorized) {
        return NO;
    }
    else if (self.addressBooks == nil)
    {
        return NO;
    }
    return YES;
}

// 获取 通讯录的数据 Loca_Contact
- (NSMutableArray *)locaAddressBookArray
{
    NSLog(@"读取通讯录");
    NSMutableArray *iphoneContactList = [[NSMutableArray alloc] initWithCapacity:0];
    CFArrayRef results = ABAddressBookCopyArrayOfAllPeople(self.addressBooks);
    
    
    NSMutableArray *resArray = [[NSMutableArray alloc] initWithCapacity:0];
    for(int i = 0; i < CFArrayGetCount(results); i++)
    {
        NSMutableDictionary *dicInfoLocal = [NSMutableDictionary dictionaryWithCapacity:0];
        ABRecordRef person = CFArrayGetValueAtIndex(results, i);
        //1. 唯一标示
        NSInteger lookupforkey =(NSInteger)ABRecordGetRecordID(person);//读取通讯录中联系人的唯一标识
        [dicInfoLocal setObject:[NSString stringWithFormat:@"%ld",lookupforkey] forKey:@"tableId"];
        //2.读取 name
        NSString *first = (__bridge NSString*)ABRecordCopyValue(person, kABPersonFirstNameProperty);
        
        if (first==nil) {
            first = @"";
        }
        NSString *last = (__bridge NSString *)ABRecordCopyValue(person, kABPersonLastNameProperty);
        if (last == nil) {
            last = @"";
        }
        NSString *nameStr = [last stringByAppendingString:first];
        [dicInfoLocal setObject:nameStr forKey:@"name"];
        
        //3.电话
        ABMultiValueRef phone = ABRecordCopyValue(person, kABPersonPhoneProperty);
        NSMutableArray *phoneArray = [[NSMutableArray alloc] init];
        for (int m = 0; m < ABMultiValueGetCount(phone); m++) {
            NSString * aPhone = (__bridge NSString *)ABMultiValueCopyValueAtIndex(phone, m) ;
            
            if (aPhone == nil) {
                aPhone = @"";
            }
            [phoneArray addObject:aPhone];
        }
        [dicInfoLocal setObject:phoneArray forKey:@"teles"];
        CFRelease(phone);
        //4.邮件
        ABMultiValueRef email = ABRecordCopyValue(person, kABPersonEmailProperty);
        NSMutableArray *emailArray = [[NSMutableArray alloc] init];
        for (int m = 0; m < ABMultiValueGetCount(email); m++) {
            NSString * aEmail = (__bridge NSString *)ABMultiValueCopyValueAtIndex(email, m) ;
            
            if (aEmail == nil) {
                aEmail = @"";
            }
            [emailArray addObject:aEmail];
        }
        [dicInfoLocal setObject:emailArray forKey:@"emails"];
        CFRelease(email);
        
        // 5.时间
        NSDate * lastUpdateDate = (__bridge NSDate *)ABRecordCopyValue(person, kABPersonModificationDateProperty);
        [dicInfoLocal setObject:lastUpdateDate forKey:@"date"];
        
        [resArray addObject:dicInfoLocal];
    }
    CFRelease(results);//new
    
    for (NSDictionary *dicTemp in resArray) {
        ContactItem * contact = [[ContactItem alloc]init];
        contact.contact_Id = [dicTemp objectForKey:@"tableId"];
        contact.name = [dicTemp objectForKey:@"name"];
        NSString *phoneStr = @"";
        NSArray *teleArray = [dicTemp objectForKey:@"teles"];
        for (int m = 0; m < [teleArray count]; m++) {
            NSString *tele = [teleArray objectAtIndex:m];
            tele = [PublicClassMethod turePhoneNumber:tele];
            if (tele.length > 0) {
                if (m!=0) {
                    phoneStr = [phoneStr stringByAppendingFormat:@"%@%@",TELE_DIV,tele];
                }
                else
                {
                    phoneStr = tele;
                }
            }
        }
        contact.teles = phoneStr;
        NSString *timeStr = [PublicClassMethod getTheTimesStrYMDHM:[dicTemp objectForKey:@"date"]];
        contact.lastUpdateTime = timeStr;
        NSString *emailStr = @"";
        NSArray *emaliArray = [dicTemp objectForKey:@"emails"];
        for (int m = 0; m < [emaliArray count]; m++) {
            NSString *email = [emaliArray objectAtIndex:m];
            email = [PublicClassMethod turePhoneNumber:email];
            if (email.length > 0) {
                if (m!=0) {
                    emailStr = [emailStr stringByAppendingFormat:@"%@%@",TELE_DIV,email];
                }
                else
                {
                    emailStr = email;
                }
            }
        }
        contact.emails = emailStr;
        
        [iphoneContactList addObject:contact];
    }
    return iphoneContactList;
}

//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//    
//}

@end

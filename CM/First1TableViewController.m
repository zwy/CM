//
//  First1TableViewController.m
//  CM
//
//  Created by zwy on 14/11/4.
//  Copyright (c) 2014年 zwy. All rights reserved.
//

#import "First1TableViewController.h"
#import "ContactItem.h"



@interface First1TableViewController ()

@end

@implementation First1TableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.dataArray = [[NSMutableArray alloc] init];
    
//    self.navigationItem.rightBarButtonItem = self.editButtonItem;

//    [self.tableView setEditing:YES animated:YES];
    [self createTableView];
    [self checkAddressBook];
    [self createAddressBook];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    else if (self.addressBooks == nil) {
        
    }
    else
    {
        [self syncContact];
    }
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
        [dicInfoLocal setObject:[NSString stringWithFormat:@"%d",lookupforkey] forKey:@"tableId"];
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
//同步通讯录
- (void)syncContact
{
    dispatch_async(dispatch_get_main_queue(), ^{
        //获取本地数据库中的通讯录信息
        NSMutableArray *myIphoneContactList = [self coreDateAddressbookArray];
        if ([myIphoneContactList count] > 0) {
            // 本地数据库有通讯录的数据 则与通讯录里的数据进行对比
            
            // 只进行 增加  和更新操作  不进行 删除操作  这儿的逻辑是删除是用户自己手动删除
            NSMutableArray *iphoneContactList = [self locaAddressBookArray];
            
            //对比得出 要上传的数组
            BOOL isChange = [self isChangeAddressBookWithNewArray:iphoneContactList oldArray:myIphoneContactList];
            if (isChange) {
                
                // 有变化 更新本地数据库
                [self upLodaAddressBookWithAddressBookArray:iphoneContactList];
            }
        }
        else
        {
            // 数据库没有数据  则把通讯录里的全部插入数据库
            
            NSMutableArray *iphoneContactList = [self locaAddressBookArray];
            if (iphoneContactList) {
                [self locaAddressBookInsertArrayWithNewArray:iphoneContactList];
            }
        }
        
        // 获取数据
        [self getTableViewData];
        
    });
}



//通讯录 和数据库里的对比 是否需要上传 aNewArray:从通讯录获取的数组 aOldArray：数据库存的数组
- (BOOL)isChangeAddressBookWithNewArray:(NSArray *)aNewArray oldArray:(NSArray *)aOldArray
{
    
    // 得到要删除的数组 那些在就的
    NSMutableArray *newArrayId = [[NSMutableArray alloc] initWithCapacity:0];
    for (ContactItem *contact in aNewArray) {
        [newArrayId addObject:contact.contact_Id];
    }
    NSArray *hasOldArray = [aOldArray filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"self.contact_Id IN %@ ",newArrayId]];
    NSLog(@"开始检测");
    BOOL isChange = NO;
    if ([aNewArray count] != [aOldArray count]) {
        isChange = YES;
    }
    else
    {
        NSMutableArray *oldArray = [[NSMutableArray alloc] initWithCapacity:0];
        for (ContactItem *contact in hasOldArray) {
            [oldArray addObject:contact.lastUpdateTime];
        }
        // 得到要删除的数组 那些在就的
        NSMutableArray *newArray = [[NSMutableArray alloc] initWithCapacity:0];
        for (ContactItem *contact in aNewArray) {
            [newArray addObject:contact.lastUpdateTime];
        }
        [newArray removeObjectsInArray:oldArray];
        // 去掉有的数组 得到被删除的数组
        if ([newArray count] > 0) {
            isChange = YES;
        }
    }
    return isChange;
}

//获取数据库里存储的通讯录的数据
- (NSMutableArray *)coreDateAddressbookArray
{
    NSMutableArray *myIphoneContactList = [ZWYDBHelper searchLocaContact];
    return myIphoneContactList;
}

// 通讯录有了变化之后 AddressBookArray:本地通讯录的数组
- (void)upLodaAddressBookWithAddressBookArray:(NSArray *)aArray
{
    
    // 插入本地数据库 ######注意本地删除的数组在本地数据库里是要删除的
    // 得到要更新的数组 和要删除的
    NSLog(@"开始更新本地通讯录的数据");
    // 逻辑是先删掉本地数据库里的 在的到没有变化的以此得到有变化的
//    [self locaAddressBookDeleteArrayWithNewArray:aArray];
    [self locaAddressBookUpdateArrayWithNewArray:aArray];
    [self locaAddressBookInsertArrayWithNewArray:aArray];
    NSLog(@"结束更新本地通讯录的数据");
}

//aNewArray:从通讯录获取的数组 aOldArray：数据库存的数组
- (void)locaAddressBookUpdateArrayWithNewArray:(NSArray *)aNewArray
{
    NSLog(@"开始修改本地通讯录的数据");
    //获取本地数据库中的通讯录信息
    NSMutableArray *aOldArray = [self coreDateAddressbookArray];
    
    // 对比得到没有变化过的数组
    NSMutableArray *changeArray = [[NSMutableArray alloc] initWithCapacity:0];

    NSMutableArray *oldArray = [[NSMutableArray alloc] initWithCapacity:0];
    for (ContactItem *contact in aOldArray) {
        [oldArray addObject:contact.lastUpdateTime];
    }
    // 得到要删除的数组 那些在就的
    NSMutableArray *newArray = [[NSMutableArray alloc] initWithCapacity:0];
    for (ContactItem *contact in aNewArray) {
        [newArray addObject:contact.lastUpdateTime];
    }
    [newArray removeObjectsInArray:oldArray];
    // 去掉有的数组 得到被删除的数组
    if ([newArray count] > 0) {
        changeArray = (NSMutableArray *)[aNewArray filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"self.lastUpdateTime IN %@",newArray]];
    }
    
    // 要更新的数组
    if ([changeArray count] > 0) {
        
        [ZWYDBHelper updateContactsWithContactArray:changeArray];
    }
    NSLog(@"结束修改本地通讯录的数据");
}

// 插入本地数据库
- (void)locaAddressBookInsertArrayWithNewArray:(NSArray *)aNewArray
{
    NSLog(@"开始插入本地通讯录的数据");
    //获取本地数据库中的通讯录信息
    NSMutableArray *aOldArray = [self coreDateAddressbookArray];
    // 要删除的数组
    //    NSMutableArray *deleteArray = [[NSMutableArray alloc] initWithArray:aOldArray];
    NSMutableArray *oldArrayId = [[NSMutableArray alloc] initWithCapacity:0];
    for (ContactItem *contact in aOldArray) {
        [oldArrayId addObject:contact.contact_Id];
    }
    // 得到要删除的数组 那些在就的
    NSMutableArray *newArrayId = [[NSMutableArray alloc] initWithCapacity:0];
    for (ContactItem *contact in aNewArray) {
        [newArrayId addObject:contact.contact_Id];
    }
    [newArrayId removeObjectsInArray:oldArrayId];
    
    // 去掉有的数组 得到被删除的数组
    if ([newArrayId count] > 0) {
        
        NSArray *insertArray = [aNewArray filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"self.contact_Id in %@",newArrayId]];
        [ZWYDBHelper insertContactsWithContactArray:insertArray];
    }
    NSLog(@"结束插入本地通讯录的数据");
}

#pragma mark - 
- (void)createTableView
{
    
}

- (void)getTableViewData
{
    self.dataArray = [self coreDateAddressbookArray];
    [self.tableView reloadData];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return [self.dataArray count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FirstCellId" forIndexPath:indexPath];
    
    // Configure the cell...
    ContactItem *item = [self.dataArray objectAtIndex:indexPath.row];
    UILabel *nameLabel = (UILabel *)[cell.contentView viewWithTag:100];
    UILabel *valueLabel = (UILabel *)[cell.contentView viewWithTag:101];
    
    nameLabel.text = item.name;
    valueLabel.text = item.teles.length > 0?item.teles:@"";
    return cell;
}



// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleNone;
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
//        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}



// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
    NSLog(@"nihao");
}



// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}


//- (IBAction)back
//{
//    [self.navigationController popViewControllerAnimated:YES];
//}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    
}


@end

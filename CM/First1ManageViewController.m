//
//  First1ManageViewController.m
//  CM
//
//  Created by zwy on 14/11/13.
//  Copyright (c) 2014年 zwy. All rights reserved.
//

#import "First1ManageViewController.h"

@interface First1ManageViewController ()

@end

@implementation First1ManageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.showArray = [[NSArray alloc] init];
    [self createNav];
//    [self loadAddressBook];
    
    [self reloadView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark - 
- (void)createNav
{
    self.title = self.navTitle;
}

- (void)reloadView
{
    if (self.type == batchDeleteContact)
    {
        self.editBtn.hidden = YES;
        [self toCalculate];
        
    }
}

- (IBAction)editBtnAction:(id)sender
{
    // 判断能不能读
    if ([self checkGetAddressBookAuth]) {
        // 开始
        self.editBtn.enabled = NO;
        [self.editBtn setTitle:@"正在计算..." forState:UIControlStateNormal];
        
        [self toCalculate];
    }
    else
    {
        
    }
}

- (IBAction)rightItemAction:(id)sender
{
    if(self.type == delSameContact || self.type == deleteInvalidContact)
    {
        // 删除
        [self deleteContact];
    }
    else
    {
        NSString *messageStr = [NSString stringWithFormat:@"你确定删除这%lu位联系人么,一旦删除是不好恢复的",(unsigned long)[self.showIdArray count]];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                        message:messageStr
                                                       delegate:self
                                              cancelButtonTitle:@"取消"
                                              otherButtonTitles:@"确定", nil];
        alert.tag = 0;
        [alert show];
    }
}

- (void)deleteContact
{
    dispatch_async(dispatch_get_main_queue(), ^{
        // 获取通讯录中所有的联系人
        NSLog(@"开始删除");
        NSArray *array = (__bridge NSArray*)ABAddressBookCopyArrayOfAllPeople(self.addressBooks);
        // 遍历所有的联系人并删除(这里只删除姓名为张三的)
        for (id obj in array) {
            ABRecordRef people = (__bridge ABRecordRef)obj;
            NSInteger lookupforkey =(NSInteger)ABRecordGetRecordID(people);
            NSString *lookupStr = [NSString stringWithFormat:@"%ld",lookupforkey];
            if ([self.showIdArray containsObject:lookupStr]) {
                ABAddressBookRemoveRecord(self.addressBooks, people,NULL);
            }
        }
        // 保存修改的通讯录对象
        ABAddressBookSave(self.addressBooks, NULL);
        NSLog(@"结束删除");
        [self toCalculate];
    });
}


// 计算
- (void)toCalculate
{
    if(self.type == delSameContact)
    {
        // 去重
        self.contactArray = [self locaAddressBookArray];
        
        // 1.找出名字 电话相同的
        self.showIdArray = [[NSMutableArray alloc] init];
        for (int i = 0; i < [self.contactArray count]; i ++) {
            ContactItem * contact = [self.contactArray objectAtIndex:i];
            for (int j = 0; j < i; j ++) {
                ContactItem * contactT = [self.contactArray objectAtIndex:j];
                
                // ###### 计算规则1:去重  TODO 算法优化
                if ([contact.name isEqualToString:contactT.name] && [contact.teles isEqualToString:contactT.teles] && [contact.emails isEqualToString:contactT.emails]) {
                    [self.showIdArray addObject:contact.contact_Id];
                    break;
                }
            }
        }
        
        self.showArray = [self.contactArray filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"self.contact_Id IN %@",self.showIdArray]];
        self.editBtn.hidden = YES;
        
        [self.tableView reloadData];
    }
    else if (self.type == deleteInvalidContact)
    {
        // 删除无效的
        self.contactArray = [self locaAddressBookArray];
        
        // 1.找出名字 电话相同的
        self.showIdArray = [[NSMutableArray alloc] init];
        for (int i = 0; i < [self.contactArray count]; i ++) {
            ContactItem * contact = [self.contactArray objectAtIndex:i];
            // ###### 计算规则1:去重  TODO 算法优化
            if (contact.name.length == 0 ||(contact.teles.length == 0 && contact.emails.length == 0)) {
                [self.showIdArray addObject:contact.contact_Id];
            }
        }
        
        self.showArray = [self.contactArray filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"self.contact_Id IN %@",self.showIdArray]];
        self.editBtn.hidden = YES;
        
        [self.tableView reloadData];
    }
    else if (self.type == mergeContact)
    {
        
    }
    else if (self.type == batchDeleteContact)
    {
        self.contactArray = [self locaAddressBookArray];
        self.showIdArray = [[NSMutableArray alloc] init];
        self.showArray = self.contactArray;
        [self.tableView reloadData];
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [self.showArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FirstCellId" forIndexPath:indexPath];
    
    // Configure the cell...
    ContactItem *item = [self.showArray objectAtIndex:indexPath.row];
    UILabel *nameLabel = (UILabel *)[cell.contentView viewWithTag:100];
    UILabel *valueLabel = (UILabel *)[cell.contentView viewWithTag:101];
    UILabel *emailLabel = (UILabel *)[cell.contentView viewWithTag:102];
    nameLabel.text = item.name;
    valueLabel.text = item.teles.length > 0?item.teles:@"";
    emailLabel.text = item.emails.length > 0?item.emails:@"";
    
    if (self.type == batchDeleteContact) {
        if ([self.showIdArray containsObject:item.contact_Id]) {
            cell.backgroundColor = [UIColor colorWithRed:55.0/255.0 green:160.0/255.0 blue:215.0/255.0 alpha:1.0];
        }
        else
        {
            cell.backgroundColor = [UIColor whiteColor];
        }
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (self.type == batchDeleteContact) {
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];

        ContactItem *item = [self.showArray objectAtIndex:indexPath.row];
        if ([self.showIdArray containsObject:item.contact_Id]) {
            [self.showIdArray removeObject:item.contact_Id];
            cell.backgroundColor = [UIColor whiteColor];
        }
        else
        {
            [self.showIdArray addObject:item.contact_Id];
            cell.backgroundColor = [UIColor colorWithRed:55.0/255.0 green:160.0/255.0 blue:215.0/255.0 alpha:1.0];
        }
        
    }
    
    
}

//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//
//}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 0) {
        if (buttonIndex == 1) {
            [self deleteContact];
            [PublicClassMethod alertWithTitle:@"提示" msg:@"删除成功" cancelTitle:nil tag:0 delegate:nil];
        }
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

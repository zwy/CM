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
    if(self.type == delSameContact)
    {
        // 删除
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
                if ([contact.name isEqualToString:contactT.name] && [contact.teles isEqualToString:contactT.teles] ) {
                    [self.showIdArray addObject:contact.contact_Id];
                    break;
                }
            }
        }
        
        self.showArray = [self.contactArray filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"self.contact_Id IN %@",self.showIdArray]];
        self.editBtn.hidden = YES;
        
        [self.tableView reloadData];
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [self.showArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FirstCellId" forIndexPath:indexPath];
    
    // Configure the cell...
    ContactItem *item = [self.showArray objectAtIndex:indexPath.row];
    UILabel *nameLabel = (UILabel *)[cell.contentView viewWithTag:100];
    UILabel *valueLabel = (UILabel *)[cell.contentView viewWithTag:101];
    
    nameLabel.text = item.name;
    valueLabel.text = item.teles.length > 0?item.teles:@"";
    return cell;
}

//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//
//}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

//
//  FirstViewController.m
//  CM
//
//  Created by zwy on 14/11/4.
//  Copyright (c) 2014年 zwy. All rights reserved.
//

#import "FirstViewController.h"
#import "First1NormalCell.h"
#import "First1ManageViewController.h"
@interface FirstViewController ()

@end

@implementation FirstViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.title = @"管理";
    
    
    
    [self createTableViewDataSouce];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = NO;
}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self createContact];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 通讯录
- (void)createContact
{
    [self checkAddressBook];
    
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



#pragma mark
- (void)createTableViewDataSouce
{
    self.dataArray = [[NSMutableArray alloc] initWithObjects:
                    //1 同步
                    [[NSDictionary alloc] initWithObjectsAndKeys:
                     [NSArray arrayWithObjects:@"ManageCellId", nil],kCellIdentifier,
                     [NSArray arrayWithObjects:@"同步本地通讯录", nil],kCellTitle,
                     [NSArray arrayWithObjects:@"", nil],kCellContent,
                     [NSArray arrayWithObjects:CellAccessoryNone, nil],kCellAccessoryType,
                     [NSArray arrayWithObjects:@"First_Sync_Contacts_Segue", nil],kCellSegue,
                     nil],
                      
                      
                      //2 一键检测
                      
                      // 3 合并 删除等一系列操作
                      [[NSDictionary alloc] initWithObjectsAndKeys:
                       [NSArray arrayWithObjects:@"ManageCellId",@"ManageCellId",@"ManageCellId", nil],kCellIdentifier,
                       [NSArray arrayWithObjects:@"去重",@"合并",@"批量删除", nil],kCellTitle,
                       [NSArray arrayWithObjects:@"去掉名字电话相同的",@"将名字相同电话不同的合并",@"批量删掉那些没关系的人", nil],kCellContent,
                       [NSArray arrayWithObjects:CellAccessoryNone,CellAccessoryNone,CellAccessoryNone, nil],kCellAccessoryType,
                       [NSArray arrayWithObjects:@"Delete_Same_Contact_Segue", @"Delete_Same_Contact_Segue",@"Delete_Same_Contact_Segue",nil],kCellSegue,
                       nil],
                      // 4 群发短信邮件
                      nil];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.dataArray count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSDictionary *dic = [self.dataArray objectAtIndex:section];
    return [[dic objectForKey:kCellIdentifier] count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSDictionary *dic = [self.dataArray objectAtIndex:indexPath.section];
    NSArray *cellArray = [dic objectForKey:kCellIdentifier];
    NSString *reuseIdentifier = [cellArray objectAtIndex:indexPath.row];
    NSArray *accessoryArray = [dic objectForKey:kCellAccessoryType];
    NSString *cellAccessoryType = [accessoryArray objectAtIndex:indexPath.row];

    NSArray *titleArray = [dic objectForKey:kCellTitle];
    NSArray *valueArray = [dic objectForKey:kCellContent];
    First1NormalCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier forIndexPath:indexPath];
    cell.accessoryType = [PublicClassMethod cellAccessoryType:cellAccessoryType];
//    cell.textLabel.text = [NSString stringWithFormat:@"%ld",(long)indexPath.row];
    // Configure the cell...
    cell.nameLabel.text = [titleArray objectAtIndex:indexPath.row];
    cell.descriptionLabel.text = [valueArray objectAtIndex:indexPath.row];
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSDictionary *dic = [self.dataArray objectAtIndex:indexPath.section];
    NSArray *cellArray = [dic objectForKey:kCellSegue];
    if ([cellArray count] > indexPath.row) {
        NSString *cellSegue = [cellArray objectAtIndex:indexPath.row];
        if([cellSegue length] > 0)
        {
            [self performSegueWithIdentifier:cellSegue sender:nil];
        }
    }
}



#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    self.tabBarController.tabBar.hidden = YES;
    if ([segue.identifier isEqualToString:@"First_Sync_Contacts_Segue"]) {
        
    }
    else if ([segue.identifier isEqualToString:@"Delete_Same_Contact_Segue"])
    {
        First1ManageViewController *first1ManageViewController = [segue destinationViewController];
        first1ManageViewController.type = delSameContact;
        first1ManageViewController.navTitle = @"去重";
    }
}


@end

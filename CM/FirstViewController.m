//
//  FirstViewController.m
//  CM
//
//  Created by zwy on 14/11/4.
//  Copyright (c) 2014年 zwy. All rights reserved.
//

#import "FirstViewController.h"
#import "First1NormalCell.h"

@interface FirstViewController ()

@end

@implementation FirstViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.title = @"管理";
    
    
    
    [self createTableViewDataSouce];
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
    else if (self.addressBooks == nil) {

    }
    else
    {

    }
}

#pragma mark
- (void)createTableViewDataSouce
{
    self.dataArray = [[NSMutableArray alloc] initWithObjects:
                    //1 全名
                    [[NSDictionary alloc] initWithObjectsAndKeys:
                     [NSArray arrayWithObjects:@"ManageCellId", nil],kCellIdentifier,
                     [NSArray arrayWithObjects:@"同步本地通讯录", nil],kCellTitle,
                     [NSArray arrayWithObjects:@"", nil],kCellContent,
                     [NSArray arrayWithObjects:CellAccessoryNone, nil],kCellAccessoryType,
                     [NSArray arrayWithObjects:@"First_Sync_Contacts_Segue", nil],kCellSegue,
                     nil],
                     
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

    First1NormalCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier forIndexPath:indexPath];
    cell.accessoryType = [PublicClassMethod cellAccessoryType:cellAccessoryType];
//    cell.textLabel.text = [NSString stringWithFormat:@"%ld",(long)indexPath.row];
    // Configure the cell...
    cell.nameLabel.text = @"同步本地通讯录";
    
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
    if ([segue.identifier isEqualToString:@"First_Sync_Contacts_Segue"]) {
        
    }
}


@end

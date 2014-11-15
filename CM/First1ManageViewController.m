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

// 计算
- (void)toCalculate
{
    if(self.type == delSameContact)
    {
        // 去重
        self.contactArray = [self locaAddressBookArray];
        
        // 1.找出名字 电话相同的
//        for (ContactItem * contact in self.contactArray) {
//            NSArray *contactArray =
//        }
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 0;
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

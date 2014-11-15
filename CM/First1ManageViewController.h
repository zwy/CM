//
//  First1ManageViewController.h
//  CM
//
//  Created by zwy on 14/11/13.
//  Copyright (c) 2014年 zwy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "PublicAddressBookViewController.h"
@interface First1ManageViewController : PublicAddressBookViewController<UITableViewDataSource,UITableViewDelegate>
//@property (nonatomic, assign)ABAddressBookRef addressBooks;
@property (nonatomic, assign) ManageType type;
@property (nonatomic, retain) IBOutlet UITableView *tableView;
@property (nonatomic, retain) IBOutlet UIButton *editBtn;
@property (nonatomic, retain) NSString *navTitle;
@property (retain, nonatomic) NSMutableArray *dataArray;
@property (retain, nonatomic) NSMutableArray *contactArray;
@end

//
//  FirstViewController.h
//  CM
//
//  Created by zwy on 14/11/4.
//  Copyright (c) 2014年 zwy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
@interface FirstViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, assign)ABAddressBookRef addressBooks;
@property (retain, nonatomic) NSMutableArray *dataArray;// tableview 数据
@end


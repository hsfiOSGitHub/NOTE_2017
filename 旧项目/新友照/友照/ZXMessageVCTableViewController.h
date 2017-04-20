//
//  ZXMessageVCTableViewController.h
//  ZXJiaXiao
//
//  Created by Finsen on 16/6/23.
//  Copyright © 2016年 ZX. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZXMessageVCTableViewController : ZXSeconBaseViewController

@property (nonatomic, strong) UITableView *tableView;
//消息数据源
@property (nonatomic, strong)NSMutableArray *dataSource;

@end

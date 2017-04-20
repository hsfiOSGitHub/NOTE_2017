//
//  SchedulingSetTableViewController.h
//  yuntangyi
//
//  Created by yuntangyi on 16/9/6.
//  Copyright © 2016年 yuntangyi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SchedulingSetTableViewController : UIViewController
@property (nonatomic,strong) NSString *start_date;//开始日期
@property (nonatomic,strong) NSString *end_date;//结束日期

@property (nonatomic,strong) NSString *start_time1;//上午开始时间
@property (nonatomic,strong) NSString *end_time1;//结束时间
@property (nonatomic,strong) NSString *start_time2;//下午开始时间
@property (nonatomic,strong) NSString *end_time2;//结束时间

@property (nonatomic, strong)NSString *amNum;//上午预约人数
@property (nonatomic, strong)NSString *pmNum;//下午预约人数
@property (nonatomic, strong)UITableView *tableView;
@end

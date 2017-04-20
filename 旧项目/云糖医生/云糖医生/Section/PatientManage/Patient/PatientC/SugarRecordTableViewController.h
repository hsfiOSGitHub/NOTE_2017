//
//  SugarRecordTableViewController.h
//  yuntangyi
//
//  Created by yuntangyi on 16/9/14.
//  Copyright © 2016年 yuntangyi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SugarRecordTableViewController : UIViewController<UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UIView *dateView;
@property (weak, nonatomic) IBOutlet UIView *backV;
@property (weak, nonatomic) IBOutlet UITextField *startDateTF;//开始日期
@property (weak, nonatomic) IBOutlet UITextField *endStartTF;//结束日期
@property (weak, nonatomic) IBOutlet UIButton *sportBtn;//运动
@property (weak, nonatomic) IBOutlet UIButton *yidaosuBtn;//胰岛素
@property (weak, nonatomic) IBOutlet UIButton *koufuyaoBtn;//口服药
@property (weak, nonatomic) IBOutlet UIButton *yinshiBtn;//饮食
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIImageView *leftImageV;
@property (weak, nonatomic) IBOutlet UIImageView *rightImageV;
@property (weak, nonatomic) IBOutlet UITableView *tableView1;
@property (weak, nonatomic) IBOutlet UITableView *tableView2;
@property (weak, nonatomic) IBOutlet UITableView *tableView3;
@property (weak, nonatomic) IBOutlet UITableView *tableView4;

@end

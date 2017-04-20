//
//  SZBAlertView5.h
//  yuntangyi
//
//  Created by yuntangyi on 16/9/20.
//  Copyright © 2016年 yuntangyi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HospitalView : UIView<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UIButton *cancelBtn;
@property (weak, nonatomic) IBOutlet UIButton *okBtn;
@property (weak, nonatomic) IBOutlet UITableView *tableView1;
@property (weak, nonatomic) IBOutlet UITableView *tableView2;
@property (weak, nonatomic) IBOutlet UITableView *tableView3;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableView1Height;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableView2Height;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableView3Height;


@property (nonatomic,strong) NSArray *source;//数据源
@property (nonatomic,strong) UIButton *currentBtn;// 当前sender Btn

@end

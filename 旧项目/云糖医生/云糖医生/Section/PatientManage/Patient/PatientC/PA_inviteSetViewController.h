//
//  PA_inviteSetViewController.h
//  yuntangyi
//
//  Created by yuntangyi on 16/8/29.
//  Copyright © 2016年 yuntangyi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PA_inviteSetViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITableView *SetTableView;
@property (nonatomic, strong) NSMutableArray *classNumArray;//排班预约情况(为日历显示)
@property (nonatomic , strong) NSString *selectDate;
@property (nonatomic) NSString* haha;  //判断是否第一次进入，防止刷新把背景刷掉
@property (nonatomic) int todayQuan;

@property (nonatomic, strong)NSString *patient_id;//患者id
@property (nonatomic, strong)NSString *name;//患者姓名;
@property (weak, nonatomic) IBOutlet UIButton *inviteBtn;
-(void)getIsBusyOrFree;
@end

//
//  SechedulingVC.h
//  yuntangyi
//
//  Created by yuntangyi on 16/8/26.
//  Copyright © 2016年 yuntangyi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SechedulingVC : UIViewController
@property (nonatomic, strong)UITableView *tableV;
@property (nonatomic, strong) NSMutableArray *classNumArray;//排班预约情况(为日历显示)
@property (nonatomic , strong) NSString *selectDate;
@property (nonatomic) NSString* haha;  //判断是否第一次进入，防止新选的日期颜色标记刷掉
@property (nonatomic) int todayQuan;

-(void)getTheSchedulingSheet;
@end

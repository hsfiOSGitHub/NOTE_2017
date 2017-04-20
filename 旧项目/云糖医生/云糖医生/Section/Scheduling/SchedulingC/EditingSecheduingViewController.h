//
//  EditingSecheduingViewController.h
//  云糖医生
//
//  Created by yuntangyi on 16/11/18.
//  Copyright © 2016年 yuntangyi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EditingSecheduingViewController : UIViewController
@property (nonatomic, strong)NSString *Date;//修改的日期
@property (nonatomic,strong) NSString *start_time1;//上午开始时间
@property (nonatomic,strong) NSString *end_time1;//结束时间
@property (nonatomic,strong) NSString *start_time2;//下午开始时间
@property (nonatomic,strong) NSString *end_time2;//结束时间

@property (nonatomic, strong)NSString *amNum;//上午预约人数
@property (nonatomic, strong)NSString *pmNum;//下午预约人数
@property (nonatomic, strong)NSString *dwp_id;//排班id
@end

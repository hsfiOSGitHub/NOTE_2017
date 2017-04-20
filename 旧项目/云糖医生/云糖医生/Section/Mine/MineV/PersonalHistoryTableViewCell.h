//
//  PersonalHistoryTableViewCell.h
//  yuntangyi
//
//  Created by yuntangyi on 16/9/1.
//  Copyright © 2016年 yuntangyi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PersonalHistoryTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *PersonalType;
@property (weak, nonatomic) IBOutlet UILabel *DetailLable;
//给外部预留传入数据计算并返回高度的接口
+ (CGFloat )calculateContentHeight:(NSString *)model;
-(void)resetContentLabelFrame:(NSString *)model;
@end

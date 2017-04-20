//
//  MineInformationTableViewCell.h
//  yuntangyi
//
//  Created by yuntangyi on 16/8/30.
//  Copyright © 2016年 yuntangyi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MineInformationTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *headImageV;//头像
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *keShiAndPositionLable;
@property (weak, nonatomic) IBOutlet UILabel *hospital;

@property (weak, nonatomic) IBOutlet UIView *bgView;

@end

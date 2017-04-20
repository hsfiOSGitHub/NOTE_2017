//
//  SportsTableViewCell.h
//  yuntangyi
//
//  Created by yuntangyi on 16/9/14.
//  Copyright © 2016年 yuntangyi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SportsTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *styleLable;
@property (weak, nonatomic) IBOutlet UILabel *timeLable;
@property (weak, nonatomic) IBOutlet UILabel *detailLable;
@property (weak, nonatomic) IBOutlet UIView *xianV;

@end

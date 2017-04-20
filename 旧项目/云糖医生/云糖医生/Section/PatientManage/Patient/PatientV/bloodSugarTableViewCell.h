//
//  bloodSugarTableViewCell.h
//  yuntangyi
//
//  Created by yuntangyi on 16/9/12.
//  Copyright © 2016年 yuntangyi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface bloodSugarTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *higheNum;
@property (weak, nonatomic) IBOutlet UIButton *normalNum;
@property (weak, nonatomic) IBOutlet UIButton *lowNum;
@property (weak, nonatomic) IBOutlet UIButton *sevenDayRecordBtn;

@end

//
//  PrPatientListCell.h
//  yuntangyi
//
//  Created by yuntangyi on 16/9/6.
//  Copyright © 2016年 yuntangyi. All rights reserved.
//

#import <UIKit/UIKit.h>
@class PrActivityPatientModel;

@interface PrPatientListCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *seletedBtn;
@property (nonatomic,assign) NSInteger isSeleted;
@property (nonatomic,strong) PrActivityPatientModel *activityPatientModel;

@end

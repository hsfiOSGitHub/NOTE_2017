//
//  OrderPatientTableViewCell.h
//  yuntangyi
//
//  Created by yuntangyi on 16/8/31.
//  Copyright © 2016年 yuntangyi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OrderPatientTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *numLable;//排班号

@property (weak, nonatomic) IBOutlet UILabel *nameLable;
@property (weak, nonatomic) IBOutlet UILabel *ageLable;
@property (weak, nonatomic) IBOutlet UILabel *genderLable;
@property (weak, nonatomic) IBOutlet UILabel *phoneLable;
@end

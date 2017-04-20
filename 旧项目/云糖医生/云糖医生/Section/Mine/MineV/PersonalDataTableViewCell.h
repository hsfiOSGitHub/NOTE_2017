//
//  PersonalDataTableViewCell.h
//  yuntangyi
//
//  Created by yuntangyi on 16/9/19.
//  Copyright © 2016年 yuntangyi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PersonalDataTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imageV;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *selectLable;
@property (weak, nonatomic) IBOutlet UIImageView *detailImgView;

@end

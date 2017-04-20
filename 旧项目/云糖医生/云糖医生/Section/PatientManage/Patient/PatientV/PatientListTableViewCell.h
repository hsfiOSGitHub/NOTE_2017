//
//  PatientListTableViewCell.h
//  yuntangyi
//
//  Created by yuntangyi on 16/8/26.
//  Copyright © 2016年 yuntangyi. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface PatientListTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *headImageV;
@property (weak, nonatomic) IBOutlet UILabel *nameLable;
@property (weak, nonatomic) IBOutlet UILabel *genderLable;
@property (weak, nonatomic) IBOutlet UILabel *ageLable;
@property (weak, nonatomic) IBOutlet UILabel *sickType;
@property (weak, nonatomic) IBOutlet UILabel *showType;
@property (weak, nonatomic) IBOutlet UILabel *ziliao;
@property (weak, nonatomic) IBOutlet UIButton *addPatientBtn;
@property (weak, nonatomic) IBOutlet UIImageView *smallimageV;
- (void)setData:(NSDictionary *)dic;

@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *rightCons;//右边约束

@end

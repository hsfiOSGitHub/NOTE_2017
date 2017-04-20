//
//  MyCertificateViewController.h
//  yuntangyi
//
//  Created by yuntangyi on 16/9/19.
//  Copyright © 2016年 yuntangyi. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "UserInfoModel.h"
@interface MyCertificateViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIImageView *TopCerImageV;
@property (weak, nonatomic) IBOutlet UIImageView *LeftImageV;
@property (weak, nonatomic) IBOutlet UIImageView *RightImageV;
@property (weak, nonatomic) IBOutlet UILabel *TopLable;
@property (weak, nonatomic) IBOutlet UIView *BackV;

@property (weak, nonatomic) IBOutlet UIButton *PicCerBtn;
@property (weak, nonatomic) IBOutlet UIButton *guaranteeCerBtn;
@property (weak, nonatomic) IBOutlet UITextField *PicCerPhoneTF;
@property (weak, nonatomic) IBOutlet UITextField *guaranteeCerPhoneTF1;
@property (weak, nonatomic) IBOutlet UITextField *guaranteeCerPhoneTF2;
@property (weak, nonatomic) IBOutlet UIButton *CommitCerBtn;
@property (weak, nonatomic) IBOutlet UILabel *LowLable;
@property (weak, nonatomic) IBOutlet UIScrollView *ScrollView;

@property (weak, nonatomic) IBOutlet UIView *annimationView;//滑动动画
@property (weak, nonatomic) NSString *is_check;//认证状态
@property (weak, nonatomic) NSString *auth_check;//认证状态
@property (weak, nonatomic) NSString *postic_url;//资格证
@property (nonatomic,strong) UserInfoModel *userInfoModel;//个人信息模型
@end

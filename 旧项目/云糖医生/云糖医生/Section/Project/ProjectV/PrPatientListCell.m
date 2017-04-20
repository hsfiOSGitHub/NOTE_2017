//
//  PrPatientListCell.m
//  yuntangyi
//
//  Created by yuntangyi on 16/9/6.
//  Copyright © 2016年 yuntangyi. All rights reserved.
//

#import "PrPatientListCell.h"

#import "PrActivityPatientModel.h"
#import "UIImageView+WebCache.h"

@interface PrPatientListCell ()
@property (weak, nonatomic) IBOutlet UIImageView *icon;//头像
@property (weak, nonatomic) IBOutlet UILabel *name;//姓名
@property (weak, nonatomic) IBOutlet UILabel *sexAndAge;//性别和年龄
@property (weak, nonatomic) IBOutlet UILabel *sickType;//患病类型

@end

@implementation PrPatientListCell
//是否选择
-(void)setIsSeleted:(NSInteger)isSeleted{
    _isSeleted = isSeleted;
    if (isSeleted) {
        [self.seletedBtn setImage:[UIImage imageNamed:@"pr_list_seleted"] forState:UIControlStateNormal];
    }else{
        [self.seletedBtn setImage:[UIImage imageNamed:@"pr_list_noseleted"] forState:UIControlStateNormal];
    }
}
#pragma mark -配置数据
-(void)setActivityPatientModel:(PrActivityPatientModel *)activityPatientModel{
    _activityPatientModel = activityPatientModel;
    
    _name.text = [NSString stringWithFormat:@"%@",activityPatientModel.name];
    NSString *sexStr;
    if ([activityPatientModel.gender isEqualToString:@"0"]) {
        sexStr = @"男";
    }else if ([activityPatientModel.gender isEqualToString:@"1"]) {
        sexStr = @"女";
    }
    _sexAndAge.text = [NSString stringWithFormat:@"%@ %@",sexStr,activityPatientModel.age];
    _sickType.text = [NSString stringWithFormat:@"%@",activityPatientModel.diabetes_name];
    [_icon sd_setImageWithURL:[NSURL URLWithString:activityPatientModel.pic] placeholderImage:[UIImage imageNamed:@"patient_placeholer"]];
}

#pragma mark -awakeFromNib
- (void)awakeFromNib {
    [super awakeFromNib];
    //配置subviews
    [self setUpSubviews];
}
-(void)setUpSubviews{
    //头像圆形
    _icon.layer.masksToBounds = YES;
    _icon.layer.cornerRadius = 25;
    _icon.layer.borderColor = [UIColor cyanColor].CGColor;
    _icon.layer.borderWidth = 1;

}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


@end

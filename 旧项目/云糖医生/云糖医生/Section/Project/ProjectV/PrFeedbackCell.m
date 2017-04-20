//
//  PrFeedbackCell.m
//  yuntangyi
//
//  Created by yuntangyi on 16/9/6.
//  Copyright © 2016年 yuntangyi. All rights reserved.
//

#import "PrFeedbackCell.h"

#import "PrAnswerListModel.h"
#import "UIImageView+WebCache.h"

@interface PrFeedbackCell ()
@property (weak, nonatomic) IBOutlet UIImageView *icon;//头像
@property (weak, nonatomic) IBOutlet UILabel *name;//姓名
@property (weak, nonatomic) IBOutlet UILabel *sexAndAge;//性别年龄
@property (weak, nonatomic) IBOutlet UILabel *feedback;//是否反馈
@property (weak, nonatomic) IBOutlet UIImageView *goImgView;//

@end

@implementation PrFeedbackCell
#pragma mark -配置数据
-(void)setAnswerListModel:(PrAnswerListModel *)answerListModel{
    _answerListModel = answerListModel;
    
//    [_icon sd_setImageWithURL:[NSURL URLWithString:answerListModel.] placeholderImage:]
    _name.text = [NSString stringWithFormat:@"%@",answerListModel.patient_name];
//    _sexAndAge.text = [NSString stringWithFormat:@"%@ %@",]
    NSString *feedbackStr;
    if ([answerListModel.status isEqualToString:@"0"]) {
        feedbackStr = @"待处理";
    }else if ([answerListModel.status isEqualToString:@"1"]) {
        feedbackStr = @"同意反馈";
    }else if ([answerListModel.status isEqualToString:@"2"]) {
        feedbackStr = @"拒绝反馈";
    }else if ([answerListModel.status isEqualToString:@"3"]) {
        feedbackStr = @"待反馈";
    }else if ([answerListModel.status isEqualToString:@"4"]) {
        feedbackStr = @"已反馈";
    }
    _feedback.text = feedbackStr;
}
#pragma mark -awakeFromNib
- (void)awakeFromNib {
    [super awakeFromNib];
    //配置子视图
    [self setUpSubviews];
    
}
//配置子视图
-(void)setUpSubviews{
    _icon.layer.masksToBounds = YES;
    _icon.layer.cornerRadius = 30;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

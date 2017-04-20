//
//  KnCellType2_1Cell.m
//  yuntangyi
//
//  Created by yuntangyi on 16/8/30.
//  Copyright © 2016年 yuntangyi. All rights reserved.
//

#import "KnCellType1_1Cell.h"

#import "UIImageView+WebCache.h"
#import "KnMeetingInfoModel.h"

@interface KnCellType1_1Cell ()
@property (weak, nonatomic) IBOutlet UIImageView *icon;//图片
@property (weak, nonatomic) IBOutlet UILabel *signIn;//是否签到

@end

@implementation KnCellType1_1Cell

-(void)setMeetingInfoModel:(KnMeetingInfoModel *)meetingInfoModel{
    _meetingInfoModel = meetingInfoModel;
    //配置数据
    [_icon sd_setImageWithURL:[NSURL URLWithString:meetingInfoModel.pic] placeholderImage:[UIImage imageNamed:@"placeholder"] completed:nil];//图片
    //是否可以报名
    if ([_meetingInfoModel.status isEqual:@0]) {
        if ([meetingInfoModel.is_exist integerValue]) {
            //"dotype": 1,//报名方式 空为未报名，0是主动报名，1是后台邀请
            if (self.doType == NULL || [self.doType isEqualToString:@""]) {//未报名
                _signIn.text = @"已报名该会议";
            }else if ([self.doType isEqualToString:@"0"]) {//主动报名
                _signIn.text = @"已报名该会议 (主动报名)";
            }else if ([self.doType isEqualToString:@"1"]) {//后台邀请
                _signIn.text = @"已报名该会议 (后台邀请)";
            }
        }else{
            _signIn.text = @"尚未报名该会议";
        }
    }else if ([_meetingInfoModel.status isEqual:@1]) {
        if ([meetingInfoModel.is_exist integerValue]) {
            //"dotype": 1,//报名方式 空为未报名，0是主动报名，1是后台邀请
            if (self.doType == NULL || [self.doType isEqualToString:@""]) {//未报名
                _signIn.text = @"已报名该会议";
            }else if ([self.doType isEqualToString:@"0"]) {//主动报名
                _signIn.text = @"已报名该会议 (主动报名)";
            }else if ([self.doType isEqualToString:@"1"]) {//后台邀请
                _signIn.text = @"已报名该会议 (后台邀请)";
            }
        }else{
            _signIn.text = @"不可报名该会议";
        }
    }
    
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

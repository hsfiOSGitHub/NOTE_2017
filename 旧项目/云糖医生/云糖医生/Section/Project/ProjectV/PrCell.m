//
//  PrCell.m
//  yuntangyi
//
//  Created by yuntangyi on 16/9/14.
//  Copyright © 2016年 yuntangyi. All rights reserved.
//

#import "PrCell.h"

#import "PrActivityListModel.h"
#import "UIImageView+WebCache.h"

@interface PrCell ()

@property (weak, nonatomic) IBOutlet UILabel *title;//标题
@property (weak, nonatomic) IBOutlet UILabel *firstContent;//第一句话
@property (weak, nonatomic) IBOutlet UILabel *sendNum;//发送给。。人数

@end

@implementation PrCell
#pragma mark -填充数据
-(void)setActivityListModel:(PrActivityListModel *)activityListModel{
    _activityListModel = activityListModel;
    [_pic sd_setImageWithURL:[NSURL URLWithString:activityListModel.pic] placeholderImage:[UIImage imageNamed:@"图片图标"]];//图片
//    _title.text = [NSString stringWithFormat:@"［%@］%@",activityListModel.type_name,activityListModel.title];
//    _firstContent.text = [NSString stringWithFormat:@"%@",activityListModel.content];
//    _sendNum.text = [NSString stringWithFormat:@"已发送给%@人",activityListModel.join_num];
}

#pragma mark -awakeFromNib
- (void)awakeFromNib {
    [super awakeFromNib];
    self.sendNum.hidden = YES;
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

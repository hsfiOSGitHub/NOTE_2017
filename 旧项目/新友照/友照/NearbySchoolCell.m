//
//  NearbySchoolCell.m
//  友照
//
//  Created by monkey2016 on 16/11/22.
//  Copyright © 2016年 ZX_XPH. All rights reserved.
//

#import "NearbySchoolCell.h"

@interface NearbySchoolCell ()
@end

@implementation NearbySchoolCell

-(void)setSchoolListModel:(SchoolListModel *)schoolListModel{
    _schoolListModel = schoolListModel;
    //配置数据
    [self.picView sd_setImageWithURL:[NSURL URLWithString:schoolListModel.pic] placeholderImage:[UIImage imageNamed:@"jiaxiaobg.jpg"]];
    self.name.text = schoolListModel.name;
    //star
    NSArray *subviews = self.starView.subviews;
    [subviews enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj removeFromSuperview];
    }];
    StarsView *star = [[StarsView alloc] initWithStarSize:CGSizeMake(16, 16) space:5 numberOfStar:5];
    star.userInteractionEnabled=NO;
    star.score = [schoolListModel.score doubleValue];
    star.frame = CGRectMake(0, 0, 16*5+5*4, 16);
    [self.starView addSubview:star];
    //money
    NSString *price = [NSString stringWithFormat:@"%@",schoolListModel.price];
    if ([price isEqualToString:@"0"])
    {
        self.money.text = [NSString stringWithFormat:@"面议"];
    }
    else
    {
        self.money.text = [NSString stringWithFormat:@"¥%@",price];
    }
    self.avgRate.text = [NSString stringWithFormat:@"通过率：%.0f%%",[schoolListModel.avg_rate floatValue] * 100];
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    _picView.layer.cornerRadius = 8;
    _picView.layer.masksToBounds = YES;
    _picView.layer.borderColor = [KRGB(109, 156, 183, 1) CGColor];
    _picView.layer.borderWidth = 1;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

@end

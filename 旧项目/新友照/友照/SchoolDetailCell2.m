//
//  SchoolDetailCell2.m
//  友照
//
//  Created by monkey2016 on 16/11/24.
//  Copyright © 2016年 ZX_XPH. All rights reserved.
//

#import "SchoolDetailCell2.h"

@implementation SchoolDetailCell2

-(void)setSchoolDetailModel:(SchoolDetailModel *)schoolDetailModel{
    _schoolDetailModel = schoolDetailModel;
    //配置数据
    self.name.text = schoolDetailModel.name;
//    CAShapeLayer *layer = [CAShapeLayer createMaskLayerWithStarView:self.starView andPercent:[schoolDetailModel.score doubleValue]/5.0];
//    self.starView.layer.mask = layer;
    //star
    StarsView *star = [[StarsView alloc] initWithStarSize:CGSizeMake(20, 20) space:5 numberOfStar:5];
    star.score = [schoolDetailModel.score doubleValue];
    star.frame = CGRectMake(0, 0, 0, 0);
    [self.starView addSubview:star];
    
    self.score.text = schoolDetailModel.score;
    self.num.text = [NSString stringWithFormat:@"累计报名人数：%@人",schoolDetailModel.student_num];
    if (![schoolDetailModel.price isEqualToString:@"0"])
    {
        self.price.text = [NSString stringWithFormat:@"¥%@",schoolDetailModel.price];
    }
    else
    {
        self.price.text = @"面议";
    }
}

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

@end

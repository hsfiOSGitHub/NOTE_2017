//
//  SchoolDetailCell7.m
//  友照
//
//  Created by monkey2016 on 16/11/24.
//  Copyright © 2016年 ZX_XPH. All rights reserved.
//

#import "SchoolDetailCell7.h"

@interface SchoolDetailCell7 ()
@property (weak, nonatomic) IBOutlet UIImageView *iconView;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *addtime;
@property (weak, nonatomic) IBOutlet UIView *starView;

@end

@implementation SchoolDetailCell7


-(void)setSchoolCommentModel:(SchoolCommentModel *)schoolCommentModel{
    _schoolCommentModel = schoolCommentModel;
    //配置数据
    [self.iconView sd_setImageWithURL:[NSURL URLWithString:schoolCommentModel.student_pic] placeholderImage:[UIImage imageNamed:@"touxiang"]];
    if (schoolCommentModel.student_name.length>0)
    {
        self.name.text = schoolCommentModel.student_name;
    }
    else
    {
         self.name.text =@"匿名学员";
    }
    self.addtime.text = schoolCommentModel.addtime;
    self.content.text = schoolCommentModel.content;
//    CAShapeLayer *layer = [CAShapeLayer createMaskLayerWithStarView:self.starView andPercent:[schoolCommentModel.score doubleValue]/5.0];
//    self.starView.layer.mask = layer;
    //star
    NSArray *subviews = self.starView.subviews;
    [subviews enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj removeFromSuperview];
    }];
    StarsView *star = [[StarsView alloc] initWithStarSize:CGSizeMake(12, 12) space:5 numberOfStar:5];
    star.score = [schoolCommentModel.score doubleValue];
    star.frame = CGRectMake(0, 0, 0, 0);
    [self.starView addSubview:star];
    
    [self setNeedsLayout];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    //设置圆角
    self.iconView.layer.masksToBounds = YES;
    self.iconView.layer.cornerRadius = 30;
    self.iconView.layer.borderColor = [KRGB(109, 156, 183, 1) CGColor];
    self.iconView.layer.borderWidth = 1;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

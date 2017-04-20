//
//  SchoolDetailCell6_2.m
//  友照
//
//  Created by monkey2016 on 16/11/26.
//  Copyright © 2016年 ZX_XPH. All rights reserved.
//

#import "SchoolDetailCell6_2.h"

@interface SchoolDetailCell6_2 ()
@property (weak, nonatomic) IBOutlet UIImageView *icon1;
@property (weak, nonatomic) IBOutlet UIImageView *icon2;
@property (weak, nonatomic) IBOutlet UIImageView *icon3;
@property (weak, nonatomic) IBOutlet UIImageView *icon4;

@property (weak, nonatomic) IBOutlet UILabel *name1;
@property (weak, nonatomic) IBOutlet UILabel *name2;
@property (weak, nonatomic) IBOutlet UILabel *name3;
@property (weak, nonatomic) IBOutlet UILabel *name4;


@end

@implementation SchoolDetailCell6_2

//科三
-(void)setSchoolDetailModel_3:(SchoolDetailModel *)schoolDetailModel_3
{
    _schoolDetailModel_3 = schoolDetailModel_3;
    //配置数据
    NSArray *iconImageArr = schoolDetailModel_3.teacher_subject3;
    if (iconImageArr.count >= 1)
    {
        [self.icon1 sd_setImageWithURL:[NSURL URLWithString:iconImageArr[0][@"pic"]] placeholderImage:[UIImage imageNamed:@"touxiang"]];
        self.name1.text = iconImageArr[0][@"tname"];
        self.icon1.hidden = NO;
        self.name1.hidden = NO;
        self.iconBtn1.hidden = NO;
    }
    if (iconImageArr.count >= 2)
    {
        [self.icon2 sd_setImageWithURL:[NSURL URLWithString:iconImageArr[1][@"pic"]] placeholderImage:[UIImage imageNamed:@"touxiang"]];
        self.name2.text = iconImageArr[1][@"tname"];
        self.icon2.hidden = NO;
        self.name2.hidden = NO;
        self.iconBtn2.hidden = NO;
    }
    if (iconImageArr.count >= 3)
    {
        [self.icon3 sd_setImageWithURL:[NSURL URLWithString:iconImageArr[2][@"pic"]] placeholderImage:[UIImage imageNamed:@"touxiang"]];
        self.name3.text = iconImageArr[2][@"tname"];
        self.icon3.hidden = NO;
        self.name3.hidden = NO;
        self.iconBtn3.hidden = NO;
    }
    if (iconImageArr.count >= 4)
    {
        [self.icon4 sd_setImageWithURL:[NSURL URLWithString:iconImageArr[3][@"pic"]] placeholderImage:[UIImage imageNamed:@"touxiang"]];
        self.name4.text = iconImageArr[3][@"tname"];
        self.icon4.hidden = NO;
        self.name4.hidden = NO;
        self.iconBtn4.hidden = NO;
    }
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    //配置圆角
    self.icon1.layer.masksToBounds = YES;
    self.icon1.layer.cornerRadius = 30;
    self.icon2.layer.masksToBounds = YES;
    self.icon2.layer.cornerRadius = 30;
    self.icon3.layer.masksToBounds = YES;
    self.icon3.layer.cornerRadius = 30;
    self.icon4.layer.masksToBounds = YES;
    self.icon4.layer.cornerRadius = 30;
    self.icon1.layer.borderColor = [KRGB(109, 156, 183, 1) CGColor];
    self.icon1.layer.borderWidth = 1;
    self.icon2.layer.borderColor = [KRGB(109, 156, 183, 1) CGColor];
    self.icon2.layer.borderWidth = 1;
    self.icon3.layer.borderColor = [KRGB(109, 156, 183, 1) CGColor];
    self.icon3.layer.borderWidth = 1;
    self.icon4.layer.borderColor = [KRGB(109, 156, 183, 1) CGColor];
    self.icon4.layer.borderWidth = 1;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end

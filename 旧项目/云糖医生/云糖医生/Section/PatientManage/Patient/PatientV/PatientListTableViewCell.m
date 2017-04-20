//
//  PatientListTableViewCell.m
//  yuntangyi
//
//  Created by yuntangyi on 16/8/26.
//  Copyright © 2016年 yuntangyi. All rights reserved.
//

#import "PatientListTableViewCell.h"

@implementation PatientListTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    //Initialization code
    self.headImageV.layer.masksToBounds = YES;
    self.headImageV.layer.cornerRadius = 40;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)setData:(NSDictionary *)dic {
    if ([dic[@"patient_name"] isEqualToString:@""]) {
        self.nameLable.text = @"--";
    }else {
        self.nameLable.text = dic[@"patient_name"];
    }
    if ([dic[@"gender"] isEqualToString:@"0"]) {
        self.genderLable.text = @"男";
    }else {
        self.genderLable.text = @"女";
    }
   self.ageLable.text = [NSString stringWithFormat:@"%@岁", dic[@"age"]];
    if ([dic[@"diabetes"] isEqualToString:@""]) {
         self.sickType.text = @"--";
    }else {
         self.sickType.text = dic[@"diabetes"];
    }
   [self.headImageV sd_setImageWithURL:dic[@"pic"] placeholderImage:[UIImage imageNamed:@"默认患者头像"]];
    if ([dic[@"xstatus"] isKindOfClass:[NSValue class]]) {
        if ([dic[@"xstatus"] integerValue] == 0) {
            self.showType.text = @"血糖监控显示正常";
            self.showType.textColor =  KRGB(28, 177, 98, 1.0);
        }else {
            self.showType.text = @"血糖监控显示异常";
            self.showType.textColor = KRGB(250, 114, 82, 1.0);
        }
    }
    self.ziliao.text = [NSString stringWithFormat:@"资料完善%@", dic[@"wsd"]];
}

@end

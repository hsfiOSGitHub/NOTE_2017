//
//  DateDetailTableViewCell.m
//  yuntangyi
//
//  Created by yuntangyi on 16/9/18.
//  Copyright © 2016年 yuntangyi. All rights reserved.
//

#import "DateDetailTableViewCell.h"

@implementation DateDetailTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.dateTF.adjustsFontSizeToFitWidth = YES;
    if (KScreenWidth < 375) {
         self.dateTF.font=[UIFont systemFontOfSize:10];
    }
    self.TF1.adjustsFontSizeToFitWidth = YES;
    self.TF2.adjustsFontSizeToFitWidth = YES;
    self.TF3.adjustsFontSizeToFitWidth = YES;
    self.TF4.adjustsFontSizeToFitWidth = YES;
    self.TF5.adjustsFontSizeToFitWidth = YES;
    self.TF6.adjustsFontSizeToFitWidth = YES;
    self.TF7.adjustsFontSizeToFitWidth = YES;
    self.TF8.adjustsFontSizeToFitWidth = YES;
}
- (void)steDetaiData:(NSDictionary *)dic {
    self.dateTF.text = dic[@"date"];
    NSArray *arr = dic[@"sugar_list"];
    self.TF1.text = arr[0][@"sugar"];
    self.TF2.text = arr[1][@"sugar"];
    self.TF3.text = arr[2][@"sugar"];
    self.TF4.text = arr[3][@"sugar"];
    self.TF5.text = arr[4][@"sugar"];
    self.TF6.text = arr[5][@"sugar"];
    self.TF7.text = arr[6][@"sugar"];
    self.TF8.text = arr[7][@"sugar"];

    if ([arr[0][@"sugar"] floatValue] < 3.9) {
        self.TF1.textColor = KRGB(0, 172, 204, 1.0);
    }else if ([arr[0][@"sugar"] floatValue] > 10) {
        self.TF1.textColor = KRGB(250, 114, 82, 1.0);
    }else {
        self.TF1.textColor = KRGB(28, 177, 98, 1.0);
    }
    if ([arr[1][@"sugar"] floatValue] < 3.9) {
        self.TF2.textColor = KRGB(0, 172, 204, 1.0);
    }else if ([arr[1][@"sugar"] floatValue] > 7.2) {
        self.TF2.textColor = KRGB(250, 114, 82, 1.0);
    }else {
        self.TF2.textColor = KRGB(28, 177, 98, 1.0);
    }

    if ([arr[2][@"sugar"] floatValue] < 3.9) {
        self.TF3.textColor = KRGB(0, 172, 204, 1.0);
    }else if ([arr[2][@"sugar"] floatValue] > 10) {
        self.TF3.textColor = KRGB(250, 114, 82, 1.0);
    }else {
        self.TF3.textColor = KRGB(28, 177, 98, 1.0);
    }
    if ([arr[3][@"sugar"] floatValue] < 3.9) {
        self.TF4.textColor = KRGB(0, 172, 204, 1.0);
    }else if ([arr[3][@"sugar"] floatValue] > 10) {
        self.TF4.textColor = KRGB(250, 114, 82, 1.0);
    }else {
        self.TF4.textColor = KRGB(28, 177, 98, 1.0);
    }
    if ([arr[4][@"sugar"] floatValue] < 3.9) {
        self.TF5.textColor = KRGB(0, 172, 204, 1.0);
    }else if ([arr[4][@"sugar"] floatValue] > 10) {
        self.TF5.textColor = KRGB(250, 114, 82, 1.0);
    }else {
        self.TF5.textColor = KRGB(28, 177, 98, 1.0);
    }
    if ([arr[5][@"sugar"] floatValue] < 3.9) {
        self.TF6.textColor = KRGB(0, 172, 204, 1.0);
    }else if ([arr[5][@"sugar"] floatValue] > 10) {
        self.TF6.textColor = KRGB(250, 114, 82, 1.0);
    }else {
        self.TF6.textColor = KRGB(28, 177, 98, 1.0);
    }
    if ([arr[6][@"sugar"] floatValue] < 3.9) {
        self.TF7.textColor = KRGB(0, 172, 204, 1.0);
    }else if ([arr[6][@"sugar"] floatValue] > 10) {
        self.TF7.textColor = KRGB(250, 114, 82, 1.0);
    }else {
        self.TF7.textColor = KRGB(28, 177, 98, 1.0);
    }
    if ([arr[7][@"sugar"] floatValue] < 3.9) {
        self.TF8.textColor = KRGB(0, 172, 204, 1.0);
    }else if ([arr[7][@"sugar"] floatValue] > 10) {
        self.TF8.textColor = KRGB(250, 114, 82, 1.0);
    }else {
        self.TF8.textColor = KRGB(28, 177, 98, 1.0);
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

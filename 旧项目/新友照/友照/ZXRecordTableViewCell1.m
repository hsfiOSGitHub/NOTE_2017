//
//  ZXRecordTableViewCell1.m
//  ZXJiaXiao
//
//  Created by yujian on 16/6/16.
//  Copyright © 2016年 ZX. All rights reserved.
//

#import "ZXRecordTableViewCell1.h"

@implementation ZXRecordTableViewCell1

- (void)awakeFromNib {
    
    [super awakeFromNib];
    _backGroundView.layer.cornerRadius = 4;
    _backGroundView.layer.masksToBounds = YES;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

@end

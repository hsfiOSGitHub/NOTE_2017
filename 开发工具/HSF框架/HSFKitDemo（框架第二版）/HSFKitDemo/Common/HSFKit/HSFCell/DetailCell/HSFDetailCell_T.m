//
//  HSFDetailCell_T.m
//  HSFBase
//
//  Created by JuZhenBaoiMac on 2017/6/26.
//  Copyright © 2017年 JuZhenBaoiMac. All rights reserved.
//

#import "HSFDetailCell_T.h"

@implementation HSFDetailCell_T

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

//设置style 重新布局
-(void)setStyle:(HSFDetailCell_TStyle)style{
    _style = style;
    switch (style) {
        case TStyle_detail:
        {
            self.rightCons.constant = 0;
        }
            break;
        case TStyle_selete:
        {
            self.rightCons.constant = 10;
        }
            break;
            
        default:
            break;
    }
    [self layoutIfNeeded];
}




- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

//
//  HSFDetailCell_ITS.m
//  HSFBase
//
//  Created by JuZhenBaoiMac on 2017/6/26.
//  Copyright © 2017年 JuZhenBaoiMac. All rights reserved.
//

#import "HSFDetailCell_ITS.h"

#define k_style_default DetailStyle //默认是页面跳转style

@implementation HSFDetailCell_ITS

- (void)awakeFromNib {
    [super awakeFromNib];
    
}

//设置style 重新布局
-(void)setStyle:(HSFDetailCell_ITSStyle)style{
    _style = style;
    switch (style) {
        case ITSStyle_detail:
        {
            self.rightCons.constant = 0;
        }
            break;
        case ITSStyle_selete:
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

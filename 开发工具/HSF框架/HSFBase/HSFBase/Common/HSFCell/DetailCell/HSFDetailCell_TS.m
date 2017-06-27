//
//  HSFDetailCell_TS.m
//  HSFBase
//
//  Created by JuZhenBaoiMac on 2017/6/26.
//  Copyright © 2017年 JuZhenBaoiMac. All rights reserved.
//

#import "HSFDetailCell_TS.h"

@implementation HSFDetailCell_TS

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}


//设置style 重新布局
-(void)setStyle:(HSFDetailCell_TSStyle)style{
    _style = style;
    switch (style) {
        case TSStyle_detail:
        {
            self.rightCons.constant = 0;
        }
            break;
        case TSStyle_selete:
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

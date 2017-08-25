//
//  HSFDetailCell_IT.m
//  HSFBase
//
//  Created by JuZhenBaoiMac on 2017/6/26.
//  Copyright © 2017年 JuZhenBaoiMac. All rights reserved.
//

#import "HSFDetailCell_IT.h"

@implementation HSFDetailCell_IT

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}


//设置style 重新布局
-(void)setStyle:(HSFDetailCell_ITStyle)style{
    _style = style;
    switch (style) {
        case ITStyle_detail:
        {
            self.rightCons.constant = 0;
        }
            break;
        case ITStyle_selete:
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

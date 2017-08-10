//
//  DCAddressItem.m
//  CDDMall
//
//  Created by apple on 2017/6/20.
//  Copyright © 2017年 RocketsChen. All rights reserved.
//

#import "DCAddressItem.h"

@implementation DCAddressItem

- (CGFloat)cellHeight
{
    if (_cellHeight) return _cellHeight;
    NSString *str = [NSString stringWithFormat:@"%@%@",_adCity,_adDetail];
    CGSize titleSize = [DCSpeedy dc_calculateTextSizeWithText:str WithTextFont:13 WithMaxW:ScreenW - 4 *DCMargin];
    _cellHeight = 4 * DCMargin + titleSize.height + 35 + 30;
    
    return _cellHeight;
}

@end

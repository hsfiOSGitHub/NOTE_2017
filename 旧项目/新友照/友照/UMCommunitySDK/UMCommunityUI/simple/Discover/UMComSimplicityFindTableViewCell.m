//
//  UMComFindTableViewCell.m
//  UMCommunity
//
//  Created by umeng on 15-3-31.
//  Copyright (c) 2015年 Umeng. All rights reserved.
//

#import "UMComSimplicityFindTableViewCell.h"
#import "UMComResouceDefines.h"

@implementation UMComSimplicityFindTableViewCell

- (void)awakeFromNib {
    // Initialization code
    self.titleNameLabel.font = UMComFontNotoSansLightWithSafeSize(17);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)setCellStyleForLine:(UMComSimplicityCellLineStyle)style
{
    CGRect frame;
    
    if (style & UMComSimplicityCellLineStyleTop) {
        frame = _topLine.frame;
        frame.origin = CGPointMake(0.f, 0.f);
        frame.size.width = self.frame.size.width;
        
        _topLine.frame = frame;
        _topLine.hidden = NO;
    } else {
        _topLine.hidden = YES;
    }
    
    if (style & UMComSimplicityCellLineStyleMiddle) {
        frame = _bottomLine.frame;
        frame.origin = CGPointMake(_titleNameLabel.frame.origin.x, self.frame.size.height);
        frame.size.width = self.frame.size.width - frame.origin.x;
        
        _bottomLine.frame = frame;
    }
    
    if (style & UMComSimplicityCellLineStyleBottom) {
        frame = _bottomLine.frame;
        frame.origin = CGPointMake(0.f, self.frame.size.height - 1);
        frame.size.width = self.frame.size.width;
        
        _bottomLine.frame = frame;
    }
//    _topLine.hidden = YES;
//    _bottomLine.hidden = YES;
}


- (void)drawRect:(CGRect)rect
{
//    UIColor *color = UMComColorWithHexString(UMCom_Feed_BgColor);
//    CGContextRef context = UIGraphicsGetCurrentContext();
//    CGFloat height = 2;
//    CGRect drawFrame = CGRectMake(15, rect.size.height - height, rect.size.width-15, height);
//    CGContextSetFillColorWithColor(context, color.CGColor);
//    CGContextFillRect(context, drawFrame);
}

@end

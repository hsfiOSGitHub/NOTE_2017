//
//  UMComLabel.m
//  UMCommunity
//
//  Created by umeng on 16/5/15.
//  Copyright © 2016年 Umeng. All rights reserved.
//

#import "UMComLabel.h"

@implementation UMComLabel

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
       [self initData];
    }
    return self;
}
- (void)awakeFromNib
{
    [self initData];
}

- (void)initData
{
    _lineSpace = 1;
    self.numberOfLines = 0;
}

- (void)setLineSpace:(CGFloat)lineSpace
{
    _lineSpace = lineSpace;
    [self refreshAttributedString];
}

- (void)setTextForAttribute:(NSString *)textForAttribute
{
    _textForAttribute = textForAttribute;
    [self refreshAttributedString];
}

- (void)refreshAttributedString
{
    if (_textForAttribute.length > 0) {
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:_textForAttribute];
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        
        [paragraphStyle setLineSpacing:_lineSpace];//调整行间距
        
        [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [_textForAttribute length])];
        self.attributedText = attributedString;
        [self sizeToFit];
    }
}

@end

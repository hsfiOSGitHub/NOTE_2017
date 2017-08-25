//
//  UILabel+size.m
//  hsfCategoryDemo
//
//  Created by monkey2016 on 17/2/27.
//  Copyright © 2017年 monkey2016. All rights reserved.
//

#import "UILabel+size.h"

@implementation UILabel (size)
//第一种方法
-(CGSize)getLabelSizeWithWidth:(CGFloat)width andAttributes:(NSMutableDictionary *)attrs{
    CGSize size =  [self.text boundingRectWithSize:CGSizeMake(width,MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size;
    return size;
}
-(CGSize)getLabelSizeWithHeight:(CGFloat)height andAttributes:(NSMutableDictionary *)attrs{
    CGSize size =  [self.text boundingRectWithSize:CGSizeMake(MAXFLOAT,height) options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size;
    return size;
}

//第二种方法
-(CGSize)getLabelSizeWithLabelWidth:(CGFloat)width{
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineBreakMode = self.lineBreakMode;
    paragraphStyle.alignment = self.textAlignment;
    
    CGRect contentFrame = [self.text boundingRectWithSize:CGSizeMake(width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName : self.font } context:nil];
    return contentFrame.size;
}
-(CGSize)getLabelSizeWithLabelHeight:(CGFloat)height{
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineBreakMode = self.lineBreakMode;
    paragraphStyle.alignment = self.textAlignment;
    
    CGRect contentFrame = [self.text boundingRectWithSize:CGSizeMake(MAXFLOAT, height) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName : self.font } context:nil];
    return contentFrame.size;
}


- (void)setFont:(UIFont * _Nonnull)font fromIndex:(NSInteger)fromIndex toIndex:(NSInteger)toIndex {
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:self.text];
    [attributedString addAttribute:NSFontAttributeName value:font range:NSMakeRange(fromIndex, toIndex - fromIndex)];
    
    [self setAttributedText:attributedString];
}


@end

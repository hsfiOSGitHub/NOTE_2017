//
//  UILabel+size.h
//  hsfCategoryDemo
//
//  Created by monkey2016 on 17/2/27.
//  Copyright © 2017年 monkey2016. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabel (size)

//第一种方法
-(CGSize)getLabelSizeWithWidth:(CGFloat)width andAttributes:(NSMutableDictionary *)attrs;
-(CGSize)getLabelSizeWithHeight:(CGFloat)height andAttributes:(NSMutableDictionary *)attrs;

//第二种方法
-(CGSize)getLabelSizeWithLabelWidth:(CGFloat)width;
-(CGSize)getLabelSizeWithLabelHeight:(CGFloat)height;


/**
 *  在指定的索引范围内设置一个自定义的字体font
 *
 *  @param font      被设置的新字体格式
 *  @param fromIndex 开始索引
 *  @param toIndex   结束索引
 */
- (void)setFont:(UIFont * _Nonnull)font
      fromIndex:(NSInteger)fromIndex
        toIndex:(NSInteger)toIndex;


@end

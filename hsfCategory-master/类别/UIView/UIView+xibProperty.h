//
//  UIView+xibProperty.h
//  hsfCategoryDemo
//
//  Created by monkey2016 on 17/2/28.
//  Copyright © 2017年 monkey2016. All rights reserved.
//

#import <UIKit/UIKit.h>

//在定义类的前面加上IB_DESIGNABLE宏

/**
 
 * 这个宏定义的作用是可以通过keypath动态看到效果,实时性,不过还是需要通过在keypath中输入相关属性来设置
 
 */

IB_DESIGNABLE  //动态刷新

@interface UIView (xibProperty)

//注意:加上IBInspectable就可以可视化显示相关的属性

/**
 
 * 可视化设置边框宽度
 
 */

@property (nonatomic,assign)IBInspectable CGFloat borderWidth;

/**
 
 * 可视化设置边框颜色
 
 */

@property (nonatomic,strong)IBInspectable UIColor *borderColor;

/**
 
 * 可视化设置圆角
 
 */

@property (nonatomic,assign)IBInspectable CGFloat cornerRadius;

@end

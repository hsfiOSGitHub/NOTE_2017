//
//  UIView+DCExtension.h
//  CDDStoreDemo
//
//  Created by apple on 2017/3/18.
//  Copyright © 2017年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (DCExtension)


@property (nonatomic , assign) CGFloat dc_width;
@property (nonatomic , assign) CGFloat dc_height;
@property (nonatomic , assign) CGSize  dc_size;
@property (nonatomic , assign) CGFloat dc_x;
@property (nonatomic , assign) CGFloat dc_y;
@property (nonatomic , assign) CGPoint dc_origin;
@property (nonatomic , assign) CGFloat dc_centerX;
@property (nonatomic , assign) CGFloat dc_centerY;
@property (nonatomic , assign) CGFloat dc_right;
@property (nonatomic , assign) CGFloat dc_bottom;

- (BOOL)intersectWithView:(UIView *)view;

+ (instancetype)dc_viewFromXib;
- (BOOL)isShowingOnKeyWindow;

@end

//
//  UIView+Extension.h
//  LetMeSpend
//
//  Created by 翁志方 on 16/4/26.
//  Copyright © 2016年 __defaultyuan. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface UIView (Extension)

//相对于父视图
@property (nonatomic, assign) CGFloat x;

@property (nonatomic, assign) CGFloat y;

@property (nonatomic, assign) CGFloat maxX;

@property (nonatomic, assign) CGFloat maxY;

@property (nonatomic, assign) CGFloat centerX;

@property (nonatomic, assign) CGFloat centerY;

//相对于自身
@property (nonatomic, assign) CGSize size;

@property (nonatomic, assign) CGFloat width;

@property (nonatomic, assign) CGFloat height;

@property (nonatomic, assign, readonly) CGPoint centerOfSelf;

@property (nonatomic, assign, readonly) CGFloat centerXOfSelf;

@property (nonatomic, assign, readonly) CGFloat centerYOfSelf;




@end

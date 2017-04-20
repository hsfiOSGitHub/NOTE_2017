//
//  ZXAnimationView.h
//  animationView
//
//  Created by ZX on 16/4/12.
//  Copyright © 2016年 ZXNavigatio. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^Show)();
typedef void(^Dissmiss)();
@interface ZXAnimationView : UIView
@property(nonatomic,strong) UILabel* label;
@property (nonatomic)UIImageView *imageView;

- (instancetype)initWithFrame:(CGRect)frame;
- (void)show;
- (void)dismiss;

+ (UIImageView *)createAnimationView;
@end

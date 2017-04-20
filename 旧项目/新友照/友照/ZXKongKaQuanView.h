//
//  ZXKongKaQuanView.h
//  ZXJiaXiao
//
//  Created by yujian on 16/7/1.
//  Copyright © 2016年 ZX. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^Show)();
typedef void(^Dissmiss)();
@interface ZXKongKaQuanView : UIView
@property(nonatomic,strong) UILabel* label;
@property (nonatomic)UIImageView *imageView;

- (instancetype)initWithFrame:(CGRect)frame;
- (void)show;
- (void)dismiss;

//+ (UIImageView *)createAnimationView;
@end

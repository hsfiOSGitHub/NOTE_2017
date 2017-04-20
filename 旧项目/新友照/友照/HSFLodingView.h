//
//  HSFLodingView.h
//  友照
//
//  Created by monkey2016 on 16/12/6.
//  Copyright © 2016年 ZX_XPH. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HSFLodingView : UIView

@property (nonatomic,strong) UIButton *maskBtn;//萌版
@property (nonatomic,strong) UILabel *title;//提示文字
@property (nonatomic,strong) UIImageView *imgView;//展示的图片

@property (nonatomic,strong) NSArray *imgArr;//图片数组
@property (nonatomic,strong) NSString *message;//提示文字

//展示
+(instancetype)showLodingViewInView:(UIView *)superView andRect:(CGRect)frame imgArr:(NSArray *)imgArr message:(NSString *)message;
//展示 － 延迟消失
+(instancetype)showLodingViewInView:(UIView *)superView andRect:(CGRect)frame imgArr:(NSArray *)imgArr message:(NSString *)message dismissAfterTimeIntervel:(NSTimeInterval)delay;


//展示不带动画
+(instancetype)showLoadFailureViewInView:(UIView *)superView andRect:(CGRect)frame img:(NSString *)imgName message:(NSString *)message;
//展示不带动画 － 延迟消失
+(instancetype)showLoadFailureViewInView:(UIView *)superView andRect:(CGRect)frame img:(NSString *)imgName message:(NSString *)message dismissAfterTimeIntervel:(NSTimeInterval)delay;

//消失
- (void)dismiss;

@end

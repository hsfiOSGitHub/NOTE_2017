//
//  HSFLodingView.m
//  友照
//
//  Created by monkey2016 on 16/12/6.
//  Copyright © 2016年 ZX_XPH. All rights reserved.
//

#import "HSFLodingView.h"

@interface HSFLodingView ()

@end

@implementation HSFLodingView
//初始化方法
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
//        self.userInteractionEnabled = YES;
        self.backgroundColor = [UIColor clearColor]; 
        //创建maskBtn
        [self createMaskBtnWithFrame:frame];
        //创建imgView
        [self createImgViewWithFrame:frame];
        //创建title
        [self createTitleWithFrame:frame];
    }
    return self;
}
//创建maskBtn
-(void)createMaskBtnWithFrame:(CGRect)FRAME{
    _maskBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _maskBtn.frame = FRAME;
    [_maskBtn addTarget:self action:@selector(maskBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_maskBtn];
}
//创建imgView
-(void)createImgViewWithFrame:(CGRect)FRAME{
    _imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0 , 0, FRAME.size.width/3,  FRAME.size.width/3)];
    _imgView.center = CGPointMake(FRAME.size.width / 2, FRAME.size.height / 2);
    [self addSubview:_imgView];
}
//创建title
-(void)createTitleWithFrame:(CGRect)FRAME{
    _title = [[UILabel alloc]initWithFrame:CGRectMake(0, _imgView.frame.origin.y + _imgView.frame.size.height + 10, FRAME.size.width, 30)];
    _title.textAlignment = NSTextAlignmentCenter;
    _title.textColor = KRGB(0, 172, 204, 1);
    [self addSubview:_title];
}
//点击maskBtn
- (void)maskBtnAction:(UIButton *)sender {
   
}
//展示动画
+(instancetype)showLodingViewInView:(UIView *)superView andRect:(CGRect)frame imgArr:(NSArray *)imgArr message:(NSString *)message {
    HSFLodingView *loadingView = [[HSFLodingView alloc]initWithFrame:frame];
    [superView addSubview:loadingView];
    //开始动画
    loadingView.imgView.animationImages = imgArr;
    loadingView.imgView.animationDuration = 0.5;
    loadingView.imgView.animationRepeatCount = 0;
    [loadingView.imgView startAnimating];
    //title message
    loadingView.title.text = message;
    return loadingView;
}
//展示动画 － 延迟消失
+(instancetype)showLodingViewInView:(UIView *)superView andRect:(CGRect)frame imgArr:(NSArray *)imgArr message:(NSString *)message dismissAfterTimeIntervel:(NSTimeInterval)delay {
    HSFLodingView *loadingView = [[HSFLodingView alloc]initWithFrame:frame];
    [superView addSubview:loadingView];
    //开始动画
    loadingView.imgView.animationImages = imgArr;
    loadingView.imgView.animationDuration = 0.5;
    loadingView.imgView.animationRepeatCount = 0;
    [loadingView.imgView startAnimating];
    //title message
    loadingView.title.text = message;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delay * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [loadingView dismiss];
    });
    
    return loadingView;
}

//展示不带动画
+(instancetype)showLoadFailureViewInView:(UIView *)superView andRect:(CGRect)frame img:(NSString *)imgName message:(NSString *)message {
    HSFLodingView *loadingView = [[HSFLodingView alloc]initWithFrame:frame];
    [superView addSubview:loadingView];
    //image
    loadingView.imgView.image = [UIImage imageNamed:imgName];
    //title message
    loadingView.title.text = message;
    //取消maskBtn
    [loadingView.maskBtn removeFromSuperview];
    
    return loadingView;
}
//展示不带动画 － 延迟消失
+(instancetype)showLoadFailureViewInView:(UIView *)superView andRect:(CGRect)frame img:(NSString *)imgName message:(NSString *)message dismissAfterTimeIntervel:(NSTimeInterval)delay {
    HSFLodingView *loadingView = [[HSFLodingView alloc]initWithFrame:frame];
    [superView addSubview:loadingView];
    //image
    loadingView.imgView.image = [UIImage imageNamed:imgName];
    //title message
    loadingView.title.text = message;
    //取消maskBtn
    [loadingView.maskBtn removeFromSuperview];
    //消失
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delay * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [loadingView dismiss];
    });
    
    return loadingView;
}



//消失
-(void)dismiss {
    [self removeFromSuperview];
}

@end

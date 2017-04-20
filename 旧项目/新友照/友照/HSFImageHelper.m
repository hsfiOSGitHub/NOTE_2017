//
//  HSFImageHelper.m
//  News
//
//  Created by monkey2016 on 16/10/21.
//  Copyright © 2016年 monkey2016. All rights reserved.
//

#import "HSFImageHelper.h"

static CGRect oldframe;
@implementation HSFImageHelper
+(void)showWithImageView:(UIImageView *)avatarImageView{
    //添加背景
    UIView *backgroundView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight)];
    backgroundView.backgroundColor=[UIColor darkGrayColor];//背景色
    backgroundView.alpha=0;
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    [keyWindow addSubview:backgroundView];
    //添加imgView
    oldframe=[avatarImageView convertRect:avatarImageView.bounds toView:keyWindow];
    UIImageView *imageView=[[UIImageView alloc]initWithFrame:oldframe];
    UIImage *image=avatarImageView.image;
    imageView.image=image;
    imageView.tag=1;
    [backgroundView addSubview:imageView];
    //显示动画
    [UIView animateWithDuration:0.3 animations:^{
        imageView.frame=CGRectMake(0,([UIScreen mainScreen].bounds.size.height-image.size.height*[UIScreen mainScreen].bounds.size.width/image.size.width)/2, [UIScreen mainScreen].bounds.size.width, image.size.height*[UIScreen mainScreen].bounds.size.width/image.size.width);
        backgroundView.alpha=1;
    } completion:^(BOOL finished) {
        
    }];
    //添加点击手势返回
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hideImage:)];
    [backgroundView addGestureRecognizer: tap];
}


+(void)showWithBtn:(UIButton *)btn{
    //添加背景
    UIView *backgroundView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight)];
    backgroundView.backgroundColor=[UIColor darkGrayColor];
    backgroundView.alpha=0;
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    [keyWindow addSubview:backgroundView];
    //添加imgView
    oldframe=[btn convertRect:btn.bounds toView:keyWindow];
    UIImageView *imageView=[[UIImageView alloc]initWithFrame:oldframe];
    UIImage *image=btn.currentImage;
    imageView.image=image;
    imageView.tag=1;
    [backgroundView addSubview:imageView];
    //显示动画
    [UIView animateWithDuration:0.3 animations:^{
        imageView.frame=CGRectMake(0,([UIScreen mainScreen].bounds.size.height-image.size.height*[UIScreen mainScreen].bounds.size.width/image.size.width)/2, [UIScreen mainScreen].bounds.size.width, image.size.height*[UIScreen mainScreen].bounds.size.width/image.size.width);
        backgroundView.alpha=1;
    } completion:^(BOOL finished) {
        
    }];
    //添加点击手势返回
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hideImage:)];
    [backgroundView addGestureRecognizer: tap];
}
#pragma mark -点击手势返回
+(void)hideImage:(UITapGestureRecognizer*)tap{
    UIView *backgroundView=tap.view;
    UIImageView *imageView=(UIImageView*)[tap.view viewWithTag:1];
    [UIView animateWithDuration:0.3 animations:^{
        imageView.frame=oldframe;
        backgroundView.alpha=0;
    } completion:^(BOOL finished) {
        [backgroundView removeFromSuperview];
    }];
}
@end

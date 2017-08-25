//
//  HSFLuckyView.h
//  LuckyDemo
//
//  Created by JuZhenBaoiMac on 2017/7/3.
//  Copyright © 2017年 JuZhenBaoiMac. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, HSFDirection) {
    HSFDirection_cw,//顺时针
    HSFDirection_acw//逆时针
};

@class HSFLuckyView;
@protocol HSFLuckyViewDelegate <NSObject>

@optional

-(void)didClickStartBtn:(HSFLuckyView *)luckyView startBtn:(UIButton *)sender;

@end

@interface HSFLuckyView : UIView

/* 自定义 */
@property (nonatomic,strong) NSIndexPath *size;//大小：3*3 3*4 4*4 ...
@property (nonatomic,strong) NSArray *arr_source;//图片数组 @[@{@"title"：@"",@"image":@""}, ...]
@property (nonatomic,strong) UIColor *maskViewColor;//遮罩颜色
@property (nonatomic,strong) NSString *startBtnImgName;//开始按钮图
@property (nonatomic,strong) NSString *bgImgName;//背景图
@property (nonatomic,strong) UIView *maskView;//滚动的view
@property (nonatomic,assign) HSFDirection direction;//方向：顺时针/逆时针
@property (nonatomic,strong) NSString *stopIndex;//可以自定义抽奖结果(from 0 ~ imgViewArr.count)
@property (nonatomic,assign) id<HSFLuckyViewDelegate> delegate;


#pragma mark -配置
-(void)setUp;

#pragma mark -开始
-(void)startACTION;

#pragma mark -停止
-(void)stopACTION;

#pragma mark -item圆角
-(void)itemCornerRadius:(CGFloat)cornerRadius borderColor:(UIColor *)borderColor borderWidth:(CGFloat)borderWidth;




@end

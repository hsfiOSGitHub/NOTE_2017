//
//  ZXFunctionBtnsView.h
//  功能按钮
//
//  Created by ZX on 16/3/1.
//  Copyright © 2016年 ZX. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#define kZX_ScreenW [UIScreen mainScreen].bounds.size.width
#define kZX_ScreenH [UIScreen mainScreen].bounds.size.height
@interface ZXFunctionBtnsView : NSObject

@property (nonatomic, copy) NSMutableArray *buttonArray;
@property (nonatomic, copy) NSArray *buttonNames;
@property (nonatomic, assign) NSInteger selectedButtonIndex;

@property (nonatomic) UIImageView *XiaHuaXianImageView;
@property (nonatomic) UIImage *XiaHuaXianimage;
//为了定制内容视图 待完善
@property (nonatomic) UICollectionView *collectionView;
//分割线背剪的高度 的 一半（垂直居中显示）
@property (nonatomic, assign) CGFloat cutHeight;
//参数：按钮名字数组 第一个按钮的起点 每个按钮的间隔 按钮的高度
//按钮的tag值从1000起
- (instancetype)initWithButtonNames:(NSArray *)names andStartPoint:(CGPoint)point andSpace:(float)space andBtnHeight:(float)h andXiaHuaXiaImage:(UIImage *)image;
//按钮被选中（只有状态改变）
- (void)buttonSelected:(NSInteger)buttonIndex;
//将按钮添加到父视图
- (void)btnsPasteSuperView:(UIView *)view;





@end

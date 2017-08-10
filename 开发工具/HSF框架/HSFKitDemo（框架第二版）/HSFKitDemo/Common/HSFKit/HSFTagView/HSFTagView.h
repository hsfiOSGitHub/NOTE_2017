//
//  HSFTagView.h
//  HCJ
//
//  Created by JuZhenBaoiMac on 2017/7/10.
//  Copyright © 2017年 JuZhenBaoiMac. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HSFTagView;

@protocol HSFTagViewDelegate <NSObject>

@optional

-(void)didSeleteTag:(HSFTagView *)tagView atIndex:(NSInteger)index;

@end

@interface HSFTagView : UIView

@property (nonatomic,strong) NSArray *tagsArr;
@property (nonatomic,strong) UIColor *tagColor;
@property (nonatomic,assign) CGFloat font;
@property (nonatomic,strong) UIColor *tagBgColor;
@property (nonatomic,assign) id<HSFTagViewDelegate> delegate;

-(void)setUp;
//添加边框圆角
-(void)setTagCornerRadius:(CGFloat)cornerRadius borderColor:(UIColor *)borderColor borderWidth:(CGFloat)borderWidth;

@end

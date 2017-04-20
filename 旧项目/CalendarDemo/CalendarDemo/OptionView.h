//
//  OptionView.h
//  SpringAnimationDemo
//
//  Created by monkey2016 on 16/12/1.
//  Copyright © 2016年 monkey2016. All rights reserved.
//

#import <UIKit/UIKit.h>

#define selfSize self.frame.size
#define kBtnW 60
#define kBtnH 90
#define kTop 20 //optionBtn 距离 contentView 顶部的高度
#define kSpaceH 30 //optionBtn Y轴方向间距
#define kCloseBtnH 45 //关闭按钮的高
#define lineNum 4 //一行显示几个optionBtn

@protocol OptionViewDelegate <NSObject>
@optional
-(void)optionBtn1Action;
-(void)optionBtn2Action;
-(void)optionBtn3Action;
-(void)optionBtn4Action;
-(void)optionBtn5Action;
-(void)optionBtn6Action;
-(void)optionBtn7Action;
-(void)optionBtn8Action;
@end

@interface OptionView : UIView

@property (nonatomic,strong) NSArray *optionBtnArr;//数组－－装字典{@"icon"：@""，@"title"：@""}
@property (nonatomic,assign) id<OptionViewDelegate> delegate;

//展示
-(void)show;

@end

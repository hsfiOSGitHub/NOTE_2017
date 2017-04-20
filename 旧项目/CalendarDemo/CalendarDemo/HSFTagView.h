//
//  HSFTagView.h
//  CalendarDemo
//
//  Created by monkey2016 on 16/12/30.
//  Copyright © 2016年 monkey2016. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol HSFTagViewDelegate <NSObject>

@optional
-(void)addTag:(NSString *)title;
-(void)removeTagAtIndex:(NSInteger)index;

-(void)showColorCardAtIndex:(NSInteger)index;
@end

@interface HSFTagView : UIView

@property (nonatomic,assign) CGFloat maxTagViewHeight;//self的最大高度 默认最大200

@property (nonatomic,strong) NSArray *tagsArr;//标签数组

@property (nonatomic,assign) id<HSFTagViewDelegate> delegate;//代理 

@property (nonatomic,strong) NSMutableDictionary *bgViewDic_color;//如果需要颜色的话必须’先‘给这个属性赋值


@end

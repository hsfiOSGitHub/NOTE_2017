//
//  FyCalendarView.h
//  FYCalendar
//
//  Created by 丰雨 on 16/3/17.
//  Copyright © 2016年 Feng. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ZXWantStudyViewController;
@class ZX_QuShangKe_ViewController;


@protocol FyCalendarView <NSObject>
/**
 *  点击返回的日期
 */
- (void)setupToday:(NSInteger)day Month:(NSInteger)month Year:(NSInteger)year;

//- (void)choose
@end

@interface FyCalendarView : UIView

@property(nonatomic)BOOL panduan;//判断是否需要点击事件


//set 选择日期
@property (nonatomic, strong) NSDate *date;
@property (nonatomic, strong) UIColor *dateColor;
//年月label
@property (nonatomic, strong) UILabel *headlabel;
@property (nonatomic, strong) UIColor *headColor;
//weekView
@property (nonatomic, strong) UIView *weekBg;
@property (nonatomic, strong) UIColor *weekDaysColor;

//全天可用
@property (nonatomic, strong) NSMutableArray *allDaysArr;
@property (nonatomic, strong) UIColor *allDaysColor;
@property (nonatomic, assign) CGFloat *allDaysAlpha;
@property (nonatomic, strong) UIImage *allDaysImage;

//部分时段可用
@property (nonatomic, strong) NSMutableArray *partDaysArr;
@property (nonatomic, strong) UIColor *partDaysColor;
@property (nonatomic, assign) CGFloat *partDaysAlpha;
@property (nonatomic, strong) UIImage *partDaysImage;

//今天日期，用来判断用户选择的日期是否小于今天，小于的话就不用查询了没意义
@property(nonatomic)NSInteger touday;

//记录点击的button用来恢复
@property(strong,nonatomic)UIButton* red;
@property(nonatomic,strong)UIButton *leftBtn;
@property(nonatomic,strong)UIButton *rightBtn;
@property(strong,nonatomic)UIButton* green;
@property(nonatomic)BOOL ai;
//属性
@property(nonatomic,strong)ZXWantStudyViewController * zxw;
@property(nonatomic,strong)ZX_QuShangKe_ViewController * zxV;

//是否只显示本月日期,默认->NO
@property (nonatomic, assign) BOOL isShowOnlyMonthDays;

//创建日历
- (void)createCalendarViewWith:(NSDate *)date;
//当前日期的下一个月
- (NSDate *)nextMonth:(NSDate *)date;

//当前日期的上一个月
- (NSDate *)lastMonth:(NSDate *)date;

//设置上一个月和下一个月
@property (nonatomic, copy) void(^nextMonthBlock)();
@property (nonatomic, copy) void(^lastMonthBlock)();

//选择年月  -> 暂不考虑
@property (nonatomic, copy) void(^chooseMonthBlock)();

//点击返回日期
@property (nonatomic, copy) void(^calendarBlock)(NSInteger day, NSInteger month, NSInteger year);


@end

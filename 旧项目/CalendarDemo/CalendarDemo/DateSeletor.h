//
//  DateSeletor.h
//  CalendarDemo
//
//  Created by monkey2016 on 16/12/23.
//  Copyright © 2016年 monkey2016. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DateSeletorDelegate <NSObject>

@optional
-(void)sendChoosedDateWithYear:(NSInteger)year month:(NSInteger)month day:(NSInteger)day firstWeekDayInMonth:(NSInteger)firstWeekDayInMonth;
@end

@interface DateSeletor : UIView
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bgViewBottomCons;//底部约束

@property (weak, nonatomic) IBOutlet UILabel *title;//标题

@property (weak, nonatomic) IBOutlet UILabel *seletedDate;//选中的日期
@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;

@property (weak, nonatomic) IBOutlet UIButton *cancelBtn;
@property (weak, nonatomic) IBOutlet UIButton *okBtn;
@property (weak, nonatomic) IBOutlet UIButton *maskBtn;

@property (nonatomic,strong) NSString *sourceVC;

@property (nonatomic,assign) id<DateSeletorDelegate> delegate;

//show
-(void)show;

@end

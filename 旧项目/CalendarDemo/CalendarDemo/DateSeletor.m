//
//  DateSeletor.m
//  CalendarDemo
//
//  Created by monkey2016 on 16/12/23.
//  Copyright © 2016年 monkey2016. All rights reserved.
//

#import "DateSeletor.h"

@implementation DateSeletor
//初始化方法
-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self = (DateSeletor *)[self loadNibView];
        self.frame = frame;
    }
    return self;
}
//获取到xib中的View
-(UIView *)loadNibView{
    NSArray *views = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil];
    return views.firstObject;
}

#pragma mark -awakeFromNib
-(void)awakeFromNib{
    [super awakeFromNib];
    _datePicker.locale = [NSLocale localeWithLocaleIdentifier:@"zh"];
}
//更改时间
- (IBAction)datePickerACTION:(UIDatePicker *)sender {
    if ([self.sourceVC isEqualToString:@"ScheduleVC"]) {
        self.seletedDate.text = [NSDate allDayTimeWithDate:sender.date];
    }else if ([self.sourceVC isEqualToString:@"EditScheduleVC"]) {
        self.seletedDate.text = [NSString stringWithFormat:@"提前 %@ 提醒",[NSDate alarmTimeWithDate:sender.date]];
    }
}


//点击maskBtn
- (IBAction)maskBtnACTION:(UIButton *)sender {
    [self removeFromSuperview];
}
- (IBAction)cancelBtnCTION:(UIButton *)sender {
    [self removeFromSuperview];
}
//点击确认
- (IBAction)okBtnACTION:(UIButton *)sender {
    if ([self.sourceVC isEqualToString:@"ScheduleVC"]) {
        NSDate *choosedDate = _datePicker.date;
        NSInteger year = [choosedDate dateYear];
        NSInteger month = [choosedDate dateMonth];
        NSInteger day = [choosedDate dateDay];
        NSInteger firstWeekDay = [choosedDate firstWeekDayInMonth];
        //    
        NSMutableDictionary *userInfo = [NSMutableDictionary dictionaryWithCapacity:4];
        [userInfo setObject:choosedDate forKey:@"date"];
        [userInfo setObject:[[NSNumber alloc] initWithInteger:year] forKey:@"year"];
        [userInfo setObject:[[NSNumber alloc] initWithInteger:month] forKey:@"month"];
        [userInfo setObject:[[NSNumber alloc] initWithInteger:day] forKey:@"day"];
        [userInfo setObject:[[NSNumber alloc] initWithInteger:firstWeekDay] forKey:@"firstWeekDay"];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"kDateSeletor_notify_ScheduleVC" object:nil userInfo:userInfo];
    }else if ([self.sourceVC isEqualToString:@"EditScheduleVC"]) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"kDateSeletor_notify_EditScheduleVC" object:nil userInfo:@{@"alarmStr":self.seletedDate.text}];
    }
    //移除
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self removeFromSuperview];
    });
}
//show
-(void)show{
    if ([self.sourceVC isEqualToString:@"ScheduleVC"]) {
        self.seletedDate.text = [NSDate allDayTimeWithDate:[NSDate date]];
    }else if ([self.sourceVC isEqualToString:@"EditScheduleVC"]) {
        self.seletedDate.text = [NSString stringWithFormat:@"提前 0分钟 提醒"];
    }
    [UIView animateWithDuration:0.3 animations:^{
        self.bgView.frame = CGRectMake(0, KScreenHeight - (305 + KScreenWidth/12), self.bgView.width, self.bgView.height);
    } completion:^(BOOL finished) {
        
    }];
}


@end

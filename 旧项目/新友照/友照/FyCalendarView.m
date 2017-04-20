//
//  FyCalendarView.m
//  FYCalendar
//
//  Created by 丰雨 on 16/3/17.
//  Copyright © 2016年 Feng. All rights reserved.
//

#import "FyCalendarView.h"

@interface FyCalendarView ()
@property (nonatomic, strong) UIButton *selectBtn;
@property (nonatomic, strong) UIButton *todaybtn;

@property (nonatomic, strong) NSMutableArray *daysArray;

@end

@implementation FyCalendarView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self setupDate];
        if (!_red)
        {
            _red=[[UIButton alloc] init];
        }
        if (!_green)
        {
            _green=[[UIButton alloc] init];
        }
        [self setupNextAndLastMonthView];
    }
    return self;
}

- (void)setupDate
{
    self.daysArray = [NSMutableArray arrayWithCapacity:42];
    for (int i = 0; i < 42; i++)
    {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.backgroundColor=[UIColor whiteColor];
        [self addSubview:button];
        [_daysArray addObject:button];
        [button addTarget:self action:@selector(logDate:) forControlEvents:UIControlEventTouchUpInside];
    }
}

//上一月和下一月
- (void)setupNextAndLastMonthView
{
    //左边上一月
    _leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_leftBtn setImage:[UIImage imageNamed:@"左三角"] forState:UIControlStateNormal];
    [_leftBtn setImageEdgeInsets:UIEdgeInsetsMake(0, self.frame.size.width/6-10, 0, self.frame.size.width/6-10)];
    [_leftBtn addTarget:self action:@selector(nextAndLastMonth:) forControlEvents:UIControlEventTouchUpInside];
   
    [self addSubview:_leftBtn];
    _leftBtn.tag = 1;
    _leftBtn.frame = CGRectMake(self.frame.size.width/6*1-10, 0,20, 20);
    _leftBtn.frame = CGRectMake(0, 0,self.frame.size.width/3, 20);

    //右边下一月
    _rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_rightBtn setImage:[UIImage imageNamed:@"右三角"] forState:UIControlStateNormal];
    _rightBtn.tag = 2;
    [_rightBtn addTarget:self action:@selector(nextAndLastMonth:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_rightBtn];
    
    _rightBtn.frame = CGRectMake(self.frame.size.width/6*5-10,0, 20, 20);
    _rightBtn.frame = CGRectMake(self.frame.size.width/3*2, 0,self.frame.size.width/3, 20);
    [_rightBtn setImageEdgeInsets:UIEdgeInsetsMake(0, self.frame.size.width/6-10, 0, self.frame.size.width/6-10)];

}

- (void)nextAndLastMonth:(UIButton *)button
{
    if (button.tag == 1)
    {
        //上一月
        if (self.lastMonthBlock)
        {
            self.lastMonthBlock();
        }
    }
    else
    {
        //下一月
        if (self.nextMonthBlock)
        {
            self.nextMonthBlock();
        }
    }
}

#pragma mark - create View
- (void)setDate:(NSDate *)date
{
    _date = date;
    [self createCalendarViewWith:date];
}

//创建日期
- (void)createCalendarViewWith:(NSDate *)date
{
    //设置具体日期的大小，也就是宽和高
    CGFloat itemW = (self.frame.size.width - 20) / 7;
    CGFloat itemH = (self.frame.size.height - 20) / 7;
    
    //年月
    self.headlabel = [[UILabel alloc] init];
    self.headlabel.text = [NSString stringWithFormat:@"%ld年%ld月",(long)[self year:date],(long)[self month:date]];
  
    self.headlabel.font= [UIFont systemFontOfSize:14];
    self.headlabel.frame = CGRectMake(self.frame.size.width/3, 0,self.frame.size.width/3, 20);
    self.headlabel.textAlignment   = NSTextAlignmentCenter;
    self.headlabel.textColor = self.headColor;
    
    UIButton *headBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    headBtn.backgroundColor = [UIColor whiteColor];
    headBtn.frame = self.headlabel.frame;
    [headBtn addTarget:self action:@selector(chooseMonth:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.headlabel];
    
    //2.日期栏
    NSArray *array = @[@"周日", @"周一", @"周二", @"周三", @"周四", @"周五", @"周六"];
    self.weekBg = [[UIView alloc] init];
    self.weekBg.frame = CGRectMake(0, CGRectGetMaxY(self.headlabel.frame), KScreenWidth, itemH);
    [self addSubview:self.weekBg];
    
    for (int i = 0; i < 7; i++)
    {
        UILabel *week = [[UILabel alloc] init];
        week.text     = array[i];
        //设置日期栏的字体
        week.font     = [UIFont systemFontOfSize:14];
        week.frame    = CGRectMake(itemW * i+(KScreenWidth-itemW*7)/2.0, 0, itemW, itemH);
        week.textAlignment   = NSTextAlignmentCenter;
        week.backgroundColor = [UIColor whiteColor];
        week.textColor       = self.weekDaysColor;
        [self.weekBg addSubview:week];
    }
    //详细日期的排布
    for (int i = 0; i < 42; i++)
    {
        int x = (i % 7) * itemW ;
        int y = (i / 7) * itemH + CGRectGetMaxY(self.weekBg.frame);
        
        UIButton *dayButton = _daysArray[i];
        
        dayButton.frame = CGRectMake(x+(itemW-itemH)/2+(KScreenWidth-itemW*7)/2.0, y, itemH-3, itemH-3);
        dayButton.titleLabel.textAlignment = NSTextAlignmentCenter;
        dayButton.layer.cornerRadius = (itemH-3)/2;
        if (!_panduan)
        {
            [dayButton addTarget:self action:@selector(logDate:) forControlEvents:UIControlEventTouchUpInside];
        }

        NSInteger daysInLastMonth = [self totaldaysInMonth:[self lastMonth:date]];
        NSInteger daysInThisMonth = [self totaldaysInMonth:date];
        NSInteger firstWeekday    = [self firstWeekdayInThisMonth:date];
        NSInteger day = 0;
        
        if (i < firstWeekday)
        {
            day = daysInLastMonth - firstWeekday + i + 1;
            [self setStyle_BeyondThisMonth:dayButton];
        }
        else if (i > firstWeekday + daysInThisMonth - 1)
        {
            day = i + 1 - firstWeekday - daysInThisMonth;
            [self setStyle_BeyondThisMonth:dayButton];
        }
        else
        {
            day = i - firstWeekday + 1;
            [dayButton setTitle:[NSString stringWithFormat:@"%li", (long)day] forState:UIControlStateNormal];
            [self setStyle_AfterToday:dayButton];
        }
        [dayButton setTitle:[NSString stringWithFormat:@"%li", (long)day] forState:UIControlStateNormal];
        //设置日期字体大小
        dayButton.titleLabel.font = [UIFont systemFontOfSize:13];
        
        // this month
        if ([self month:date] == [self month:[NSDate date]]) {
            
            NSInteger todayIndex = [self day:date] + firstWeekday - 1;
            
            if (i < todayIndex && i >= firstWeekday) {
                //                [self setStyle_BeforeToday:dayButton];
            }else if(i ==  todayIndex){
                [self setStyle_Today:dayButton];
            }
        }
    }
}

#pragma mark - chooseMonth
- (void)chooseMonth:(UIButton *)button {
    //下期版本
}


#pragma mark - output date

//当前选中的日期
-(void)logDate:(UIButton *)dayBtn
{
    
    if (!_panduan)
    {
        NSInteger day = [[dayBtn titleForState:UIControlStateNormal] integerValue];
        NSDateComponents *comp = [[NSCalendar currentCalendar] components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:self.date];
        
//        //如果时间小于小于今天就不用查询了
//        if (day>=self.touday)
//        {
            _todaybtn.layer.borderWidth=0;
            self.selectBtn.selected = NO;
            //设置上一次选中的按钮为白色
            [self.selectBtn setBackgroundColor:[UIColor whiteColor]];
            self.selectBtn.layer.borderWidth=0;
            dayBtn.selected = YES;
            //可约
            if (self.green)
            {
                self.green.backgroundColor=[UIColor colorWithRed:45/255.0 green:195/255.0 blue:130/255.0 alpha:1];
            }
            //不可约
            if (self.red)
            {
                self.red.backgroundColor=[UIColor colorWithRed:235/255.0 green:72/255.0 blue:103/255.0 alpha:1];
            }
            if(CGColorEqualToColor(dayBtn.backgroundColor.CGColor,[UIColor colorWithRed:45/255.0 green:195/255.0 blue:130/255.0 alpha:1].CGColor))
            {
                self.green = dayBtn;
            }
            else if (CGColorEqualToColor(dayBtn.backgroundColor.CGColor,[UIColor colorWithRed:235/255.0 green:72/255.0 blue:103/255.0 alpha:1].CGColor))
            {
                self.red=dayBtn;
            }

            //更改选中当前日期的颜色
            self.selectBtn = dayBtn;
            
            //更改选中当前颜色的边框
            dayBtn.layer.borderWidth = 2;//边框宽度
            dayBtn.layer.borderColor = [[UIColor colorWithRed:249/255.0 green:203/255.0 blue:104/255.0 alpha:1] CGColor];//边框颜色
            if (self.calendarBlock)
            {
                //获取点击日期
                self.calendarBlock(day, [comp month], [comp year]);
                //设置日期
//                self.zxV.selectDate = [NSString stringWithFormat:@"%li-%li-%li",(long)[comp year],(long)[comp month],(long)day];
//                //查询数据
//                [self.zxV getClassNetdata];
            }
//        }
    }
}

#pragma mark - date button style

- (void)setStyle_BeyondThisMonth:(UIButton *)btn
{
    btn.enabled = NO;
    if (self.isShowOnlyMonthDays)
    {
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    }
    else
    {
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }
}

- (void)setStyle_Today:(UIButton *)btn
{
    if (_selectBtn) {
        
        //设置今天日期的背景颜色和字体颜色
        _selectBtn.layer.cornerRadius = btn.frame.size.height / 2;
        _selectBtn.layer.masksToBounds = YES;
        _todaybtn=btn;
        //设置边框
        _selectBtn.layer.borderWidth = 2;//边框宽度
        _selectBtn.layer.borderColor = [[UIColor colorWithRed:249/255.0 green:203/255.0 blue:104/255.0 alpha:1] CGColor];//边框颜色
    }
    else
    {
        //设置今天日期的背景颜色和字体颜色
        btn.layer.cornerRadius = btn.frame.size.height / 2;
        btn.layer.masksToBounds = YES;
        _todaybtn=btn;
        //今天日期
        self.touday = [[btn titleForState:UIControlStateNormal] integerValue];
        //设置边框
        btn.layer.borderWidth = 2;//边框宽度
        btn.layer.borderColor = [[UIColor colorWithRed:249/255.0 green:203/255.0 blue:104/255.0 alpha:1] CGColor];//边框颜色
    }
   
}

- (void)setStyle_AfterToday:(UIButton *)btn
{
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    for (NSString *str in self.allDaysArr) {
        if ([str isEqualToString:btn.titleLabel.text])
        {
            btn.backgroundColor =[UIColor colorWithRed:45/255.0 green:195/255.0 blue:130/255.0 alpha:1];
            [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        }
    }
    for (NSString *str in self.partDaysArr) {
        if ([str isEqualToString:btn.titleLabel.text])
        {
            btn.backgroundColor = [UIColor colorWithRed:235/255.0 green:72/255.0 blue:103/255.0 alpha:1];
            [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        }
    }
}


//一个月第一个周末
- (NSInteger)firstWeekdayInThisMonth:(NSDate *)date{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    [calendar setFirstWeekday:1];//1.Sun. 2.Mon. 3.Thes. 4.Wed. 5.Thur. 6.Fri. 7.Sat.
    NSDateComponents *component = [calendar components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:date];
    [component setDay:1];
    NSDate *firstDayOfMonthDate = [calendar dateFromComponents:component];
    NSUInteger firstWeekDay = [calendar ordinalityOfUnit:NSCalendarUnitWeekday inUnit:NSCalendarUnitWeekOfMonth forDate:firstDayOfMonthDate];
    return firstWeekDay - 1;
}

//总天数
- (NSInteger)totaldaysInMonth:(NSDate *)date{
    NSRange daysInOfMonth = [[NSCalendar currentCalendar] rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:date];
    return daysInOfMonth.length;
}

#pragma mark - month +/-

- (NSDate *)lastMonth:(NSDate *)date{
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    dateComponents.month = -1;
    NSDate *newDate = [[NSCalendar currentCalendar] dateByAddingComponents:dateComponents toDate:date options:0];
    
    return newDate;
}

- (NSDate*)nextMonth:(NSDate *)date{
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    dateComponents.month = +1;
    NSDate *newDate = [[NSCalendar currentCalendar] dateByAddingComponents:dateComponents toDate:date options:0];
    
    return newDate;
}


#pragma mark - date get: day-month-year

- (NSInteger)day:(NSDate *)date{
    NSDateComponents *components = [[NSCalendar currentCalendar] components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:date];
    return [components day];
}


- (NSInteger)month:(NSDate *)date{
    NSDateComponents *components = [[NSCalendar currentCalendar] components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:date];
    return [components month];
}

- (NSInteger)year:(NSDate *)date{
    NSDateComponents *components = [[NSCalendar currentCalendar] components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:date];
    return [components year];
}

@end

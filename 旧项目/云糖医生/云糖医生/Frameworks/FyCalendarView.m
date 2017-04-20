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
@property (nonatomic, strong) NSMutableArray *daysArray;
@property (nonatomic) int flag;
@property (nonatomic, strong) UIButton *NowBtn;
@property (nonatomic, strong)UISwipeGestureRecognizer *leftSwipeGestureRecognizer;
@property (nonatomic, strong)UISwipeGestureRecognizer *rightSwipeGestureRecognizer;
@end

@implementation FyCalendarView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self setupDate];
        [self setupNextAndLastMonthView];
//        //加手势
//        self.leftSwipeGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipes:)];
//        self.rightSwipeGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipes:)];
//        self.leftSwipeGestureRecognizer.direction = UISwipeGestureRecognizerDirectionLeft;
//        self.rightSwipeGestureRecognizer.direction = UISwipeGestureRecognizerDirectionRight;
//        [self addGestureRecognizer: self.leftSwipeGestureRecognizer];
//        [self addGestureRecognizer: self.rightSwipeGestureRecognizer];

    }
    return self;
}
//左右轻扫手势
- (void)handleSwipes:(UISwipeGestureRecognizer *)sender
{
    if (sender.direction == UISwipeGestureRecognizerDirectionRight)
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
- (void)setupDate
{
    self.daysArray = [NSMutableArray arrayWithCapacity:49];
    for (int i = 0; i < 49; i++)
    {
        UIButton *button = [[UIButton alloc] init];
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
    [_leftBtn addTarget:self action:@selector(nextAndLastMonth:) forControlEvents:UIControlEventTouchUpInside];
    
    [self addSubview:_leftBtn];
  
    _leftBtn.tag = 1;
    _leftBtn.frame = CGRectMake(KScreenWidth / 3 - 60, 0,60, 30);
    //右边下一月
    _rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_rightBtn setImage:[UIImage imageNamed:@"右三角"] forState:UIControlStateNormal];
    _rightBtn.tag = 2;
    
    [_rightBtn addTarget:self action:@selector(nextAndLastMonth:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_rightBtn];
  
    _rightBtn.frame = CGRectMake(KScreenWidth * 2 / 3 , 0, 60, 30);
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
    CGFloat itemW = self.frame.size.width / 7;
    CGFloat itemH = 307 / 7;
    
    //年月
    self.headlabel = [[UILabel alloc] init];
    self.headlabel.text = [NSString stringWithFormat:@"%ld年%ld月",(long)[self year:date],(long)[self month:date]];
    
    self.headlabel.font= [UIFont systemFontOfSize:14];
    self.headlabel.frame = CGRectMake(self.frame.size.width/3, 0,self.frame.size.width/3, 30);
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
    self.weekBg.frame = CGRectMake(0, CGRectGetMaxY(self.headlabel.frame), self.frame.size.width, itemH);
    
    [self addSubview:self.weekBg];
    
    for (int i = 0; i < 7; i++)
    {
        UILabel *week = [[UILabel alloc] init];
        week.text = array[i];
        //设置日期栏的字体
        week.font     = [UIFont systemFontOfSize:14];
        week.frame    = CGRectMake(itemW * i, 0, itemW, itemH);
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
         dayButton.userInteractionEnabled=NO;
        dayButton.frame = CGRectMake(x+(itemW-itemH) * 3/4 + 1, y, itemH-3, itemH-3);
        dayButton.titleLabel.textAlignment = NSTextAlignmentCenter;
        dayButton.layer.cornerRadius = (itemH-3)/2;
        [dayButton addTarget:self action:@selector(logDate:) forControlEvents:UIControlEventTouchUpInside];
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
        // [self setStyle_BeforeToday:dayButton];
            }
            else if(i ==  todayIndex){
              
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
   
    NSInteger day = [[dayBtn titleForState:UIControlStateNormal] integerValue];
    NSDateComponents *comp = [[NSCalendar currentCalendar] components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:self.date];
    //如果时间小于小于今天就不用查询了
  
    if (day>=self.touday)
    {
        self.selectBtn.selected = NO;
        [self.selectBtn setBackgroundColor:[UIColor whiteColor]];
        dayBtn.selected = YES;
        if (self.green)
        {
            self.green.backgroundColor = KRGB(0, 172, 204, 1.0);
            [self.green setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        }
        if (self.red)
        {
            self.red.backgroundColor=[UIColor colorWithRed:0.937 green:0.322 blue:0.227 alpha:1.000];
        }
        if(dayBtn.backgroundColor == KRGB(0, 172, 204, 1.0))
        {
            self.green=dayBtn;
        }
        else if (dayBtn.backgroundColor==[UIColor colorWithRed:0.937 green:0.322 blue:0.227 alpha:1.000])
        {
            self.red=dayBtn;
        }
        self.selectBtn = dayBtn;
     //更改选中当前日期的颜色
     
       self.ZXS.todayQuan = 1;
       self.ZXP.todayQuan = 1;
        dayBtn.layer.borderWidth = 2;
        dayBtn.layer.borderColor = [[UIColor colorWithRed:249/255.0 green:203/255.0 blue:104/255.0 alpha:1] CGColor];//边框颜色
        if (self.calendarBlock)
        {
            //获取点击日期
            self.calendarBlock(day, [comp month], [comp year]);
            //设置日期
            self.ZXS.selectDate=[NSString stringWithFormat:@"%li-%02li-%02li",(long)[comp year],(long)[comp month],(long)day];
            self.ZXP.selectDate=[NSString stringWithFormat:@"%li-%02li-%02li",(long)[comp year],(long)[comp month],(long)day];
            //查询数据
            [self.ZXS getTheSchedulingSheet];
            self.ZXS.haha=[NSString stringWithFormat:@"%li",(long)day];
            [self.ZXP getIsBusyOrFree];
            self.ZXP.haha=[NSString stringWithFormat:@"%li",(long)day];

        }
    }
    else
    {
        self.ZXS.haha=@"";
        [self.ZXS.tableV reloadData];
        self.ZXP.haha=@"";
        [self.ZXP.SetTableView reloadData];

    }
}

#pragma mark - date button style

- (void)setStyle_BeyondThisMonth:(UIButton *)btn
{
    btn.enabled = NO;
    if (self.isShowOnlyMonthDays)
    {
        [btn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    }
    else
    {
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }
}

- (void)setStyle_Today:(UIButton *)btn
{
   
   
    if ([[ZXUD objectForKey:@"rili"] isEqualToString:@"invite"]) {
        //设置今天日期的背景颜色和字体颜色
        if (self.ZXP.todayQuan != 1) {
            btn.layer.borderWidth = 2;
            btn.layer.borderColor = [[UIColor colorWithRed:249/255.0 green:203/255.0 blue:104/255.0 alpha:1] CGColor];//边框颜色
        }
    }else {
        //设置今天日期的背景颜色和字体颜色
        if (self.ZXS.todayQuan != 1) {
            btn.layer.borderWidth = 2;
            btn.layer.borderColor = [[UIColor colorWithRed:249/255.0 green:203/255.0 blue:104/255.0 alpha:1] CGColor];//边框颜色
        }
    }
    //今天日期
    self.touday = [[btn titleForState:UIControlStateNormal] integerValue];
    self.NowBtn = btn;
}

- (void)setStyle_AfterToday:(UIButton *)btn
{
//    [btn setTitleColor:[UIColor colorWithRed:0.937 green:0.322 blue:0.227 alpha:1.000] forState:UIControlStateSelected];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    for (NSString *str in self.allDaysArr)
    {
        if ([str isEqualToString:btn.titleLabel.text])
        {
            btn.userInteractionEnabled=YES;
            btn.backgroundColor = KRGB(0, 172, 204, 1.0);
            [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        }
    }
    for (NSString *str in self.partDaysArr)
    {
        
        if ([str isEqualToString:btn.titleLabel.text])
        {
            btn.userInteractionEnabled=YES;
            btn.backgroundColor = [UIColor colorWithRed:0.937 green:0.322 blue:0.227 alpha:1.000];
        }
    }
   
    if ([self.ZXS.haha isEqualToString:btn.titleLabel.text])
    {
        btn.layer.borderWidth = 2;
        btn.layer.borderColor = [[UIColor colorWithRed:249/255.0 green:203/255.0 blue:104/255.0 alpha:1] CGColor];//边框颜色
    }
    if ([self.ZXP.haha isEqualToString:btn.titleLabel.text])
    {
        btn.layer.borderWidth = 2;
        btn.layer.borderColor = [[UIColor colorWithRed:249/255.0 green:203/255.0 blue:104/255.0 alpha:1] CGColor];//边框颜色
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

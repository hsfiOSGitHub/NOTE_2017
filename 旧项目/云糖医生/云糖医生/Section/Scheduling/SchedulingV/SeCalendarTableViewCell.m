//
//  SeCalendarTableViewCell.m
//  yuntangyi
//
//  Created by yuntangyi on 16/8/31.
//  Copyright © 2016年 yuntangyi. All rights reserved.
//

#import "SeCalendarTableViewCell.h"

@implementation SeCalendarTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    //设置新日历
    [self shezhixinrili];
}
//设置新日历
-(void)shezhixinrili
{
    //获取当前日期
    self.xindate = [NSDate date];
    //设置位置和大小
    self.rili = [[FyCalendarView alloc] initWithFrame:CGRectMake(0, 10, [UIScreen mainScreen].bounds.size.width, 370)];
    //日期状态
    self.rili.leftBtn.alpha = 0.3;
    self.rili.leftBtn.userInteractionEnabled=NO;
    self.contentView.backgroundColor=[UIColor whiteColor];
    [self.contentView addSubview:self.rili];
    self.rili.date = [NSDate date];
    self.rili.calendarBlock =  ^(NSInteger day, NSInteger month, NSInteger year)
    {
        NSLog(@"%li-%02li-%02li", (long)year,(long)month,(long)day);
    };
     __weak typeof(self) weakSelf = self;
    self.rili.nextMonthBlock = ^(){
        [weakSelf setupNextMonth];
    };
    self.rili.lastMonthBlock = ^(){
        [weakSelf setupLastMonth];
    };
    //加手势
    self.leftSwipeGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(setupNextMonth)];
    self.rightSwipeGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(setupLastMonth)];
    self.leftSwipeGestureRecognizer.direction = UISwipeGestureRecognizerDirectionLeft;
    self.rightSwipeGestureRecognizer.direction = UISwipeGestureRecognizerDirectionRight;
    
}
//新日历下一月
- (void)setupNextMonth
{
    self.xindate = [self.rili nextMonth:self.xindate];
    self.rili.date=self.xindate;
    _en=YES;
    [self xinrilishuaxin];
}

//新日历上一月
- (void)setupLastMonth
{
    self.xindate = [self.rili lastMonth:self.xindate];
    self.rili.date=self.xindate;
    _en=NO;
    [self xinrilishuaxin];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
//新日历刷新
-(void)xinrilishuaxin
{
    //刷新界面
    [self.rili removeFromSuperview];
    self.rili = [[FyCalendarView alloc] initWithFrame:CGRectMake(0, 10, [UIScreen mainScreen].bounds.size.width, 370)];
    self.rili.ZXS = self.ZXS;
    [self.contentView addSubview:self.rili];
    self.rili.allDaysArr = [NSMutableArray array];
    self.rili.partDaysArr = [NSMutableArray array];
    //对日期进行判断
    for (int i = 0; i<_dataArray.count; i++)
    {
        NSDictionary *dic = _dataArray[i];
        NSDateFormatter *inputFormatter = [[NSDateFormatter alloc] init];
        [inputFormatter setDateFormat:@"yyyy-MM-dd"];
        NSDate* inputDate = [inputFormatter dateFromString:dic[@"day"]];
        int total = [dic[@"total_num"] intValue];
        int real = [dic[@"real_num"] intValue];
        if (real < total)
        {
            NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
            [formatter setDateStyle:NSDateFormatterMediumStyle];
            [formatter setTimeStyle:NSDateFormatterShortStyle];
            [formatter setDateFormat:@"MM"];
            NSString* str=[formatter stringFromDate:inputDate];
            NSString* str2=[formatter stringFromDate:self.xindate];
            if([str isEqualToString:str2])
            {
                [formatter setDateFormat:@"d"];
                NSString* str=[formatter stringFromDate:inputDate];
                [self.rili.allDaysArr addObject:str];
            }
        }
        else if(real >= total)
        {
            NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
            [formatter setDateStyle:NSDateFormatterMediumStyle];
            [formatter setTimeStyle:NSDateFormatterShortStyle];
            [formatter setDateFormat:@"MM"];
            NSString* str=[formatter stringFromDate:inputDate];
            NSString* str2=[formatter stringFromDate:self.xindate];
            if([str isEqualToString:str2])
            {
                [formatter setDateFormat:@"d"];
                NSString* str=[formatter stringFromDate:inputDate];
                [self.rili.partDaysArr addObject:str];
            }
        }
    }
    if (!_en)
    {
        self.rili.leftBtn.alpha=0.3;
        self.rili.leftBtn.userInteractionEnabled = NO;
        [self removeGestureRecognizer:self.rightSwipeGestureRecognizer];
        [self addGestureRecognizer:self.leftSwipeGestureRecognizer];
    }
    else
    {
        self.rili.rightBtn.alpha=0.3;
        self.rili.rightBtn.userInteractionEnabled = NO;
        [self removeGestureRecognizer:self.leftSwipeGestureRecognizer];
        [self addGestureRecognizer:self.rightSwipeGestureRecognizer];
    }
    [self.rili createCalendarViewWith:self.xindate];
    self.rili.date=self.xindate;
    self.rili.calendarBlock =  ^(NSInteger day, NSInteger month, NSInteger year){
        NSLog(@"%li-%02li-%02li", (long)year,(long)month,(long)day);
    };
    __weak typeof(self) weakSelf = self;
    self.rili.lastMonthBlock = ^(){
        [weakSelf setupLastMonth];
    };
    self.rili.nextMonthBlock = ^(){
        [weakSelf setupNextMonth];
    };
}

@end

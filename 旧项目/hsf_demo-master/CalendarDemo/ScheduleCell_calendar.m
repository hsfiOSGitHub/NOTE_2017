//
//  ScheduleCell_calendar.m
//  CalendarDemo
//
//  Created by monkey2016 on 16/12/22.
//  Copyright © 2016年 monkey2016. All rights reserved.
//

#import "ScheduleCell_calendar.h"

#import "CalecdarCell.h"

static NSString *identifierCell = @"identifierCell";
@implementation ScheduleCell_calendar
#pragma mark -懒加载
-(NSMutableArray *)seleteDayArr{
    if (!_seleteDayArr) {
        _seleteDayArr = [NSMutableArray array];
        for (int i = 0; i < 6*7; i++) {
            [_seleteDayArr addObject:@"0"];
        }
    }
    return _seleteDayArr;
}
- (NSMutableArray *)monthArray {
    if (_monthArray == nil) {
        _monthArray = [NSMutableArray arrayWithCapacity:4];
        
        NSDate *previousMonthDate = [_currentMonthDate previousMonthDate];
        NSDate *nextMonthDate = [_currentMonthDate nextMonthDate];
        
        [_monthArray addObject:[[GFCalendarMonth alloc] initWithDate:previousMonthDate]];
        [_monthArray addObject:[[GFCalendarMonth alloc] initWithDate:_currentMonthDate]];
        [_monthArray addObject:[[GFCalendarMonth alloc] initWithDate:nextMonthDate]];
        [_monthArray addObject:[self previousMonthDaysForPreviousDate:previousMonthDate]]; // 存储左边的月份的前一个月份的天数，用来填充左边月份的首部
        
        // 发通知，更改当前月份标题
        [self notifyToChangeCalendarHeader];
    }
    
    return _monthArray;
}
#pragma mark -awakeFromNib
- (void)awakeFromNib {
    [super awakeFromNib];
    _currentMonthDate = [NSDate date];
    _currentSeleteMonth = [[NSDate date] dateMonth];
    _currentSeleteYear = [[NSDate date] dateYear];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.scrollView setContentOffset:CGPointMake(KScreenWidth, 0) animated:NO];
        //默认选中今天
        GFCalendarMonth *monthInfo = self.monthArray[1];
        NSInteger firstWeekday = monthInfo.firstWeekday;
        NSInteger row = [[NSDate date] dateDay] + firstWeekday - 1;
        [self collectionView:self.collectionViewMid didSelectItemAtIndexPath:[NSIndexPath indexPathForItem:row inSection:0]];
    });
    //配置scrollView
    [self setUpScrollView];
    //配置collectionView
    [self setUpCollectionView];
    //注册通知，更改日期
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeDateAtDateSeletor:) name:@"kDateSeletor_notify_ScheduleVC" object:nil];
}
//通知，更改日期
-(void)changeDateAtDateSeletor:(NSNotification *)notify{
    NSDictionary *dic = notify.userInfo;
    NSDate *choosedDate = dic[@"date"];
    [self refreshToCurrentMonthToDate:choosedDate];
    
    NSNumber *day = dic[@"day"];
    NSNumber *firstWeekDay = dic[@"firstWeekDay"];
    
    [self collectionView:self.collectionViewMid didSelectItemAtIndexPath:[NSIndexPath indexPathForItem:([firstWeekDay integerValue] + [day integerValue] - 1) inSection:0]];

}
//配置scrollView
-(void)setUpScrollView{
    self.scrollView.delegate = self;
}
//配置collectionView
-(void)setUpCollectionView{
    self.collectionViewLeft.delegate = self;
    self.collectionViewLeft.dataSource = self;
    self.collectionViewMid.delegate = self;
    self.collectionViewMid.dataSource = self;
    self.collectionViewRight.delegate = self;
    self.collectionViewRight.dataSource = self;
    //注册cell
    [self.collectionViewLeft registerNib:[UINib nibWithNibName:NSStringFromClass([CalecdarCell class]) bundle:nil] forCellWithReuseIdentifier:identifierCell];
    [self.collectionViewMid registerNib:[UINib nibWithNibName:NSStringFromClass([CalecdarCell class]) bundle:nil] forCellWithReuseIdentifier:identifierCell];
    [self.collectionViewRight registerNib:[UINib nibWithNibName:NSStringFromClass([CalecdarCell class]) bundle:nil] forCellWithReuseIdentifier:identifierCell];
}
#pragma mark -<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout
//item的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(KScreenWidth/7, KScreenWidth/7 * 6/7);
}
//配置item的边距
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(0, 0, 0, 0);
}
//最小行间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 0;
}
//最小列间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 0;
}
//组数
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
//行数
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 6 * 7;
}
//行内容
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    CalecdarCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifierCell forIndexPath:indexPath];
    if (collectionView == _collectionViewLeft) {
        GFCalendarMonth *monthInfo = self.monthArray[0];
        NSInteger firstWeekday = monthInfo.firstWeekday;
        NSInteger totalDays = monthInfo.totalDays;
        
        // 当前月
        if (indexPath.row >= firstWeekday && indexPath.row < firstWeekday + totalDays) {
            cell.todayLabel.text = [NSString stringWithFormat:@"%ld", indexPath.row - firstWeekday + 1];
            cell.todayLabel.textColor = [UIColor darkTextColor];
            
            // 标识今天
            if ((monthInfo.month == [[NSDate date] dateMonth]) && (monthInfo.year == [[NSDate date] dateYear])) {
                if (indexPath.row == [[NSDate date] dateDay] + firstWeekday - 1) {
                    cell.todayCircle.backgroundColor = KRGB(99, 218, 247, 1);
                    cell.todayLabel.textColor = [UIColor whiteColor];
                } else {
                    cell.todayCircle.backgroundColor = [UIColor clearColor];
                }
            } else {
                cell.todayCircle.backgroundColor = [UIColor clearColor];
            }
        }
        // 补上前后月的日期，淡色显示
        else if (indexPath.row < firstWeekday) {
            int totalDaysOflastMonth = [self.monthArray[3] intValue];
            cell.todayLabel.text = [NSString stringWithFormat:@"%ld", totalDaysOflastMonth - (firstWeekday - indexPath.row) + 1];
            cell.todayLabel.textColor = [UIColor colorWithWhite:0.85 alpha:1.0];
            cell.todayCircle.backgroundColor = [UIColor clearColor];
        } else if (indexPath.row >= firstWeekday + totalDays) {
            cell.todayLabel.text = [NSString stringWithFormat:@"%ld", indexPath.row - firstWeekday - totalDays + 1];
            cell.todayLabel.textColor = [UIColor colorWithWhite:0.85 alpha:1.0];
            cell.todayCircle.backgroundColor = [UIColor clearColor];
        }
        
        cell.userInteractionEnabled = NO;
        
    }
    else if (collectionView == _collectionViewMid) {
        
        GFCalendarMonth *monthInfo = self.monthArray[1];
        NSInteger firstWeekday = monthInfo.firstWeekday;
        NSInteger totalDays = monthInfo.totalDays;
        
        // 当前月
        if (indexPath.row >= firstWeekday && indexPath.row < firstWeekday + totalDays) {
            cell.todayLabel.text = [NSString stringWithFormat:@"%ld", indexPath.row - firstWeekday + 1];
            cell.todayLabel.textColor = [UIColor darkTextColor];
            cell.userInteractionEnabled = YES;
            
            // 标识今天
            cell.todayCircle.backgroundColor = [UIColor clearColor];
            
            if ((indexPath.row == [[NSDate date] dateDay] + firstWeekday - 1) &&(monthInfo.month == [[NSDate date] dateMonth]) && (monthInfo.year == [[NSDate date] dateYear])) {
                cell.todayCircle.backgroundColor = KRGB(52, 168, 238, 1);
                cell.todayLabel.textColor = [UIColor whiteColor];
                cell.todayLabel.text = @"今";
            }else{
                
            }
        }
        // 补上前后月的日期，淡色显示
        else if (indexPath.row < firstWeekday) {
            GFCalendarMonth *lastMonthInfo = self.monthArray[0];
            NSInteger totalDaysOflastMonth = lastMonthInfo.totalDays;
            cell.todayLabel.text = [NSString stringWithFormat:@"%ld", totalDaysOflastMonth - (firstWeekday - indexPath.row) + 1];
            cell.todayLabel.textColor = [UIColor colorWithWhite:0.85 alpha:1.0];
            cell.todayCircle.backgroundColor = [UIColor clearColor];
            cell.userInteractionEnabled = NO;
        } else if (indexPath.row >= firstWeekday + totalDays) {
            cell.todayLabel.text = [NSString stringWithFormat:@"%ld", indexPath.row - firstWeekday - totalDays + 1];
            cell.todayLabel.textColor = [UIColor colorWithWhite:0.85 alpha:1.0];
            cell.todayCircle.backgroundColor = [UIColor clearColor];
            cell.userInteractionEnabled = NO;
        }
        //边框
        cell.todayCircle.layer.borderColor = [KRGB(23, 204, 14, 1.0) CGColor];
        if ([self.seleteDayArr[indexPath.row] isEqualToString:@"0"]) {//未选中
            cell.todayCircle.layer.borderWidth = 0;
        }else if ([self.seleteDayArr[indexPath.row] isEqualToString:@"1"]) {//选中
            cell.todayCircle.layer.borderWidth = 1.5;
        }
    }
    else if (collectionView == _collectionViewRight) {
        
        GFCalendarMonth *monthInfo = self.monthArray[2];
        NSInteger firstWeekday = monthInfo.firstWeekday;
        NSInteger totalDays = monthInfo.totalDays;
        
        // 当前月
        if (indexPath.row >= firstWeekday && indexPath.row < firstWeekday + totalDays) {
            
            cell.todayLabel.text = [NSString stringWithFormat:@"%ld", indexPath.row - firstWeekday + 1];
            cell.todayLabel.textColor = [UIColor darkTextColor];
                        
            // 标识今天
            if ((monthInfo.month == [[NSDate date] dateMonth]) && (monthInfo.year == [[NSDate date] dateYear])) {
                if (indexPath.row == [[NSDate date] dateDay] + firstWeekday - 1) {
                    cell.todayCircle.backgroundColor = KRGB(99, 218, 247, 1);
                    cell.todayLabel.textColor = [UIColor whiteColor];
                } else {
                    cell.todayCircle.backgroundColor = [UIColor clearColor];
                }
            } else {
                cell.todayCircle.backgroundColor = [UIColor clearColor];
            }
            
        }
        // 补上前后月的日期，淡色显示
        else if (indexPath.row < firstWeekday) {
            GFCalendarMonth *lastMonthInfo = self.monthArray[1];
            NSInteger totalDaysOflastMonth = lastMonthInfo.totalDays;
            cell.todayLabel.text = [NSString stringWithFormat:@"%ld", totalDaysOflastMonth - (firstWeekday - indexPath.row) + 1];
            cell.todayLabel.textColor = [UIColor colorWithWhite:0.85 alpha:1.0];
            cell.todayCircle.backgroundColor = [UIColor clearColor];
        } else if (indexPath.row >= firstWeekday + totalDays) {
            cell.todayLabel.text = [NSString stringWithFormat:@"%ld", indexPath.row - firstWeekday - totalDays + 1];
            cell.todayLabel.textColor = [UIColor colorWithWhite:0.85 alpha:1.0];
            cell.todayCircle.backgroundColor = [UIColor clearColor];
        }
        
        cell.userInteractionEnabled = NO;
    }
    return cell;
}
//点击item
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:(NSCalendarUnitYear | NSCalendarUnitMonth) fromDate:_currentMonthDate];
    NSDate *currentDate = [calendar dateFromComponents:components];
    
//    CalecdarCell *cell = (CalecdarCell *)[collectionView cellForItemAtIndexPath:indexPath];
    NSInteger firstWeekday = [currentDate firstWeekDayInMonth];
    NSInteger year = [currentDate dateYear];
    NSInteger month = [currentDate dateMonth];
    NSInteger day = indexPath.row - firstWeekday;
    
        
    if (self.didSelectDayHandler != nil) {        
        self.didSelectDayHandler(year, month, day); // 执行回调
    }
    
    //更新顶部日期
    NSMutableDictionary *userInfo = [NSMutableDictionary dictionaryWithCapacity:4];
    [userInfo setObject:[[NSNumber alloc] initWithInteger:year] forKey:@"year"];
    [userInfo setObject:[[NSNumber alloc] initWithInteger:month] forKey:@"month"];
    [userInfo setObject:[[NSNumber alloc] initWithInteger:day] forKey:@"day"];
    [userInfo setObject:[[NSNumber alloc] initWithInteger:firstWeekday] forKey:@"firstWeekDay"];
    
    NSNotification *notify = [[NSNotification alloc] initWithName:@"ChangeCalendarHeaderNotification" object:nil userInfo:userInfo];
    [[NSNotificationCenter defaultCenter] postNotification:notify];
    
    // 标识今天
    self.seleteDayArr = nil;
    [self.seleteDayArr replaceObjectAtIndex:indexPath.row withObject:@"1"];
    [_collectionViewMid reloadData]; 
    
    //今天按钮的漂移
    NSString *dateStr = [NSString stringWithFormat:@"%ld-%ld-%ld",(long)year,(long)month,(long)day + 1];
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-M-d"];
    NSDate *date = [formatter dateFromString:dateStr];
    GFCalendarMonth *monthInfo = self.monthArray[1];
    if ((indexPath.row == [[NSDate date] dateDay] + firstWeekday - 1) &&(monthInfo.month == [[NSDate date] dateMonth]) && (monthInfo.year == [[NSDate date] dateYear])) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"todayBtn" object:self userInfo:@{@"dir":@"cell_top_cell",@"currentDate":date}];
    }else{
        [[NSNotificationCenter defaultCenter] postNotificationName:@"todayBtn" object:self userInfo:@{@"dir":@"cell_top",@"currentDate":date}];
    }
}



#pragma mark -
- (NSNumber *)previousMonthDaysForPreviousDate:(NSDate *)date {
    return [[NSNumber alloc] initWithInteger:[[date previousMonthDate] totalDaysInMonth]];
}
// 发通知，更改当前月份标题
- (void)notifyToChangeCalendarHeader {
    //默认选中每个月的今天
    GFCalendarMonth *monthInfo = self.monthArray[1];
    NSInteger firstWeekday = monthInfo.firstWeekday;
    NSInteger row = [[NSDate date] dateDay] + firstWeekday - 1;
    [self collectionView:self.collectionViewMid didSelectItemAtIndexPath:[NSIndexPath indexPathForItem:row inSection:0]];
}
//跳转到指定的日期
- (void)refreshToCurrentMonthToDate:(NSDate *)youChoosedDate {
    _currentMonthDate = youChoosedDate;
    
    NSDate *previousMonthDate = [_currentMonthDate previousMonthDate];
    NSDate *nextMonthDate = [_currentMonthDate nextMonthDate];
    
    [self.monthArray removeAllObjects];
    [self.monthArray addObject:[[GFCalendarMonth alloc] initWithDate:previousMonthDate]];
    [self.monthArray addObject:[[GFCalendarMonth alloc] initWithDate:_currentMonthDate]];
    [self.monthArray addObject:[[GFCalendarMonth alloc] initWithDate:nextMonthDate]];
    [self.monthArray addObject:[self previousMonthDaysForPreviousDate:previousMonthDate]];
    
    // 刷新数据
    [_collectionViewMid reloadData];
    [_collectionViewLeft reloadData];
    [_collectionViewRight reloadData];
    
}
#pragma mark - UIScrollViewDelegate
//点击按钮自动滑动
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView{
    
}
//手动左右滑动
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
    if (scrollView != self.scrollView) {
        return;
    }else{
        // 向右滑动
        if (scrollView.contentOffset.x < self.bounds.size.width) {
            
            _currentMonthDate = [_currentMonthDate previousMonthDate];
            NSDate *previousDate = [_currentMonthDate previousMonthDate];
            
            // 数组中最左边的月份现在作为中间的月份，中间的作为右边的月份，新的左边的需要重新获取
            GFCalendarMonth *currentMothInfo = self.monthArray[0];
            GFCalendarMonth *nextMonthInfo = self.monthArray[1];
            
            
            GFCalendarMonth *olderNextMonthInfo = self.monthArray[2];
            
            // 复用 GFCalendarMonth 对象
            olderNextMonthInfo.totalDays = [previousDate totalDaysInMonth];
            olderNextMonthInfo.firstWeekday = [previousDate firstWeekDayInMonth];
            olderNextMonthInfo.year = [previousDate dateYear];
            olderNextMonthInfo.month = [previousDate dateMonth];
            GFCalendarMonth *previousMonthInfo = olderNextMonthInfo;
            
            NSNumber *prePreviousMonthDays = [self previousMonthDaysForPreviousDate:[_currentMonthDate previousMonthDate]];
            
            [self.monthArray removeAllObjects];
            [self.monthArray addObject:previousMonthInfo];
            [self.monthArray addObject:currentMothInfo];
            [self.monthArray addObject:nextMonthInfo];
            [self.monthArray addObject:prePreviousMonthDays];
            
        }
        // 向左滑动
        else if (scrollView.contentOffset.x > self.bounds.size.width) {
            
            _currentMonthDate = [_currentMonthDate nextMonthDate];
            NSDate *nextDate = [_currentMonthDate nextMonthDate];
            
            // 数组中最右边的月份现在作为中间的月份，中间的作为左边的月份，新的右边的需要重新获取
            GFCalendarMonth *previousMonthInfo = self.monthArray[1];
            GFCalendarMonth *currentMothInfo = self.monthArray[2];
            
            
            GFCalendarMonth *olderPreviousMonthInfo = self.monthArray[0];
            
            NSNumber *prePreviousMonthDays = [[NSNumber alloc] initWithInteger:olderPreviousMonthInfo.totalDays]; // 先保存 olderPreviousMonthInfo 的月天数
            
            // 复用 GFCalendarMonth 对象
            olderPreviousMonthInfo.totalDays = [nextDate totalDaysInMonth];
            olderPreviousMonthInfo.firstWeekday = [nextDate firstWeekDayInMonth];
            olderPreviousMonthInfo.year = [nextDate dateYear];
            olderPreviousMonthInfo.month = [nextDate dateMonth];
            GFCalendarMonth *nextMonthInfo = olderPreviousMonthInfo;
            
            
            [self.monthArray removeAllObjects];
            [self.monthArray addObject:previousMonthInfo];
            [self.monthArray addObject:currentMothInfo];
            [self.monthArray addObject:nextMonthInfo];
            [self.monthArray addObject:prePreviousMonthDays];
            
        }
        
        self.seleteDayArr = nil;//重置选中状态
        [_collectionViewMid reloadData]; // 中间的 collectionView 先刷新数据
        [scrollView setContentOffset:CGPointMake(self.bounds.size.width, 0.0) animated:NO]; // 然后变换位置
        [_collectionViewLeft reloadData]; // 最后两边的 collectionView 也刷新数据
        [_collectionViewRight reloadData];
        
        // 发通知，更改当前月份标题
        [self notifyToChangeCalendarHeader];
    }    
}




- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

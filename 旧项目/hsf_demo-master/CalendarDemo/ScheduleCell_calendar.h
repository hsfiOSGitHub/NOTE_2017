//
//  ScheduleCell_calendar.h
//  CalendarDemo
//
//  Created by monkey2016 on 16/12/22.
//  Copyright © 2016年 monkey2016. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^DidSelectDayHandler)(NSInteger, NSInteger, NSInteger);

@interface ScheduleCell_calendar : UITableViewCell<UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UICollectionViewDelegate,UIScrollViewDelegate>


@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionViewLeft;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionViewMid;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionViewRight;


//>>>>>>>>>>>>>>>

@property (nonatomic, strong) NSDate *currentMonthDate;
@property (nonatomic, strong) NSMutableArray *monthArray;
@property (nonatomic, copy) DidSelectDayHandler didSelectDayHandler; // 日期点击回调
@property (nonatomic,assign) BOOL notToday;
@property (nonatomic,strong) NSMutableArray *seleteDayArr;
@property (nonatomic,assign) NSInteger currentSeleteMonth;
@property (nonatomic,assign) NSInteger currentSeleteYear;

//通知，更改日期
-(void)changeDateAtDateSeletor:(NSNotification *)notify;
//跳转到指定的日期
- (void)refreshToCurrentMonthToDate:(NSDate *)youChoosedDate; // 刷新 calendar 回到当前日期月份
//点击item
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath;


@end

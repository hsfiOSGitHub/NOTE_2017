//
//  SeCalendarTableViewCell.h
//  yuntangyi
//
//  Created by yuntangyi on 16/8/31.
//  Copyright © 2016年 yuntangyi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FyCalendarView.h"

@interface SeCalendarTableViewCell : UITableViewCell
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) FyCalendarView *rili;
@property (nonatomic, strong) NSDate *xindate;
@property(nonatomic)BOOL en;
@property(nonatomic, strong)SechedulingVC *ZXS;
@property (nonatomic, strong)UISwipeGestureRecognizer *leftSwipeGestureRecognizer;
@property (nonatomic, strong)UISwipeGestureRecognizer *rightSwipeGestureRecognizer;
-(void)xinrilishuaxin;
-(void)shezhixinrili;
@end

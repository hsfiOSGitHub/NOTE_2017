//
//  PACalendarTableViewCell.h
//  yuntangyi
//
//  Created by yuntangyi on 16/8/31.
//  Copyright © 2016年 yuntangyi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FyCalendarView.h"

@interface PACalendarTableViewCell : UITableViewCell
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) FyCalendarView *rili;
@property (nonatomic, strong) NSDate *xindate;
@property(nonatomic)BOOL en;
@property (nonatomic, strong)PA_inviteSetViewController *ZXP;
@property (nonatomic, strong)UISwipeGestureRecognizer *leftSwipeGestureRecognizer;
@property (nonatomic, strong)UISwipeGestureRecognizer *rightSwipeGestureRecognizer;
-(void)xinrilishuaxin;
-(void)shezhixinrili;
@end

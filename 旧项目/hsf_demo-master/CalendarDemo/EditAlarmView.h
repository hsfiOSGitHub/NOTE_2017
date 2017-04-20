//
//  EditAlarmView.h
//  CalendarDemo
//
//  Created by monkey2016 on 16/12/28.
//  Copyright © 2016年 monkey2016. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EditAlarmView : UIView
@property (weak, nonatomic) IBOutlet UIButton *maskBtn_alarm;

@property (weak, nonatomic) IBOutlet UIView *bgView;

//展示
-(void)show;

@end

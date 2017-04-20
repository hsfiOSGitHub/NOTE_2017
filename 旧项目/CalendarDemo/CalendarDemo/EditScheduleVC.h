//
//  EditScheduleVC.h
//  CalendarDemo
//
//  Created by monkey2016 on 16/12/27.
//  Copyright © 2016年 monkey2016. All rights reserved.
//

#import "HSFBaseVC.h"

@class ScheduleModel;


@protocol EditScheduleVCDelegate <NSObject>

@optional

-(void)saveToUpdateUI;

@end

@interface EditScheduleVC : HSFBaseVC

@property (nonatomic,strong) NSString *pushOrMode;//转场方式
@property (nonatomic,strong) NSDictionary *condition;//查询条件

//数据源
@property (nonatomic,strong) ScheduleModel *model;

@property (nonatomic,assign) id<EditScheduleVCDelegate>delegate;

@end

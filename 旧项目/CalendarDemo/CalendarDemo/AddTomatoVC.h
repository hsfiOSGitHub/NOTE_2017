//
//  AddTomatoVC.h
//  CalendarDemo
//
//  Created by monkey2016 on 17/1/9.
//  Copyright © 2017年 monkey2016. All rights reserved.
//

#import "HSFBaseVC.h"

@class TaskModel;

@interface AddTomatoVC : HSFBaseVC

//数据源
@property (nonatomic,strong) TaskModel *model;

@property (nonatomic,strong) NSString *addOrEdit;


@end

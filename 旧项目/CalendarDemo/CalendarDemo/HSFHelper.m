
//
//  HSFHelper.m
//  CalendarDemo
//
//  Created by monkey2016 on 16/12/26.
//  Copyright © 2016年 monkey2016. All rights reserved.
//

#import "HSFHelper.h"

static HSFHelper *helper;
@implementation HSFHelper

//单例的初始化方法
+(instancetype)sharedHelper{
    if (!helper) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            helper = [[HSFHelper alloc]init];
        });
    }
    return helper;
}



@end

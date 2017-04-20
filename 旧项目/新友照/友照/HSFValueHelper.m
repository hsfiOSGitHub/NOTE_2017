//
//  HSFValueHelper.m
//  友照
//
//  Created by monkey2016 on 16/12/16.
//  Copyright © 2016年 ZX_XPH. All rights reserved.
//

#import "HSFValueHelper.h"

static HSFValueHelper  *helper;
@implementation HSFValueHelper

//单例的创建
+(instancetype)sharedHelper{
    if (!helper) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            helper = [[HSFValueHelper alloc]init];
        });
    }
    return helper;
}

@end

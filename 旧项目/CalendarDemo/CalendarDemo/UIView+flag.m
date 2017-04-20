//
//  UIView+flag.m
//  CalendarDemo
//
//  Created by monkey2016 on 16/12/28.
//  Copyright © 2016年 monkey2016. All rights reserved.
//

#import "UIView+flag.h"
#import <objc/runtime.h>  


const char kFlag;//声明一个唯一地址的key。或用static char kFlag; 
@implementation UIView (flag)

@dynamic flagStr;//运行时动态获取   

-(void)setFlagStr:(NSString *)flagStr{
    objc_setAssociatedObject(self, &kFlag, flagStr, OBJC_ASSOCIATION_COPY_NONATOMIC);
}
-(NSString *)flagStr{
    return objc_getAssociatedObject(self, &kFlag);
}

@end

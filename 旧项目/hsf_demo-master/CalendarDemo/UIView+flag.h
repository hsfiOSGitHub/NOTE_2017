//
//  UIView+flag.h
//  CalendarDemo
//
//  Created by monkey2016 on 16/12/28.
//  Copyright © 2016年 monkey2016. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <objc/runtime.h> 

@interface UIView (flag)
@property (nonatomic,strong) NSString *flagStr;

-(void)setFlagStr:(NSString *)flagStr;
-(NSString *)flagStr;

@end

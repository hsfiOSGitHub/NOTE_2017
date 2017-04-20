//
//  PNPieChartDataItem.m
//  PNChartDemo
//
//  Created by Hang Zhang on 14-5-5.
//  Copyright (c) 2014年 kevinzhow. All rights reserved.
//

#import "SCPieChartDataItem.h"
#import <UIKit/UIKit.h>

@implementation SCPieChartDataItem


+ (instancetype)dataItemWithValue:(CGFloat)value
                            color:(UIColor*)color{
	SCPieChartDataItem *item = [SCPieChartDataItem new];
	item.value = value;
	item.color  = color;
	return item;
}

+ (instancetype)dataItemWithValue:(CGFloat)value
                            color:(UIColor*)color
                      description:(NSString *)description {
	SCPieChartDataItem *item = [SCPieChartDataItem dataItemWithValue:value color:color];
	item.textDescription = description;
	return item;
}

- (void)setValue:(CGFloat)value{
    NSAssert(value >= 0, @"value should >= 0");
    if (value != _value){
        _value = value;
    }
}

@end

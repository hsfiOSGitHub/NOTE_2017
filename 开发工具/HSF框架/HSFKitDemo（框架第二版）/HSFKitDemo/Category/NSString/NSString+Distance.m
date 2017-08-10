//
//  NSString+Distance.m
//  PSD
//
//  Created by JuZhenBaoiMac on 2017/6/3.
//  Copyright © 2017年 JuZhenBaoiMac. All rights reserved.
//

#import "NSString+Distance.h"

@implementation NSString (Distance)

+(NSString *)distanceStringWithString:(NSString *)string{
    double distance = [string doubleValue];
    NSString *distance_str = @"";
    if (distance < 1000) {
        distance_str = [NSString stringWithFormat:@"%@ 米",string];//米
    }else if (distance > 1000) {
        double z = distance/1000;
        distance_str = [NSString stringWithFormat:@"%.2f 公里",z];//千米
    }
    return distance_str;
}

@end

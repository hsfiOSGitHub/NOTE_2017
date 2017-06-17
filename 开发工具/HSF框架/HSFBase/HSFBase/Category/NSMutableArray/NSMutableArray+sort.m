//
//  NSMutableArray+sort.m
//  SuperCar
//
//  Created by JuZhenBaoiMac on 2017/5/19.
//  Copyright © 2017年 JuZhenBaoiMac. All rights reserved.
//

#import "NSMutableArray+sort.h"

@implementation NSMutableArray (sort)

//数组逆序
- (NSMutableArray *)exchangeArray{
    NSInteger num = self.count;
    NSMutableArray *temp = [[NSMutableArray alloc] init];
    for (NSInteger i = num - 1; i >= 0; i --) {
        [temp addObject:[self objectAtIndex:i]];
    }
    return temp;
}

@end

//
//  NSMutableArray+sort.m
//  SuperCar
//
//  Created by JuZhenBaoiMac on 2017/5/19.
//  Copyright © 2017年 JuZhenBaoiMac. All rights reserved.
//

#import "NSMutableArray+sort.h"

@implementation NSMutableArray (sort)

- (NSMutableArray * _Nonnull)reversedArray {
    return (NSMutableArray *)[[self class] reversedArray:self];
}

+ (NSArray * _Nonnull)reversedArray:(NSArray * _Nonnull)array {
    NSMutableArray *arrayTemp = [NSMutableArray arrayWithCapacity:[array count]];
    NSEnumerator *enumerator = [array reverseObjectEnumerator];
    
    for (id element in enumerator) [arrayTemp addObject:element];
    
    return arrayTemp;
}

+ (NSMutableArray * _Nonnull)sortArrayByKey:(NSString * _Nonnull)key array:(NSMutableArray * _Nonnull)array ascending:(BOOL)ascending {
    NSMutableArray *tempArray = [[NSMutableArray alloc] init];
    [tempArray removeAllObjects];
    [tempArray addObjectsFromArray:array];
    
    NSSortDescriptor *descriptor = [[NSSortDescriptor alloc] initWithKey:key ascending:ascending];
    NSArray *sortedArray = [tempArray sortedArrayUsingDescriptors:@[descriptor]];
    
    [tempArray removeAllObjects];
    tempArray = (NSMutableArray *)sortedArray;
    
    [array removeAllObjects];
    [array addObjectsFromArray:tempArray];
    
    return array;
}
@end

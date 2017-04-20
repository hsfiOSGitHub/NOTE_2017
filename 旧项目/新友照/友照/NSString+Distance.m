//
//  NSString+Distance.m
//  友照
//
//  Created by monkey2016 on 16/12/5.
//  Copyright © 2016年 ZX_XPH. All rights reserved.
//

#import "NSString+Distance.h"

@implementation NSString (Distance)
+(NSString *)distanceStringWithString:(NSString *)string{
    if ([string doubleValue] < 1000) {
        return [NSString stringWithFormat:@"距您：%.0fm",[string doubleValue]];
    }
    return [NSString stringWithFormat:@"距您：%.2fkm",[string doubleValue]/1000];
}
@end

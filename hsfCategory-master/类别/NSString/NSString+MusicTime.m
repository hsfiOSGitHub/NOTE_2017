//
//  NSString+MusicTime.m
//  News
//
//  Created by monkey2016 on 16/10/26.
//  Copyright © 2016年 monkey2016. All rights reserved.
//

#import "NSString+MusicTime.h"

@implementation NSString (MusicTime)
+(NSString *)musicTimeWith:(NSTimeInterval)timeInterval{
    NSString *musicTime;
    if (timeInterval < 60) {
        musicTime = [NSString stringWithFormat:@"00:%02d",(int)timeInterval];
    }else if (timeInterval >= 60) {
        musicTime = [NSString stringWithFormat:@"%02d:%02d",(int)timeInterval/60,(int)timeInterval%60];
    }
    return musicTime;
}
@end

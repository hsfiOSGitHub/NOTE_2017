//
//  NSString+TimeString.h
//  yuntangyi
//
//  Created by yuntangyi on 16/10/17.
//  Copyright © 2016年 yuntangyi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (TimeString)
/*处理返回应该显示的时间*/
+ (NSString *) returnUploadTime:(NSString*)timeStr;
@end

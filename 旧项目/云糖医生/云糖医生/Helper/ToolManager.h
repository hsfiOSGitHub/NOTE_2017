//
//  ToolManager.h
//  yuntangyi
//
//  Created by yuntangyi on 16/8/29.
//  Copyright © 2016年 yuntangyi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ToolManager : NSObject
//KnowledgeVC
@property (nonatomic,assign) NSInteger titleBtnTag;//标题btn的tag值

//获得当前的时间戳
+ (NSString *)getCurrentTimeStamp;
//MD5加密
+ (NSString *)secureMD5WithString:(NSString *)string;
//获取版本号
+ (NSString *)getVersion;
//获取当前日期
+ (NSString *)getCurrentDate;


+(instancetype)sharedManager;

@end

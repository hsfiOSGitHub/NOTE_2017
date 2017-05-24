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




//点击退出当前账号
-(void)logoutACTIONFromSuperVC:(UIViewController *)superVC;

//判断手机型号
- (NSString *)iphoneType;


/**
 *  获取当前时间
 *
 *  @return 当前时间
 */
- (NSString *)getCurrentTime;

/**
 *  数组逆序
 *
 *  @param array 需要逆序的数组
 *
 *  @return 逆序后的输出
 */
- (NSMutableArray *)exchangeArray:(NSMutableArray *)array;


+(instancetype)sharedManager;

@end

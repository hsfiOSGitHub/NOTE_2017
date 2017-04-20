//
//  MyMeetingSignUpInfoModel.h
//  yuntangyi
//
//  Created by yuntangyi on 16/9/30.
//  Copyright © 2016年 yuntangyi. All rights reserved.
//

#import <Foundation/Foundation.h>
/*
 返回值说明
 {
 "res": "1001",
 "msg": "请求成功",
 "resault": {
             "meeting_sn": "",
             "status": "已签到",
             "meeting_start_time": "2016-10-25 14:00:33",
             "meeting_end_time": "2016-10-25 18:00:40",
             "actor": " 控糖卫士 ",
             "address": "（广东深圳）深圳会展中心9号馆",
             "meeting_name": "2016中国糖尿病移动医疗高峰论坛"
             }
 }
 {"res":"1002","msg":"登录状态已过期"}
 {"res":"1004","msg":"重复请求"}
 {"res":"1005","msg":"缺少参数"}
 {"res":"1006","msg":"没有操作权限"}
 {"res":"1007","msg":"会议信息有误"}
 {"res":"1008","msg":"您未报名该会议"}
 */
@interface MyMeetingSignUpInfoModel : NSObject
@property (nonatomic,strong) NSString *meeting_sn;
@property (nonatomic,strong) NSString *status;
@property (nonatomic,strong) NSString *meeting_start_time;
@property (nonatomic,strong) NSString *meeting_end_time;
@property (nonatomic,strong) NSString *actor;
@property (nonatomic,strong) NSString *address;
@property (nonatomic,strong) NSString *meeting_name;

//初始化方法
-(instancetype)initWithDict:(NSDictionary *)dict;
+(instancetype)modelWithDict:(NSDictionary *)dict;
@end

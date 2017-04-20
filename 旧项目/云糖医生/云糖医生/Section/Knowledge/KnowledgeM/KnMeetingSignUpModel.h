//
//  KnMeetingSignUpModel.h
//  yuntangyi
//
//  Created by yuntangyi on 16/9/14.
//  Copyright © 2016年 yuntangyi. All rights reserved.
//

#import <Foundation/Foundation.h>
/*
 返回值说明
 {
     "res": "1001",
     "msg": "请求成功",
     "resault": {
         "id": "1",//2,3,4,8,9,11,12,13
         "meeting_start_time": "2016-09-13 20:16:16",
         "actor": "小明",//演讲人
         "meeting_name": "哈哈哈",
         "meeting_sn": "201609281418453888",
         "address": "河南洛阳",
         "words":"报名成功"
         }
 }
 {"res":"1002","msg":"登录状态已过期"}
 {"res":"1004","msg":"重复请求"}
 {"res":"1005","msg":"缺少参数"}
 {"res":"1006","msg":"没有操作权限"}
 {"res":"1007","msg":"会议信息有误"}
 {"res":"1008","msg":"暂不可报名"}
 {"res":"1009","msg":"请勿重复报名"}
 {"res":"10010","msg":"报名失败"}

 */
@interface KnMeetingSignUpModel : NSObject
@property (nonatomic,strong) NSString *signUp_id;
@property (nonatomic,strong) NSString *meeting_start_time;
@property (nonatomic,strong) NSString *actor;
@property (nonatomic,strong) NSString *meeting_name;
@property (nonatomic,strong) NSString *meeting_sn;
@property (nonatomic,strong) NSString *address;
@property (nonatomic,strong) NSString *words;

-(instancetype)initWithDict:(NSDictionary *)dict;
+(instancetype)modelWithDict:(NSDictionary *)dict;

@end

//
//  KnMeetingInfoModel.h
//  yuntangyi
//
//  Created by yuntangyi on 16/9/14.
//  Copyright © 2016年 yuntangyi. All rights reserved.
//

#import <Foundation/Foundation.h>
/*
 返回值说明
 会议内容按web形式显示
 {
     "res": "1001",
     "msg": "请求成功",
     "resault": {
                 "mid": "13",
                 "meeting_name": "会议名称",
                 "start_time": "2016-09-13 20:16:16",
                 "pic": "",
                 "content_url": "http://192.168.20.8/api/doctor/index.php?m=meeting_conent&id=8",
                 "address": "河南洛阳",
                 "actor": "小明",
                 "entered_num": "1,//已报名人数
                 "surplus_num": "199",//剩余人数
                 "note: "报名须知",
                 "status": 1, //可以报名，0为可报名 1为不可报名
                 "is_exist": 0//是否有报名0没有1有
                 }
 }
 {"res":"1002","msg":"登录状态已过期"}
 {"res":"1004","msg":"重复请求"}
 {"res":"1005","msg":"缺少参数"}
 {"res":"1006","msg":"没有操作权限"}
 {"res":"1007","msg":"会议信息有误"}

 */
@interface KnMeetingInfoModel : NSObject
@property (nonatomic,strong) NSString *mid;
@property (nonatomic,strong) NSString *meeting_name;
@property (nonatomic,strong) NSString *start_time;
@property (nonatomic,strong) NSString *pic;
@property (nonatomic,strong) NSString *content_url;
@property (nonatomic,strong) NSString *address;
@property (nonatomic,strong) NSString *actor;
@property (nonatomic,strong) NSString *entered_num;
@property (nonatomic,strong) NSNumber *surplus_num;
@property (nonatomic,strong) NSString *note;
@property (nonatomic,strong) NSNumber *status;
@property (nonatomic,strong) NSNumber *is_exist;

-(instancetype)initWithDict:(NSDictionary *)dict;
+(instancetype)modelWithDict:(NSDictionary *)dict;

@end

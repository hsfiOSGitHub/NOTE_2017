//
//  KnMeetingListModel.h
//  yuntangyi
//
//  Created by yuntangyi on 16/9/14.
//  Copyright © 2016年 yuntangyi. All rights reserved.
//

#import <Foundation/Foundation.h>
/*
 返回值说明
 status为是否可报名字段，会议开始前一个小时可报名为0，不可报名为1
 is_do为签到方式，如果为空为未报名，0是报名了未签到，1是签到
 dotype为报名方式 如果为空是未报名，0是主动报名1是后台邀请
 {
 "res": "1001",
 "msg": "请求成功",
 "list": [
             {
             "id": "13",
             "meeting_name": "会议名称",
             "start_time": "2016-09-13",
             "pic": "",
             "content": "讲核心的内容",
             "tags_list": [
                             "明白的好",
                             "大家很好啊"
                            ],
             "is_do": 0,//是否签到，空串为未参加，0是未签到，1签到
             "dotype": 1,//报名方式 空为未报名，0是主动报名，1是后台邀请
             "status": 0
             },
 }
 {"res":"1002","msg":"登录状态已过期"}
 {"res":"1004","msg":"重复请求"}
 {"res":"1005","msg":"缺少参数"}
 {"res":"1006","msg":"医生不存在"}
 {"res":"1007","msg":"没有操作权限"}
 */
@interface KnMeetingListModel : NSObject

@property (nonatomic,strong) NSString *knID;
@property (nonatomic,strong) NSString *meeting_name;
@property (nonatomic,strong) NSString *start_time;
@property (nonatomic,strong) NSString *pic;
@property (nonatomic,strong) NSString *content;
@property (nonatomic,strong) NSArray *tags_list;
@property (nonatomic,strong) NSString *is_do;
@property (nonatomic,strong) NSString *dotype;
@property (nonatomic,strong) NSString *status;

-(instancetype)initWithDict:(NSDictionary *)dict;
+(instancetype)modelWithDict:(NSDictionary *)dict;

@end

//
//  MiMyMeetingListModel.h
//  yuntangyi
//
//  Created by yuntangyi on 16/9/18.
//  Copyright © 2016年 yuntangyi. All rights reserved.
//

#import <Foundation/Foundation.h>
/*
 返回值说明
 res":"1001",
 "msg":"请求成功",
 "list":[
     {
     "mid":"74",
     "meeting_name":"2016iworld数字世界博览会--移动健康数字医疗论坛",
     "start_time":"2016-11-18",
     "pic":"http://app.yuntangyi.com/attachment/meeting/thumb/14751286853200.jpg",
     "content":"",
     "tags_list":[
     
     ],
     "is_do":"0",
     "dotype":"0",
     "status":0
     },
 {"res":"1002","msg":"登录状态已过期"}
 {"res":"1004","msg":"重复请求"}
 {"res":"1005","msg":"缺少必须参数"}
 {"res":"1006","msg":"医生不存在"}
 {"res":"1006","msg":"没有操作权限"}

 */
@interface MiMyMeetingListModel : NSObject
@property (nonatomic,strong) NSString *ID;
@property (nonatomic,strong) NSString *meeting_name;
@property (nonatomic,strong) NSString *start_time;
@property (nonatomic,strong) NSString *pic;
@property (nonatomic,strong) NSString *content;
@property (nonatomic,strong) NSArray *tags_list;
@property (nonatomic,strong) NSString *is_do;
@property (nonatomic,strong) NSString *dotype;
@property (nonatomic,strong) NSString *status;

//初始化方法
-(instancetype)initWithDict:(NSDictionary *)dict;
+(instancetype)modelWithDict:(NSDictionary *)dict;

@end

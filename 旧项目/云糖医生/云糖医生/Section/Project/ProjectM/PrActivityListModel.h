//
//  PrActivityListModel.h
//  yuntangyi
//
//  Created by yuntangyi on 16/9/18.
//  Copyright © 2016年 yuntangyi. All rights reserved.
//

#import <Foundation/Foundation.h>
/*
 返回值说明
 join_status如果是1的时候可以打开项目详情（用到项目详情接口），如果是0就直接打开activity_url的地址
 {
 "res": "1001",
 "msg": "请求成功",
 "list": [
             {
             "activity_id": "3",
             "title": "最近要送药啦！哈哈",
             "pic": "",
             "type_name": "送水",
             "content": "这个是送药的哟",
             "activity_url": "http://www.baidu.com",
             "join_num": "1",
             "join_status":1//是否可以发送给患者，默认0不能，1能
             },
             {
             "activity_id": "2",
             "title": "大家都要好好的啊。",
             "pic": "http://localhost:8089/attachment/activity/thumb/20160907104453-ZytsCSS1WB.png",
             "type_name": "送药",
             "content": "哈哈哈哈。这个是项目...",
             "activity_url": "http://www.baidu.com",//问卷链接
             "join_num": "1",//已发送人数
             "join_status":1//是否可以发送给患者，默认0不能，1能
             }
        ]
 }
 {"res":"1002","msg":"登录状态已过期"}
 {"res":"1004","msg":"重复请求"}
 {"res":"1005","msg":"缺少参数"}
 {"res":"1006","msg":"医生不存在"}
 {"res":"1007","msg":"没有操作权限"}


 */
@interface PrActivityListModel : NSObject
@property (nonatomic,strong) NSString *activity_id;
@property (nonatomic,strong) NSString *title;
@property (nonatomic,strong) NSString *pic;
@property (nonatomic,strong) NSString *type_name;
@property (nonatomic,strong) NSString *content;
@property (nonatomic,strong) NSString *activity_url;
@property (nonatomic,strong) NSString *join_num;
@property (nonatomic,strong) NSString *join_status;

+(instancetype)modelWithDict:(NSDictionary *)dict;
-(instancetype)initWithDict:(NSDictionary *)dict;


@end

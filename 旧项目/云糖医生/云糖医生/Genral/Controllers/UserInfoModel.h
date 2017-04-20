//
//  UserInfoModel.h
//  yuntangyi
//
//  Created by yuntangyi on 16/9/26.
//  Copyright © 2016年 yuntangyi. All rights reserved.
//

#import <Foundation/Foundation.h>
/*
 返回值说明
 首先判断is_check的状态，当is_check是0的时候继续判断auth_check状态
 当is_check是1的时候，就是已认证无须继续判断auth_check状态
 {
     "res": "1001",
     "msg": "登录成功",
     "ident_code": "e01ec4d87b72144428b90146cf739908",
     "info": {
             "name": "张三",
             "gender": "0",
             "age":"1" ,
             "birth": "2016-09-16",
             "pic": "http://localhost:8060/attachment/doctor/20160908164057-EjqwY8u2dN.png",//头像
             "hid": "1863",//医院id
             "hospital": "洛阳东方医院",//医院
             "did": "108",//科室id
             "department": "内分泌科",//科室
             "title": "主任医师",//职称
             "conent": "",//个人简介
             "do_at": "",//擅长
             "is_check": "1",//认证状态 0 未认证 1已认证
             "auth_check": "0",//0是未认证 1审核通过 2审核不通过 3待审核
             "status": "0",//账号状态 可用为0 禁用为2
             "ttid": "0",//职称id
             "activity_id": 0//最近的一次项目id
     }
 }
 {"res":"1004","msg":"重复请求"}
 {"res":"1005","msg":"缺少参数"}
 {"res":"1006","msg":"该手机号已注册"}
 {"res":"1007","msg":"验证码有误"}
 {"res":"1008","msg":"验证码已经过期"}
 {"res":"1009","msg":"您的账号被禁用"} */

@interface UserInfoModel : NSObject
@property (nonatomic,strong) NSString *ids;
@property (nonatomic,strong) NSString *name;
@property (nonatomic,strong) NSString *gender;
@property (nonatomic,strong) NSString *age;
@property (nonatomic,strong) NSString *birth;
@property (nonatomic,strong) NSString *pic;
@property (nonatomic,strong) NSString *hid;
@property (nonatomic,strong) NSString *hospital;
@property (nonatomic,strong) NSString *did;
@property (nonatomic,strong) NSString *department;
@property (nonatomic,strong) NSString *title;
@property (nonatomic,strong) NSString *conent;
@property (nonatomic,strong) NSString *do_at;
@property (nonatomic,strong) NSString *is_check;
@property (nonatomic,strong) NSString *status;
@property (nonatomic,strong) NSString *auth_check;
@property (nonatomic,strong) NSString *pospic_url;
@property (nonatomic,strong) NSString *check_type;
@property (nonatomic,strong) NSString *ttid;
@property (nonatomic,strong) NSString *activity_id;
@property (nonatomic,strong) NSString *login_type;

//初始化方法
-(instancetype)initWithDict:(NSDictionary *)dict;
+(instancetype)modelWithDict:(NSDictionary *)dict;
@end

//
//  DoctorUpdateModel.h
//  yuntangyi
//
//  Created by yuntangyi on 16/9/22.
//  Copyright © 2016年 yuntangyi. All rights reserved.
//

#import <Foundation/Foundation.h>
/*
 返回值说明
 {
 "res": "1001",
 "msg": "修改成功",
 "info": {
         "name": "小侯",
         "gender": "1",
         "age": null,
         "birth": "2016-09-09",
         "pic": null,
         "hid": "0",
         "hospital": null,
         "did": "0",
         "department": null,
         "title": null,
         "conent": "",
         "do_at": "疑难杂症",
         "is_check": "0",
         "status": "0"
 }
 }
 {"res":"1002","msg":"登录状态已过期"}
 {"res":"1004","msg":"重复请求"}
 {"res":"1005","msg":"缺少参数"}
 {"res":"1006","msg":"您的账号被禁用"}
 */
@interface DoctorUpdateModel : NSObject
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

//初始化方法
-(instancetype)initWithDict:(NSDictionary *)dict;
+(instancetype)modelWithDict:(NSDictionary *)dict;


@end







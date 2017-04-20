//
//  PrActivityPatientModel.h
//  yuntangyi
//
//  Created by yuntangyi on 16/9/18.
//  Copyright © 2016年 yuntangyi. All rights reserved.
//

#import <Foundation/Foundation.h>
/*
 返回值说明10
 {
 "res": "1001",
 "msg": "请求成功",
 "resault": [
     {
     "patient_id": "1",
     "name": "小星星",
     "gender": "0",
     "age": 23,
     "pic": "http://192.168.20.8/attachment/patient/thumb/212931180.jpg",
     "bigpic": "http://192.168.20.8/attachment/patient/212931180.jpg",
     "diabetes_name": ""
     },
     {
     "patient_id": "3",
     "name": "宋南南",
     "gender": "1",
     "age": 24,
     "pic": "http://192.168.20.8/attachment/patient/thumb/212931180.jpg",
     "bigpic": "http://192.168.20.8/attachment/patient/212931180.jpg",
     "diabetes_name": "2型糖尿病"
     }
     ]
 }
 {"res":"1002","msg":"登录状态已过期"}
 {"res":"1004","msg":"重复请求"}
 {"res":"1005","msg":"缺少参数"}
 {"res":"1006","msg":"没有操作权限"}
 */

@interface PrActivityPatientModel : NSObject
@property (nonatomic,strong) NSString *patient_id;
@property (nonatomic,strong) NSString *name;
@property (nonatomic,strong) NSString *gender;
@property (nonatomic,strong) NSString *age;
@property (nonatomic,strong) NSString *pic;
@property (nonatomic,strong) NSString *bigpic;
@property (nonatomic,strong) NSString *diabetes_name;

+(instancetype)modelWithDict:(NSDictionary *)dict;
-(instancetype)initWithDict:(NSDictionary *)dict;

@end

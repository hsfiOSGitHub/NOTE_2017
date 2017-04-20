//
//  PrAnswerListModel.h
//  yuntangyi
//
//  Created by yuntangyi on 16/9/18.
//  Copyright © 2016年 yuntangyi. All rights reserved.
//

#import <Foundation/Foundation.h>
/*
 返回值说明
 status：0待处理1同意反馈2拒绝反馈3待反馈4已反馈
 {
 "res": "1001",
 "msg": "请求成功",
 "list": [
         {
         "aid": "2",//反馈的id
         "status": "1",//
         "patient_name": "小星星",
         "gender": "0"//0是男，1是女
         }
     ]
 }
 {"res":"1002","msg":"登录状态已过期"}
 {"res":"1004","msg":"重复请求"}
 {"res":"1005","msg":"缺少必须参数"}
 {"res":"1006","msg":"没有操作权限"}
 */
@interface PrAnswerListModel : NSObject
@property (nonatomic,strong) NSString *aid;
@property (nonatomic,strong) NSString *status;
@property (nonatomic,strong) NSString *patient_name;
@property (nonatomic,strong) NSString *gender;

+(instancetype)modelWithDict:(NSDictionary *)dict;
-(instancetype)initWithDict:(NSDictionary *)dict;

@end

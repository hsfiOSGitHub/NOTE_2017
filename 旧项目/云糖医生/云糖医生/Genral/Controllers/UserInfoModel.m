//
//  UserInfoModel.m
//  yuntangyi
//
//  Created by yuntangyi on 16/9/26.
//  Copyright © 2016年 yuntangyi. All rights reserved.
//

#import "UserInfoModel.h"

@implementation UserInfoModel
//初始化方法
-(instancetype)initWithDict:(NSDictionary *)dict{
    self = [super init];
    if (self) {
        self.ids = dict[@"id"];
        self.name = dict[@"name"];
        self.gender = dict[@"gender"];
        self.age = dict[@"age"];
        self.birth = dict[@"birth"];
        self.pic = dict[@"pic"];
        self.hid = dict[@"hid"];
        self.hospital = dict[@"hospital"];
        self.did = dict[@"did"];
        self.department = dict[@"department"];
        self.title = dict[@"title"];
        self.conent = dict[@"conent"];
        self.do_at = dict[@"do_at"];
        self.is_check = dict[@"is_check"];
        self.status = dict[@"status"];
        self.auth_check = dict[@"auth_check"];
        self.check_type = dict[@"check_type"];
        self.ttid = dict[@"ttid"];
        self.pospic_url = dict[@"pospic_url"];
        self.activity_id = dict[@"activity_id"];
        self.login_type = dict[@"login_type"];
    }
    return self;
}

+(instancetype)modelWithDict:(NSDictionary *)dict{
    return [[self alloc]initWithDict:dict];
}

@end

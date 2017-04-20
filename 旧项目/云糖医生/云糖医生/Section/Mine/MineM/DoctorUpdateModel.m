
//
//  DoctorUpdateModel.m
//  yuntangyi
//
//  Created by yuntangyi on 16/9/22.
//  Copyright © 2016年 yuntangyi. All rights reserved.
//

#import "DoctorUpdateModel.h"

@implementation DoctorUpdateModel
//初始化方法
-(instancetype)initWithDict:(NSDictionary *)dict{
    self = [super init];
    if (self) {
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
    }
    return self;
}

+(instancetype)modelWithDict:(NSDictionary *)dict{
    return [[self alloc]initWithDict:dict];
}
@end

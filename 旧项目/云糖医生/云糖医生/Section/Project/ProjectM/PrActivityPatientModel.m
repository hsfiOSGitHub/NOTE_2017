//
//  PrActivityPatientModel.m
//  yuntangyi
//
//  Created by yuntangyi on 16/9/18.
//  Copyright © 2016年 yuntangyi. All rights reserved.
//

#import "PrActivityPatientModel.h"

@implementation PrActivityPatientModel
//初始化方法
-(instancetype)initWithDict:(NSDictionary *)dict{
    self = [super init];
    if (self) {
        self.patient_id = dict[@"patient_id"];
        self.name = dict[@"name"];
        self.gender = dict[@"gender"];
        self.age = dict[@"age"];
        self.pic = dict[@"pic"];
        self.bigpic = dict[@"bigpic"];
        self.diabetes_name = dict[@"diabetes_name"];
    }
    return self;
}

+(instancetype)modelWithDict:(NSDictionary *)dict{
    return [[self alloc]initWithDict:dict];
}
@end

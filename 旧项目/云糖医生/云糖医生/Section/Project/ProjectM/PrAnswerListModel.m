//
//  PrAnswerListModel.m
//  yuntangyi
//
//  Created by yuntangyi on 16/9/18.
//  Copyright © 2016年 yuntangyi. All rights reserved.
//

#import "PrAnswerListModel.h"

@implementation PrAnswerListModel
//初始化方法
-(instancetype)initWithDict:(NSDictionary *)dict{
    self = [super init];
    if (self) {
        self.aid = dict[@"aid"];
        self.status = dict[@"status"];
        self.patient_name = dict[@"patient_name"];
        self.gender = dict[@"gender"];
    }
    return self;
}

+(instancetype)modelWithDict:(NSDictionary *)dict{
    return [[self alloc]initWithDict:dict];
}
@end

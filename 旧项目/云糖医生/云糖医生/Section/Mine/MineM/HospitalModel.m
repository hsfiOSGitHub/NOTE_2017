//
//  HospitalModel.m
//  yuntangyi
//
//  Created by yuntangyi on 16/9/21.
//  Copyright © 2016年 yuntangyi. All rights reserved.
//

#import "HospitalModel.h"

@implementation HospitalModel
-(instancetype)initWithDict:(NSDictionary *)dict{
    if (self = [super init]) {
        self.ID = dict[@"id"];
        self.name = dict[@"name"];
        self.type = dict[@"type"];
        self.state = dict[@"state"];
        self.seq = dict[@"seq"];
    }
    return self;
}
+(instancetype)modelWithDict:(NSDictionary *)dict{
    return [[self alloc]initWithDict:dict];
}
@end

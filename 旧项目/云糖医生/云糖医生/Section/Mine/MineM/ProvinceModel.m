//
//  ProvinceModel.m
//  yuntangyi
//
//  Created by yuntangyi on 16/9/21.
//  Copyright © 2016年 yuntangyi. All rights reserved.
//

#import "ProvinceModel.h"

@implementation ProvinceModel
-(instancetype)initWithDict:(NSDictionary *)dict{
    if (self = [super init]) {
        self.ID = dict[@"id"];
        self.name = dict[@"name"];
        self.province_id = dict[@"province_id"];
        self.state = dict[@"state"];
        self.seq = dict[@"seq"];
    }
    return self;
}
+(instancetype)modelWithDict:(NSDictionary *)dict{
    return [[self alloc]initWithDict:dict];
}
@end

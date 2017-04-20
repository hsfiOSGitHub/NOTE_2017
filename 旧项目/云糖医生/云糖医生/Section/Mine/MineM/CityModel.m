//
//  CityModel.m
//  yuntangyi
//
//  Created by yuntangyi on 16/9/21.
//  Copyright © 2016年 yuntangyi. All rights reserved.
//

#import "CityModel.h"

@implementation CityModel
-(instancetype)initWithDict:(NSDictionary *)dict{
    if (self = [super init]) {
        self.ID = dict[@"id"];
        self.name = dict[@"name"];
        self.city_id = dict[@"city_id"];
        self.type = dict[@"type"];
        self.code = dict[@"code"];
    }
    return self;
}
+(instancetype)modelWithDict:(NSDictionary *)dict{
    return [[self alloc]initWithDict:dict];
}
@end

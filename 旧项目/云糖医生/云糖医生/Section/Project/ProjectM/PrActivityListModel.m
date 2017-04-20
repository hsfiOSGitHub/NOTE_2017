//
//  PrActivityListModel.m
//  yuntangyi
//
//  Created by yuntangyi on 16/9/18.
//  Copyright © 2016年 yuntangyi. All rights reserved.
//

#import "PrActivityListModel.h"

@implementation PrActivityListModel
//初始化方法
-(instancetype)initWithDict:(NSDictionary *)dict{
    self = [super init];
    if (self) {
        self.activity_id = dict[@"activity_id"];
        self.title = dict[@"title"];
        self.pic = dict[@"pic"];
        self.type_name = dict[@"type_name"];
        self.content = dict[@"content"];
        self.activity_url = dict[@"activity_url"];
        self.join_num = dict[@"join_num"];
        self.join_status = dict[@"join_status"];
    }
    return self;
}

+(instancetype)modelWithDict:(NSDictionary *)dict{
    return [[self alloc]initWithDict:dict];
}
@end

//
//  SchoolListModel.m
//  友照
//
//  Created by monkey2016 on 16/11/26.
//  Copyright © 2016年 ZX_XPH. All rights reserved.
//

#import "SchoolListModel.h"

@implementation SchoolListModel
-(instancetype)initWithDic:(NSDictionary *)dic{
    if (self = [super init]) {
        self.avg_days = dic[@"avg_days"];
        self.avg_rate = dic[@"avg_rate"];
        self.school_id = dic[@"id"];
        self.name = dic[@"name"];
        self.pic = dic[@"pic"];
        self.price = dic[@"price"];
        self.score = dic[@"score"];
    }
    return self;
}
+(instancetype)modelWithDic:(NSDictionary *)dic{
    return [[self alloc]initWithDic:dic];
}
@end

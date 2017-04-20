//
//  TeacherListModel.m
//  友照
//
//  Created by monkey2016 on 16/11/30.
//  Copyright © 2016年 ZX_XPH. All rights reserved.
//

#import "TeacherListModel.h"

@implementation TeacherListModel

-(instancetype)initWithDic:(NSDictionary *)dic{
    if (self = [super init]) {
        self.avg_rate = dic[@"avg_rate"];
        self.ID = dic[@"id"];
        self.name = dic[@"name"];
        self.pic = dic[@"pic"];
        self.school_name = dic[@"school_name"];
        self.score = dic[@"score"];
    }
    return self;
}
+(instancetype)modelWithDic:(NSDictionary *)dic{
    return [[self alloc]initWithDic:dic];
}

@end

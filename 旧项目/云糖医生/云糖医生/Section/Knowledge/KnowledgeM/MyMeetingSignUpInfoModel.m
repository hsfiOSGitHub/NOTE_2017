//
//  MyMeetingSignUpInfoModel.m
//  yuntangyi
//
//  Created by yuntangyi on 16/9/30.
//  Copyright © 2016年 yuntangyi. All rights reserved.
//

#import "MyMeetingSignUpInfoModel.h"

@implementation MyMeetingSignUpInfoModel
//初始化方法
-(instancetype)initWithDict:(NSDictionary *)dict{
    self = [super init];
    if (self) {
        self.meeting_sn = dict[@"meeting_sn"];
        self.status = dict[@"status"];
        self.meeting_start_time = dict[@"meeting_start_time"];
        self.meeting_end_time = dict[@"meeting_end_time"];
        self.actor = dict[@"actor"];
        self.address = dict[@"address"];
        self.meeting_name = dict[@"meeting_name"];
    }
    return self;
}

+(instancetype)modelWithDict:(NSDictionary *)dict{
    return [[self alloc]initWithDict:dict];
}
@end

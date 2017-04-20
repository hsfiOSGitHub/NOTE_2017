//
//  KnMeetingSignUpModel.m
//  yuntangyi
//
//  Created by yuntangyi on 16/9/14.
//  Copyright © 2016年 yuntangyi. All rights reserved.
//

#import "KnMeetingSignUpModel.h"

@implementation KnMeetingSignUpModel
-(instancetype)initWithDict:(NSDictionary *)dict{
    if (self = [super init]) {
        self.signUp_id = dict[@"signUp_id"];
        self.meeting_start_time = dict[@"meeting_start_time"];
        self.actor = dict[@"actor"];
        self.meeting_name = dict[@"meeting_name"];
        self.meeting_sn = dict[@"meeting_sn"];
        self.address = dict[@"address"];
        self.words = dict[@"words"];
    }
    return self;
}
+(instancetype)modelWithDict:(NSDictionary *)dict{
    return [[self alloc]initWithDict:dict];
}
@end

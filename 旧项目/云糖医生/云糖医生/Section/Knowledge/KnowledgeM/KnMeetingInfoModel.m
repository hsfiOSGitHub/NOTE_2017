//
//  KnMeetingInfoModel.m
//  yuntangyi
//
//  Created by yuntangyi on 16/9/14.
//  Copyright © 2016年 yuntangyi. All rights reserved.
//

#import "KnMeetingInfoModel.h"

@implementation KnMeetingInfoModel
-(instancetype)initWithDict:(NSDictionary *)dict{
    if (self = [super init]) {
        self.mid = dict[@"mid"];
        self.meeting_name = dict[@"meeting_name"];
        self.start_time = dict[@"start_time"];
        self.pic = dict[@"pic"];
        self.content_url = dict[@"content_url"];
        self.address = dict[@"address"];
        self.actor = dict[@"actor"];
        self.entered_num = dict[@"entered_num"];
        self.surplus_num = dict[@"surplus_num"];
        self.note = dict[@"note"];
        self.status = dict[@"status"];
        self.is_exist = dict[@"is_exist"];
    }
    return self;
}
+(instancetype)modelWithDict:(NSDictionary *)dict{
    return [[self alloc]initWithDict:dict];
}
@end

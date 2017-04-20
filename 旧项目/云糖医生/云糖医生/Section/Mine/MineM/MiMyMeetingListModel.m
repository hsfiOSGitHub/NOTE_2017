//
//  MiMyMeetingListModel.m
//  yuntangyi
//
//  Created by yuntangyi on 16/9/18.
//  Copyright © 2016年 yuntangyi. All rights reserved.
//

#import "MiMyMeetingListModel.h"

@implementation MiMyMeetingListModel
//初始化方法
-(instancetype)initWithDict:(NSDictionary *)dict{
    self = [super init];
    if (self) {
        self.ID = dict[@"mid"];
        self.meeting_name = dict[@"meeting_name"];
        self.start_time = dict[@"start_time"];
        self.pic = dict[@"pic"];
        self.content = dict[@"content"];
        self.tags_list = dict[@"tags_list"];
        self.is_do = dict[@"is_do"];
        self.dotype = dict[@"dotype"];
        self.status = dict[@"status"];
    }
    return self;
}

+(instancetype)modelWithDict:(NSDictionary *)dict{
    return [[self alloc]initWithDict:dict];
}
@end

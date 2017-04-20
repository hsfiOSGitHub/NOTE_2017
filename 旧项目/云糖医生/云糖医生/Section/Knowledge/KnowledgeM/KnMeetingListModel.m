//
//  KnMeetingListModel.m
//  yuntangyi
//
//  Created by yuntangyi on 16/9/14.
//  Copyright © 2016年 yuntangyi. All rights reserved.
//

#import "KnMeetingListModel.h"

@implementation KnMeetingListModel
-(instancetype)initWithDict:(NSDictionary *)dict{
    if (self = [super init]) {
        self.knID = dict[@"id"];
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

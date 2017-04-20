//
//  KnNewsListModel.m
//  yuntangyi
//
//  Created by yuntangyi on 16/9/23.
//  Copyright © 2016年 yuntangyi. All rights reserved.
//

#import "KnNewsListModel.h"

@implementation KnNewsListModel
//初始化方法
-(instancetype)initWithDict:(NSDictionary *)dict{
    self = [super init];
    if (self) {
        self.KnID = dict[@"id"];
        self.pic = dict[@"pic"];
        self.title = dict[@"title"];
        self.content = dict[@"content"];
        self.addtime = dict[@"addtime"];
        self.click = dict[@"click"];
        self.collect = dict[@"collect"];
        self.praise = dict[@"praise"];
        self.iscollect = dict[@"iscollect"];
        self.ispraise = dict[@"ispraise"];
        self.url = dict[@"url"];
    }
    return self;
}

+(instancetype)modelWithDict:(NSDictionary *)dict{
    return [[self alloc]initWithDict:dict];
}
@end

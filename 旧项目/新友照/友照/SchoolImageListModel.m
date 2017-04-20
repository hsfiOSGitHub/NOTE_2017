//
//  SchoolImageListModel.m
//  友照
//
//  Created by monkey2016 on 16/12/1.
//  Copyright © 2016年 ZX_XPH. All rights reserved.
//

#import "SchoolImageListModel.h"

@implementation SchoolImageListModel

-(instancetype)initWithDic:(NSDictionary *)dic{
    if (self = [super init]) {
        self.ID = dic[@"id"];
        self.name = dic[@"name"];
        self.num = dic[@"num"];
        self.images = dic[@"images"];
    }
    return self;
}
+(instancetype)modelWithDic:(NSDictionary *)dic{
    return [[self alloc]initWithDic:dic];
}


@end

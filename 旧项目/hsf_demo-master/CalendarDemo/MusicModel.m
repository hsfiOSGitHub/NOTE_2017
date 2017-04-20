//
//  MusicModel.m
//  CalendarDemo
//
//  Created by monkey2016 on 17/1/20.
//  Copyright © 2017年 monkey2016. All rights reserved.
//

#import "MusicModel.h"

@implementation MusicModel

-(instancetype)initWithDic:(NSDictionary *)dic{
    if (self = [super init]) {
        self.musicName = dic[@"musicName"];
        self.singerName = dic[@"singerName"];
        self.type = dic[@"type"];
        self.singerPic = dic[@"singerPic"];
        self.is_playing = dic[@"is_playing"];
        self.isLike = dic[@"isLike"];
    }
    return self;
}
+(instancetype)modelWithDic:(NSDictionary *)dic{
    return [[self alloc]initWithDic:dic];
}

@end

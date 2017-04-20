//
//  SchoolCommentModel.m
//  友照
//
//  Created by monkey2016 on 16/11/26.
//  Copyright © 2016年 ZX_XPH. All rights reserved.
//

#import "SchoolCommentModel.h"

@implementation SchoolCommentModel
-(instancetype)initWithDic:(NSDictionary *)dic{
    if (self = [super init]) {
        self.addtime = dic[@"addtime"];
        self.content = dic[@"content"];
        self.ID = dic[@"id"];
        self.score = dic[@"score"];
        self.stid = dic[@"stid"];
        self.student_name = dic[@"student_name"];
        self.student_pic = dic[@"student_pic"];
    }
    return self;
}
+(instancetype)modelWithDic:(NSDictionary *)dic{
    return [[self alloc]initWithDic:dic];
}
@end

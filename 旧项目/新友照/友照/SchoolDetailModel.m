//
//  SchoolDetailModel.m
//  友照
//
//  Created by monkey2016 on 16/11/26.
//  Copyright © 2016年 ZX_XPH. All rights reserved.
//

#import "SchoolDetailModel.h"

@implementation SchoolDetailModel
-(instancetype)initWithDic:(NSDictionary *)dic{
    if (self = [super init]) {
        self.ID = dic[@"id"];
        self.name = dic[@"name"];
        self.score = dic[@"score"];
        self.price = dic[@"price"];
        self.student_num = dic[@"student_num"];
        self.teacher_subject2 = dic[@"teacher_subject2"];
        self.teacher_subject3 = dic[@"teacher_subject3"];
        self.pic = dic[@"pic"];
        self.school_images_num = dic[@"school_images_num"];
        self.content = dic[@"content"];
        self.location = dic[@"location"];
        self.address = dic[@"address"];
        self.tel = dic[@"tel"];
        self.commentNums = dic[@"commentNums"];
        self.comment = dic[@"comment"];
    }
    return self;
}
+(instancetype)modelWithDic:(NSDictionary *)dic{
    return [[self alloc]initWithDic:dic];
}
@end

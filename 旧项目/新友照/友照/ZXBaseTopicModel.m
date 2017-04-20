//
//  ZXBaseTopicModel.m
//  ZXJiaXiao
//
//  Created by ZX on 16/2/26.
//  Copyright © 2016年 ZX. All rights reserved.
//

#import "ZXBaseTopicModel.h"

@implementation ZXBaseTopicModel


-(instancetype)initWithDic:(NSDictionary *)dic{
    if (self = [super init]) {
        self.kemu = dic[@"kemu"];
        self.ID = dic[@"ID"];
        self.Type = dic[@"Type"];
        self.Question = dic[@"Question"];
        self.sinaimg = dic[@"sinaimg"];
        self.An1 = dic[@"An1"];
        self.An2 = dic[@"An2"];
        self.An3 = dic[@"An3"];
        self.An4 = dic[@"An4"];
        self.AnswerTrue = dic[@"AnswerTrue"];
        self.explain = dic[@"explain"];
        self.diff_degree = dic[@"diff_degree"];
        self.status = dic[@"status"];
    }
    return self;
}
+(instancetype)modelWithDic:(NSDictionary *)dic{
    return [[self alloc]initWithDic:dic];
}


@end

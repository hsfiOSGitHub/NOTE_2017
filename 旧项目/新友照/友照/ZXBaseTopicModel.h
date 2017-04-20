//
//  ZXBaseTopicModel.h
//  ZXJiaXiao
//
//  Created by ZX on 16/2/26.
//  Copyright © 2016年 ZX. All rights reserved.
//

#import <Foundation/Foundation.h>

/*
 {
 An1 = "\U5de5\U4f5c\U8bc1";
 An2 = "\U9a7e\U9a76\U8bc1";
 An3 = "\U8eab\U4efd\U8bc1";
 An4 = "\U804c\U4e1a\U8d44\U683c\U8bc1";
 AnswerTrue = 2;
 ID = 10;
 Question = "\U9a7e\U9a76\U673a\U52a8\U8f66\U5e94\U5f53\U968f\U8eab\U643a\U5e26\U54ea\U79cd\U8bc1\U4ef6\Uff1f";
 Type = 2;
 "diff_degree" = 0;
 explain = "\U300a\U9053\U8def\U4ea4\U901a\U5b89\U5168\U6cd5\U300b\U7b2c\U5341\U4e5d\U6761\Uff1a\U9a7e\U9a76\U4eba\U5e94\U5f53\U6309\U7167\U9a7e\U9a76\U8bc1\U8f7d\U660e\U7684\U51c6\U9a7e\U8f66\U578b\U9a7e\U9a76\U673a\U52a8\U8f66\Uff1b\U9a7e\U9a76\U673a\U52a8\U8f66\U65f6\Uff0c\U5e94\U5f53\U968f\U8eab\U643a\U5e26\U673a\U52a8\U8f66\U9a7e\U9a76\U8bc1\U3002";
 kemu = 1;
 status = 0;
 }
 */


@interface ZXBaseTopicModel : NSObject

//练习的科目
@property (nonatomic,copy) NSString *kemu;
//第几题
@property (nonatomic,copy) NSString * ID;
//题目类型
@property(nonatomic,copy)NSString *Type;//1 是判断题 ／ 2是单选题  ／  3是多选题
//题目
@property (nonatomic,copy) NSString *Question;
//图片或视频
@property (nonatomic,copy) NSString *sinaimg;
//选项
@property (nonatomic, copy) NSString *An1;
@property (nonatomic, copy) NSString *An2;
@property (nonatomic, copy) NSString *An3;
@property (nonatomic, copy) NSString *An4;
//所有的答案,可以从这里判断出答案的个数和都有哪些答案
@property (nonatomic,copy) NSString *AnswerTrue;
//提示
@property (nonatomic,copy) NSString *explain;
////练习的难易程度 难易程度
@property (nonatomic,copy) NSString *diff_degree;
//此题是否已经答过
@property (nonatomic, copy) NSString *status;


-(instancetype)initWithDic:(NSDictionary *)dic;
+(instancetype)modelWithDic:(NSDictionary *)dic;

@end

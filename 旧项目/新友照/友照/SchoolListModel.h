//
//  SchoolListModel.h
//  友照
//
//  Created by monkey2016 on 16/11/26.
//  Copyright © 2016年 ZX_XPH. All rights reserved.
//

#import <Foundation/Foundation.h>

/*
 {
 "avg_days" = 0;
 "avg_rate" = 1;
 id = 1846;
 name = "\U5409\U7965\U9a7e\U6821";
 pic = "http://test.youzhaola.com/attachment/school/1846/thumb/20160805162811-xylVUJnhMH.jpg";
 price = 3600;
 score = "5.0";
 }
 */

@interface SchoolListModel : NSObject
@property (nonatomic,strong) NSNumber *avg_days;
@property (nonatomic,strong) NSNumber *avg_rate;//通过率
@property (nonatomic,strong) NSNumber *school_id;//驾校id
@property (nonatomic,strong) NSString *name;//驾校名称
@property (nonatomic,strong) NSString *pic;//驾校图片
@property (nonatomic,strong) NSNumber *price;//价格
@property (nonatomic,strong) NSString *score;//评分

-(instancetype)initWithDic:(NSDictionary *)dic;
+(instancetype)modelWithDic:(NSDictionary *)dic;

@end

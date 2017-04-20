//
//  TeacherListModel.h
//  友照
//
//  Created by monkey2016 on 16/11/30.
//  Copyright © 2016年 ZX_XPH. All rights reserved.
//

#import <Foundation/Foundation.h>

/*
 {
 "avg_rate" = 1;
 id = 21;
 name = "\U5c39\U4e39";
 pic = "http://test.youzhaola.com/attachment/teacher/2/thumb/1459419988p-4aRX9pI6gO.jpg";
 "school_name" = "\U53cb\U7167";
 score = "5.0";
 }
 */

@interface TeacherListModel : NSObject

@property (nonatomic,strong) NSNumber *avg_rate;
@property (nonatomic,strong) NSNumber *ID;
@property (nonatomic,strong) NSString *name;
@property (nonatomic,strong) NSString *pic;
@property (nonatomic,strong) NSString *school_name;
@property (nonatomic,strong) NSString *score;


-(instancetype)initWithDic:(NSDictionary *)dic;
+(instancetype)modelWithDic:(NSDictionary *)dic;

@end

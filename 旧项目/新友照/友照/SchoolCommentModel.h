//
//  SchoolCommentModel.h
//  友照
//
//  Created by monkey2016 on 16/11/26.
//  Copyright © 2016年 ZX_XPH. All rights reserved.
//

#import <Foundation/Foundation.h>

/*
 {
 addtime = "2016-07-23 16:27:16";
 content = "\U8f66\U51b5\U826f\U597d  \U4e2d\U56fd\U597d\U6559\U7ec3";
 id = 150;
 score = 4;
 stid = 9097;
 "student_name" = "";
 "student_pic" = "";
 }
 */

@interface SchoolCommentModel : NSObject

@property (nonatomic,strong) NSString *addtime;
@property (nonatomic,strong) NSString *content;
@property (nonatomic,strong) NSNumber *ID;
@property (nonatomic,strong) NSNumber *score;
@property (nonatomic,strong) NSNumber *stid;
@property (nonatomic,strong) NSString *student_name;
@property (nonatomic,strong) NSString *student_pic;

-(instancetype)initWithDic:(NSDictionary *)dic;
+(instancetype)modelWithDic:(NSDictionary *)dic;

@end

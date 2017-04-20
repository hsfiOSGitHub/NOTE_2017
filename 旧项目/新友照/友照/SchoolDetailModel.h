//
//  SchoolDetailModel.h
//  友照
//
//  Created by monkey2016 on 16/11/26.
//  Copyright © 2016年 ZX_XPH. All rights reserved.
//

#import <Foundation/Foundation.h>
/*
 {
 "id":"186",
 "name":"商丘友照",
 "score":"5.0",
 "price":"0",
 "student_num":"80",
 "teacher_subject2":[
 
 ],
 "teacher_subject3":[
 
 ],
 "pic":"http://test.youzhaola.com/attachment/school/186/thumb/20160805111659-juW3UsKj9B.png",
 "school_images_num":"0",
 "content":"友照商丘驾校是洛阳智行信息技术有限公司推出的，以优质服务标准，最快拿证速度，最实惠的价格，让友照的学子开心拿证！",
 "location":"115.662802,34.420311",
 "address":"河南省商丘市梁园区府前路",
 "tel":"18637052606",
 "commentNums":"0",
 "comment":[
 
 ]
 }
 */

@interface SchoolDetailModel : NSObject
@property (nonatomic,strong) NSString *ID;
@property (nonatomic,strong) NSString *name;
@property (nonatomic,strong) NSString *score;
@property (nonatomic,strong) NSString *price;
@property (nonatomic,strong) NSString *student_num;
@property (nonatomic,strong) NSArray *teacher_subject2;
@property (nonatomic,strong) NSArray *teacher_subject3;
@property (nonatomic,strong) NSString *pic;
@property (nonatomic,strong) NSString *school_images_num;
@property (nonatomic,strong) NSString *content;
@property (nonatomic,strong) NSString *location;
@property (nonatomic,strong) NSString *address;
@property (nonatomic,strong) NSString *tel;
@property (nonatomic,strong) NSString *commentNums;
@property (nonatomic,strong) NSArray *comment;

-(instancetype)initWithDic:(NSDictionary *)dic;
+(instancetype)modelWithDic:(NSDictionary *)dic;



@end

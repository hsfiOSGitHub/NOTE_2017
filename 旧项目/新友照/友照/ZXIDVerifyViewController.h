//
//  ZXIDVerifyViewController.h
//  ZXJiaXiao
//
//  Created by ZX on 16/3/15.
//  Copyright © 2016年 ZX. All rights reserved.
//

typedef NS_ENUM(NSInteger, VerifyType)
{
    verifyTypeJiaoLian = 0,//预约教练
    verifyTypeJiaXiao     //预约驾校
};

//根据枚举来调用不同的接口
@interface ZXIDVerifyViewController : ZXSeconBaseViewController
@property (nonatomic, assign) VerifyType verifyType;
@property (nonatomic) NSString *jiaolianID;
@property (nonatomic) NSString *subject;

@property (nonatomic) NSString *yanZhengMaType;

//教练的图片
@property (nonatomic, copy) NSString *teacher_pic;
@property (nonatomic) NSString *jiaxiaoID;
@property (nonatomic, copy) NSString *teacher_name;
@end

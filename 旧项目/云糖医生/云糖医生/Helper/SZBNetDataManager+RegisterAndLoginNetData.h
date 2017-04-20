//
//  SZBNetDataManager+RegisterAndLoginNetData.h
//  yuntangyi
//
//  Created by yuntangyi on 16/9/2.
//  Copyright © 2016年 yuntangyi. All rights reserved.
//
//typedef NS_ENUM(NSInteger, SecurityCodeType) {
//    NoRegisterType = 11,
//    RegisterType = 12,
//    FindBackPasswordType = 13,
//    ModifyPasswordType = 14,
//};

#import "SZBNetDataManager.h"

@interface SZBNetDataManager (RegisterAndLoginNetData)

//@property (nonatomic,assign) SecurityCodeType securityCodeType;

//注册register
-(void)registerPhone:(NSString *)phone andPassword:(NSString *)password andCode:(NSString *)code andRandomStamp:(NSString *)randomString success:(SuccessBlockType)successBlock failed:(FailuerBlockType)failedBlock;
//密码登录login
-(void)LoginPhone:(NSString *)phone andPassword:(NSString *)password andRandomStamp:(NSString *)randomString success:(SuccessBlockType)successBlock failed:(FailuerBlockType)failedBlock;
//免注册登录
-(void)nrloginPhone:(NSString *)phone andCode:(NSString *)code andRandomStamp:(NSString *)randomString success:(SuccessBlockType)successBlock failed:(FailuerBlockType)failedBlock;
//获取验证码
-(void)MessagePhone:(NSString *)phone andType:(NSString *)type andRandomStamp:(NSString *)randomString success:(SuccessBlockType)successBlock failed:(FailuerBlockType)failedBlock;
//忘记密码(找回密码)
-(void)forgetPasswordPhone:(NSString *)phone andPassWord:(NSString *)passWord andCode:(NSString *)code andRandomStamp:(NSString *)randomString success:(SuccessBlockType)successBlock failed:(FailuerBlockType)failedBlock;
//修改密码
-(void)updatePasswordIdentCode:(NSString *)identCode andOldPassWord:(NSString *)oldPassWord andNewPassWord:(NSString *)newPassWord andRandomStamp:(NSString *)randomString success:(SuccessBlockType)successBlock failed:(FailuerBlockType)failedBlock;
//意见反馈
-(void)feedbackRandomStamp:(NSString *)randomString andPhone:(NSString *)phone andContent:(NSString *)content andVersion:(NSString *)version success:(SuccessBlockType)successBlock failed:(FailuerBlockType)failedBlock;
//退出登录
- (void)logoutRandomString:(NSString *)randomString andCode:(NSString *)code success:(SuccessBlockType)successBlock failed:(FailuerBlockType)failedBlock;
//消息数量
- (void)remindNumRandomString:(NSString *)randomString andCode:(NSString *)code success:(SuccessBlockType)successBlock failed:(FailuerBlockType)failedBlock;

@end

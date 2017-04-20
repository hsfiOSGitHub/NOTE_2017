//
//  NSString+Predicate.h
//  iOS-Category
//
//  Created by 庄BB的MacBook on 16/7/20.
//  Copyright © 2016年 BBFC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Predicate)

//有效的电话号码
- (BOOL) isValidMobileNumber;

//有效的真实姓名
- (BOOL) isValidRealName;

//是否只有中文
- (BOOL) isOnlyChinese;

//有效的验证码(根据自家的验证码位数进行修改)
- (BOOL) isValidVerifyCode;

//有效的银行卡号
- (BOOL) isValidBankCardNumber;

//有效的邮箱
- (BOOL) isValidEmail;

//有效的字母数字密码
- (BOOL) isValidAlphaNumberPassword;

//检测有效身份证
//15位
- (BOOL) isValidIdentifyFifteen;

//18位
- (BOOL) isValidIdentifyEighteen;

//限制只能输入数字
- (BOOL) isOnlyNumber;

//电话号码中间4位****显示
+ (NSString*) getSecrectStringWithPhoneNumber:(NSString*)phoneNum;

//银行卡号中间8位显示
+ (NSString*) getSecrectStringWithAccountNo:(NSString*)accountNo;


//去掉前后空格
- (NSString *) trimmedString;

//转为电话格式
+ (NSString*) stringMobileFormat:(NSString*)mobile;

//数组中文格式（几万）可自行添加
+ (NSString*) stringChineseFormat:(double)value;


//Data类型转换为Base64
+ (NSString *)base64StringFromData:(NSData *)data length:(NSUInteger)length;

@end

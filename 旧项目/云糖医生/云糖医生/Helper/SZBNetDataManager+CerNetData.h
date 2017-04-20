//
//  SZBNetDataManager+CerNetData.h
//  yuntangyi
//
//  Created by yuntangyi on 16/9/23.
//  Copyright © 2016年 yuntangyi. All rights reserved.
//

#import "SZBNetDataManager.h"

@interface SZBNetDataManager (CerNetData)
//证件认证
- (void)doctorAuthWithFile:(id)file andRandomString:(NSString *)randomString andCode:(NSString *)code andKeshiPhone:(NSString *)keshiPhone success:(SuccessBlockType)successBlock failed:(FailuerBlockType)failedBlock;
//联名认证
- (void)doctorAuth2RandomString:(NSString *)randomString andCode:(NSString *)code andPhone1:(NSString *)phone1 andPhone2:(NSString *)phone2 success:(SuccessBlockType)successBlock failed:(FailuerBlockType)failedBlock;

@end

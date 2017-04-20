//
//  SZBNetDataManager+DoctorCerNetData.h
//  SZB_doctor
//
//  Created by chaoyang on 16/9/20.
//  Copyright © 2016年 monkey2016. All rights reserved.
//

#import "SZBNetDataManager.h"

@interface SZBNetDataManager (DoctorCerNetData)
//证件认证
- (void)doctorAuthRandomString:(NSString *)randomString andCode:(NSString *)code andCardUp:(id)cardUp success:(SuccessBlockType)successBlock failed:(FailuerBlockType)failedBlock;
//联名认证
- (void)doctorAuth2RandomString:(NSString *)randomString andCode:(NSString *)code andPhone1:(NSString *)phone1 andPhone2:(NSString *)phone2 success:(SuccessBlockType)successBlock failed:(FailuerBlockType)failedBlock;
@end

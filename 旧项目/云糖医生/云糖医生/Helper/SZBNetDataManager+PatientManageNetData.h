//
//  SZBNetDataManager+PatientManageNetData.h
//  yuntangyi
//
//  Created by yuntangyi on 16/9/7.
//  Copyright © 2016年 yuntangyi. All rights reserved.
//

#import "SZBNetDataManager.h"

@interface SZBNetDataManager (PatientManageNetData)
//患者管理
- (void)patientListRandomString:(NSString *)randomString andCode:(NSString *)code success:(SuccessBlockType)successBlock failed:(FailuerBlockType)failedBlock;
//患者详情patient_content
- (void)patientContentRandomString:(NSString *)randomString andCode:(NSString *)code andPatientIds:(NSString *)ids success:(SuccessBlockType)successBlock failed:(FailuerBlockType)failedBlock;
//搜索患者
- (void)patientSearchRandomString:(NSString *)randomString andCode:(NSString *)code andStr:(NSString *)str success:(SuccessBlockType)successBlock failed:(FailuerBlockType)failedBlock;
//按手机号搜索患者
- (void)SearchPhoneRandomString:(NSString *)randomString andCode:(NSString *)code andPhone:(NSString *)phone success:(SuccessBlockType)successBlock failed:(FailuerBlockType)failedBlock;

//邀请诊治patient_invite
- (void)patientInvitePatientIds:(NSString *)ids andRandomString:(NSString *)randomString andCode:(NSString *)code andDate:(NSString *)date andTime_point:(NSString *)timePoint success:(SuccessBlockType)successBlock failed:(FailuerBlockType)failedBlock;
//添加患者
- (void)patientAddRandomString:(NSString *)randomString andCode:(NSString *)code andPatient_id:(NSString *)patient_id andActivity_id:(NSString *)activity_id success:(SuccessBlockType)successBlock failed:(FailuerBlockType)failedBlock;
//患者健康资料
- (void)getPatientRandomString:(NSString *)randomString andCode:(NSString *)code andPatient_id:(NSString *)patient_id success:(SuccessBlockType)successBlock failed:(FailuerBlockType)failedBlock;
//患者血糖记录
- (void)getPatientBloodsugarRandomString:(NSString *)randomString andCode:(NSString *)code andPatient_id:(NSString *)patient_id andStartDate:(NSString *)startDate andEndDate:(NSString *)endDate success:(SuccessBlockType)successBlock failed:(FailuerBlockType)failedBlock;

//患者运动饮食胰岛素口服药统计
- (void)StatisticsM:(NSString *)m andRandomString:(NSString *)randomString andCode:(NSString *)code andPatient_id:(NSString *)patient_id andStartDate:(NSString *)startDate andEndDate:(NSString *)endDate success:(SuccessBlockType)successBlock failed:(FailuerBlockType)failedBlock;
@end

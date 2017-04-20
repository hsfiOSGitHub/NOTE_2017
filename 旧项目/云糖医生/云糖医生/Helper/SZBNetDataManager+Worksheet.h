//
//  SZBNetDataManager+Worksheet.h
//  yuntangyi
//
//  Created by yuntangyi on 16/9/6.
//  Copyright © 2016年 yuntangyi. All rights reserved.
//

#import "SZBNetDataManager.h"

@interface SZBNetDataManager (Worksheet)
//医生排班设置 worksheet_set
-(void)worksheetSetWithRandomStamp:(NSString *)randomString andIdentCode:(NSString *)identCode andStartDate:(NSString *)startDate andEndDate:(NSString *)endDate andAmStartTime:(NSString *)amStartTime andAmEndTime:(NSString *)amEndTime andAmnum:(NSString *)amnum andPmStartTime:(NSString *)pmStartTime andPmEndTime:(NSString *)pmEndTime andPmnum:(NSString *)pmnum andPoint:(NSString *)pointStr success:(SuccessBlockType)successBlock failed:(FailuerBlockType)failedBlock;
//医生排班修改worksheet_update
-(void)worksheet_updateWithRandomStamp:(NSString *)randomString andIdentCode:(NSString *)identCode andAmStartTime:(NSString *)amStartTime andAmEndTime:(NSString *)amEndTime andAmnum:(NSString *)amnum andPmStartTime:(NSString *)pmStartTime andPmEndTime:(NSString *)pmEndTime andPmnum:(NSString *)pmnum andPoint:(NSString *)pointStr andID:(NSString *)iD success:(SuccessBlockType)successBlock failed:(FailuerBlockType)failedBlock;
//删除排班worksheet_del
-(void)worksheet_delWithRandomStamp:(NSString *)randomString andIdentCode:(NSString *)identCode andDwp_id:(NSString *)dwp_id success:(SuccessBlockType)successBlock failed:(FailuerBlockType)failedBlock;
//预约日程表worksheet
-(void)worksheetWithRandomStamp:(NSString *)randomString andIdentCode:(NSString *)identCode andID:(NSString *)iD success:(SuccessBlockType)successBlock failed:(FailuerBlockType)failedBlock;
//预约数据列表
-(void)worksheetListWithRandomStamp:(NSString *)randomString andIdentCode:(NSString *)identCode andDate:(NSString *)date andPage:(NSString *)page success:(SuccessBlockType)successBlock failed:(FailuerBlockType)failedBlock;
@end

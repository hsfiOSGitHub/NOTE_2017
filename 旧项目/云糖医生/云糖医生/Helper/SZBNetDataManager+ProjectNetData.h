//
//  SZBNetDataManager+ProjectNetData.h
//  yuntangyi
//
//  Created by yuntangyi on 16/9/18.
//  Copyright © 2016年 yuntangyi. All rights reserved.
//

#import "SZBNetDataManager.h"

@interface SZBNetDataManager (ProjectNetData)
//项目列表 activity_list
-(void)activity_listWithRandomStamp:(NSString *)randomString andIdent_code:(NSString *)ident_code AndPage:(NSString *)page success:(SuccessBlockType)successBlock failed:(FailuerBlockType)failedBlock;
//项目详情 activity
-(void)activityWithActivity_id:(NSString *)activity_id success:(SuccessBlockType)successBlock failed:(FailuerBlockType)failedBlock;
//选择患者列表 activity_patient
-(void)activity_patientWithActivity_id:(NSString *)activity_id AndRndstring:(NSString *)rndstring AndIdent_code:(NSString *)ident_code success:(SuccessBlockType)successBlock failed:(FailuerBlockType)failedBlock;
//项目分享 activity_invite
-(void)activity_inviteWithActivity_id:(NSString *)activity_id AndRndstring:(NSString *)rndstring AndIdent_code:(NSString *)ident_code AndPatient_id:(NSString *)patient_id success:(SuccessBlockType)successBlock failed:(FailuerBlockType)failedBlock;
//反馈情况列表 answer_list
-(void)answer_listWithActivity_id:(NSString *)activity_id AndRndstring:(NSString *)rndstring AndIdent_code:(NSString *)ident_code success:(SuccessBlockType)successBlock failed:(FailuerBlockType)failedBlock;
//反馈详情 answer_info
-(void)answer_infoWithAid:(NSString *)aid AndRndstring:(NSString *)rndstring AndIdent_code:(NSString *)ident_code success:(SuccessBlockType)successBlock failed:(FailuerBlockType)failedBlock;
@end

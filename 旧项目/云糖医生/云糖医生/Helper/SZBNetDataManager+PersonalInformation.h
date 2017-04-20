//
//  SZBNetDataManager+PersonalInformation.h
//  yuntangyi
//
//  Created by yuntangyi on 16/9/7.
//  Copyright © 2016年 yuntangyi. All rights reserved.
//

#import "SZBNetDataManager.h"

@interface SZBNetDataManager (PersonalInformation)
//头像上传doctor_avatar
- (void)uploadUserHeadImageWithFile:(id)file andRandomString:(NSString *)randomString andCode:(NSString *)code success:(SuccessBlockType)successBlock failed:(FailuerBlockType)failedBlock;

//我报名的会议 my_meeting_list
- (void)my_meeting_listWithRandomString:(NSString *)randomString AndIdent_code:(NSString *)ident_code AndPage:(NSString *)page success:(SuccessBlockType)successBlock failed:(FailuerBlockType)failedBlock;
//报名详情meeting_sign_up_info
- (void)meeting_sign_up_infoWithRandomString:(NSString *)randomString AndIdent_code:(NSString *)ident_code andMid:(NSString *)mid success:(SuccessBlockType)successBlock failed:(FailuerBlockType)failedBlock;
//医生基本信息修改 doctor_update
- (void)doctor_updateWithRandomString:(NSString *)randomString andIdent_code:(NSString *)ident_code andHid:(NSString *)hid andDid:(NSString *)did andGender:(NSString *)gender andContent:(NSString *)content andDo_at:(NSString *)do_at andName:(NSString *)name andTtid:(NSString *)ttid success:(SuccessBlockType)successBlock failed:(FailuerBlockType)failedBlock;


@end

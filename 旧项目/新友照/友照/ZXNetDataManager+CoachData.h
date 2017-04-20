//
//  ZXNetDataManager+CoachData.h
//  友照
//
//  Created by chaoyang on 16/11/26.
//  Copyright © 2016年 ZX_XPH. All rights reserved.
//

#import "ZXNetDataManager.h"

@interface ZXNetDataManager (CoachData)
//教练列表
- (void)JiaoLianListWithTimeStamp:(NSString *)timeStamp andSubject:(NSString *)subject andPage:(NSString *)page andSort:(NSString *)sort andName:(NSString *)name andSid:(NSString *)sid  andCity:(NSString*)city success:(SuccessBlockType)successBlock failed:(FailuerBlockType)failedBlock;
//教练列表
- (void)JiaoLianDetailWithTimeStamp:(NSString *)timeStamp andTid:(NSString *)tid success:(SuccessBlockType)successBlock failed:(FailuerBlockType)failedBlock;
//全部评论
- (void)jiaoLianCommentWithTimeStamp:(NSString *)timeStamp andTid:(NSString *)tid andPage:(NSString *)page success:(SuccessBlockType)successBlock failed:(FailuerBlockType)failedBlock;
//预约状态的查询
- (void)YuYueStateWithRndstring:(NSString *)timeStamp andIdent_code:(NSString *)ident_code andSid:(NSString *)sid andTid:(NSString *)tid andErid:(NSString *)erid andErpid:(NSString *)erpid success:(SuccessBlockType)successBlock failed:(FailuerBlockType)failedBlock;
//预约教练 id_card 身份证号
- (void)YuYueJiaoLianWithTimeStamp:(NSString *)timeStamp andIdent_code:(NSString *)ident_code andTid:(NSString *)tid andPhone:(NSString *)phone andName:(NSString *)name andCode:(NSString *)code andId_card:(NSString *)id_card success:(SuccessBlockType)successBlock failed:(FailuerBlockType)failedBlock;
//获取验证码 参数：手机号 验证码类型 时间戳
- (void)userApplyYanZhengMaWithPhoneNum:(NSString *)phoneNum andType:(NSString *)type andTimeString:(NSString *)timeString success:(SuccessBlockType)successBlock failed:(FailuerBlockType)failedBlock;
//上传头像
- (void)uploadUserHeadImageWithFile:(NSData *)file andTimeStamp:(NSString *)timeStamp andCode:(NSString *)code success:(SuccessBlockType)successBlock failed:(FailuerBlockType)failedBlock;
//修改学员的信息 参数：昵称 地区 性别
- (void)modifyUserInfoWithName:(NSString *)name andArea:(NSString *)area andGender:(NSString *)gender andTimeStamp:(NSString *)timeStamp andCode:(NSString *)code success:(SuccessBlockType)successBlock failed:(FailuerBlockType)failedBlock;
@end

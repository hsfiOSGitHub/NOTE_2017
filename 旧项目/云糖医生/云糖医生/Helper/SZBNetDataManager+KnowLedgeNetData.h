//
//  SZBNetDataManager+KnowLedgeNetData.h
//  yuntangyi
//
//  Created by yuntangyi on 16/9/2.
//  Copyright © 2016年 yuntangyi. All rights reserved.
//

#import "SZBNetDataManager.h"

@interface SZBNetDataManager (KnowLedgeNetData)
//资讯类型news_type
-(void)news_typeRandomStamp:(NSString *)randomString andIdent_code:(NSString *)ident_code success:(SuccessBlockType)successBlock failed:(FailuerBlockType)failedBlock;
//资讯news_list
-(void)news_listRandomStamp:(NSString *)randomString andPage:(NSString *)page andIdent_code:(NSString *)ident_code andPid:(NSString *)pid success:(SuccessBlockType)successBlock failed:(FailuerBlockType)failedBlock;
//资讯news_list
-(void)newsRandomStamp:(NSString *)randomString andID:(NSString *)ID success:(SuccessBlockType)successBlock failed:(FailuerBlockType)failedBlock;
//资讯收藏 news_collect
-(void)news_collectWithRandomStamp:(NSString *)randomString AndIdent_code:(NSString *)ident_code AndId:(NSString *)ID success:(SuccessBlockType)successBlock failed:(FailuerBlockType)failedBlock;
//资讯点赞 news_praise
-(void)news_praiseWithRandomStamp:(NSString *)randomString AndIdent_code:(NSString *)ident_code AndId:(NSString *)ID success:(SuccessBlockType)successBlock failed:(FailuerBlockType)failedBlock;

//会议列表meeting_list
-(void)meeting_listWithRandomStamp:(NSString *)randomString andIdent_code:(NSString *)ident_code AndPage:(NSString *)page success:(SuccessBlockType)successBlock failed:(FailuerBlockType)failedBlock;
//会议详情meeting_info
-(void)meeting_infoWithID:(NSString *)ID AndRandomStamp:(NSString *)randomString andIdent_code:(NSString *)ident_code success:(SuccessBlockType)successBlock failed:(FailuerBlockType)failedBlock;
//会议报名 meeting_sign_up
-(void)meeting_sign_upWithMid:(NSString *)mid AndRandomStamp:(NSString *)randomString andIdent_code:(NSString *)ident_code success:(SuccessBlockType)successBlock failed:(FailuerBlockType)failedBlock;
@end

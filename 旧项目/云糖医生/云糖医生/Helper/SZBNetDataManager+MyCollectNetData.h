//
//  SZBNetDataManager+MyCollectNetData.h
//  yuntangyi
//
//  Created by yuntangyi on 16/9/18.
//  Copyright © 2016年 yuntangyi. All rights reserved.
//

#import "SZBNetDataManager.h"

@interface SZBNetDataManager (MyCollectNetData)
//我的收藏-资讯列表
- (void)myCollectNewsRandomString:(NSString *)randomString andCode:(NSString *)code andPage:(NSInteger)page success:(SuccessBlockType)successBlock failed:(FailuerBlockType)failedBlock;
//我报名的会议
- (void)myMeetingListRandomString:(NSString *)randomString andCode:(NSString *)code success:(SuccessBlockType)successBlock failed:(FailuerBlockType)failedBlock;
@end

//
//  ZXNetDataManager+ZXkesan_xiangqing.h
//  友照
//
//  Created by ZX on 16/12/5.
//  Copyright © 2016年 ZX_XPH. All rights reserved.
//

#import "ZXNetDataManager.h"

@interface ZXNetDataManager (ZXkesan_xiangqing)

//科三详情  andOP:(NSString *)op
- (void)KeSanMoNiDetailWithTimeStamp:(NSString *)timeStamp andID:(NSString *)ID andWeeked:(NSString *)weeked andIdent_code:(NSString *)ident_code andOP:(NSString *)op success:(SuccessBlockType)successBlock failed:(FailuerBlockType)failedBlock;

//获取教练的评论
- (void)JiaXiaoCommentWithTimeStamp:(NSString *)timeStamp andSid:(NSString *)sid andPage:(NSString *)page success:(SuccessBlockType )successBlock Failed:(FailuerBlockType)failedBlock;

//科三订单详情
- (void)KeSanOrderDetailWithTimeStamp:(NSString *)timeStamp andIdent_code:(NSString *)ident_code andOrder_id:(NSString *)order_id success:(SuccessBlockType)successBlock failed:(FailuerBlockType)failedBlock;
    
//系统消息
-(void)xitongxiaoxiWithTimeStamp:(NSString *)timeStamp andIdent_code:(NSString *)ident_code success:(SuccessBlockType )successBlock Failed:(FailuerBlockType)failedBlock;
    
//修改用户的信息，名字，性别
- (void)modifyUserInfoSuccess:(SuccessBlockType)successBlock failed:(FailuerBlockType)failedBlock;



//检测版本
-(void)jiancebanbensuccess:(SuccessBlockType )successBlock Failed:(FailuerBlockType)failedBlock;

//上传头像
- (void)uploadUserHeadImageWithFile:(NSData *)file andTimeStamp:(NSString *)timeStamp andCode:(NSString *)code success:(SuccessBlockType)successBlock failed:(FailuerBlockType)failedBlock;

@end

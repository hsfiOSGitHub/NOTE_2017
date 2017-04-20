//
//  ZXNetDataManager+kesanmoni.h
//  友照
//
//  Created by ZX on 16/11/28.
//  Copyright © 2016年 ZX_XPH. All rights reserved.
//

#import "ZXNetDataManager.h"

@interface ZXNetDataManager (kesanmoni)


//科三详情  andOP:(NSString *)op
- (void)KeSanMoNiWithTimeStamp:(NSString *)timeStamp andID:(NSString *)ID andWeeked:(NSString *)weeked andIdent_code:(NSString *)ident_code andOP:(NSString *)op success:(SuccessBlockType)successBlock failed:(FailuerBlockType)failedBlock;

@end

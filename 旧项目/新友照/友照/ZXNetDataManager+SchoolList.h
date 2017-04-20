//
//  ZXNetDataManager+SchoolList.h
//  友照
//
//  Created by monkey2016 on 16/11/26.
//  Copyright © 2016年 ZX_XPH. All rights reserved.
//

#import "ZXNetDataManager.h"

@interface ZXNetDataManager (SchoolList)
//获取所在城市驾校位置坐标
-(void)schoolLocationDataWithRndstring:(NSString *)rndstring andCity:(NSString *)city success:(SuccessBlockType)successBlock failed:(FailuerBlockType)failedBlock;
//驾校列表
-(void)schoolListDataWithM:(NSString *)m andRndstring:(NSString *)rndstring andSort:(NSString *)sort andPage:(NSString *)page andName:(NSString *)name andSchool_ids:(NSString *)school_ids andCity:(NSString *)city success:(SuccessBlockType)successBlock failed:(FailuerBlockType)failedBlock;
//驾校详情
-(void)schoolDetailDataWithM:(NSString *)m andRndstring:(NSString *)rndstring andSid:(NSString *)sid success:(SuccessBlockType)successBlock failed:(FailuerBlockType)failedBlock;
@end

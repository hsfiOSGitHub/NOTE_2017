//
//  SZBNetDataManager+department.h
//  yuntangyi
//
//  Created by yuntangyi on 16/9/29.
//  Copyright © 2016年 yuntangyi. All rights reserved.
//

#import "SZBNetDataManager.h"

@interface SZBNetDataManager (department)
//医院科室 hospital_department
- (void)hospital_departmentRandomString:(NSString *)randomString success:(SuccessBlockType)successBlock failed:(FailuerBlockType)failedBlock;
//医生职称列表 get_doctor_type
- (void)get_doctor_typeRandomString:(NSString *)randomString success:(SuccessBlockType)successBlock failed:(FailuerBlockType)failedBlock;
@end

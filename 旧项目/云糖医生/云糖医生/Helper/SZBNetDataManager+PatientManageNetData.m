//
//  SZBNetDataManager+PatientManageNetData.m
//  yuntangyi
//
//  Created by yuntangyi on 16/9/7.
//  Copyright © 2016年 yuntangyi. All rights reserved.
//

#import "SZBNetDataManager+PatientManageNetData.h"

@implementation SZBNetDataManager (PatientManageNetData)
//患者管理
- (void)patientListRandomString:(NSString *)randomString andCode:(NSString *)code success:(SuccessBlockType)successBlock failed:(FailuerBlockType)failedBlock {
    self.successBlock = successBlock;
    self.failedBlock = failedBlock;
    NSString *url =[NSString stringWithFormat:SPatient_list_Url,randomString,code];
    //转码
    NSString *NewUrl = [url stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]];
    NSLog(@"%@", NewUrl);
    [self.manager GET:NewUrl parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (self.successBlock) {
            self.successBlock(task,responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (self.failedBlock) {
            self.failedBlock(task,error);
        }
    }];
}
//患者详情patient_content
- (void)patientContentRandomString:(NSString *)randomString andCode:(NSString *)code andPatientIds:(NSString *)ids success:(SuccessBlockType)successBlock failed:(FailuerBlockType)failedBlock {
    self.successBlock = successBlock;
    self.failedBlock = failedBlock;
    NSString *url =[NSString stringWithFormat:SPatient_content_Url,randomString,code, ids];
    //转码
    NSString *NewUrl = [url stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]];
    NSLog(@"%@", NewUrl);
    [self.manager GET:NewUrl parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (self.successBlock) {
            self.successBlock(task,responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (self.failedBlock) {
            self.failedBlock(task,error);
        }
    }];
}
//搜索患者
- (void)patientSearchRandomString:(NSString *)randomString andCode:(NSString *)code andStr:(NSString *)str success:(SuccessBlockType)successBlock failed:(FailuerBlockType)failedBlock {
    self.successBlock = successBlock;
    self.failedBlock = failedBlock;
    NSString *url =[NSString stringWithFormat:SPatient_search_Url,randomString  ,code,str];
    //转码
    NSString *NewUrl = [url stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]];
    NSLog(@"%@", NewUrl);
    [self.manager GET:NewUrl parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (self.successBlock) {
            self.successBlock(task,responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (self.failedBlock) {
            self.failedBlock(task,error);
        }
    }];
    
}
//按手机号搜索患者
- (void)SearchPhoneRandomString:(NSString *)randomString andCode:(NSString *)code andPhone:(NSString *)phone success:(SuccessBlockType)successBlock failed:(FailuerBlockType)failedBlock {
    self.successBlock = successBlock;
    self.failedBlock = failedBlock;
    NSString *url =[NSString stringWithFormat:SSearch_phone_Url,randomString  ,code,phone];
    //转码
    NSString *NewUrl = [url stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]];
    NSLog(@"%@", NewUrl);
    [self.manager GET:NewUrl parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (self.successBlock) {
            self.successBlock(task,responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (self.failedBlock) {
            self.failedBlock(task,error);
        }
    }];
}
//邀请诊治patient_invite
- (void)patientInvitePatientIds:(NSString *)ids andRandomString:(NSString *)randomString andCode:(NSString *)code andDate:(NSString *)date andTime_point:(NSString *)timePoint success:(SuccessBlockType)successBlock failed:(FailuerBlockType)failedBlock {
    self.successBlock = successBlock;
    self.failedBlock = failedBlock;
    NSString *url =[NSString stringWithFormat:SPatient_invite_Url,ids,randomString,code, date, timePoint];
    //转码
    NSString *NewUrl = [url stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]];
    NSLog(@"%@", NewUrl);
    [self.manager GET:NewUrl parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (self.successBlock) {
            self.successBlock(task,responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (self.failedBlock) {
            self.failedBlock(task,error);
        }
    }];
}
//添加患者
- (void)patientAddRandomString:(NSString *)randomString andCode:(NSString *)code andPatient_id:(NSString *)patient_id andActivity_id:(NSString *)activity_id success:(SuccessBlockType)successBlock failed:(FailuerBlockType)failedBlock {
    self.successBlock = successBlock;
    self.failedBlock = failedBlock;
    NSString *url =[NSString stringWithFormat:SPatient_add_Url,randomString,code, patient_id, activity_id];
    //转码
    NSString *NewUrl = [url stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]];
    NSLog(@"%@", NewUrl);
    [self.manager GET:NewUrl parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (self.successBlock) {
            self.successBlock(task,responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (self.failedBlock) {
            self.failedBlock(task,error);
        }
    }];
}
//患者健康资料
- (void)getPatientRandomString:(NSString *)randomString andCode:(NSString *)code andPatient_id:(NSString *)patient_id success:(SuccessBlockType)successBlock failed:(FailuerBlockType)failedBlock {
    self.successBlock = successBlock;
    self.failedBlock = failedBlock;
    NSString *url =[NSString stringWithFormat:SGet_patient_Url,randomString,code, patient_id];
    //转码
    NSString *NewUrl = [url stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]];
    NSLog(@"%@", NewUrl);
    [self.manager GET:NewUrl parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (self.successBlock) {
            self.successBlock(task,responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (self.failedBlock) {
            self.failedBlock(task,error);
        }
    }];
}
//患者血糖记录
- (void)getPatientBloodsugarRandomString:(NSString *)randomString andCode:(NSString *)code andPatient_id:(NSString *)patient_id andStartDate:(NSString *)startDate andEndDate:(NSString *)endDate success:(SuccessBlockType)successBlock failed:(FailuerBlockType)failedBlock {
    self.successBlock = successBlock;
    self.failedBlock = failedBlock;
    NSString *url =[NSString stringWithFormat:SGet_patient_bloodsugar_Url,randomString,code, patient_id, startDate, endDate];
    //转码
    NSString *NewUrl = [url stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]];
    NSLog(@"%@", NewUrl);
    [self.manager GET:NewUrl parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (self.successBlock) {
            self.successBlock(task,responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (self.failedBlock) {
            self.failedBlock(task,error);
        }
    }];
}

//患者运动饮食胰岛素口服药统计
- (void)StatisticsM:(NSString *)m andRandomString:(NSString *)randomString andCode:(NSString *)code andPatient_id:(NSString *)patient_id andStartDate:(NSString *)startDate andEndDate:(NSString *)endDate success:(SuccessBlockType)successBlock failed:(FailuerBlockType)failedBlock {
    self.successBlock = successBlock;
    self.failedBlock = failedBlock;
    NSString *url =[NSString stringWithFormat:SStatistics_Url,m,randomString,code, patient_id,startDate,endDate];
    //转码
    NSString *NewUrl = [url stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]];
    NSLog(@"%@", NewUrl);
    [self.manager GET:NewUrl parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (self.successBlock) {
            self.successBlock(task,responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (self.failedBlock) {
            self.failedBlock(task,error);
        }
    }];
    
}
@end

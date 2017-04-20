//
//  SZBNetDataManager+DoctorCerNetData.m
//  SZB_doctor
//
//  Created by chaoyang on 16/9/20.
//  Copyright © 2016年 monkey2016. All rights reserved.
//

#import "SZBNetDataManager+DoctorCerNetData.h"

@implementation SZBNetDataManager (DoctorCerNetData)
//证件认证
- (void)doctorAuthRandomString:(NSString *)randomString andCode:(NSString *)code andCardUp:(id)cardUp success:(SuccessBlockType)successBlock failed:(FailuerBlockType)failedBlock {
    
}
//联名认证
- (void)doctorAuth2RandomString:(NSString *)randomString andCode:(NSString *)code andPhone1:(NSString *)phone1 andPhone2:(NSString *)phone2 success:(SuccessBlockType)successBlock failed:(FailuerBlockType)failedBlock {
    self.successBlock = successBlock;
    self.failedBlock = failedBlock;
    NSString *url =[NSString stringWithFormat:SDoctor_auth2_Url,randomString,code, phone1, phone2];
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

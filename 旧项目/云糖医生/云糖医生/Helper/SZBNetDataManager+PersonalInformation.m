//
//  SZBNetDataManager+PersonalInformation.m
//  yuntangyi
//
//  Created by yuntangyi on 16/9/7.
//  Copyright © 2016年 yuntangyi. All rights reserved.
//

#import "SZBNetDataManager+PersonalInformation.h"

@implementation SZBNetDataManager (PersonalInformation)
//头像上传doctor_avatar
- (void)uploadUserHeadImageWithFile:(id)file andRandomString:(NSString *)randomString andCode:(NSString *)code success:(SuccessBlockType)successBlock failed:(FailuerBlockType)failedBlock {
    self.successBlock = successBlock;
    self.failedBlock = failedBlock;
    NSString *fileName = [NSString stringWithFormat:@"%@.jpg",[ToolManager getCurrentTimeStamp]];
    NSString *url =[NSString stringWithFormat:SDoctor_avatar_Url, randomString , code];
    //转码
    NSString *NewUrl = [url stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]];
    [self.manager POST:NewUrl parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
    [formData appendPartWithFileData:file name:@"file" fileName:fileName mimeType:@"image/jpg"];
//       NSLog(@"%@",formData);
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
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

//我报名的会议 my_meeting_list
- (void)my_meeting_listWithRandomString:(NSString *)randomString AndIdent_code:(NSString *)ident_code AndPage:(NSString *)page success:(SuccessBlockType)successBlock failed:(FailuerBlockType)failedBlock {
    self.successBlock = successBlock;
    self.failedBlock = failedBlock;
    NSString *url =[NSString stringWithFormat:SMy_meeting_list_Url, randomString, ident_code, page];
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
//报名详情meeting_sign_up_info
- (void)meeting_sign_up_infoWithRandomString:(NSString *)randomString AndIdent_code:(NSString *)ident_code andMid:(NSString *)mid success:(SuccessBlockType)successBlock failed:(FailuerBlockType)failedBlock {
    self.successBlock = successBlock;
    self.failedBlock = failedBlock;
    NSString *url =[NSString stringWithFormat:SMeeting_sign_up_info_Url, randomString, ident_code, mid];
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
//医生基本信息修改 doctor_update
- (void)doctor_updateWithRandomString:(NSString *)randomString andIdent_code:(NSString *)ident_code andHid:(NSString *)hid andDid:(NSString *)did andGender:(NSString *)gender andContent:(NSString *)content andDo_at:(NSString *)do_at andName:(NSString *)name andTtid:(NSString *)ttid success:(SuccessBlockType)successBlock failed:(FailuerBlockType)failedBlock {
    self.successBlock = successBlock;
    self.failedBlock = failedBlock;
    NSString *url =[NSString stringWithFormat:SDoctor_update_Url, randomString, ident_code, hid, did, gender, content, do_at, name, ttid];
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

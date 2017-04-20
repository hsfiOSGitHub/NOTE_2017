//
//  ZXNetDataManager+CoachData.m
//  友照
//
//  Created by chaoyang on 16/11/26.
//  Copyright © 2016年 ZX_XPH. All rights reserved.
//

#import "ZXNetDataManager+CoachData.h"

@implementation ZXNetDataManager (CoachData)
//教练列表
- (void)JiaoLianListWithTimeStamp:(NSString *)timeStamp andSubject:(NSString *)subject andPage:(NSString *)page andSort:(NSString *)sort andName:(NSString *)name andSid:(NSString *)sid  andCity:(NSString*)city success:(SuccessBlockType)successBlock failed:(FailuerBlockType)failedBlock{
    self.failedBlock = failedBlock;
    self.successBlock = successBlock;
    NSDictionary *dic = @{@"m":@"teacher_list", @"rndstring": timeStamp, @"subject":subject, @"sort":sort, @"page":page, @"sid":sid, @"name":name, @"city":city};
//    NSLog(@"http://test.youzhaola.com/api/v23/index.php?m=teacher_list&rndstring=%@&subject=%@&sort=%@&page=%@&sid=%@&name=%@&city=%@",timeStamp,subject,sort,page,sid,name,city);
    [self.manager POST:ZX_URL parameters:dic progress:^(NSProgress * _Nonnull downloadProgress) {
        
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

//教练详情
- (void)JiaoLianDetailWithTimeStamp:(NSString *)timeStamp andTid:(NSString *)tid success:(SuccessBlockType)successBlock failed:(FailuerBlockType)failedBlock
{
    self.failedBlock = failedBlock;
    self.successBlock = successBlock;
    NSDictionary *dic = @{@"m":@"teacher", @"rndstring": timeStamp, @"tid":tid};
    NSLog(@"http://test.youzhaola.com/api/v23/index.php?m=teacher&rndstring=%@&tid=%@",timeStamp,tid);
    [self.manager POST:ZX_URL parameters:dic progress:^(NSProgress * _Nonnull downloadProgress) {
        
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
//教练全部评论
- (void)jiaoLianCommentWithTimeStamp:(NSString *)timeStamp andTid:(NSString *)tid andPage:(NSString *)page success:(SuccessBlockType)successBlock failed:(FailuerBlockType)failedBlock {
    self.failedBlock = failedBlock;
    self.successBlock = successBlock;
    NSDictionary *dic = @{@"m":@"teacher_comment", @"rndstring": timeStamp, @"tid":tid, @"page":page};
    NSLog(@"http://test.youzhaola.com/api/v23/index.php?m=teacher_comment&rndstring=%@&tid=%@&page=%@",timeStamp,tid, page);
    [self.manager POST:ZX_URL parameters:dic progress:^(NSProgress * _Nonnull downloadProgress) {
        
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
//预约状态的查询
- (void)YuYueStateWithRndstring:(NSString *)timeStamp andIdent_code:(NSString *)ident_code andSid:(NSString *)sid andTid:(NSString *)tid andErid:(NSString *)erid andErpid:(NSString *)erpid success:(SuccessBlockType)successBlock failed:(FailuerBlockType)failedBlock {
    self.failedBlock = failedBlock;
    self.successBlock = successBlock;
    NSDictionary *dic = @{@"m":@"book_status", @"rndstring": timeStamp, @"ident_code":ident_code, @"sid":sid, @"tid":tid,@"erid":erid, @"erpid":erpid};
    NSLog(@"http://test.youzhaola.com/api/v23/index.php?m=book_status&rndstring=%@&ident_code=%@&sid=%@&tid=%@&erid=%@&erpid=%@",timeStamp,ident_code,sid,tid, erid,erpid);
    [self.manager POST:ZX_URL parameters:dic progress:^(NSProgress * _Nonnull downloadProgress) {
        
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
//预约教练 id_card 身份证号
- (void)YuYueJiaoLianWithTimeStamp:(NSString *)timeStamp andIdent_code:(NSString *)ident_code andTid:(NSString *)tid andPhone:(NSString *)phone andName:(NSString *)name andCode:(NSString *)code andId_card:(NSString *)id_card success:(SuccessBlockType)successBlock failed:(FailuerBlockType)failedBlock {
    self.failedBlock = failedBlock;
    self.successBlock = successBlock;
    NSDictionary *dic = @{@"m":@"book_teacher", @"rndstring": timeStamp, @"ident_code":ident_code, @"tid":tid,@"phone":phone, @"name":name, @"code":code, @"id_card":id_card};
    NSLog(@"http://test.youzhaola.com/api/v23/index.php?m=book_teacher&rndstring=%@&ident_code=%@&tid=%@&phone=%@&name=%@&code=%@&id_card=%@",timeStamp,ident_code,tid, phone,name, code, id_card);
    [self.manager POST:ZX_URL parameters:dic progress:^(NSProgress * _Nonnull downloadProgress) {
        
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
//获取验证码 参数：手机号 验证码类型 时间戳
- (void)userApplyYanZhengMaWithPhoneNum:(NSString *)phoneNum andType:(NSString *)type andTimeString:(NSString *)timeString success:(SuccessBlockType)successBlock failed:(FailuerBlockType)failedBlock
{
    self.failedBlock = failedBlock;
    self.successBlock = successBlock;
    NSDictionary *dic = @{@"m":@"message", @"rndstring":timeString, @"phone":phoneNum,@"type":type};
    NSLog(@"http://test.youzhaola.com/api/v23/index.php?m=message&phone=%@&type=%@&rndstring=%@",phoneNum,type,timeString);
    [self.manager POST:ZX_URL parameters:dic progress:^(NSProgress * _Nonnull downloadProgress) {
        
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
//上传头像
- (void)uploadUserHeadImageWithFile:(NSData *)file andTimeStamp:(NSString *)timeStamp andCode:(NSString *)code success:(SuccessBlockType)successBlock failed:(FailuerBlockType)failedBlock{
    self.successBlock = successBlock;
    self.failedBlock = failedBlock;
    
    NSString *fileName = [NSString stringWithFormat:@"%@.jpg",[ZXDriveGOHelper getCurrentTimeStamp]];
    NSDictionary *parameters = @{@"m":@"avatar",
                                 @"rndstring":timeStamp,
                                 @"ident_code":code};
    NSMutableString *url = [NSMutableString string];
    [url appendFormat:@"%@",ZX_URL];
    [parameters enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        if ([key isEqualToString:@"m"]) {
            [url appendFormat:@"?%@=%@",key,obj];
        }else{
            [url appendFormat:@"&%@=%@",key,obj];
        }
    }];
    NSLog(@"%@",url);
    [self.manager POST:ZX_URL parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        [formData appendPartWithFileData:file name:@"file" fileName:fileName mimeType:@"image/jpg"];
        
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
//修改学员的信息 参数：昵称 地区 性别
- (void)modifyUserInfoWithName:(NSString *)name andArea:(NSString *)area andGender:(NSString *)gender andTimeStamp:(NSString *)timeStamp andCode:(NSString *)code success:(SuccessBlockType)successBlock failed:(FailuerBlockType)failedBlock{
    self.successBlock = successBlock;
    self.failedBlock = failedBlock;
    NSDictionary *dict = @{@"m":@"update",
                           @"nickname":name,
                           @"area":area,
                           @"gender":gender,
                           @"rndstring":timeStamp,
                           @"ident_code":code
                           };
    [self.manager POST:ZX_URL parameters:dict progress:^(NSProgress * _Nonnull uploadProgress) {
        
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

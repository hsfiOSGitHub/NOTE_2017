//
//  ZXNetDataManager+ZXkesan_xiangqing.m
//  友照
//
//  Created by ZX on 16/12/5.
//  Copyright © 2016年 ZX_XPH. All rights reserved.
//

#import "ZXNetDataManager+ZXkesan_xiangqing.h"

@implementation ZXNetDataManager (ZXkesan_xiangqing)

//科三详情  andOP:(NSString *)op
- (void)KeSanMoNiDetailWithTimeStamp:(NSString *)timeStamp andID:(NSString *)ID andWeeked:(NSString *)weeked andIdent_code:(NSString *)ident_code andOP:(NSString *)op success:(SuccessBlockType)successBlock failed:(FailuerBlockType)failedBlock {
    self.successBlock = successBlock;
    self.failedBlock = failedBlock;
    
    if(!weeked)
    {
        NSDictionary *parameters = @{@"m":@"book_exam_carinfo",
                                     @"rndstring":timeStamp,
                                     @"id":ID,
                                     @"weekd":@"",
                                     @"ident_code":ident_code,
                                     };
        
        [self.manager POST:ZX_URL parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            if (self.successBlock)
            {
                self.successBlock(task,responseObject);
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
            if (self.failedBlock)
            {
                self.failedBlock(task,error);
            }
        }];
    }
    else
    {
        NSDictionary *parameters = @{@"m":@"book_exam_carinfo",
                                     @"rndstring":timeStamp,
                                     @"id":ID,
                                     @"weekd":weeked,
                                     @"ident_code":ident_code,
                                     };
        [self.manager POST:ZX_URL parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            if (self.successBlock)
            {
                self.successBlock(task,responseObject);
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
            if (self.failedBlock)
            {
                self.failedBlock(task,error);
            }
        }];
    }
}

//科三订单详情
- (void)KeSanOrderDetailWithTimeStamp:(NSString *)timeStamp andIdent_code:(NSString *)ident_code andOrder_id:(NSString *)order_id success:(SuccessBlockType)successBlock failed:(FailuerBlockType)failedBlock
{
    self.successBlock = successBlock;
    self.failedBlock = failedBlock;
    NSDictionary *parameters = @{@"m":@"book_order_orderinfo",
                                 @"rndstring":timeStamp,
                                 @"ident_code":ident_code,
                                 @"order_id":order_id,
                                 };

    [self.manager POST:ZX_URL parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress)
     {
        
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
                                 @"ident_code":code
                                 };

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
    

//系统消息
-(void)xitongxiaoxiWithTimeStamp:(NSString *)timeStamp andIdent_code:(NSString *)ident_code success:(SuccessBlockType )successBlock Failed:(FailuerBlockType)failedBlock
{
    self.successBlock = successBlock;
    self.failedBlock = failedBlock;
    
    NSDictionary *parameters = @{@"m":@"info_list",
                                 @"rndstring":timeStamp,
                                 @"ident_code":ident_code,
                                 };
    
    [self.manager POST:ZX_URL parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {
        
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

    
//每次用户修改用户的信息，先归档，在提交给服务器
- (void)modifyUserInfoSuccess:(SuccessBlockType)successBlock failed:(FailuerBlockType)failedBlock {
    self.successBlock = successBlock;
    self.failedBlock = failedBlock;

    NSDictionary *parameters = @{@"m":@"update",
                                 @"rndstring":[ZXDriveGOHelper getCurrentTimeStamp],
                                 @"nickname":[ZXUD objectForKey:@"username"],
                                 @"area":[ZXUD objectForKey:@"personalCity"],
                                 @"gender":[ZXUD objectForKey:@"sex"],
                                 @"ident_code":[ZXUD objectForKey:@"ident_code"],
                                 };
    [self.manager POST:ZX_URL parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {
        
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


//检测版本
-(void)jiancebanbensuccess:(SuccessBlockType )successBlock Failed:(FailuerBlockType)failedBlock
{
    self.successBlock = successBlock;
    self.failedBlock = failedBlock;
    
    [self.manager POST:@"http://itunes.apple.com/lookup?id=1112427256" parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
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
    

//获取教练的评论
- (void)JiaXiaoCommentWithTimeStamp:(NSString *)timeStamp andSid:(NSString *)sid andPage:(NSString *)page success:(SuccessBlockType )successBlock Failed:(FailuerBlockType)failedBlock {
    self.successBlock = successBlock;
    self.failedBlock = failedBlock;
    
    NSDictionary *parameters = @{@"m":@"teacher_comment",
                                 @"rndstring":timeStamp,
                                 @"tid":sid,
                                 @"page":page,
                                 };

  
    [self.manager POST:ZX_URL parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {
        
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

//
//  ZXNetDataManager+kesanmoni.m
//  友照
//
//  Created by ZX on 16/11/28.
//  Copyright © 2016年 ZX_XPH. All rights reserved.
//

#import "ZXNetDataManager+kesanmoni.h"

@implementation ZXNetDataManager (kesanmoni)


//科三详情  andOP:(NSString *)op
- (void)KeSanMoNiWithTimeStamp:(NSString *)timeStamp andID:(NSString *)ID andWeeked:(NSString *)weeked andIdent_code:(NSString *)ident_code andOP:(NSString *)op success:(SuccessBlockType)successBlock failed:(FailuerBlockType)failedBlock {
    self.successBlock = successBlock;
    self.failedBlock = failedBlock;
    
    NSMutableDictionary* dic=[[NSMutableDictionary alloc]init];
    [dic setValue:@"book_exam_carinfo" forKey:@"m"];
    [dic setValue:timeStamp forKey:@"rndstring"];
    [dic setValue:ID forKey:@"id"];
    [dic setValue:weeked forKey:@"weekd"];
    [dic setValue:ident_code forKey:@"ident_code"];
  
    [self.manager POST:ZX_URL parameters:dic progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (self.successBlock) {
            self.successBlock(task,responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        if (self.failedBlock)
        {
            self.failedBlock(task,error);
        }
    }];
}
@end

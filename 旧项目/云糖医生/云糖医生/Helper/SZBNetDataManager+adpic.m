//
//  SZBNetDataManager+adpic.m
//  yuntangyi
//
//  Created by yuntangyi on 16/9/23.
//  Copyright © 2016年 yuntangyi. All rights reserved.
//

#import "SZBNetDataManager+adpic.h"

@implementation SZBNetDataManager (adpic)
//开屏图adpic
- (void)SAdpicSuccess:(SuccessBlockType)successBlock failed:(FailuerBlockType)failedBlock {
    self.successBlock = successBlock;
    self.failedBlock = failedBlock;
    NSString *url =[NSString stringWithFormat:SAdpic_Url];
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

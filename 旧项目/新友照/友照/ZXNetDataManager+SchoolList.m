//
//  ZXNetDataManager+SchoolList.m
//  友照
//
//  Created by monkey2016 on 16/11/26.
//  Copyright © 2016年 ZX_XPH. All rights reserved.
//

#import "ZXNetDataManager+SchoolList.h"

@implementation ZXNetDataManager (SchoolList)

//获取所在城市驾校位置坐标
-(void)schoolLocationDataWithRndstring:(NSString *)rndstring andCity:(NSString *)city success:(SuccessBlockType)successBlock failed:(FailuerBlockType)failedBlock{
    self.successBlock = successBlock;
    self.failedBlock = failedBlock;
    NSDictionary *parameters = @{@"m":@"school_location_list",
                                 @"rndstring":rndstring,
                                 @"city":city};
    
    [self.manager POST:ZX_URL parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        
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

//驾校列表
-(void)schoolListDataWithM:(NSString *)m andRndstring:(NSString *)rndstring andSort:(NSString *)sort andPage:(NSString *)page andName:(NSString *)name andSchool_ids:(NSString *)school_ids andCity:(NSString *)city success:(SuccessBlockType)successBlock failed:(FailuerBlockType)failedBlock{
    self.successBlock = successBlock;
    self.failedBlock = failedBlock;
    NSDictionary *parameters = @{@"m":m,
                                 @"rndstring":rndstring,
                                 @"sort":sort,
                                 @"page":page,
                                 @"name":name,
                                 @"school_ids":school_ids,
                                 @"city":city};
    
    [self.manager POST:ZX_URL parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        
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
//驾校详情
-(void)schoolDetailDataWithM:(NSString *)m andRndstring:(NSString *)rndstring andSid:(NSString *)sid success:(SuccessBlockType)successBlock failed:(FailuerBlockType)failedBlock
{
    self.successBlock = successBlock;
    self.failedBlock = failedBlock;
    NSDictionary *parameters = @{@"m":m,
                                 @"rndstring":rndstring,
                                 @"sid":sid};
    NSMutableString *url = [NSMutableString string];
    [url appendFormat:@"%@",ZX_URL];
    [parameters enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        if ([key isEqualToString:@"m"]) {
            [url appendFormat:@"?%@=%@",key,obj];
        }else{
            [url appendFormat:@"&%@=%@",key,obj];
        }
    }];
    YZLog(@"%@",url);
    [self.manager POST:ZX_URL parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        
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

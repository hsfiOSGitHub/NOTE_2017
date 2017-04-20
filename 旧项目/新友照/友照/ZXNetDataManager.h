//
//  ZXNetDataManager.h
//  ZXJiaXiao
//
//  Created by ZX on 16/3/3.
//  Copyright © 2016年 ZX. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"

typedef void(^SuccessBlockType)(NSURLSessionDataTask *task, id responseObject);
typedef void(^FailuerBlockType)(NSURLSessionTask *task, NSError *error);

@interface ZXNetDataManager : NSObject
@property (nonatomic, copy) SuccessBlockType successBlock;
@property (nonatomic, copy) FailuerBlockType failedBlock;
@property (nonatomic) AFHTTPSessionManager *manager;
+ (instancetype)manager;
+ (instancetype)manager2;
+ (instancetype)manager3;
+ (instancetype)manager4;
+ (instancetype)manager5;
@end

//
//  SZBNetDataManager.h
//  yuntangyi
//
//  Created by yuntangyi on 16/9/2.
//  Copyright © 2016年 yuntangyi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"


typedef void(^SuccessBlockType)(NSURLSessionDataTask *task, id responseObject);
typedef void(^FailuerBlockType)(NSURLSessionTask *task, NSError *error);

@interface SZBNetDataManager : NSObject

@property (nonatomic, strong) SuccessBlockType successBlock;
@property (nonatomic, strong) FailuerBlockType failedBlock;
@property (nonatomic) AFHTTPSessionManager *manager;

+ (SZBNetDataManager *)manager;
@end

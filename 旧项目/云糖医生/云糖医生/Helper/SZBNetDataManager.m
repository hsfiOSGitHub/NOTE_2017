//
//  SZBNetDataManager.m
//  yuntangyi
//
//  Created by yuntangyi on 16/9/2.
//  Copyright © 2016年 yuntangyi. All rights reserved.
//

#import "SZBNetDataManager.h"

@implementation SZBNetDataManager
static SZBNetDataManager *manager;
//单例的创建
+ (SZBNetDataManager *)manager {
    if (!manager) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            manager = [[SZBNetDataManager alloc]init];
        });
    }
    return manager;
}
- (instancetype)init
{
    self = [super init];
    if (self) {
        _manager = [AFHTTPSessionManager manager];
        NSMutableSet *set = [NSMutableSet setWithSet:_manager.responseSerializer.acceptableContentTypes];
        
        [set addObject:@"text/html"];
        _manager.responseSerializer.acceptableContentTypes = set;
        //
//        AFSecurityPolicy *securityPolicy = [[AFSecurityPolicy alloc] init];
//        [securityPolicy setAllowInvalidCertificates:YES];
//        [_manager setSecurityPolicy:securityPolicy];
//        _manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    }
    return self;
}

@end

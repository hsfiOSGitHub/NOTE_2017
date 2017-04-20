//
//  Created by ZX on 16/3/3.
//  Copyright © 2016年 ZX. All rights reserved.
//

#import "ZXNetDataManager.h"
@interface ZXNetDataManager()

@end

static ZXNetDataManager *_s = nil;
static ZXNetDataManager *_s2 = nil;
static ZXNetDataManager *_s3 = nil;
static ZXNetDataManager *_s4 = nil;
static ZXNetDataManager *_s5 = nil;

@implementation ZXNetDataManager
+ (instancetype)manager
{
    @synchronized(self)
    {
        //判断网络状态
        if ([ZXUD boolForKey:@"NetDataState"])
        {
            //取消之前的网络的请求
            if (_s == nil)
            {
                _s = [[ZXNetDataManager alloc] init];
                _s.manager.responseSerializer = [AFHTTPResponseSerializer serializer];
            }
            //取消之前的网络的请求
            [_s.manager.operationQueue cancelAllOperations];
        }
        else
        {
            [MBProgressHUD showSuccess:@"网络不好，请稍后重试。"];
        }
    }
    return _s;
}

+ (instancetype)manager2
{
    @synchronized(self)
    {
        //判断网络状态
        if ([ZXUD boolForKey:@"NetDataState"])
        {
            //取消之前的网络的请求
            if (_s2 == nil)
            {
                _s2 = [[ZXNetDataManager alloc] init];
                _s2.manager.responseSerializer = [AFHTTPResponseSerializer serializer];
            }
            //取消之前的网络的请求
            [_s2.manager.operationQueue cancelAllOperations];
        }
        else
        {
            [MBProgressHUD showSuccess:@"网络不好，请稍后重试。"];
        }
    }
    return _s2;
}


+ (instancetype)manager3
{
    @synchronized(self)
    {
        //判断网络状态
        if ([ZXUD boolForKey:@"NetDataState"])
        {
            //取消之前的网络的请求
            if (_s3 == nil)
            {
                _s3 = [[ZXNetDataManager alloc] init];
                _s3.manager.responseSerializer = [AFHTTPResponseSerializer serializer];
            }
            //取消之前的网络的请求
            [_s3.manager.operationQueue cancelAllOperations];
        }
        else
        {
            [MBProgressHUD showSuccess:@"网络不好，请稍后重试。"];
        }
    }
    return _s3;
}
+ (instancetype)manager4
{
    @synchronized(self)
    {
        //判断网络状态
        if ([ZXUD boolForKey:@"NetDataState"])
        {
            //取消之前的网络的请求
            if (_s4 == nil)
            {
                _s4 = [[ZXNetDataManager alloc] init];
                _s4.manager.responseSerializer = [AFHTTPResponseSerializer serializer];
            }
            //取消之前的网络的请求
            [_s4.manager.operationQueue cancelAllOperations];
        }
        else
        {
            [MBProgressHUD showSuccess:@"网络不好，请稍后重试。"];
        }
    }
    return _s4;
}
+ (instancetype)manager5
{
    @synchronized(self)
    {
        //判断网络状态
        if ([ZXUD boolForKey:@"NetDataState"])
        {
            //取消之前的网络的请求
            if (_s5 == nil)
            {
                _s5 = [[ZXNetDataManager alloc] init];
                _s5.manager.responseSerializer = [AFHTTPResponseSerializer serializer];
            }
            //取消之前的网络的请求
            [_s5.manager.operationQueue cancelAllOperations];
        }
        else
        {
            [MBProgressHUD showSuccess:@"网络不好，请稍后重试。"];
        }
    }
    return _s5;
}

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        _manager = [AFHTTPSessionManager manager];
        NSMutableSet *set = [NSMutableSet setWithSet:_manager.responseSerializer.acceptableContentTypes];
        [set addObject:@"text/html"];
        _manager.responseSerializer.acceptableContentTypes = set;
    }
    return self;
}


@end

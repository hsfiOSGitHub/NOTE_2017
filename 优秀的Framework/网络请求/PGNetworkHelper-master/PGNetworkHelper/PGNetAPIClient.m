//
//  PGNetAPIClient.m
//
//  Created by piggybear on 16/8/22.
//  Copyright © 2016年 piggybear. All rights reserved.
//

#import "PGNetAPIClient.h"

@implementation PGNetAPIClient

static NSString *_baseUrl = @"";
static AFSSLPinningMode _pinningMode = AFSSLPinningModeNone;

+ (instancetype)sharedClient {
    static PGNetAPIClient *_sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSURLSessionConfiguration *sessionConfiguration = [NSURLSessionConfiguration ephemeralSessionConfiguration];
        _sharedClient = [[PGNetAPIClient alloc] initWithBaseURL:[NSURL URLWithString:_baseUrl] sessionConfiguration:sessionConfiguration];
        _sharedClient.securityPolicy = [AFSecurityPolicy policyWithPinningMode:_pinningMode];
    });
    return _sharedClient;
}

+ (void)baseUrl:(NSString *)baseUrl {
    _baseUrl = baseUrl;
}

+ (void)policyWithPinningMode:(AFSSLPinningMode)pinningMode {
    _pinningMode = pinningMode;
}

@end

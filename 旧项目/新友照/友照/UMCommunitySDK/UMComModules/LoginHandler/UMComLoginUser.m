//
//  UMComLoginUser.m
//  UMCommunity
//
//  Created by wyq.Cloudayc on 7/15/16.
//  Copyright © 2016 Umeng. All rights reserved.
//

#import "UMComLoginUser.h"

@interface UMComLoginUser()


@end

@implementation UMComLoginUser

- (instancetype)init
{
    self = [super init];
    if (self) {
        _snsType = UMComSnsTypeNone;
        
        _updatedProfile = NO;
    }
    return self;
}

- (id)initWithSnsType:(UMComSnsType)snsType
{
    if (self = [self init]) {
        self.snsType = snsType;
    }
    return self;
}

@end
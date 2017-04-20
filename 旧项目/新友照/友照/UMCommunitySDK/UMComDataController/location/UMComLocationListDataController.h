//
//  UMComLocationListDataController.h
//  UMCommunity
//
//  Created by 张军华 on 16/6/23.
//  Copyright © 2016年 Umeng. All rights reserved.
//

#import "UMComListDataController.h"

@class CLLocation;

@interface UMComLocationListDataController : UMComListDataController


- (instancetype)initWithCount:(NSInteger)count withLocation:(CLLocation *)location;

@property(nonatomic,strong)CLLocation *location;

@end

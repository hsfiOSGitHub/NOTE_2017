//
//  UMComLocationListDataController.m
//  UMCommunity
//
//  Created by 张军华 on 16/6/23.
//  Copyright © 2016年 Umeng. All rights reserved.
//

#import "UMComLocationListDataController.h"
#import <CoreLocation/CoreLocation.h>



@implementation UMComLocationListDataController

- (instancetype)initWithCount:(NSInteger)count withLocation:(CLLocation *)location
{
    if (self = [super initWithRequestType:UMComRequestType_AllTopic count:count] ) {
        
        self.location = location;
    }
    return self;
}


- (void)refreshNewDataCompletion:(UMComDataListRequestCompletion)completion
{
    __weak typeof(self) weakself  = self;
    [[UMComDataRequestManager defaultManager] fetchLocationNamesWithLocation:self.location completion:^(NSDictionary *responseObject, NSError *error) {
        [weakself handleNewData:responseObject error:error completion:completion];
    }];
}
@end

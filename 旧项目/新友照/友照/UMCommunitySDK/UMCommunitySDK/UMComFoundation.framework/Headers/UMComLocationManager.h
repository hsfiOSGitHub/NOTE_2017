//
//  UMComLocation.h
//  UMCommunity
//
//  Created by wyq.Cloudayc on 7/2/16.
//  Copyright © 2016 Umeng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

typedef void (^UMComLocationEventBlock)(BOOL success, CLLocation *location);

@interface UMComLocationManager : NSObject
<CLLocationManagerDelegate>

@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, strong) UMComLocationEventBlock locationBlock;

+ (instancetype)sharedInstance;

- (void)startLocateWithEvent:(UMComLocationEventBlock)block;
- (void)stopLocationUpdate;

@end
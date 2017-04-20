//
//  UMComLocation.h
//  UMCommunity
//
//  Created by umeng on 15/9/25.
//  Copyright (c) 2015年 Umeng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import "UMComModelObject.h"

@interface UMComLocation : UMComModelObject

@property (nonatomic, copy) NSString *locationModelID;

@property (nonatomic, copy) NSString *name;

@property (nonatomic, copy) NSString *address;

@property (nonatomic, retain) NSNumber* distance;

@property (nonatomic, retain) NSNumber* latitude;//纬度

@property (nonatomic, retain) NSNumber* longitude;//经度

@end

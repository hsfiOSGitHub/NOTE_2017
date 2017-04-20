//
//  UMengLoginHandler.h
//  UMCommunity
//
//  Created by Gavin Ye on 8/25/14.
//  Copyright (c) 2014 Umeng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UMComLoginDelegate.h"

@interface UMComSimpleLoginHandler : NSObject<UMComLoginDelegate>

+ (void)binYZLoginHandler;

@end

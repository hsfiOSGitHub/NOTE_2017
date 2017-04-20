//
//  UMComKit+Runtime.h
//  UMCommunity
//
//  Created by wyq.Cloudayc on 5/12/16.
//  Copyright © 2016 Umeng. All rights reserved.
//

#import "UMComKit.h"

@interface UMComKit (Runtime)


+ (void)swizzleClassMethod:(id)obj originalSelector:(SEL)oSelector swizzledSelector:(SEL)swizzledSelector;

+ (void)swizzleInstanceMethod:(Class)class originalSelector:(SEL)oSelector swizzledSelector:(SEL)swizzledSelector;

@end

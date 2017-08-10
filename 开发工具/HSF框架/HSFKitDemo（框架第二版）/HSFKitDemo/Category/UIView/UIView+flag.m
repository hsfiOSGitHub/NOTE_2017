//
//  UIView+flag.m
//  hsfCategoryDemo
//
//  Created by monkey2016 on 17/2/24.
//  Copyright © 2017年 monkey2016. All rights reserved.
//

#import "UIView+flag.h"

#import <objc/runtime.h>

@implementation UIView (flag)

static void *strKey = &strKey;

-(void)setFlag:(NSString *)flag{
    objc_setAssociatedObject(self, & strKey, flag, OBJC_ASSOCIATION_COPY);
}
-(NSString *)flag{
    return objc_getAssociatedObject(self, &strKey);
}

@end

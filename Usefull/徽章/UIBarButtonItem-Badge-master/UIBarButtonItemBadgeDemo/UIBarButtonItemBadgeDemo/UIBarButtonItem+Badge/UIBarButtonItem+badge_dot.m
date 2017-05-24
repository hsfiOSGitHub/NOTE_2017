//
//  UIBarButtonItem+badge_dot.m
//  UIBarButtonItemBadgeDemo
//
//  Created by JuZhenBaoiMac on 2017/5/20.
//  Copyright © 2017年 zY. All rights reserved.
//

#import "UIBarButtonItem+badge_dot.h"
#import <objc/runtime.h>

NSString *const ZYBarButtonItem_hasBadgeKey = @"ZYBarButtonItem_hasBadgeKey";
NSString *const ZYBarButtonItem_badgeKey = @"ZYBarButtonItem_badgeKey";
NSString *const ZYBarButtonItem_badgeSizeKey = @"ZYBarButtonItem_badgeSizeKey";
NSString *const ZYBarButtonItem_badgeOriginXKey = @"ZYBarButtonItem_badgeOriginXKey";
NSString *const ZYBarButtonItem_badgeOriginYKey = @"ZYBarButtonItem_badgeOriginYKey";
NSString *const ZYBarButtonItem_badgeColorKey = @"ZYBarButtonItem_badgeColorKey";

@implementation UIBarButtonItem (badge_dot)

@dynamic hasBadge_dot;
@dynamic badgeSize_dot,badgeOriginX_dot,badgeOriginY_dot;


- (void)initBadge
{
    UIView *superview = nil;
    
    if (self.customView) {
        superview = self.customView;
        superview.clipsToBounds = NO;
    } else if ([self respondsToSelector:@selector(view)] && [(id)self view]) {
        superview = [(id)self view];
    }
    [superview addSubview:self.badge_dot];
    
    // 默认设置 default configure
    self.badgeColor_dot = [UIColor redColor];
    self.badgeSize_dot = 8;
    self.badgeOriginX_dot = 14;
    self.badgeOriginY_dot = 12;
    self.badge_dot.hidden = YES;
}

- (void)showBadge
{
    self.badge_dot.hidden = NO;
}

- (void)hideBadge
{
    self.badge_dot.hidden = YES;
}

- (void)refreshBadge
{
    self.badge_dot.frame = (CGRect){self.badgeOriginX_dot,self.badgeOriginY_dot,self.badgeSize_dot,self.badgeSize_dot};
    self.badge_dot.backgroundColor = self.badgeColor_dot;
    self.badge_dot.layer.cornerRadius = self.badgeSize_dot/2;
}


#pragma mark ---------- badge getter & setter function -----------

- (UIView *)badge_dot
{
    UIView *badge_dot = (UIView *)objc_getAssociatedObject(self, &ZYBarButtonItem_badgeKey);
    if (!badge_dot) {
        badge_dot = [[UIView alloc] init];
        [self setBadge_dot:badge_dot];
        [self initBadge];
    }
    return badge_dot;
}

- (void)setBadge_dot:(UIView *)badge_dot
{
    objc_setAssociatedObject(self, &ZYBarButtonItem_badgeKey, badge_dot, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIColor *)badgeColor_dot
{
    return objc_getAssociatedObject(self, &ZYBarButtonItem_badgeColorKey);
}

- (void)setBadgeColor_dot:(UIColor *)badgeColor_dot
{
    objc_setAssociatedObject(self, &ZYBarButtonItem_badgeColorKey, badgeColor_dot, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    if (self.badge_dot) {
        [self refreshBadge];
    }
}

-(CGFloat)badgeSize_dot {
    NSNumber *number = objc_getAssociatedObject(self, &ZYBarButtonItem_badgeSizeKey);
    return number.floatValue;
}

-(void)setBadgeSize_dot:(CGFloat)badgeSize_dot
{
    NSNumber *number = [NSNumber numberWithDouble:badgeSize_dot];
    objc_setAssociatedObject(self, &ZYBarButtonItem_badgeSizeKey, number, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    if (self.badge_dot) {
        [self refreshBadge];
    }
}

-(CGFloat)badgeOriginX_dot {
    NSNumber *number = objc_getAssociatedObject(self, &ZYBarButtonItem_badgeOriginXKey);
    return number.floatValue;
}

-(void)setBadgeOriginX_dot:(CGFloat)badgeOriginX_dot
{
    NSNumber *number = [NSNumber numberWithDouble:badgeOriginX_dot];
    objc_setAssociatedObject(self, &ZYBarButtonItem_badgeOriginXKey, number, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    if (self.badge_dot) {
        [self refreshBadge];
    }
}

-(CGFloat)badgeOriginY_dot {
    NSNumber *number = objc_getAssociatedObject(self, &ZYBarButtonItem_badgeOriginYKey);
    return number.floatValue;
}

-(void)setBadgeOriginY_dot:(CGFloat)badgeOriginY_dot
{
    NSNumber *number = [NSNumber numberWithDouble:badgeOriginY_dot];
    objc_setAssociatedObject(self, &ZYBarButtonItem_badgeOriginYKey, number, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    if (self.badge_dot) {
        [self refreshBadge];
    }
}

- (void)setHasBadge_dot:(BOOL)hasBadge_dot
{
    if (hasBadge_dot) {
        [self showBadge];
    }else{
        [self hideBadge];
    }
    
    NSNumber *number = [NSNumber numberWithBool:hasBadge_dot];
    objc_setAssociatedObject(self, &ZYBarButtonItem_hasBadgeKey, number, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)hasBadge_dot
{
    NSNumber *number = objc_getAssociatedObject(self, &ZYBarButtonItem_hasBadgeKey);
    return number.boolValue;
}

@end


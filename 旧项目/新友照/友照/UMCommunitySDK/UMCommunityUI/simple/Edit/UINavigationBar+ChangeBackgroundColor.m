//
//  UINavigationBar+Awesome.m
//  LTNavigationBar
//
//  Created by ltebean on 15-2-15.
//  Copyright (c) 2015 ltebean. All rights reserved.
//

#import "UINavigationBar+ChangeBackgroundColor.h"
#import <objc/runtime.h>

@implementation UINavigationBar (ChangeBackgroundColor)
static char UMComOverlayKey;

- (UIView *)overlayForNavigationBar
{
    return objc_getAssociatedObject(self, &UMComOverlayKey);
}

- (void)setOverlayForNavigationBar:(UIView *)overlay
{
    objc_setAssociatedObject(self, &UMComOverlayKey, overlay, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)umcom_setBackgroundColor:(UIColor *)backgroundColor
{
    if (!self.overlayForNavigationBar) {
        [self setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
        self.overlayForNavigationBar = [[UIView alloc] initWithFrame:CGRectMake(0, -20, CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds) + 20)];
        self.overlayForNavigationBar.userInteractionEnabled = NO;
        self.overlayForNavigationBar.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        [self insertSubview:self.overlayForNavigationBar atIndex:0];
    }
    self.overlayForNavigationBar.backgroundColor = backgroundColor;
}

- (void)umcom_setTranslationY:(CGFloat)translationY
{
    self.transform = CGAffineTransformMakeTranslation(0, translationY);
}

- (void)umcom_setElementsAlpha:(CGFloat)alpha
{
    [[self valueForKey:@"_leftViews"] enumerateObjectsUsingBlock:^(UIView *view, NSUInteger i, BOOL *stop) {
        view.alpha = alpha;
    }];
    
    [[self valueForKey:@"_rightViews"] enumerateObjectsUsingBlock:^(UIView *view, NSUInteger i, BOOL *stop) {
        view.alpha = alpha;
    }];
    
    UIView *titleView = [self valueForKey:@"_titleView"];
    titleView.alpha = alpha;
//    when viewController first load, the titleView maybe nil
    [[self subviews] enumerateObjectsUsingBlock:^(UIView *obj, NSUInteger idx, BOOL *stop) {
        if ([obj isKindOfClass:NSClassFromString(@"UINavigationItemView")]) {
            obj.alpha = alpha;
            *stop = YES;
        }
    }];
}

- (void)umcom_reset
{
    [self setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
    [self.overlayForNavigationBar removeFromSuperview];
    self.overlayForNavigationBar = nil;
}

@end

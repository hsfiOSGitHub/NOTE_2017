//
//  UIViewController+TunTransition.m
//  TunViewControllerTransition
//
//  Created by 涂育旺 on 2017/7/15.
//  Copyright © 2017年 Qianhai Jiutong. All rights reserved.
//

#import "UIViewController+TunTransition.h"
#import <objc/runtime.h>

typedef NS_ENUM(NSInteger, TunVCTransitionType)
{
    TunVCTransitionType_Transition,
    TunVCTransitionType_InverseTransition,
    TunVCTransitionType_CircleTransition,
    TunVCTransitionType_CircleInverseTransition,
    TunVCTransitionType_PageTransition,
    TunVCTransitionType_PageInverseTransition
};

@interface UIViewController ()

@property (nonatomic, copy) NSString *toViewKeyPath;

@property (nonatomic, strong) UIView *fromView;

@property (nonatomic, assign) TunVCTransitionType transitionType;

@property (nonatomic, strong) id<UIViewControllerContextTransitioning> transitionContext;

@end

@implementation UIViewController (TunTransition)

#pragma mark - init property

const NSString *typeKey = nil;
const NSString *fromViewKey = nil;
const NSString *toViewKey = nil;
const NSString *transitionContextKey = nil;

// transitionType
- (void)setTransitionType:(TunVCTransitionType)transitionType
{
    objc_setAssociatedObject(self, &typeKey, @(transitionType), OBJC_ASSOCIATION_ASSIGN);
}

- (TunVCTransitionType)transitionType
{
    return [objc_getAssociatedObject(self, &typeKey) integerValue];
}

// fromView
- (void)setFromView:(UIView *)fromView
{
    objc_setAssociatedObject(self, &fromViewKey, fromView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIView *)fromView
{
    return objc_getAssociatedObject(self, &fromViewKey);
}

// toView
- (void)setToViewKeyPath:(NSString *)toViewKeyPath
{
    objc_setAssociatedObject(self, &toViewKey, toViewKeyPath, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSString *)toViewKeyPath
{
    return objc_getAssociatedObject(self, &toViewKey);
}

//transitionContext
- (void)setTransitionContext:(id<UIViewControllerContextTransitioning>)transitionContext
{
    objc_setAssociatedObject(self, &transitionContextKey, transitionContext, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (id<UIViewControllerContextTransitioning>)transitionContext
{
    return objc_getAssociatedObject(self, &transitionContextKey);
}

#pragma mark - public method

- (void)animateTransitionFromView:(UIView *)view toView:(NSString *)toViewKeyPath
{
    self.fromView = view;
    self.toViewKeyPath = toViewKeyPath;
    self.transitionType = TunVCTransitionType_Transition;
}

- (void)animateInverseTransition
{
    self.navigationController.delegate = self;
    self.transitionType = TunVCTransitionType_InverseTransition;
}

- (void)animateCircleTransitionFromView:(UIView *)view
{
    self.fromView = view;
    self.transitionType = TunVCTransitionType_CircleTransition;

}

- (void)animateCircleInverseTransition
{
    self.navigationController.delegate = self;
    self.transitionType = TunVCTransitionType_CircleInverseTransition;
}

- (void)animatePageTransition
{
    self.transitionType = TunVCTransitionType_PageTransition;
}

- (void)animatePageInverseTransition
{
    self.navigationController.delegate = self;
    self.transitionType = TunVCTransitionType_PageInverseTransition;
}

#pragma mark - UINavigationControllerDelegate

- (id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController animationControllerForOperation:(UINavigationControllerOperation)operation fromViewController:(UIViewController *)fromVC toViewController:(UIViewController *)toVC
{
    return self;
}

#pragma mark - UIViewControllerAnimatedTransitioning

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext
{
    return 0.6f;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    switch (self.transitionType) {
            
        case TunVCTransitionType_Transition:
        {
            [self animateForTransition:transitionContext];
        }
            break;
        case TunVCTransitionType_InverseTransition:
        {
            [self animateForInverseTransition:transitionContext];
        }
            break;
        case TunVCTransitionType_CircleTransition:
        {
            [self animateForCircleTransition:transitionContext];
        }
            break;
        case TunVCTransitionType_CircleInverseTransition:
        {
            [self animateForCircleInverseTransition:transitionContext];
        }
            break;
        case TunVCTransitionType_PageTransition:
        {
            [self animateForPageTransition:transitionContext];
        }
            break;
        case TunVCTransitionType_PageInverseTransition:
        {
            [self animateForPageInverseTransition:transitionContext];
        }
            break;

        default:
            break;
    }
}

#pragma mark - CAAnimationDelegate

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    if (!flag) {
        return;
    }
    
    [self.transitionContext completeTransition:![self.transitionContext transitionWasCancelled]];
    [self.transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey].view.layer.mask = nil;
    [self.transitionContext viewControllerForKey:UITransitionContextToViewControllerKey].view.layer.mask = nil;
}

#pragma mark - transition

- (void)animateForTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    
    UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    UIView *toView = [toVC valueForKeyPath:self.toViewKeyPath];
    
    UIView *containerView = [transitionContext containerView];
    
    UIView *snapShotView = [self.fromView snapshotViewAfterScreenUpdates:NO];
    snapShotView.frame = [containerView convertRect:self.fromView.frame fromView:self.fromView.superview];
    self.fromView.hidden = YES;
    
    toVC.view.frame = [transitionContext finalFrameForViewController:toVC];
    toVC.view.alpha = 0;
    toView.hidden = YES;
    
    toVC.fromView = self.fromView;
    toVC.toViewKeyPath = self.toViewKeyPath;
    
    [containerView addSubview:toVC.view];
    [containerView addSubview:snapShotView];
    
    [UIView animateWithDuration:[self transitionDuration:transitionContext] delay:0.0f usingSpringWithDamping:0.6f initialSpringVelocity:1.0f options:UIViewAnimationOptionCurveLinear animations:^{
        [containerView layoutIfNeeded];
        toVC.view.alpha = 1.0f;
        snapShotView.frame = [containerView convertRect:toView.frame fromView:toView.superview];
        
    } completion:^(BOOL finished) {
        
        toView.hidden = NO;
        self.fromView.hidden = NO;
        [snapShotView removeFromSuperview];
        
        [transitionContext completeTransition:!transitionContext.transitionWasCancelled];
    }];
    
}

- (void)animateForInverseTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIView *containerView = [transitionContext containerView];
    
    UIView *fromView = [fromVC valueForKeyPath:self.toViewKeyPath];
    
    UIView *snapShotView = [fromView snapshotViewAfterScreenUpdates:NO];
    snapShotView.backgroundColor = [UIColor clearColor];
    snapShotView.frame = [containerView convertRect:fromView.frame fromView:fromView.superview];
    fromView.hidden = YES;
    
    toVC.view.frame = [transitionContext finalFrameForViewController:toVC];
    
    UIView *originView = fromVC.fromView;
    originView.hidden = YES;
    
    [containerView insertSubview:toVC.view belowSubview:fromVC.view];
    [containerView addSubview:snapShotView];
    
    [UIView animateWithDuration:[self transitionDuration:transitionContext] delay:0.0f usingSpringWithDamping:0.6f initialSpringVelocity:1.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        fromVC.view.alpha = 0.0f;
        snapShotView.frame = [containerView convertRect:originView.frame fromView:originView.superview];
    } completion:^(BOOL finished) {
        [snapShotView removeFromSuperview];
        originView.hidden = NO;
        [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
    }];
}

#pragma mark - Circle

- (void)animateForCircleTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    self.transitionContext = transitionContext;
    
    UIView *containerView = [transitionContext containerView];
    UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    UIView *fromView = self.fromView;
    UIView *snapShotView = [fromView snapshotViewAfterScreenUpdates:NO];
    toVC.fromView = snapShotView;
    
    snapShotView.frame = [self relativeFrameForScreenWithView:fromView];
    [containerView addSubview:snapShotView];
    [containerView addSubview:toVC.view];
    
    CGPoint finalPoint = [self getFinalPoint:toVC forFromView:fromView];
    
    CGFloat radius = sqrt((finalPoint.x * finalPoint.x) + (finalPoint.y * finalPoint.y));
    
    UIBezierPath *maskStartPath = [UIBezierPath bezierPathWithOvalInRect:snapShotView.frame];
    
    UIBezierPath *maskEndPath = [UIBezierPath bezierPathWithOvalInRect:CGRectInset(snapShotView.frame, -radius, -radius)];
    
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    maskLayer.path = maskEndPath.CGPath;
    toVC.view.layer.mask = maskLayer;
    
    CABasicAnimation *maskAnimation = [CABasicAnimation animationWithKeyPath:@"path"];
    maskAnimation.fromValue = (__bridge id _Nullable)(maskStartPath.CGPath);
    maskAnimation.toValue = (__bridge id _Nullable)(maskEndPath.CGPath);
    maskAnimation.duration = [self transitionDuration:transitionContext];
    maskAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    maskAnimation.delegate = self;
    [maskLayer addAnimation:maskAnimation forKey:@"Circle"];
    [snapShotView removeFromSuperview];
}

- (void)animateForCircleInverseTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    self.transitionContext = transitionContext;
    
    UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    
    UIView *containerView = [transitionContext containerView];
    UIView *toView = fromVC.fromView;
    
    [containerView addSubview:toVC.view];
    [containerView addSubview:fromVC.view];
    
    CGPoint finalPoint = [self getFinalPoint:toVC forFromView:toView];
    
    CGFloat radius = sqrt((finalPoint.x * finalPoint.x) + (finalPoint.y * finalPoint.y));
    
    UIBezierPath *maskStartPath = [UIBezierPath bezierPathWithOvalInRect:CGRectInset(toView.frame, -radius, -radius)];
    UIBezierPath *maskEndPath = [UIBezierPath bezierPathWithOvalInRect:toView.frame];
    
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    maskLayer.path = maskEndPath.CGPath;
    fromVC.view.layer.mask = maskLayer;
    
    CABasicAnimation *maskAnimation = [CABasicAnimation animationWithKeyPath:@"path"];
    maskAnimation.fromValue = (__bridge id _Nullable)(maskStartPath.CGPath);
    maskAnimation.toValue = (__bridge id _Nullable)(maskEndPath.CGPath);
    maskAnimation.duration = [self transitionDuration:transitionContext];
    maskAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    maskAnimation.delegate = self;
    [maskLayer addAnimation:maskAnimation forKey:@"CircleInvert"];
}

- (void)animateForPageTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIView *containerView = [transitionContext containerView];
    
    UIView *fromView = fromVC.view;
    UIView *toView = toVC.view;
    
    [containerView addSubview:toView];
    [containerView sendSubviewToBack:toView];
    
    CATransform3D transform = CATransform3DIdentity;
    transform.m34 = -0.002;
    containerView.layer.sublayerTransform = transform;
    
    CGRect initialFrame = [transitionContext initialFrameForViewController:fromVC];
    fromView.frame = initialFrame;
    toView.frame = initialFrame;
    
    fromView.layer.anchorPoint = CGPointMake(0.0, 0.5);
    fromView.layer.position = CGPointMake(0, CGRectGetMidY([UIScreen mainScreen].bounds));
    
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.frame = fromView.bounds;
    gradient.colors = @[(id)[UIColor colorWithWhite:0.0 alpha:0.5].CGColor,
                        (id)[UIColor colorWithWhite:0.0 alpha:0.0].CGColor];
    gradient.startPoint = CGPointMake(0.0, 0.5);
    gradient.endPoint = CGPointMake(0.8, 0.5);
    
    UIView *shadow = [[UIView alloc] initWithFrame:fromView.bounds];
    shadow.backgroundColor = [UIColor clearColor];
    [shadow.layer insertSublayer:gradient atIndex:1];
    shadow.alpha = 0.0;
    
    [fromView addSubview:shadow];
    
    [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
        
        fromView.layer.transform = CATransform3DMakeRotation(-M_PI_2, 0.0, 1.0, 0.0);
        shadow.alpha = 1.0;
        
    } completion:^(BOOL finished) {
        
        fromView.layer.anchorPoint = CGPointMake(0.5, 0.5);
        fromView.layer.position = CGPointMake(CGRectGetMidX([UIScreen mainScreen].bounds), CGRectGetMidY([UIScreen mainScreen].bounds));
        fromView.layer.transform = CATransform3DIdentity;
        [shadow removeFromSuperview];
        [transitionContext completeTransition:YES];
    }];
}

- (void)animateForPageInverseTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIView *containerView = [transitionContext containerView];
    
    UIView *fromView = fromVC.view;
    UIView *toView = toVC.view;
    [containerView addSubview:toView];
    
    CATransform3D transform = CATransform3DIdentity;
    transform.m34 = -0.002;
    containerView.layer.sublayerTransform = transform;
    
    CGRect initialFrame = [transitionContext initialFrameForViewController:fromVC];
    fromView.frame = initialFrame;
    toView.frame = initialFrame;
    toView.layer.anchorPoint = CGPointMake(0.0, 0.5);
    toView.layer.position = CGPointMake(0, CGRectGetMidY([UIScreen mainScreen].bounds));
    toView.layer.transform = CATransform3DMakeRotation(-M_PI_2, 0.0, 1.0, 0.0);
    
    [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
       
        toView.layer.transform = CATransform3DMakeRotation(0, 0, 1.0, 0.0);
        
    } completion:^(BOOL finished) {
        
        toView.layer.anchorPoint = CGPointMake(0.5, 0.5);
        toView.layer.position = CGPointMake(CGRectGetMidX([UIScreen mainScreen].bounds), CGRectGetMidY([UIScreen mainScreen].bounds));
        [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
    }];
}

#pragma mark - Utility

- (CGPoint)getFinalPoint:(UIViewController *)toVC forFromView:(UIView *)fromView
{
    CGPoint finalPoint;
    
    if (fromView.frame.origin.x > (toVC.view.bounds.size.width / 2)) {
        if (fromView.frame.origin.y < (toVC.view.bounds.size.height / 2)) {
            
            finalPoint = CGPointMake(fromView.center.x - 0, fromView.center.y - CGRectGetMaxY(toVC.view.frame));
        }else
        {
            finalPoint = CGPointMake(fromView.center.x - 0, fromView.center.y - 0);
        }
    }else
    {
        if (fromView.frame.origin.y < (toVC.view.bounds.size.height / 2)) {
            
            finalPoint = CGPointMake(fromView.center.x - CGRectGetMaxX(toVC.view.bounds), fromView.center.y - CGRectGetMaxY(toVC.view.bounds));
        }else
        {
            finalPoint = CGPointMake(fromView.center.x - CGRectGetMaxX(toVC.view.bounds), fromView.center.y - 0);
        }
    }
    
    return finalPoint;
}


- (CGRect)relativeFrameForScreenWithView:(UIView *)v
{
    
    CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    
    UIView *view = v;
    CGFloat x = .0;
    CGFloat y = .0;
    while (view.frame.size.width != screenWidth || view.frame.size.height != screenHeight) {
        x += view.frame.origin.x;
        y += view.frame.origin.y;
        view = view.superview;
        if ([view isKindOfClass:[UIScrollView class]]) {
            x -= ((UIScrollView *) view).contentOffset.x;
            y -= ((UIScrollView *) view).contentOffset.y;
        }
    }
    return CGRectMake(x, y, v.frame.size.width, v.frame.size.height);
}

@end

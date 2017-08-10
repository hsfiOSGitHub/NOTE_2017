//
//  XWFilterAnimator+XWBarSwipe.h
//  XWTransitionDemo
//
//  Created by wazrx on 16/6/19.
//  Copyright © 2016年 wazrx. All rights reserved.
//

#import "XWFilterAnimator.h"

@interface XWFilterAnimator (XWBarSwipe)

- (void)xw_barSwipeAnimationFor:(XWFilterTransitionView *)filterView transitionContext:(id<UIViewControllerContextTransitioning>)transitionContext duration:(NSTimeInterval)duration toFlag:(BOOL)flag;
@end

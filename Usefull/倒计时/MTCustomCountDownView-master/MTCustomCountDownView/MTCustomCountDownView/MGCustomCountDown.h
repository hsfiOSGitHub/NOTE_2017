//
//  MGCustomCountDown.h
//  MTCustomCountDownView
//
//  Created by acmeway on 2017/5/18.
//  Copyright © 2017年 acmeway. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MGCustomCountDown;
@protocol MGCustomCountDownDelagete <NSObject>

- (void)customCountDown:(MGCustomCountDown *)downView;

@end
@interface MGCustomCountDown : UIView

@property (nonatomic, assign) id<MGCustomCountDownDelagete> delegate;
@property (nonatomic, assign) NSInteger downNumber;


+ (instancetype)downView;

- (void)addTimerForAnimationDownView;

@end

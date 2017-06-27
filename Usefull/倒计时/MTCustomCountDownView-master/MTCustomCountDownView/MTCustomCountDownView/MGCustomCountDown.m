//
//  MGCustomCountDown.m
//  MTCustomCountDownView
//
//  Created by acmeway on 2017/5/18.
//  Copyright © 2017年 acmeway. All rights reserved.
//

#import "MGCustomCountDown.h"

#define ScreenWidth [UIScreen mainScreen].bounds.size.width
#define ScreenHeight [UIScreen mainScreen].bounds.size.height

@interface MGCustomCountDown ()
@property (nonatomic) UILabel* countdownLabel;

@end
@implementation MGCustomCountDown

+ (instancetype)downView
{
    MGCustomCountDown *downView = [[MGCustomCountDown alloc] init];
    
    return downView;
}

- (instancetype)init
{
    if (self = [super init]) {
        
        [self setupSubview];
    }
    return self;
}

- (void)setupSubview
{
    [[self subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    self.opaque = NO;

    float fontSize = [UIScreen mainScreen].bounds.size.width * 0.3;
    
    self.countdownLabel = [[UILabel alloc] init];
    [self.countdownLabel setFont:[UIFont systemFontOfSize:fontSize]];
    [self.countdownLabel setTextColor:[UIColor whiteColor]];
    self.countdownLabel.textAlignment = NSTextAlignmentCenter;
    
    self.countdownLabel.opaque = YES;
    self.countdownLabel.alpha = 1.0;
    [self addSubview: self.countdownLabel];
    
    self.countdownLabel.backgroundColor = [UIColor clearColor];
  
}

- (void)addTimerForAnimationDownView
{
    [self numAction];
    [self setCircleBackView];
}

- (void)numAction
{
    __block NSInteger second = 3;
    
    dispatch_queue_t quene = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    dispatch_source_t timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, quene);
    
    dispatch_source_set_timer(timer, dispatch_walltime(NULL, 0), NSEC_PER_SEC * 1, 0);
    
    dispatch_source_set_event_handler(timer, ^{
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if (second >= 0) {
                
                if (second == 0)
                {
                    self.countdownLabel.text = [NSString stringWithFormat:@"%@", @"GO"];
                }
                else
                {
                    self.countdownLabel.text = [NSString stringWithFormat:@"%ld", second];
                }
                [self animationTest];
                second--;
            }
            else
            {
                
                dispatch_source_cancel(timer);

                if ([self.delegate respondsToSelector:@selector(customCountDown:)]) {
                    [self.delegate customCountDown:self];
                    [self removeFromSuperview];
                }
            }
        });
    });
    //启动源
    dispatch_resume(timer);
}

- (void)setCircleBackView
{
    CGFloat delay = 1.0;
    CGFloat scale = 3;
    NSInteger count = 4;
    
    for (NSInteger i = 0; i < count; i++) {
        
        UIView *animationView = [self circleView];
        
        animationView.backgroundColor = [UIColor clearColor];
        
        [self insertSubview:animationView atIndex:0];
        
        [UIView animateWithDuration:1
                              delay:i * delay
                            options:UIViewAnimationOptionCurveLinear
                         animations:^{
                             
                             animationView.transform = CGAffineTransformMakeScale(scale, scale);
                             animationView.backgroundColor = [UIColor colorWithWhite:0.5 alpha:0.5];
                             animationView.alpha = 0;
                             
                         } completion:^(BOOL finished) {
                             
                             [animationView removeFromSuperview];
                       
                         }];
    }

}
- (UIView *)circleView
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
    view.center = self.center;
    view.backgroundColor = [UIColor colorWithRed:52 / 255.0 green:143 / 255.0 blue:242 / 255.0 alpha:1.0];
    view.layer.cornerRadius = 50.0;
    view.layer.masksToBounds = YES;
    
    return view;
}

- (void)animationTest
{
    CABasicAnimation *animation2 = [CABasicAnimation animationWithKeyPath:@"opacity"];
    animation2.duration = 0.30;
    animation2.toValue = @(0.2);
    animation2.removedOnCompletion = YES;
    animation2.fillMode = kCAFillModeForwards;
    [self.countdownLabel.layer addAnimation:animation2 forKey:@"opacity"];
    
    CAKeyframeAnimation * animation;
    animation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    animation.duration = 0.30;
    animation.removedOnCompletion = YES;
    animation.fillMode = kCAFillModeForwards;
    NSMutableArray *values = [NSMutableArray array];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.2, 0.2, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.5, 1.5, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.4, 1.4, 1.0)]];
    animation.values = values;
    [self.countdownLabel.layer addAnimation:animation forKey:nil];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
  
    self.countdownLabel.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width , self.frame.size.width);
    [self.countdownLabel setCenter:self.center];
    
}


@end

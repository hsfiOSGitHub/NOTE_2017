//
//  TYVideoErrorView.h
//  TYVideoPlayerDemo
//
//  Created by tany on 16/7/12.
//  Copyright © 2016年 tany. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, TYVideoErrorEvent) {
    TYVideoErrorEventBack,
    TYVideoErrorEventReplay,
};

@interface TYVideoErrorView : UIView

@property (nonatomic, copy) void (^eventActionHandle)(TYVideoErrorEvent event);

- (void)setTitle:(NSString *)title;

@end

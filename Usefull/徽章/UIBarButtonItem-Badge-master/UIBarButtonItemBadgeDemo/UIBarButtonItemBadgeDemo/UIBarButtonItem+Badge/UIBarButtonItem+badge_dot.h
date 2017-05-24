//
//  UIBarButtonItem+badge_dot.h
//  UIBarButtonItemBadgeDemo
//
//  Created by JuZhenBaoiMac on 2017/5/20.
//  Copyright © 2017年 zY. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIBarButtonItem (badge_dot)
@property (strong, nonatomic) UIView *badge_dot;
@property (assign, nonatomic) UIColor *badgeColor_dot;
@property (assign, nonatomic) CGFloat badgeOriginX_dot;
@property (assign, nonatomic) CGFloat badgeOriginY_dot;
@property (assign, nonatomic) CGFloat badgeSize_dot; // badge width and height
@property BOOL hasBadge_dot; // show badge or not
@end

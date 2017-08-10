//
//  DCHoverNavView.h
//  CDDMall
//
//  Created by apple on 2017/6/7.
//  Copyright © 2017年 RocketsChen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DCHoverNavView : UIView

/* title */
@property (nonatomic, strong) UILabel * titleLabel;

/* imageView */
@property (strong , nonatomic)UIImageView *iconImageView;

@property (nonatomic , copy) void(^leftItemClickBlock)();

@property (nonatomic , copy) void(^rightItemClickBlock)();

@end

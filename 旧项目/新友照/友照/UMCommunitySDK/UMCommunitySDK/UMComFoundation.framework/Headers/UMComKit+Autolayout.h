//
//  UMComKit+Autolayout.h
//  UMCommunity
//
//  Created by wyq.Cloudayc on 5/26/16.
//  Copyright © 2016 Umeng. All rights reserved.
//

#import "UMComKit.h"
#import <UIKit/UIKit.h>

@interface UMComKit (Autolayout)

+ (BOOL)ALView:(UIView *)view setConstraintConstant:(CGFloat)constant forAttribute:(NSLayoutAttribute)attribute;
+ (CGFloat)ALView:(UIView *)view constraintConstantforAttribute:(NSLayoutAttribute)attribute;
+ (NSArray *)ALView_AllConstraints:(UIView *)view;
+ (NSLayoutConstraint*)ALView:(UIView *)view constraintForAttribute:(NSLayoutAttribute)attribute;

+ (void)ALView:(UIView *)view hideByHeight:(BOOL)hidden;
+ (void)ALView:(UIView *)view hideByWidth:(BOOL)hidden;
+ (void)ALView:(UIView *)view hideView:(BOOL)hidden byAttribute:(NSLayoutAttribute)attribute;

+ (CGSize)ALView_GetSize:(UIView *)view;
+ (void)ALView_SizeToSubviews:(UIView *)view;
+ (void)ALView_UpdateSizes:(UIView *)view;

@end

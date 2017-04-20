//
//  UMComCustomMenuViewController.h
//  UMCommunity
//
//  Created by umeng on 16/5/11.
//  Copyright © 2016年 Umeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UMComViewController.h"
#import "UMComSimpleHorizonMenuView.h"

@interface UMComCustomMenuViewController : UMComViewController<UMComSimpleHorizonMenuViewDelegate>

/**
 *子ViewController
 */
@property (nonatomic, strong) NSArray  *subViewControllers;

/**
 * title 菜单表
 */
@property (nonatomic, strong) NSArray  *titlesArray;

/**
 *
 */
@property (nonatomic, strong) UMComSimpleHorizonMenuView *menuView;

/**
 *显示表现序号
 */
@property (nonatomic, assign) NSInteger showIndex;


@property (nonatomic, strong) UIView *userMessageView;
/**
 * 点击发现
 */
- (void)onTouchDiscover;

- (void)didTransitionToIndex:(NSInteger)index;

@end

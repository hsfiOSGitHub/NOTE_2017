//
//  UIView+superVC.h
//  News
//
//  Created by monkey2016 on 16/11/29.
//  Copyright © 2016年 monkey2016. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (superVC)
/** 获取当前view所在的viewController */
- (UIViewController *)getSuperVC;
@end

//
//  UIView+screenshot.h
//  hsfCategoryDemo
//
//  Created by monkey2016 on 17/2/24.
//  Copyright © 2017年 monkey2016. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (screenshot)

//View截图
- (UIImage*) screenshot;

//ScrollView截图 contentOffset
- (UIImage*) screenshotForScrollViewWithContentOffset:(CGPoint)contentOffset;

//View按Rect截图
- (UIImage*) screenshotInFrame:(CGRect)frame;

@end

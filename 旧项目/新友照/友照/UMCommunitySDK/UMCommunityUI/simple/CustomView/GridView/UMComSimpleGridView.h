//
//  UMComGridView.h
//  UMCommunity
//
//  Created by luyiyuan on 14/8/27.
//  Copyright (c) 2014年 luyiyuan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UMComSimpleGridViewerController.h"
@interface UMComSimpleGridView : UIView

@property (nonatomic, strong) void (^TapInImage)(UMComSimpleGridViewerController *viewerViewController, UIImageView *imageView);

@property (nonatomic, assign) CGFloat totalWidth;

- (id)initWithArray:(NSArray *)array placeholder:(UIImage *)placeholder cellPad:(NSUInteger)cellPad;

- (void)setImages:(NSArray *)images placeholder:(UIImage *)placeholder cellPad:(NSInteger)cellPad;

- (void)setArray:(NSArray *)array;

- (void)setPresentFatherViewController:(UIViewController *)viewController;

//默认一周（60*60*24*7）
- (void)setCacheSecondes:(NSTimeInterval)secondes;

- (void)startDownload;



@end

//
//  StarView.m
//  StarScoreDemo
//
//  Created by StarLord on 15/7/28.
//  Copyright (c) 2015年 xxx. All rights reserved.
//

#import "StarView.h"

@interface StarView()
@property (nonatomic, strong) UIImage *starHighLightImage;
@property (nonatomic, strong) UIImage *starNormalImage;
@end

@implementation StarView

- (UIImage *)starHighLightImage{
    if (!_starHighLightImage) {
        _starHighLightImage = [UIImage imageNamed:@"star_hd"];
    }
    return _starHighLightImage;
}

- (UIImage *)starNormalImage{
    if (!_starNormalImage) {
        _starNormalImage = [UIImage imageNamed:@"star_normal"];
    }
    return _starNormalImage;
}


- (void)setPercent:(CGFloat)percent{
    _percent = percent;
    [self setNeedsDisplay];
}


- (void)drawRect:(CGRect)rect{
    [super drawRect:rect];
    if (_percent == 1) {
        [self.starHighLightImage drawInRect:rect];
        return;
    }
    if (_percent == 0) {
        [self.starNormalImage drawInRect:rect];
        return;
    }
    
    CGFloat leftImageWidth = rect.size.width * _percent;
    CGFloat rightImageWidth = rect.size.width - leftImageWidth;
    
    UIImage *leftImage = [self segmentImage:self.starHighLightImage percent:_percent fromLeft:YES];
    UIImage *rightImage = [self segmentImage:self.starNormalImage percent:1 - _percent fromLeft:NO];

    [leftImage drawInRect:CGRectMake(0, 0, leftImageWidth, rect.size.height)];
    [rightImage drawInRect:CGRectMake(leftImageWidth, 0, rightImageWidth, rect.size.height)];
}

- (UIImage *)segmentImage:(UIImage *)image percent:(CGFloat)percent fromLeft:(BOOL)left{
    
    CGSize sz = [image size];
    
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(sz.width*percent, sz.height), NO, 0);
    
    if (left) {
        [image drawAtPoint:CGPointMake(0, 0)];
    }else{
        [image drawAtPoint:CGPointMake(-(sz.width - sz.width*percent), 0)];
    }
    
    UIImage* im = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    return im;
}

@end

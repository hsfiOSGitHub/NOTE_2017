//
//  UIView+Extension.m
//  LetMeSpend
//
//  Created by 翁志方 on 16/4/26.
//  Copyright © 2016年 __defaultyuan. All rights reserved.
//

#import "UIView+Extension.h"

@implementation UIView (Extension)
//>>>>>getter<<<<<
//相对于父视图
-(CGFloat)x{
    return self.frame.origin.x;
}
-(CGFloat)y{
    return self.frame.origin.y;
}
-(CGFloat)maxX{
    return self.frame.origin.x + self.frame.size.width;
}
-(CGFloat)maxY{
    return self.frame.origin.y + self.frame.size.height;
}
-(CGFloat)centerX{
    return self.frame.origin.x + self.frame.size.width/2;
}
-(CGFloat)centerY{
    return self.frame.origin.y + self.frame.size.height/2;
}
//相对于自身
- (CGSize)size{
    return self.frame.size;
}
-(CGFloat)width{
    return self.frame.size.width;
}
-(CGFloat)height{
    return self.frame.size.height;
}
-(CGPoint)centerOfSelf{
    return CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
}
-(CGFloat)centerXOfSelf{
    return self.frame.size.width/2;
}
-(CGFloat)centerYOfSelf{
    return self.frame.size.height/2;
}


//>>>>>setter<<<<<
//相对于父视图
-(void)setX:(CGFloat)x{
    CGRect frame = self.frame;
    frame.origin.x = x;
    self.frame = frame;
}
-(void)setY:(CGFloat)y{
    CGRect frame = self.frame;
    frame.origin.y = y;
    self.frame = frame;
}
-(void)setMaxX:(CGFloat)maxX{
    CGRect frame = self.frame;
    frame.origin.x = maxX - frame.size.width;
    self.frame = frame;
}
-(void)setMaxY:(CGFloat)maxY{
    CGRect frame = self.frame;
    frame.origin.y = maxY - frame.size.height;
    self.frame = frame;
}
-(void)setCenterX:(CGFloat)centerX{
    self.center = CGPointMake(centerX, self.center.y);
}
-(void)setCenterY:(CGFloat)centerY{
    self.center = CGPointMake(self.center.x, centerY);
}
//相对于自身
- (void)setSize:(CGSize)size
{
    CGRect frame = self.frame;
    frame.size = size;
    self.frame = frame;
}
-(void)setWidth:(CGFloat)width{
    CGRect frame = self.frame;
    frame.size.width = width;
    self.frame = frame;
}
-(void)setHeight:(CGFloat)height{
    CGRect frame = self.frame;
    frame.size.height = height;
    self.frame = frame;
}
-(void)setCenterOfSelf:(CGPoint)centerOfSelf{
    //readonly
}
-(void)setCenterXOfSelf:(CGFloat)centerXOfSelf{
    //readonly
}
-(void)setCenterYOfSelf:(CGFloat)centerYOfSelf{
    //readonly
}



@end

//
//  UIImage+cut.h
//  CalendarDemo
//
//  Created by monkey2016 on 17/1/17.
//  Copyright © 2017年 monkey2016. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (cut)

//裁剪图片的函数  
-(UIImage*)cutImageAtSquare:(UIImage*)image Frame:(CGRect)frame;
//第二种方法
-(UIImage*)captureView:(UIView *)theView frame:(CGRect)fra;

@end

//
//  HSFSearchTF.h
//  HSFBase
//
//  Created by JuZhenBaoiMac on 2017/6/17.
//  Copyright © 2017年 JuZhenBaoiMac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HSFSearchTF : UITextField

#pragma mark -类方法
+(instancetype)searchViewWithFrame:(CGRect)frame delegate:(UIViewController *)delegateVC placeholder:(NSString *)placeholder placeholderColor:(UIColor *)placeholderColor titleColor:(UIColor *)titleColor font:(NSInteger)fontSize leftImgName:(NSString *)leftImgName isHaveBaseline:(BOOL)isHave;

@end

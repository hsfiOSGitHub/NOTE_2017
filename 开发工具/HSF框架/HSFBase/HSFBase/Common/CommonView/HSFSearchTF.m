//
//  HSFSearchTF.m
//  HSFBase
//
//  Created by JuZhenBaoiMac on 2017/6/17.
//  Copyright © 2017年 JuZhenBaoiMac. All rights reserved.
//

#import "HSFSearchTF.h"

@implementation HSFSearchTF

#pragma mark -类方法
+(instancetype)searchViewWithFrame:(CGRect)frame delegate:(UIViewController *)delegateVC placeholder:(NSString *)placeholder placeholderColor:(UIColor *)placeholderColor titleColor:(UIColor *)titleColor font:(NSInteger)fontSize leftImgName:(NSString *)leftImgName isHaveBaseline:(BOOL)isHave {
    
    HSFSearchTF *searchTF = [[HSFSearchTF alloc]initWithFrame:frame];
    searchTF.delegate = delegateVC;
    //placeholder
    NSAttributedString *attr_str = [[NSAttributedString alloc]initWithString:placeholder attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:fontSize],NSForegroundColorAttributeName:placeholderColor}];
    searchTF.attributedPlaceholder = attr_str;
    //title
    searchTF.textColor = titleColor;
    searchTF.font = [UIFont systemFontOfSize:fontSize];
    //左边搜索icon
    UIImageView *imgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 30, 30)];
    imgView.image = [UIImage imageNamed:leftImgName];
    imgView.contentMode = UIViewContentModeCenter;
    [searchTF setLeftViewMode:UITextFieldViewModeAlways];
    [searchTF setLeftView:imgView];
    //baseline
    if (isHave) {
        UIView *baseline = [[UIView alloc]initWithFrame:CGRectMake(0, searchTF.height - 5, searchTF.width, 1)];
        baseline.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.5];
        baseline.userInteractionEnabled = NO;
        [searchTF addSubview:baseline];
    }
    
    
    return searchTF;
}

#pragma mark -初始化方法
-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        //        self.inputAccessoryView = self.keyboardTopView;
        //        self.returnKeyType = UIReturnKeySearch;
        //
        //        //title
        //        NSAttributedString *attr_str = [[NSAttributedString alloc]initWithString:@"请输入关键字" attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17],NSForegroundColorAttributeName:kRGBColor(249, 188, 197)}];
        //        self.attributedPlaceholder = attr_str;
        //        self.clearButtonMode = UITextFieldViewModeWhileEditing;
        //        self.tintColor = kRGBColor(249, 188, 197);
        //        self.textColor = kRGBColor(249, 188, 197);
        //
        //        //左边搜索icon
        //        UIImageView *imgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 30, 30)];
        //        imgView.image = [UIImage imageNamed:@"search"];
        //        imgView.contentMode = UIViewContentModeCenter;
        //        [self setLeftViewMode:UITextFieldViewModeAlways];
        //        [self setLeftView:imgView];
        //
        //        //baseline
        //        UIView *baseline = [[UIView alloc]initWithFrame:CGRectMake(0, frame.size.height - 5, frame.size.width, 1)];
        //        baseline.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.5];
        //        baseline.userInteractionEnabled = NO;
        //        [self addSubview:baseline];
    }
    return self;
}

@end

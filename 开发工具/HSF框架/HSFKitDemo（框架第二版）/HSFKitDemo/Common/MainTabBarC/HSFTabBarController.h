//
//  HSFTabBarController.h
//  HCJ
//
//  Created by JuZhenBaoiMac on 2017/7/13.
//  Copyright © 2017年 JuZhenBaoiMac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HSFTabBarController : BaseVC

@property (nonatomic,strong) UIView *tabBar;


@property (nonatomic,strong) NSArray *childVCArr;
@property (nonatomic,strong) NSArray *source;   //@[@{@"title":@"首页", @"selImg":@"", @"norImg":@""}]
@property (nonatomic,strong) UIColor *norColor;
@property (nonatomic,strong) UIColor *selColor;


//配置
-(void)setUp;

@end

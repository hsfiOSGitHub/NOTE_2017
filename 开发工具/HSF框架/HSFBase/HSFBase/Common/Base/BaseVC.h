//
//  BaseVC.h
//  SuperCar
//
//  Created by JuZhenBaoiMac on 2017/5/19.
//  Copyright © 2017年 JuZhenBaoiMac. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, ReturnType) {
    PopTpey = 0,
    DismissType
};

@class HSFNoResultView;

@interface BaseVC : UIViewController<UITextFieldDelegate>
@property (nonatomic,assign) ReturnType currentReturnType;//当前返回上一级方式
@property (nonatomic,assign) BOOL isFirstClass;//一级页面（有tabbar） 默认是NO -> 有返回icon


/*  附加功能  */
@property (nonatomic,strong) HSFNoResultView *noResultView;//网络请求 --> 没有结果
@property (nonatomic,strong) UIButton *menuBtn;//导航栏菜单menu
@property (nonatomic,strong) NSMutableArray *menuSource_icon;
@property (nonatomic,strong) NSMutableArray *menuSource_title;




#pragma mark -导航栏
//搜索
-(void)searchItemACTION;
//菜单menu
-(void)menuBtnACTION:(UIButton *)sender;

#pragma mark -返回上一级
-(void)goBack;

#pragma mark -导航栏左右位子
-(void)setLeftItemWithTitle:(NSString *)title tintColor:(UIColor *)color;
-(void)setLeftItemWithImageNamed:(NSString *)imageName;
-(void)leftItemACTION;

-(void)setRightItemWithTitle:(NSString *)title tintColor:(UIColor *)color;
-(void)setRightItemWithImageNamed:(NSString *)imageName;
-(void)rightItemACTION;

#pragma mark -HUD
-(void)showTopMessage:(NSString *)topMessage;
-(void)showCenterMessage:(NSString *)message;
-(void)showBottomMessag:(NSString *)message;

-(void)showSuccessMessage:(NSString *)message;
-(void)showErorrMessage:(NSString *)message;
-(void)showLoadingMessage:(NSString *)message;

#pragma mark -实用方法
//网络请求返回的状态码 （根据实际网络请求返回的数据结构 更改以下代码）
-(NSInteger)requestFinshCode:(NSDictionary *)responseObject isShowMessage:(BOOL)isShow;
//网络请求返回的是字典
-(NSDictionary *)dictionaryRequestSuccess:(NSDictionary *)responseObject;
//网络请求返回的是数组
-(NSArray *)arrayRequestSuccess:(NSDictionary *)responseObject;


@end

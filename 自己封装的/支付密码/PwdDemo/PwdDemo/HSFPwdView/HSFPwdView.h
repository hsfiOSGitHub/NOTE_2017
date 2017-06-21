//
//  HSFPwdView.h
//  PwdDemo
//
//  Created by JuZhenBaoiMac on 2017/6/20.
//  Copyright © 2017年 JuZhenBaoiMac. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, PwdType) {
    PwdType_Star,   // ＊
    PwdType_Dot     // •
};

typedef NS_ENUM(NSInteger, ShowType) {
    ShowType_Baseline,
    ShowType_Padding    
};

@protocol HSFPwdViewDelegate <NSObject>

@optional

-(void)inputePwdSuccess:(NSString *)pwd;

@end


@interface HSFPwdView : UIView

@property (nonatomic,assign) PwdType pwd_type;
@property (nonatomic,assign) ShowType show_type;
@property (nonatomic,assign) id<HSFPwdViewDelegate>delegate;
@property (nonatomic,assign) NSInteger pwdNumber;//密码个数

@property (nonatomic,strong) NSString *currentPwd;//当前密码
/*  个性化设置  */
@property (nonatomic,assign) CGFloat fontSize;//密码font
@property (nonatomic,strong) UIColor *pwdColor;//密码颜色
@property (nonatomic,strong) UIColor *baselineColor;//底线颜色
@property (nonatomic,strong) UIColor *paddingColor;//间隔线颜色


//类方法
+(instancetype)pwdViewWithFrame:(CGRect)frame delegate:(id<HSFPwdViewDelegate>)delegate pwdNumber:(NSInteger) pwdNum pwdType:(PwdType)pwdType showType:(ShowType)showType;

//调用方法
-(void)addPwd:(NSString *)pwdStr;

//加边框圆角
-(void)setBorderColor:(UIColor *)borderColor borderWidth:(CGFloat)borderWidth cornerRadius:(CGFloat)cornerRadius;

#pragma mark -显示/隐藏 密码
-(void)showPwd;
-(void)hidePwd;


@end

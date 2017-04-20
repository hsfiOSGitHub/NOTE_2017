//
//  MBProgressHUD+bottom.m
//  友照
//
//  Created by monkey2016 on 16/12/6.
//  Copyright © 2016年 ZX_XPH. All rights reserved.
//

#import "MBProgressHUD+bottom.h"

@implementation MBProgressHUD (bottom)
//默认添加到window上
+ (void)showBottomHUD:(NSString *)error{
    [self showBottomHUD:error toView:nil];
}
//添加到view上
+ (void)showBottomHUD:(NSString *)error toView:(UIView *)view{
    [self showBottom:error icon:@"" view:view];
}
//指定初始化方法
+ (void)showBottom:(NSString *)text icon:(NSString *)icon view:(UIView *)view{
    if (view == nil) view = [[UIApplication sharedApplication].windows lastObject];
    // 快速显示一个提示信息
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.labelText = text;
    // 再设置模式
    hud.mode = MBProgressHUDModeText;
    
    // 隐藏时候从父控件中移除
    hud.removeFromSuperViewOnHide = YES;
    
    // 1秒之后再消失
    [hud hide:YES afterDelay:1];
    
    //设置偏移
    hud.yOffset = KScreenHeight/2 - 80;
}
@end

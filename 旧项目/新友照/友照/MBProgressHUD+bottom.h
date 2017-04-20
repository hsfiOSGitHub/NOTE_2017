//
//  MBProgressHUD+bottom.h
//  友照
//
//  Created by monkey2016 on 16/12/6.
//  Copyright © 2016年 ZX_XPH. All rights reserved.
//

#import "MBProgressHUD.h"

@interface MBProgressHUD (bottom)
//默认添加到window上
+ (void)showBottomHUD:(NSString *)error;
//添加到view上
+ (void)showBottomHUD:(NSString *)error toView:(UIView *)view;
@end

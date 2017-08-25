//
//  UIView+Window.h
//  HSFChatKit
//
//  Created by JuZhenBaoiMac on 2017/8/23.
//  Copyright © 2017年 JuZhenBaoiMac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Window)

/**
 获取指定视图在window根控制器中的位置
 
 @param view 指定View
 @return 返回在window根控制器中的位置
 */
+ (CGRect)getFrameInWindow:(UIView * _Nonnull)view;


/**
 将UIView添加到window上
 */
-(void)addToWindow;


@end

//
//  CMAlertView.h
//  AllTest
//
//  Created by jon on 16/10/26.
//  Copyright © 2016年 jon. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
typedef void(^actionBlock)(NSInteger buttonTag);
@interface CMAlertView : NSObject

@property (nonatomic, copy) actionBlock alertBlcok;
@property (nonatomic, copy) actionBlock sheetBlcok;

+ (CMAlertView *)sharedInstance;

/*!
 @method 创建提示框
 @param viewController     用于显示alert的controller
 @param title              标题
 @param message            提示内容
 @param cancelTitle        取消按钮
 @param block              点击按钮的回调
 @param otherButtonTitles  按钮
 @discussion               取消按钮buttonTag为0,其他按钮按顺序从1开始.                           iOS8之前buttonTag为系统的buttonIndex.如果取消和其他按钮都为nil则没有操作按钮,传参数时必须以nil结尾，否则会崩溃.
 *
 */
- (void)showAlertController:(UIViewController *)viewController
                      title:(NSString *)title
                    message:(NSString *)message
                cancelTitle:(NSString *)cancelTitle
                actionBlock:(actionBlock)block
          otherButtonTitles:(NSString *)otherButtonTitles, ... NS_REQUIRES_NIL_TERMINATION;

/*!
 @method  创建actionSheet
 @param viewController     用于显示actionSheet的controller
 @param title              标题
 @param message            提示内容
 @param cancelTitle        取消按钮
 @param block              点击按钮的回调 
 @param otherButtonTitles  按钮
 @param destructive        destructive按钮
 @discussion               取消按钮buttonTag为0,destructive按钮的buttonTag==-1,其他按钮按顺序从1开始. iOS8之前buttonTag为系统的buttonIndex.如果取消和其他按钮都为nil则没有操作按钮,传参数时必须以nil结尾，否则会崩溃.

 *
 */
- (void)showActionSheetController:(UIViewController *)viewController
                            title:(NSString *)title
                          message:(NSString *)message
                      cancelTitle:(NSString *)cancelTitle
                      destructive:(NSString *)destructive
                      actionBlock:(actionBlock)block
                otherButtonTitles:(NSString *)otherButtonTitles, ... NS_REQUIRES_NIL_TERMINATION;






/**
 用法
 [[CMAlertView sharedInstance] showActionSheetController:self title:@"提示" message:@"这是一个测试消息" cancelTitle:@"取消" destructive:@"滚犊子" actionBlock:^(NSInteger buttonTag) {
 switch (buttonTag) {
 case 0:
 //do something
 break;
 case 1:
 NSLog(@"点击确定");
 break;
 case 2:
 NSLog(@"点击不确定");
 break;
 case 3:
 NSLog(@"点击很不确定");
 break;
 
 default:
 break;
 }
 } otherButtonTitles:@"确定",@"不怎么确定",@"不确定",@"确定",@"不怎么确定",@"不确定",@"确定",@"不怎么确定",@"不确定", nil];
 */




@end

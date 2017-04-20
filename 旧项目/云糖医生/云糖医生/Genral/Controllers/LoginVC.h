//
//  LoginVC.h
//  yuntangyi
//
//  Created by yuntangyi on 16/9/1.
//  Copyright © 2016年 yuntangyi. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LoginVCDeletage <NSObject>

-(void)quitLoginVCPlayMp4Again;

@end

@interface LoginVC : UIViewController
@property (nonatomic,assign) id<LoginVCDeletage> delegate;
@property (nonatomic,strong) NSString *sourceModeVC;
@end

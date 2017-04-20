//
//  KnSignUpDetailVC.h
//  yuntangyi
//
//  Created by yuntangyi on 16/8/30.
//  Copyright © 2016年 yuntangyi. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol KnSignUpDetailVCDelegate <NSObject>

-(void)returnSignUpStatus:(NSNumber *)is_exist;

@end

@interface KnSignUpDetailVC : UIViewController
@property (nonatomic,strong) NSString *mid;
@property (nonatomic,strong) NSString *sourcePushVC;//
@property (nonatomic,assign) id<KnSignUpDetailVCDelegate> delegate;
@property (nonatomic,strong) NSString *doType;//报名方式 主动报名 后台邀请
@end

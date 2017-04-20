//
//  RegesterVC.h
//  yuntangyi
//
//  Created by yuntangyi on 16/9/2.
//  Copyright © 2016年 yuntangyi. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol RegisterVCDelegate <NSObject>

-(void)quitRegisterVCPlayMp4;

@end

@interface RegisterVC : UIViewController
@property (nonatomic,strong) NSString *sourcePushVC;
@property (nonatomic,strong) NSString *sourceModeVC;
@property (nonatomic,assign) id<RegisterVCDelegate> delegate;
@end

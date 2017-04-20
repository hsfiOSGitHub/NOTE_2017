//
//  Register2VC.h
//  yuntangyi
//
//  Created by yuntangyi on 16/9/29.
//  Copyright © 2016年 yuntangyi. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol Register2VCDeletage <NSObject>

-(void)playMp4Again;

@end

@interface Register2VC : UIViewController
@property (nonatomic,assign) id<Register2VCDeletage> delegate;
@end

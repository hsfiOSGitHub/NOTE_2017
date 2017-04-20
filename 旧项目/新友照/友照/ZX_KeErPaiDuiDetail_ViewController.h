//
//  ZX_KeErPaiDuiDetail_ViewController.h
//  友照
//
//  Created by cleloyang on 2016/11/26.
//  Copyright © 2016年 ZX_XPH. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZX_KeErPaiDuiDetail_ViewController : ZXSeconBaseViewController

@property(strong,nonatomic) NSString* kaoChangId;
@property(nonatomic,strong) NSString* nianYueRi;
@property(nonatomic,strong) NSString* zhouJi;
@property(nonatomic,strong) NSString* kaoChangMing;
@property(nonatomic,strong) NSString* riQi;
@property(nonatomic,strong) NSString* stid;
@property(strong,nonatomic) NSArray* keErPaiDuiArr;
@property(nonatomic, assign) BOOL isWoDeDuiWu;

@end

//
//  UMComProfileSettingController.h
//  UMCommunity
//
//  Created by luyiyuan on 14/10/27.
//  Copyright (c) 2014年 Umeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UMComResouceDefines.h"
#import "UMComViewController.h"


@class UMComUser, UMComImageView;

@interface UMComSimpleProfileSettingController : UMComViewController
<UITextFieldDelegate,UINavigationControllerDelegate>

@property (nonatomic, assign) BOOL hideLogout;

@property (nonatomic, copy) dispatch_block_t updateCompletion ;


@property (weak, nonatomic) IBOutlet UILabel *souceUidLabel;
@property (nonatomic, weak) IBOutlet UITextField * nameField;
@property (nonatomic, strong) IBOutlet UMComImageView *userPortrait;


@property (weak, nonatomic) IBOutlet UILabel *pushStatus;
@property (weak, nonatomic) IBOutlet UIButton *logoutButton;
@property (weak, nonatomic) IBOutlet UIImageView *cameraIcon;

@property (weak, nonatomic) IBOutlet UIView *maleIcon;
@property (weak, nonatomic) IBOutlet UIView *femaleIcon;

- (IBAction)choseMale:(id)sender;
- (IBAction)choseFemale:(id)sender;

- (IBAction)logout:(id)sender;

@end

//
//  UMComLoginViewController.h
//  UMCommunity
//
//  Created by wyq.Cloudayc on 5/11/16.
//  Copyright © 2016 Umeng. All rights reserved.
//

#import "UMComViewController.h"

@interface UMComLoginViewController : UMComViewController

/**
 *  community login
 */
@property (weak, nonatomic) IBOutlet UITextField *accountField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;
@property (weak, nonatomic) IBOutlet UIButton *registerButton;

@property (weak, nonatomic) IBOutlet UIImageView *accountIcon;
@property (weak, nonatomic) IBOutlet UIImageView *passwordIcon;

@property (weak, nonatomic) IBOutlet UIView *accountColorView;
@property (weak, nonatomic) IBOutlet UIView *pwdColorView;

- (instancetype)initWithExclusiveLogin:(BOOL)exclusive;

- (IBAction)forgotPassword:(id)sender;

- (IBAction)login:(id)sender;

- (IBAction)registerAccount:(id)sender;

@end

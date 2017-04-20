//
//  UMComLoginViewController.m
//  UMCommunity
//
//  Created by wyq.Cloudayc on 5/11/16.
//  Copyright © 2016 Umeng. All rights reserved.
//

#import "UMComLoginViewController.h"
#import "UMComRegisterViewController.h"
#import "UMComResouceDefines.h"
#import <UMComFoundation/UMComKit+String.h>
#import "UIViewController+UMComAddition.h"
#import "UMComShowToast.h"
#import "UMComProgressHUD.h"
#import <UMComFoundation/UMUtils.h>

#import <UMComDataStorage/UMComUser.h>
#import <UMComDataStorage/UMComImageUrl.h>

#import <UMCommunitySDK/UMComDataRequestManager.h>
#import <UMComFoundation/UMComKit+Color.h>

@interface UMComLoginViewController ()

@property (nonatomic, weak) UITextField *currentField;

@property (nonatomic, assign) BOOL exclusiveLogin;

@end

@implementation UMComLoginViewController

- (instancetype)init
{
    if (self = [self initWithNibName:@"UMComLoginViewController" bundle:nil]) {
        self.exclusiveLogin = NO;
    }
    return self;
}

- (instancetype)initWithExclusiveLogin:(BOOL)exclusive
{
    if (self = [self init]) {
        self.exclusiveLogin = exclusive;
    }
    return self;
}

- (void)checkLoadPlatformLoginView
{
    if (_exclusiveLogin) {
        return;
    }
    SEL initLoginPlatformViewSelector = NSSelectorFromString(@"plugInViewController:");
    Class PlatformViewClass = NSClassFromString(@"UMComLoginPlatformView");
    if ([[PlatformViewClass class] respondsToSelector:initLoginPlatformViewSelector]) {
        [PlatformViewClass performSelector:initLoginPlatformViewSelector withObject:self];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UMComColorWithHexString(@"#E1E6E9");

    [self setForumUITitle:UMComLocalizedString(@"um_com_login", @"登录")];

    [self initViews];

    [self checkLoadPlatformLoginView];

    self.navigationItem.leftBarButtonItem = nil;
    self.navigationItem.leftBarButtonItems = nil;

    UIButton *closeButon = [UIButton buttonWithType:UIButtonTypeCustom];
    [closeButon setImage:UMComImageWithImageName(@"close") forState:UIControlStateNormal];
    [closeButon addTarget:self action:@selector(close) forControlEvents:UIControlEventTouchUpInside];
    closeButon.frame = CGRectMake(0.f, 0.f, 22.f, 22.f);
    UIBarButtonItem *closeItem = [[UIBarButtonItem alloc] initWithCustomView:closeButon];
    [self.navigationItem setLeftBarButtonItem:closeItem];
    
    UIView *placeHolderView = [[UIView alloc] init];
    placeHolderView.frame = CGRectMake(0.f, 0.f, 22.f, 22.f);
    UIBarButtonItem *placeHolderButton = [[UIBarButtonItem alloc] initWithCustomView:placeHolderView];
    [self.navigationItem setRightBarButtonItem:placeHolderButton];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initViews
{
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)]) {
        [self setEdgesForExtendedLayout:UIRectEdgeNone];
    }
    
    [_accountIcon setImage:UMComImageWithImageName(@"userid")];
    [_passwordIcon setImage:UMComImageWithImageName(@"keyword")];
    
    _registerButton.layer.borderWidth = 1.f;
    _registerButton.layer.borderColor = UMComColorWithHexString(@"#469EF8").CGColor;
    
    UITapGestureRecognizer *tapClose = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
    [self.view addGestureRecognizer:tapClose];
}

- (IBAction)forgotPassword:(id)sender {
    [_passwordField resignFirstResponder];
    [_accountField resignFirstResponder];
    if (_accountField.text.length == 0) {
        [UMComShowToast accountEmailEmpty];
        return;
    }
    
    if (![UMComKit checkEmailFormat:_accountField.text]) {
        [UMComShowToast accountEmailInvalid];
        return;
    }
    
    [[UMComDataRequestManager defaultManager] userPasswordForgetForUMCommunity:_accountField.text response:^(NSDictionary *responseObject, NSError *error) {
        if (error) {
            [UMComShowToast showFetchResultTipWithError:error];
        } else {
            [UMComShowToast accountFindPasswordSuccess];
        }

    }];
}


- (IBAction)login:(id)sender {
    [_passwordField resignFirstResponder];
    [_accountField resignFirstResponder];

    if (_accountField.text.length == 0) {
        [UMComShowToast accountEmailEmpty];
        return;
    }
    
    if (![UMComKit checkEmailFormat:_accountField.text]) {
        [UMComShowToast accountEmailInvalid];
        return;
    }
    
    if (_passwordField.text.length == 0) {
        [UMComShowToast accountPasswordEmpty];
        return;
    }
    
    if (_passwordField.text.length < 6 || _passwordField.text.length > 18 || ![UMComKit includeAlphabetOrDigitOnly:_passwordField.text]) {
        [UMComShowToast accountPasswordInvalid];
        return;
    }
    
    //加入等待框
    UMComProgressHUD *hud = [UMComProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    hud.label.text = UMComLocalizedString(@"um_com_loginingContent",@"登录中...");
    hud.label.backgroundColor = [UIColor clearColor];
    
    __weak typeof(self) ws = self;
    [UMComLoginManager requestLoginWithEmailAccount:_accountField.text password:_passwordField.text requestCompletion:^(NSDictionary *responseObject, NSError *error, dispatch_block_t completion) {
        [hud hideAnimated:YES];
        if (error) {
            [UMComShowToast showFetchResultTipWithError:error];
        } else {
            [UMComShowToast accountLoginSuccess];
            [ws.navigationController dismissViewControllerAnimated:YES completion:completion];
        }
    }];
}

- (IBAction)registerAccount:(id)sender {
    UMComRegisterViewController *registerVC = [[UMComRegisterViewController alloc] init];
    [self.navigationController pushViewController:registerVC animated:YES];
}

#pragma mark - UITextField delegate
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    self.currentField = textField;
    [self refreshColorView];
}
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [self refreshColorView];
}

#pragma mark - event
- (void)refreshColorView
{
    _accountColorView.hidden = [_accountField isFirstResponder];
    _pwdColorView.hidden = [_passwordField isFirstResponder];
}

- (void)hideKeyboard
{
    [_currentField resignFirstResponder];
}

- (void)close
{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

@end

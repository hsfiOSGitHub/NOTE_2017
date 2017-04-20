//
//  UMComMicroFeedTableViewController.m
//  UMCommunity
//
//  Created by 张军华 on 16/2/24.
//  Copyright © 2016年 Umeng. All rights reserved.
//

#import "UMComFocusFeedTableViewController.h"
#import <UMCommunitySDK/UMComSession.h>
#import "UMComLoginManager.h"
#import "UMComFeedListDataController.h"
#import <UMComFoundation/UMComKit+Color.h>
#import "UMComRefreshView.h"

#define UMCom_MicroFeed_LoginTextFont 18
#define UMCom_MicroFeed_LoginTextColor @"#FFFFFF"
#define UMCom_MicroFeed_LoginBgColor @"#008BEA"
#define UMCom_MicroFeed_NoticeTextColor @"#A5A5A5"
#define UMCom_MicroFeed_NoticeTextFont 15

@interface UMComFocusFeedTableViewController ()

@property (nonatomic, strong) UIView *loginView;

- (void)login:(UIButton *)sender;
- (UIView *)createNoLoginView;

//设置需要登陆的时候，是否显示编辑界面入口
-(void)setEditButtonWhenNeedLogin;

@end

@implementation UMComFocusFeedTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if ([UMComLoginManager isLogin] == YES) {
        [self creatDataController];
    }else{
        self.isAutoStartLoadData = NO;
    }
}

- (void)creatDataController
{
    UMComFeedFocusDataController* focusDataController =  [[UMComFeedFocusDataController alloc] initWithCount:UMCom_Limit_Page_Count];
    focusDataController.isReadLoacalData = YES;
    focusDataController.isSaveLoacalData = YES;
    self.dataController = focusDataController;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [self setEditButtonWhenNeedLogin];
    [super viewWillAppear:animated];
    [self resetSubViews];
}

#pragma mark -  限制登陆的方法
- (void)resetSubViews
{
    if (![UMComSession sharedInstance].isLogin) {
        if (!self.loginView) {
            self.loginView = [self createNoLoginView];
            [self.view addSubview:self.loginView];
        }else{
            if (self.loginView.superview != self.view) {
                [self.view addSubview:self.loginView];
            }
        }
        self.editButton.hidden = YES;
        [self.view bringSubviewToFront:self.loginView];
    }else{
        self.editButton.hidden = NO;
        [self.loginView removeFromSuperview];
        if (!self.dataController) {
            [self creatDataController];
            [self refreshData];
        }
    }
}

- (UIView *)createNoLoginView
{
    UIView *nologinView = [[UIView alloc]initWithFrame:self.view.bounds];
    nologinView.backgroundColor = [UIColor whiteColor];
    
    UILabel *noticellabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, nologinView.frame.size.width, 40)];
    noticellabel.text = UMComLocalizedString(@"um_com_focusAferLoginIn", @"您登陆后，服务器君才知道您关注的话题哦~");
    noticellabel.center = CGPointMake(nologinView.frame.size.width/2, nologinView.frame.size.height/2 - 45);
    noticellabel.textAlignment = NSTextAlignmentCenter;
    noticellabel.font = UMComFontNotoSansLightWithSafeSize(UMCom_MicroFeed_NoticeTextFont);
    noticellabel.textColor = UMComColorWithHexString(UMCom_MicroFeed_NoticeTextColor);
    [nologinView addSubview:noticellabel];
    
    UIButton *loginButton = [UIButton buttonWithType:UIButtonTypeCustom];
    loginButton.frame = CGRectMake(0, 0, 150, 45);
    loginButton.layer.cornerRadius = 5;
    loginButton.clipsToBounds = YES;
    loginButton.center = CGPointMake(nologinView.frame.size.width/2, nologinView.frame.size.height/2);
    [loginButton setTitle:UMComLocalizedString(@"um_com_login", @"立即登录") forState:UIControlStateNormal];
    [loginButton setTitleColor:UMComColorWithHexString(UMCom_MicroFeed_LoginTextColor) forState:UIControlStateNormal];
    [loginButton setBackgroundColor:UMComColorWithHexString(UMCom_MicroFeed_LoginBgColor)];
    loginButton.titleLabel.font = UMComFontNotoSansLightWithSafeSize(UMCom_MicroFeed_LoginTextFont);
    [loginButton addTarget:self action:@selector(login:) forControlEvents:UIControlEventTouchUpInside];
    [nologinView addSubview:loginButton];
    return nologinView;
}

- (void)login:(UIButton *)sender
{
    __weak typeof(self) weakSelf = self;
    [UMComLoginManager performLogin:self completion:^(id responseObject, NSError *error) {
        if (!error) {
            self.editButton.hidden = NO;
            [weakSelf creatDataController];
            [weakSelf refreshData];
            [weakSelf.loginView removeFromSuperview];
        }
    }];
}

#pragma mark - UMComRefreshTableViewDelegate
- (void)refreshData
{
    if ([UMComSession sharedInstance].isLogin)
    {
        self.editButton.hidden = NO;
        [super refreshData];
    }
    else
    {
        [self.refreshHeadView endLoading];
        self.editButton.hidden = YES;
    }
}

- (void)loadMoreData
{
    if ([UMComSession sharedInstance].isLogin)
    {
        self.editButton.hidden = NO;
        [super loadMoreData];
    }
    else
    {
        [self.refreshFootView endLoading];
        self.editButton.hidden = YES;
    }
    
}


#pragma mark -设置是否显示编辑界面入口
-(void)setEditButtonWhenNeedLogin
{
    if (![UMComSession sharedInstance].isLogin)
    {
        self.isShowEditButton = NO;
    }
    else
    {
        self.isShowEditButton = YES;
    }
}


- (void)createFeedSucceed:(UMComFeed *)feed
{
    [self insertFeedStyleToDataArrayWithFeed:feed];
}

@end

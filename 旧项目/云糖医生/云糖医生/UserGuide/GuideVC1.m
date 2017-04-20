//
//  GuideVC1.m
//  yuntangyi
//
//  Created by yuntangyi on 16/10/28.
//  Copyright © 2016年 yuntangyi. All rights reserved.
//

#import "GuideVC1.h"

#import "AppDelegate.h"
#import "SZBNetDataManager+adpic.h"
#import "RegisterVC.h"
#import "LoginVC.h"

@interface GuideVC1 ()
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;
@property (weak, nonatomic) IBOutlet UIButton *registerBtn;

@property (weak, nonatomic) IBOutlet UIButton *tasteNow;//立即体验
@property (weak, nonatomic) IBOutlet UILabel *version;//版本

@end

@implementation GuideVC1



//点击登录
- (IBAction)loginBtnAction:(UIButton *)sender {
    //版本
    NSString *key = (NSString *)kCFBundleVersionKey;
    //新版本号
    NSString *version = [NSBundle mainBundle].infoDictionary[key];
    //老版本号
    [ZXUD setObject:version forKey:@"firstLanch"];
    LoginVC *login_VC = [[LoginVC alloc]init];
    login_VC.sourceModeVC = @"GuideVC";
//    login_VC.delegate = self;
    UINavigationController *navi = [[UINavigationController alloc]initWithRootViewController:login_VC];
    [self presentViewController:navi animated:YES completion:nil];
}
//点击注册
- (IBAction)registerBtnAction:(UIButton *)sender {
    RegisterVC *register_VC = [[RegisterVC alloc]init];
    register_VC.sourceModeVC = @"GuideVC";
//    register_VC.delegate = self;
    UINavigationController *navi = [[UINavigationController alloc]initWithRootViewController:register_VC];
    [self presentViewController:navi animated:YES completion:nil];
}
#pragma mark -viewWillAppear
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}
#pragma mark -viewDidLoad
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    _loginBtn.layer.masksToBounds = YES;
    _loginBtn.layer.cornerRadius = 5;
    //    _loginBtn.layer.borderColor = [UIColor groupTableViewBackgroundColor].CGColor;
    //    _loginBtn.layer.borderWidth = 1;
    
    _registerBtn.layer.masksToBounds = YES;
    _registerBtn.layer.cornerRadius = 5;
    //    _registerBtn.layer.borderColor = [UIColor groupTableViewBackgroundColor].CGColor;
    //    _registerBtn.layer.borderWidth = 1;
    
    
    
    //获取版本号
    [self getCurrentVersion];

}
//获取版本号
-(void)getCurrentVersion{
    NSString *versionStr = [ToolManager getVersion];
    self.version.text = [NSString stringWithFormat:@"云糖医生%@",versionStr];
}





- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

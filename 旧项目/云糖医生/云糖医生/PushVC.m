//
//  PushVC.m
//  云糖医生
//
//  Created by yujian on 16/10/14.
//  Copyright © 2016年 yuntangyi. All rights reserved.
//

#import "PushVC.h"
#import "MainTabBarController.h"
@interface PushVC ()<UIWebViewDelegate>
@property (nonatomic ,strong) UIWebView *pushWeb;
@property (nonatomic, strong)LoadingView *loadingView;
@property (nonatomic, strong) NetworkLoadFailureView *loadFailureView;//重新加载占位图
@end

@implementation PushVC
-(NetworkLoadFailureView *)loadFailureView{
    if (!_loadFailureView) {
        _loadFailureView = [[NetworkLoadFailureView alloc]initWithFrame:CGRectMake(0, 64, KScreenWidth, KScreenHeight - 64)];
    }
    return _loadFailureView;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
   
    [self creatWebView];
    _loadingView = [[LoadingView alloc]initWithFrame:CGRectMake(0, 64, KScreenWidth, KScreenHeight - 64)];
    _pushWeb = [[UIWebView alloc] initWithFrame:CGRectMake(0, 64, KScreenWidth, KScreenHeight - 64)];
    _pushWeb.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_pushWeb];
    self.pushWeb.delegate = self;
    //加载网页
    [self loadWebView];
}

//创建webView
- (void)creatWebView
{

    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(15, 20, 44, 44)];
    UILabel *lable = [[UILabel alloc]initWithFrame:CGRectMake(0, 20, KScreenWidth, 43)];
    lable.font = [UIFont systemFontOfSize:20];
    lable.textAlignment = NSTextAlignmentCenter;
    lable.text = @"详情";
    [self.view addSubview:lable];
    UIView *V = [[UIView alloc]initWithFrame:CGRectMake(0, 63, KScreenWidth, 1)];
    V.backgroundColor = J_BackLightGray;
    [self.view addSubview:V];
    [btn setBackgroundImage:[[UIImage imageNamed:@"返回"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]  forState:UIControlStateNormal];

    [btn addTarget:self action:@selector(BACK) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:btn];

    _pushWeb = [[UIWebView alloc] initWithFrame:CGRectMake(0, 64, KScreenWidth, KScreenHeight)];
    [self.view addSubview:_pushWeb];
    //加载网址
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:S_newsDetail_URL,_nid]];
    [_pushWeb loadRequest:[NSURLRequest requestWithURL:url]];

}

//返回
- (void)BACK
{
    MainTabBarController *tab  = [[MainTabBarController alloc] init];
    [[UIApplication sharedApplication].delegate window].rootViewController=tab;
    [[[UIApplication sharedApplication].delegate window] makeKeyAndVisible];
}

//加载网页
- (void)loadWebView {
    [self.loadFailureView removeFromSuperview];
    //加载网址
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:S_newsDetail_URL,_nid]];
    [_pushWeb loadRequest:[NSURLRequest requestWithURL:url]];
    
}
#pragma mark -UIWebViewDelegate
//  网页开始加载的时候调用
-(void)webViewDidStartLoad:(UIWebView *)webView{
    [self.view addSubview:_loadingView];
}
// 网页加载完成的时候调用
- (void)webViewDidFinishLoad:(UIWebView *)webView{
    [_loadingView dismiss];
}
//加载失败
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    [_loadingView dismiss];
    [self.view addSubview:self.loadFailureView];
    [self.loadFailureView.loadAgainBtn addTarget:self action:@selector(loadWebView) forControlEvents:UIControlEventTouchUpInside];
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

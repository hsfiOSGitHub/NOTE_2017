//
//  AboutUsViewController.m
//  yuntangyi
//
//  Created by yuntangyi on 16/9/27.
//  Copyright © 2016年 yuntangyi. All rights reserved.
//

#import "AboutUsViewController.h"

@interface AboutUsViewController ()<UIWebViewDelegate>
@property (strong, nonatomic) UIWebView *webV;
@property (nonatomic, strong)LoadingView *loadingView;
@property (nonatomic, strong) NetworkLoadFailureView *loadFailureView;//重新加载占位图
@end

@implementation AboutUsViewController
-(NetworkLoadFailureView *)loadFailureView{
    if (!_loadFailureView) {
        _loadFailureView = [[NetworkLoadFailureView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    }
    return _loadFailureView;
}
- (void)viewDidLoad {
    [super viewDidLoad];
     self.navigationItem.title = @"关于我们";
     self.view.backgroundColor = [UIColor whiteColor];
     self.navigationController.navigationBar.translucent = YES;
     self.automaticallyAdjustsScrollViewInsets = NO;
     self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"返回"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStyleDone target:self action:@selector(goToBack)];
    // Do any additional setup after loading the view.
  
    _loadingView = [[LoadingView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight)];
     self.webV = [[UIWebView alloc]initWithFrame:CGRectMake(0, 64, KScreenWidth, KScreenHeight - 64)];
     self.webV.delegate = self;
     _webV.backgroundColor = J_BackLightGray;
     [self loadWebView];
     [self.view addSubview:_webV];
   
}
- (void)loadWebView {
    [self.loadFailureView removeFromSuperview];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://app.yuntangyi.com/api/index.php?m=about_us"]];
    [_webV loadRequest:request];
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
- (void)goToBack {
    [self.navigationController popViewControllerAnimated:YES];
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

//
//  ZX_FuWuTiaoKuan_ViewController.m
//  友照
//
//  Created by cleloyang on 2016/11/22.
//  Copyright © 2016年 ZX_XPH. All rights reserved.
//

#import "ZX_FuWuTiaoKuan_ViewController.h"
#import "NJKWebViewProgress.h"
#import "NJKWebViewProgressView.h"

@interface ZX_FuWuTiaoKuan_ViewController ()<UIWebViewDelegate, NJKWebViewProgressDelegate>
@property (nonatomic, strong) NJKWebViewProgressView *webViewProgressView;
@property (nonatomic, strong) NJKWebViewProgress *webViewProgress;
@end

@implementation ZX_FuWuTiaoKuan_ViewController

- (void)viewDidDisappear:(BOOL)animated
{
    [_webViewProgressView removeFromSuperview];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"服务条款";
    _webViewProgress = [[NJKWebViewProgress alloc] init];
    _fuWuTiaoKuanWeb.delegate = _webViewProgress;
    _webViewProgress.webViewProxyDelegate = self;
    _webViewProgress.progressDelegate = self;
    
    
    CGRect navBounds = self.navigationController.navigationBar.bounds;
    CGRect barFrame = CGRectMake(0,navBounds.size.height - 2,navBounds.size.width,2);
    _webViewProgressView = [[NJKWebViewProgressView alloc] initWithFrame:barFrame];
    _webViewProgressView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
    [_webViewProgressView setProgress:0 animated:YES];
    
    NSURL *fileURL = [[NSBundle mainBundle] URLForResource:@"fuwu.html" withExtension:nil];
    NSURLRequest *request = [NSURLRequest requestWithURL:fileURL];
    [_fuWuTiaoKuanWeb loadRequest:request];
    
    [self.navigationController.navigationBar addSubview:_webViewProgressView];
    
}

//更新进度
- (void)webViewProgress:(NJKWebViewProgress *)webViewProgress updateProgress:(float)progress
{
    [_webViewProgressView setProgress:progress animated:YES];
}

//页面加载成功
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    //关闭进度条
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
}

//页面加载失败
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    //关闭进度条
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
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

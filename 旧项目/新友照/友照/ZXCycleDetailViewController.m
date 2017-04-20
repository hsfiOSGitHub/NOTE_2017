//
//  ZXCycleDetailViewController.m
//  ZXJiaXiao
//
//  Created by Finsen on 16/7/8.
//  Copyright © 2016年 ZX. All rights reserved.
//

#import "ZXCycleDetailViewController.h"
#import "NJKWebViewProgress.h"
#import "NJKWebViewProgressView.h"

@interface ZXCycleDetailViewController ()<UIWebViewDelegate, NJKWebViewProgressDelegate>

@property (nonatomic, strong) NJKWebViewProgressView *webViewProgressView;
@property (nonatomic, strong) NJKWebViewProgress *webViewProgress;

@end

@implementation ZXCycleDetailViewController

- (void)viewDidDisappear:(BOOL)animated
{
    [_webViewProgressView removeFromSuperview];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.webV setDelegate:self];
    _webViewProgress = [[NJKWebViewProgress alloc] init];
    _webV.delegate = _webViewProgress;
    _webViewProgress.webViewProxyDelegate = self;
    _webViewProgress.progressDelegate = self;
    
    CGRect navBounds = self.navigationController.navigationBar.bounds;
    CGRect barFrame = CGRectMake(0,navBounds.size.height - 2,navBounds.size.width,2);
    _webViewProgressView = [[NJKWebViewProgressView alloc] initWithFrame:barFrame];
    _webViewProgressView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
    [_webViewProgressView setProgress:0 animated:YES];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:self.url]];
    [self.webV loadRequest:request];
    
    [self.navigationController.navigationBar addSubview:_webViewProgressView];
}

//更新进度
- (void)webViewProgress:(NJKWebViewProgress *)webViewProgress updateProgress:(float)progress
{
    [_webViewProgressView setProgress:progress animated:YES];
}

//页面加载成功
-(void)webViewDidFinishLoad:(UIWebView *)webView
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
}



@end

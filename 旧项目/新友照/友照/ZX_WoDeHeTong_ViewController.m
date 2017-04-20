//
//  ZX_WoDeHeTong_ViewController.m
//  友照
//
//  Created by cleloyang on 2016/12/1.
//  Copyright © 2016年 ZX_XPH. All rights reserved.
//

#import "ZX_WoDeHeTong_ViewController.h"
#import "NJKWebViewProgress.h"
#import "NJKWebViewProgressView.h"
#import "ZXKongKaQuanView.h"


#define ZX_heTong_URL [NSString stringWithFormat:@"%@?m=agreement&rndstring=%@&ident_code=%@",ZX_URL]

@interface ZX_WoDeHeTong_ViewController ()<UIWebViewDelegate, NJKWebViewProgressDelegate>

@property (nonatomic, strong) NJKWebViewProgressView *webViewProgressView;
@property (nonatomic, strong) NJKWebViewProgress *webViewProgress;
@property(nonatomic, strong) UIWebView *woDeHeTongWeb;

@end

@implementation ZX_WoDeHeTong_ViewController

- (void)viewDidDisappear:(BOOL)animated
{
    [_webViewProgressView removeFromSuperview];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"我的合同";
    _woDeHeTongWeb = [[UIWebView alloc]initWithFrame:self.view.frame];
    _woDeHeTongWeb.backgroundColor = [UIColor whiteColor];
    _woDeHeTongWeb.delegate = self;
    [self.view addSubview:_woDeHeTongWeb];
    
    _webViewProgress = [[NJKWebViewProgress alloc] init];
    _woDeHeTongWeb.delegate = _webViewProgress;
    _webViewProgress.webViewProxyDelegate = self;
    _webViewProgress.progressDelegate = self;
    
    CGRect navBounds = self.navigationController.navigationBar.bounds;
    CGRect barFrame = CGRectMake(0,navBounds.size.height - 2,navBounds.size.width,2);
    _webViewProgressView = [[NJKWebViewProgressView alloc] initWithFrame:barFrame];
    _webViewProgressView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
    [_webViewProgressView setProgress:0 animated:YES];
    [self getWoDeHeTongData];
    [self.navigationController.navigationBar addSubview:_webViewProgressView];
}

//获取我的合同数据
- (void)getWoDeHeTongData
{
    [[ZXNetDataManager manager] getWoDeHeTongDataWithRndstring:[ZXDriveGOHelper getCurrentTimeStamp] andIdent_code: [ZXUD objectForKey:@"ident_code"] success:^(NSURLSessionDataTask *task, id responseObject)
    {
        NSError *err;
        NSString *receiveStr = [[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSString *jsonString = [receiveStr stringByReplacingOccurrencesOfString:@"\r" withString:@""];
        jsonString = [jsonString stringByReplacingOccurrencesOfString:@"\n" withString:@""];
        jsonString = [jsonString stringByReplacingOccurrencesOfString:@"\t" withString:@""];
        jsonString = [jsonString stringByReplacingOccurrencesOfString:@"\v" withString:@""];
        jsonString = [jsonString stringByReplacingOccurrencesOfString:@"\f" withString:@""];
        jsonString = [jsonString stringByReplacingOccurrencesOfString:@"\b" withString:@""];
        jsonString = [jsonString stringByReplacingOccurrencesOfString:@"\a" withString:@""];
        jsonString = [jsonString stringByReplacingOccurrencesOfString:@"\e" withString:@""];
        NSData * data = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&err];
        
        if(err)
        {
            NSLog(@"json解析失败：%@",err);
            [_woDeHeTongWeb loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString: [NSString stringWithFormat:@"%@?m=agreement&rndstring=%@&ident_code=%@",ZX_URL,[ZXDriveGOHelper getCurrentTimeStamp],[ZXUD objectForKey:@"ident_code"]]]]];
        }
        else
        {
            [MBProgressHUD showSuccess:jsonDict[@"msg"]];
        }
    } Failed:^(NSURLSessionTask *task, NSError *error)
    {
    }];
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

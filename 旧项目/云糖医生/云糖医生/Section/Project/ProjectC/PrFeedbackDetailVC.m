//
//  PrFeedbackDetailVC.m
//  yuntangyi
//
//  Created by yuntangyi on 16/9/6.
//  Copyright © 2016年 yuntangyi. All rights reserved.
//

#import "PrFeedbackDetailVC.h"

@interface PrFeedbackDetailVC ()<UIWebViewDelegate>
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (nonatomic,strong) LoadingView *loadingView;//加载中动画
@end

@implementation PrFeedbackDetailVC
#pragma mark -懒加载
-(LoadingView *)loadingView{
    if (!_loadingView) {
        _loadingView = [[LoadingView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight)];
    }
    return _loadingView;
}
#pragma mark - 导航栏设置
-(void)setUpNavi{
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"返回"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStyleDone target:self action:@selector(backAction)];
}
-(void)backAction{
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark -viewDidLoad
- (void)viewDidLoad {
    [super viewDidLoad];
    //标题
    self.title = @"反馈详情";
    //配置导航栏
    [self setUpNavi];
    //网络加载动画
    [self.view addSubview:self.loadingView];
    //加载网页
    _webView.delegate = self;
    NSString *url1 = @"http://china.ynet.com/3.1/1609/23/11769599.html";
    NSURL *url = [NSURL URLWithString:url1];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [_webView loadRequest:request];
}
#pragma mark -UIWebViewDelegate
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    
    return YES;
}
- (void)webViewDidStartLoad:(UIWebView *)webView{
    
}
- (void)webViewDidFinishLoad:(UIWebView *)webView{
    //加载动画停止
    [self.loadingView dismiss];
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

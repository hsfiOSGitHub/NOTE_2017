//
//  Project2VC.m
//  yuntangyi
//
//  Created by yuntangyi on 16/10/14.
//  Copyright © 2016年 yuntangyi. All rights reserved.
//

#import "Project2VC.h"

@interface Project2VC ()<UIWebViewDelegate>
@property (weak, nonatomic) IBOutlet UIWebView *webView;

@property (nonatomic,strong) LoadingView *loadingView;//加载中动画
@property (nonatomic,strong) NetworkLoadFailureView *loadFailureView;//加载失败图片
@end

@implementation Project2VC
//初始化方法
-(instancetype)init{
    if (self = [super init]) {
        self.hidesBottomBarWhenPushed = YES;//隐藏tabBar
    }
    return self;
}
#pragma mark -懒加载
-(LoadingView *)loadingView{
    if (!_loadingView) {
        _loadingView = [[LoadingView alloc]initWithFrame:self.webView.bounds];
    }
    return _loadingView;
}
#pragma mark - 导航栏设置
-(void)setUpNavi{
    self.navigationController.navigationBar.translucent = NO;
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"返回"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStyleDone target:self action:@selector(backAction)];
}
-(void)backAction{
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark -viewWillAppear
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.barTintColor = KRGB(253, 254, 255, 1);
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSFontAttributeName:[UIFont systemFontOfSize:20],NSForegroundColorAttributeName:KRGB(0, 172, 204, 1)}];
}
#pragma mark -viewDidLoad
- (void)viewDidLoad {
    [super viewDidLoad];
    //标题
    self.navigationItem.title = @"项目";
    //设置导航栏
    [self setUpNavi];
    //配置webView
    [self setUpWebView];
}
//配置webView
-(void)setUpWebView{
    self.webView.delegate = self;
    //    self.webView.backgroundColor = KRGB(0, 172, 204, 1);
    //加载网页
    _webView.delegate = self;
    NSString *newURL = nil;
    if ([self.activity_id isEqualToString:@"7"]) {
        newURL = [NSString stringWithFormat:@"http://app.yuntangyi.com/wenjuan/index.php?ident_code=%@",[ZXUD objectForKey:@"ident_code"]];
    }else{
        newURL = self.url;
    }
    NSURL *url = [NSURL URLWithString:newURL];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [_webView loadRequest:request];
}
#pragma mark -UIWebViewDelegate
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    //网络加载动画
    [self.view addSubview:self.loadingView];
    return YES;
}
- (void)webViewDidStartLoad:(UIWebView *)webView{
    
}
- (void)webViewDidFinishLoad:(UIWebView *)webView{
    //加载动画停止
    [self.loadingView dismiss];
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    //加载动画停止
    [self.loadingView dismiss];
    //加载失败
    [_loadFailureView removeFromSuperview];
    _loadFailureView = [[NetworkLoadFailureView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight)];
    _loadFailureView.center = CGPointMake(KScreenWidth/2, KScreenHeight/2);
    [self.view addSubview:_loadFailureView];
    [self.loadFailureView.loadAgainBtn addTarget:self action:@selector(loadAgainBtnAction) forControlEvents:UIControlEventTouchUpInside];
}
-(void)loadAgainBtnAction{
    [_loadFailureView removeFromSuperview];
    //加载网页
    _webView.delegate = self;
    NSURL *url = [NSURL URLWithString:self.url];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [_webView loadRequest:request];
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

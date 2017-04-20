//
//  SystemNewsVC.m
//  yuntangyi
//  Created by yuntangyi on 16/8/30.
//  Copyright © 2016年 yuntangyi. All rights reserved.
//

#import "SystemNewsVC.h"

#import "UINavigationBar+Background.h"

@interface SystemNewsVC ()<UIWebViewDelegate>
@property (nonatomic,strong) UIWebView *webV;
@property (nonatomic, strong)LoadingView *loadingView;//加载动画
@property (nonatomic, strong) NetworkLoadFailureView *loadFailureView;//重新加载占位图
@end

@implementation SystemNewsVC
-(NetworkLoadFailureView *)loadFailureView{
    if (!_loadFailureView) {
        _loadFailureView = [[NetworkLoadFailureView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    }
    return _loadFailureView;
}
#pragma mark -导航栏设置
-(void)setUpNavi{
    self.navigationController.navigationBar.backgroundColor = [UIColor whiteColor];
    //返回按钮
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(0, 0, 44, 44);
    [backBtn setImage:[UIImage imageNamed:@"返回"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc]initWithCustomView:backBtn];
    self.navigationItem.leftBarButtonItem = backItem;
    self.webV.delegate = self;
}
//返回
-(void)backAction{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark -viewDidLoad
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.webV = [[UIWebView alloc]initWithFrame:self.view.bounds];
    self.webV.backgroundColor = [UIColor colorWithRed:0.933 green:0.933 blue:0.953 alpha:1.000];
    [self.view addSubview:self.webV];
    //导航栏设置
    [self setUpNavi];
    //标题
    self.navigationItem.title = @"系统消息";
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSFontAttributeName:[UIFont systemFontOfSize:19],NSForegroundColorAttributeName:KRGB(0, 172, 204, 1)}];
    _loadingView = [[LoadingView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight)];
    [self loadWebView];
}
- (void)loadWebView {
    //消息列表
    NSString *str = [NSString stringWithFormat:SRemind_list_Url,[ZXUD objectForKey:@"ident_code"]];
    NSURL *url = [NSURL URLWithString:str];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [self.webV loadRequest:request];
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

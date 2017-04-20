//
//  PicAndWheetViewController.m
//  yuntangyi
//
//  Created by yuntangyi on 16/9/18.
//  Copyright © 2016年 yuntangyi. All rights reserved.
//

#import "PicAndWheetViewController.h"
#import "SZBNetDataManager+PatientManageNetData.h"

@interface PicAndWheetViewController ()<UIWebViewDelegate>
@property (weak, nonatomic) IBOutlet UIWebView *webV;
@property (nonatomic, strong)LoadingView *loadingView;
@property (nonatomic, strong) NetworkLoadFailureView *loadFailureView;//重新加载占位图
@end

@implementation PicAndWheetViewController
-(NetworkLoadFailureView *)loadFailureView{
    if (!_loadFailureView) {
        _loadFailureView = [[NetworkLoadFailureView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    }
    return _loadFailureView;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"血糖图表";
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"返回"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStyleDone target:self action:@selector(goToBack)];
      _loadingView = [[LoadingView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight)];
      self.webV.delegate = self;
    //加载网页
      [self loadWebView];
   
}
//加载网页
- (void)loadWebView {
    [self.loadFailureView removeFromSuperview];
    //患者血糖图表
    NSString *str = [NSString stringWithFormat:SEcharts_Url,[ToolManager getCurrentTimeStamp], [ZXUD objectForKey:@"ident_code"], [ZXUD objectForKey:@"patient_id"]];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:str]];
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

//
//  WebViewController.m
//  XHLaunchAdExample
//
//  Created by xiaohui on 16/9/8.
//  Copyright © 2016年 CoderZhuXH. All rights reserved.
//

#import "WebViewController.h"

@interface WebViewController ()

@property (weak, nonatomic) IBOutlet UIWebView *myWebView;
@property (nonatomic, strong)LoadingView *loadingView;
@end

@implementation WebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"详情";
    _loadingView = [[LoadingView alloc]initWithFrame:CGRectMake(0, 64, KScreenWidth, KScreenHeight - 64)];
  
    [self setupWebView];
    
    // Do any additional setup after loading the view from its nib.
}
-(void)setupWebView{
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:self.URLString]];
    [self.myWebView loadRequest:request];
}
- (IBAction)closeAction:(id)sender {

    [self dismissViewControllerAnimated:YES completion:nil];

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

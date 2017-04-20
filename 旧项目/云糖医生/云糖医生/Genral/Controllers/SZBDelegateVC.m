//
//  SZBDelegateVC.m
//  yuntangyi
//
//  Created by yuntangyi on 16/9/28.
//  Copyright © 2016年 yuntangyi. All rights reserved.
//

#import "SZBDelegateVC.h"

@interface SZBDelegateVC ()<UIWebViewDelegate>
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *loadingIndicatorView;

@end

@implementation SZBDelegateVC
- (IBAction)cancelBtnAction:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //配置webView
    self.webView.delegate = self;
    // 添加内容
    NSURL *fileURL = [[NSBundle mainBundle] URLForResource:@"server.html" withExtension:nil];
    NSURLRequest *request = [NSURLRequest requestWithURL:fileURL];
    [self.webView loadRequest:request];
}
#pragma mark -UIWebViewDelegate
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    //旋转吧，大白
    [self.loadingIndicatorView startAnimating];
    return YES;
}
- (void)webViewDidStartLoad:(UIWebView *)webView{
    
}
- (void)webViewDidFinishLoad:(UIWebView *)webView{
    //转够了没有，大白
    [self.loadingIndicatorView stopAnimating];
    self.loadingIndicatorView.hidden = YES;
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    //转够了没有，大白
    [self.loadingIndicatorView stopAnimating];
    self.loadingIndicatorView.hidden = YES;
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

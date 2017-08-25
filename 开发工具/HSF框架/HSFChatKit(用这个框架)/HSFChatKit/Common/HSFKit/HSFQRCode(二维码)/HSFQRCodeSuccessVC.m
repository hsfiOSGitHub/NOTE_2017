//
//  HSFQRCodeSuccessVC.m
//  HSFKitDemo
//
//  Created by JuZhenBaoiMac on 2017/8/10.
//  Copyright © 2017年 JuZhenBaoiMac. All rights reserved.
//

#import "HSFQRCodeSuccessVC.h"

#import "SGWebView.h"
#import "SGQRCodeConst.h"


@interface HSFQRCodeSuccessVC ()<SGWebViewDelegate>

@property (nonatomic,strong) SGWebView *webView;

@end

@implementation HSFQRCodeSuccessVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self setupNavigationItem];
    
    if (self.jump_bar_code) {
        [self setupLabel];
    } else {
        [self setupWebView];
    }
}

- (void)setupNavigationItem {
    //    UIButton *left_Button = [[UIButton alloc] init];
    //    [left_Button setTitle:@"back" forState:UIControlStateNormal];
    //    [left_Button setTitleColor:[UIColor colorWithRed: 21/ 255.0f green: 126/ 255.0f blue: 251/ 255.0f alpha:1.0] forState:(UIControlStateNormal)];
    //    [left_Button sizeToFit];
    //    [left_Button addTarget:self action:@selector(left_BarButtonItemAction) forControlEvents:UIControlEventTouchUpInside];
    //    UIBarButtonItem *left_BarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:left_Button];
    //    self.navigationItem.leftBarButtonItem = left_BarButtonItem;
    
    self.navigationItem.title = @"扫描结果";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:(UIBarButtonSystemItemRefresh) target:self action:@selector(right_BarButtonItemAction)];
    self.navigationItem.rightBarButtonItem.tintColor = [UIColor whiteColor];
}
//- (void)left_BarButtonItemAction {
//    [self.navigationController popToRootViewControllerAnimated:YES];
//}
//返回
-(void)returnToPrevious{
    [self.navigationController popToRootViewControllerAnimated:YES];
}
- (void)right_BarButtonItemAction {
    [self.webView reloadData];
}

// 添加Label，加载扫描过来的内容
- (void)setupLabel {
    // 提示文字
    UILabel *prompt_message = [[UILabel alloc] init];
    prompt_message.frame = CGRectMake(0, 200, self.view.frame.size.width, 30);
    prompt_message.text = @"您扫描的条形码结果如下： ";
    prompt_message.textColor = [UIColor redColor];
    prompt_message.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:prompt_message];
    
    // 扫描结果
    CGFloat label_Y = CGRectGetMaxY(prompt_message.frame);
    UILabel *label = [[UILabel alloc] init];
    label.frame = CGRectMake(0, label_Y, self.view.frame.size.width, 30);
    label.text = self.jump_bar_code;
    label.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:label];
}

// 添加webView，加载扫描过来的内容
- (void)setupWebView {
    CGFloat webViewX = 0;
    CGFloat webViewY = 0;
    CGFloat webViewW = SGQRCodeScreenWidth;
    CGFloat webViewH = SGQRCodeScreenHeight;
    self.webView = [SGWebView webViewWithFrame:CGRectMake(webViewX, webViewY, webViewW, webViewH)];
    [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.jump_URL]]];
    _webView.progressViewColor = [UIColor redColor];
    _webView.SGQRCodeDelegate = self;
    [self.view addSubview:_webView];
}


/** 页面开始加载时调用 */
- (void)webViewDidStartLoad:(SGWebView *)webView{
    
}
/** 内容开始返回时调用 */
- (void)webView:(SGWebView *)webView didCommitWithURL:(NSURL *)url{
    
}
/** 页面加载失败时调用 */
- (void)webView:(SGWebView *)webView didFinishLoadWithURL:(NSURL *)url{
    SGQRCodeLog(@"didFinishLoad");
    self.title = webView.navigationItemTitle;
}
/** 页面加载完成之后调用 */
- (void)webView:(SGWebView *)webView didFailLoadWithError:(NSError *)error{
    
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

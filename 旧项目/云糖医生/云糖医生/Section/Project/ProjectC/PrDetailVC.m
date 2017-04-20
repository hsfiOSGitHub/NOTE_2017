//
//  PrDetailVC.m
//  SZB_doctor
//
//  Created by monkey2016 on 16/9/6.
//  Copyright © 2016年 monkey2016. All rights reserved.
//

#import "PrDetailVC.h"

#import "PrPatientListVC.h"
#import "PrDetailCell1.h"
#import "PrDetailCell2.h"
#import "SZBNetDataManager+ProjectNetData.h"
#import "PrActivityModel.h"

@interface PrDetailVC ()<UIWebViewDelegate>
@property (weak, nonatomic) IBOutlet UIButton *shareBtn;//分享按钮
@property (weak, nonatomic) IBOutlet UIWebView *webView;//网页
@property (nonatomic,strong) LoadingView *loadingView;//加载中动画

@end

static NSString *identifierCell1 = @"identifierCell1";
static NSString *identifierCell2 = @"identifierCell2";
@implementation PrDetailVC
#pragma mark -懒加载
-(LoadingView *)loadingView{
    if (!_loadingView) {
        _loadingView = [[LoadingView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight)];
    }
    return _loadingView;
}
#pragma mark -网络请求
////项目详情
//-(void)loadActivity_UrlData{
//    SZBNetDataManager *manager = [SZBNetDataManager manager];
//    [manager activityWithActivity_id:self.activity_id success:^(NSURLSessionDataTask *task, id responseObject) {
//        //网络请求成功
//        
//    } failed:^(NSURLSessionTask *task, NSError *error) {
//        //网络请求失败
//    }];
//}
#pragma mark -viewDidLoad
- (void)viewDidLoad {
    [super viewDidLoad];
    //网络加载动画
    [self.view addSubview:self.loadingView];
    //加载网页
    _webView.delegate = self;
//    NSString *url1 = @"http://china.ynet.com/3.1/1609/23/11769599.html";
    NSURL *url = [NSURL URLWithString:self.url];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [_webView loadRequest:request];
    //配置分享给患者按钮
    [self setUpShareBtn];
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
- (void)webView:(UIWebView *)webView didFailLoadWithError:(nullable NSError *)error{
    
}


//配置分享给患者按钮
-(void)setUpShareBtn{
    _shareBtn.layer.masksToBounds = YES;
    _shareBtn.layer.borderColor = [UIColor grayColor].CGColor;
    _shareBtn.layer.borderWidth = 1;
//    _shareBtn.layer.cornerRadius = 5;
}
//点击分享给患者
- (IBAction)shareBtnEvent:(UIButton *)sender {
    PrPatientListVC *patientList_VC = [[PrPatientListVC alloc]init];
    UINavigationController *navi = [[UINavigationController alloc]initWithRootViewController:patientList_VC];
    [self presentViewController:navi animated:YES completion:nil];
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

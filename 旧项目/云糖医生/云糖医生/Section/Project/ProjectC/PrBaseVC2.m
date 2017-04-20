//
//  PrBaseVC2.m
//  yuntangyi
//
//  Created by yuntangyi on 16/10/8.
//  Copyright © 2016年 yuntangyi. All rights reserved.
//

#import "PrBaseVC2.h"

#import "PrPatientListVC.h"
#import "PrFeedbackCell.h"
#import "PrFeedbackDetailVC.h"
#import "SZBNetDataManager+ProjectNetData.h"
#import "PrAnswerListModel.h"

@interface PrBaseVC2 ()<UITableViewDelegate,UITableViewDataSource,UIWebViewDelegate,UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *shareBtn;

@property (weak, nonatomic) IBOutlet UIView *baseline;//底线
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *baselineLeftConstraint;//底线左边约束

@property (weak, nonatomic) IBOutlet UIButton *projDetailBtn;//项目详情
@property (weak, nonatomic) IBOutlet UIButton *projFeedbackBtn;//项目反馈
@property (nonatomic,strong) UIButton *currentProjBtn;//当前点击的按钮

@property (nonatomic,strong) LoadingView *loadingView;//加载中动画
@property (nonatomic,strong) NetworkLoadFailureView *loadFailureView;//加载失败图片

@property (nonatomic,strong) NSArray *source;//数据源
@end

static NSString *identifierFeedbackCell = @"identifierFeedbackCell";
@implementation PrBaseVC2
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
    self.navigationItem.title = @"项目详情";
    //设置导航栏
    [self setUpNavi];
    //配置scrollView
    [self setUpScrollView];
    //配置tableView
    [self setUpTableView];
    //配置webView
    [self setUpWebView];
    //配置项目详情和项目反馈按钮 底线
    [self setUpProjBtnAndBaseline];
    //配置分享给患者按钮
    [self setUpShareBtn];
}
//配置scrollView
-(void)setUpScrollView{
    self.scrollView.delegate = self;
}
//配置tableView
-(void)setUpTableView{
    //设置数据源代理
    _tableView.dataSource = self;
    _tableView.delegate = self;
    //注册dell
    [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([PrFeedbackCell class]) bundle:nil] forCellReuseIdentifier:identifierFeedbackCell];
    //高度
    _tableView.estimatedRowHeight = 44;
    _tableView.rowHeight = UITableViewAutomaticDimension;
    
}
//配置webView
-(void)setUpWebView{
    self.webView.delegate = self;
//    self.webView.backgroundColor = KRGB(0, 172, 204, 1);
    //加载网页
    _webView.delegate = self;
    NSURL *url = [NSURL URLWithString:self.url];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [_webView loadRequest:request];
}
//配置项目详情和项目反馈按钮 底线
-(void)setUpProjBtnAndBaseline{
    [self.projDetailBtn setTitleColor:KRGB(0, 172, 204, 1) forState:UIControlStateNormal];
    [self.projDetailBtn setBackgroundColor:[UIColor whiteColor]];
    
    [self.projFeedbackBtn setTitleColor:KRGB(0, 172, 204, 1) forState:UIControlStateNormal];
    [self.projFeedbackBtn setBackgroundColor:[UIColor whiteColor]];
}
//配置分享给患者按钮
-(void)setUpShareBtn{
    [_shareBtn setBackgroundColor:KRGB(0, 172, 204, 1)];
    [_shareBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
}
//点击项目详情按钮
- (IBAction)projDetialBtnAction:(UIButton *)sender {
    [self.scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
}
//点击项目反馈按钮
- (IBAction)projFeedbackBtnAction:(UIButton *)sender {
    [self.scrollView setContentOffset:CGPointMake(KScreenWidth, 0) animated:YES];
}
//点击分享按钮
- (IBAction)shareBtnAction:(UIButton *)sender {
    PrPatientListVC *patientList_VC = [[PrPatientListVC alloc]init];
    patientList_VC.activity_id = self.activity_id;
    UINavigationController *navi = [[UINavigationController alloc]initWithRootViewController:patientList_VC];
    [self presentViewController:navi animated:YES completion:nil];
}
#pragma mark -UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (scrollView == _scrollView) {
        CGFloat offsetX = _scrollView.contentOffset.x;
        if (offsetX < KScreenWidth/2) {
            self.currentProjBtn = self.projDetailBtn;
            [UIView animateWithDuration:0.1 animations:^{
                self.baselineLeftConstraint.constant = 0;
                [self.baseline setNeedsLayout];
            }];
        }else if (offsetX > KScreenWidth/2) {
            self.currentProjBtn = self.projFeedbackBtn;
            [UIView animateWithDuration:0.1 animations:^{
                self.baselineLeftConstraint.constant = KScreenWidth/2;
                [self.baseline setNeedsLayout];
            }];
            //先将数据源 置空
            self.source = nil;
        }
    }
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
    
#pragma mark -UITableViewDelegate,UITableViewDataSource
//组数
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
//行数
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.source count];
}
//行内容
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    PrFeedbackCell *cell = [tableView dequeueReusableCellWithIdentifier:identifierFeedbackCell];
    return cell;
}
//点击cell
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];//取消选中
//    PrFeedbackDetailVC *feedbackDetail_VC = [[PrFeedbackDetailVC alloc]init];
//    self.hidesBottomBarWhenPushed = YES;
//    [self.navigationController pushViewController:feedbackDetail_VC animated:YES];
//    self.hidesBottomBarWhenPushed = NO;
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

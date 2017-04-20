//
//  KnCellType2VC.m
//  yuntangyi
//
//  Created by yuntangyi on 16/8/30.
//  Copyright © 2016年 yuntangyi. All rights reserved.
//

#import "KnCellType2VC.h"

#import "SZBNetDataManager+KnowLedgeNetData.h"
//分享
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKUI/ShareSDK+SSUI.h>
#import "ValueHelper.h"

@interface KnCellType2VC ()<UIWebViewDelegate>
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (weak, nonatomic) IBOutlet UIView *bgView;

@property (weak, nonatomic) IBOutlet UIView *shareView;
@property (weak, nonatomic) IBOutlet UIImageView *shareImgView;
@property (weak, nonatomic) IBOutlet UILabel *shareLabel;
@property (weak, nonatomic) IBOutlet UIButton *shareBtn;

@property (weak, nonatomic) IBOutlet UIView *collectView;
@property (weak, nonatomic) IBOutlet UIImageView *collectImgView;
@property (weak, nonatomic) IBOutlet UILabel *collectLabel;
@property (weak, nonatomic) IBOutlet UIButton *collectBtn;

@property (weak, nonatomic) IBOutlet UIView *likeView;
@property (weak, nonatomic) IBOutlet UIImageView *likeImgView;
@property (weak, nonatomic) IBOutlet UILabel *likeLabel;
@property (weak, nonatomic) IBOutlet UIButton *likeBtn;

@property (nonatomic,strong) UILabel *alertLabel;

@property (nonatomic,strong) LoadingView *loadingView;//加载中动画
@property (nonatomic,strong) NetworkLoadFailureView *loadFailureView;//加载失败图片
@end


@implementation KnCellType2VC
//初始化方法
-(instancetype)init{
    if (self = [super init]) {
        self.hidesBottomBarWhenPushed = YES;
    }
    return self;
}
#pragma maek -懒加载
-(UILabel *)alertLabel{
    if (!_alertLabel) {
        _alertLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, KScreenHeight, 150, 40)];
        _alertLabel.center = CGPointMake(self.view.center.x, KScreenHeight + 20);
        _alertLabel.layer.masksToBounds = YES;
        _alertLabel.layer.cornerRadius = 5;
        _alertLabel.textColor = [UIColor whiteColor];
        _alertLabel.backgroundColor = [UIColor darkGrayColor];
        _alertLabel.font = [UIFont systemFontOfSize:15];
        _alertLabel.textAlignment = NSTextAlignmentCenter;
        [self.view addSubview:_alertLabel];
    }
    return _alertLabel;
}
#pragma mark -懒加载

#pragma mark - 导航栏设置
-(void)setUpNavi{
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"返回"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStyleDone target:self action:@selector(backAction)];
}
//返回
-(void)backAction{
    //收藏
    UIImage *collectionImg = [UIImage imageNamed:@"Kn_newsDetail_collection"];
    UIImage *nocollectionImg = [UIImage imageNamed:@"Kn_newsDetail_noCollection"];
    if ([self.collectImgView.image isEqual:collectionImg]) {
        [self.delegate changeIsCollectStateWith:@"1" andNewsIndex:self.newsIndex andIndex:self.index];
    }else if ([self.collectImgView.image isEqual:nocollectionImg]) {
        [self.delegate changeIsCollectStateWith:@"0" andNewsIndex:self.newsIndex andIndex:self.index];
    }
    //点赞
    UIImage *likeImg = [UIImage imageNamed:@"Kn_newsDetail_like"];
    UIImage *nolikeImg = [UIImage imageNamed:@"Kn_NewsDetail_noLike"];
    if ([self.likeImgView.image isEqual:likeImg]) {
        [self.delegate changeIsPraiseStateWith:@"1" andNewsIndex:self.newsIndex andIndex:self.index];
    }else if ([self.likeImgView.image isEqual:nolikeImg]) {
        [self.delegate changeIsPraiseStateWith:@"0" andNewsIndex:self.newsIndex andIndex:self.index];
    }
    //返回
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark -viewWillAppear
-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSFontAttributeName:[UIFont systemFontOfSize:20],NSForegroundColorAttributeName:KRGB(0, 172, 204, 1.0)}];
}
#pragma mark -viewDidLoad
- (void)viewDidLoad {
    [super viewDidLoad];
    //标题
    self.navigationItem.title = @"正文";
    self.navigationController.navigationBar.translucent = YES;
    //导航栏设置
    [self setUpNavi];
    //加载网页
    [_loadFailureView removeFromSuperview];
    self.bgView.hidden = YES;
    _webView.delegate = self;
    NSURL *url = [NSURL URLWithString:self.url];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [_webView loadRequest:request];
    
    //配置分享  是否收藏  是否点赞
        //分享
    self.shareLabel.text = @"分享";
    UIImage *nosharedImg = [UIImage imageNamed:@"Kn_newsDetail_noShare"];
    self.shareImgView.image = nosharedImg;
        //收藏
    self.collectLabel.text = @"收藏";
    UIImage *collectionImg = [UIImage imageNamed:@"Kn_newsDetail_collection"];
    UIImage *nocollectionImg = [UIImage imageNamed:@"Kn_newsDetail_noCollection"];
    self.iscollect = self.iscollect;
    if ([self.iscollect isEqualToString:@"0"]) {
        self.collectImgView.image = nocollectionImg;
    }else if ([self.iscollect isEqualToString:@"1"]) {
        self.collectImgView.image = collectionImg;
    }
        //赞
    self.likeLabel.text = @"赞";
    UIImage *likeImg = [UIImage imageNamed:@"Kn_newsDetail_like"];
    UIImage *nolikeImg = [UIImage imageNamed:@"Kn_NewsDetail_noLike"];
    self.ispraise = self.ispraise;
    if ([self.ispraise isEqualToString:@"0"]) {
        self.likeImgView.image = nolikeImg;
    }else if ([self.ispraise isEqualToString:@"1"]) {
        self.likeImgView.image = likeImg;
    }
}

-(void)dismissAlertLabel{
    self.alertLabel.center = CGPointMake(self.view.center.x, KScreenHeight + 20);
}
//分享
- (IBAction)shareBtnAction:(UIButton *)sender {
    //1、创建分享参数
    NSArray* imageArray = @[_TPurl];
    //（注意：图片必须要在Xcode左边目录里面，名称必须要传正确，如果要分享网络图片，可以这样传iamge参数 images:@[@"http://mob.com/Assets/images/logo.png?v=20150320"]）
    if (imageArray)
    {
        NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
        [shareParams SSDKSetupShareParamsByText:_NR
                                         images:imageArray
                                            url:[NSURL URLWithString:_url]
                                          title:_BT
                                           type:SSDKContentTypeAuto];
        //2、分享（可以弹出我们的分享菜单和编辑界面）
        [ShareSDK showShareActionSheet:nil
                                 items:nil
                           shareParams:shareParams
                   onShareStateChanged:^(SSDKResponseState state, SSDKPlatformType platformType, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error, BOOL end) {
                       
                       switch (state)
                       {
                           case SSDKResponseStateSuccess:
                           {
                               UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"分享成功"
                                                                                   message:nil
                                                                                  delegate:nil
                                                                         cancelButtonTitle:@"确定"
                                                                         otherButtonTitles:nil];
                               [alertView show];
                               
//                               [_shareBtn setTitle:@"分享" forState:UIControlStateNormal];
//                               [_shareBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
//                               [_shareBtn setImage:[UIImage imageNamed:@"分享点击效果"] forState:UIControlStateNormal];
                               
                               break;
                           }
                           case SSDKResponseStateFail:
                           {
                               UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"分享失败"
                                                                               message:[NSString stringWithFormat:@"%@",error]
                                                                              delegate:nil
                                                                     cancelButtonTitle:@"OK"
                                                                     otherButtonTitles:nil, nil];
                               [alert show];
                               break;
                           }
                           default:
                               break;
                       }
                   }
         ];
    }
}

//收藏
- (IBAction)collectionBtnAction:(UIButton *)sender {
    UIImage *collectionImg = [UIImage imageNamed:@"Kn_newsDetail_collection"];
    UIImage *nocollectionImg = [UIImage imageNamed:@"Kn_newsDetail_noCollection"];
    SZBNetDataManager *manager = [SZBNetDataManager manager];
    [manager news_collectWithRandomStamp:[ToolManager getCurrentTimeStamp] AndIdent_code:[ZXUD objectForKey:@"ident_code"] AndId:self.newsID success:^(NSURLSessionDataTask *task, id responseObject) {
        /*
         {"res":"1001","msg":"收藏成功","status":"1","num":"16"}
         {"res":"1001","msg":"取消收藏","status":"0","num":"15"}
         {"res":"1002","msg":"登录状态已过期"}
         {"res":"1004","msg":"重复请求"}
         {"res":"1005","msg":"缺少参数"}
         {"res":"1006","msg":"您的账号被禁用"}
         {"res":"1007","msg":"资讯不存在"}
         {"res":"1008","msg":"收藏失败"}
         */
        if ([responseObject[@"res"] isEqualToString:@"1001"]) {
            if ([responseObject[@"status"] isEqualToString:@"0"]) {//取消收藏
                self.collectImgView.image = nocollectionImg;
            }else if ([responseObject[@"status"] isEqualToString:@"1"]) {//收藏成功
                self.collectImgView.image = collectionImg;
            }
        }else {
            self.collectImgView.image = nocollectionImg;
        }
        if ([responseObject[@"res"] isEqualToString:@"1001"]) {
            self.alertLabel.text = responseObject[@"msg"];
        }else{
            self.alertLabel.text = @"收藏失败";
        }
        [UIView animateWithDuration:0.1 animations:^{
            [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
            self.alertLabel.center = CGPointMake(self.view.center.x, KScreenHeight - 80);
        } completion:^(BOOL finished) {
            [self performSelector:@selector(dismissAlertLabel) withObject:nil afterDelay:1];
            
        }];
        NSLog(@"%@",responseObject);
    } failed:^(NSURLSessionTask *task, NSError *error) {
        self.alertLabel.text = @"网络请求失败";
        [UIView animateWithDuration:0.1 animations:^{
            [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
            self.alertLabel.center = CGPointMake(self.view.center.x, KScreenHeight - 80);
        } completion:^(BOOL finished) {
            [self performSelector:@selector(dismissAlertLabel) withObject:nil afterDelay:1];
            
        }];
        NSLog(@"%@",error);
    }];
}
//赞
- (IBAction)likeBtnAction:(UIButton *)sender {
    UIImage *likeImg = [UIImage imageNamed:@"Kn_newsDetail_like"];
    UIImage *nolikeImg = [UIImage imageNamed:@"Kn_NewsDetail_noLike"];
    SZBNetDataManager *manager = [SZBNetDataManager manager];
    [manager news_praiseWithRandomStamp:[ToolManager getCurrentTimeStamp] AndIdent_code:[ZXUD objectForKey:@"ident_code"] AndId:self.newsID success:^(NSURLSessionDataTask *task, id responseObject) {
        //网络请求成功
        /*
         {"res":"1001","msg":"点赞成功","status":"1","num":"2"}
         {"res":"1001","msg":"取消点赞","status":"0","num":"1"}
         {"res":"1002","msg":"登录状态已过期"}
         {"res":"1004","msg":"重复请求"}
         {"res":"1005","msg":"缺少参数"}
         {"res":"1006","msg":"您的账号被禁用"}
         {"res":"1007","msg":"资讯不存在"}
         {"res":"1008","msg":"点赞失败"}
         */
        if ([responseObject[@"res"] isEqualToString:@"1001"]) {
            if ([responseObject[@"status"] isEqualToString:@"0"]) {//取消点赞
                self.likeImgView.image = nolikeImg;
            }else if ([responseObject[@"status"] isEqualToString:@"1"]) {//点赞成功
                self.likeImgView.image = likeImg;
            }
        }else {
            self.likeImgView.image = nolikeImg;
        }
        if ([responseObject[@"res"] isEqualToString:@"1001"]) {
            self.alertLabel.text = responseObject[@"msg"];
        }else{
            self.alertLabel.text = @"点赞失败";
        }
        
        [UIView animateWithDuration:0.1 animations:^{
            [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
            self.alertLabel.center = CGPointMake(self.view.center.x, KScreenHeight - 80);
        } completion:^(BOOL finished) {
            [self performSelector:@selector(dismissAlertLabel) withObject:nil afterDelay:1];
            
        }];
        NSLog(@"%@",responseObject);
    } failed:^(NSURLSessionTask *task, NSError *error) {
        self.alertLabel.text = @"网络请求失败";
        [UIView animateWithDuration:0.1 animations:^{
            [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
            self.alertLabel.center = CGPointMake(self.view.center.x, KScreenHeight - 80);
        } completion:^(BOOL finished) {
            [self performSelector:@selector(dismissAlertLabel) withObject:nil afterDelay:1];
            
        }];
        NSLog(@"%@",error);
    }];
}
#pragma mark -UIWebViewDelegate
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    //网络加载动画
    self.loadingView = [[LoadingView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight)];
    [self.view addSubview:self.loadingView];
    return YES;
}
- (void)webViewDidStartLoad:(UIWebView *)webView{
    
}
- (void)webViewDidFinishLoad:(UIWebView *)webView{
    //加载动画停止
    [self.loadingView dismiss];
    self.bgView.hidden = NO;
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
    //加载网页
    [_loadFailureView removeFromSuperview];
    self.bgView.hidden = YES;
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

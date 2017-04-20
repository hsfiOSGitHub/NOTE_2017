//
//  PrBaseVC.m
//  SZB_doctor
//
//  Created by monkey2016 on 16/9/6.
//  Copyright © 2016年 monkey2016. All rights reserved.
//

#import "PrBaseVC.h"
#import "PrDetailVC.h"
#import "PrFeedbackVC.h"

#define btnW  (KScreenWidth - 1)/2
#define btnH  50
#define baselineH  3

@interface PrBaseVC ()<UIScrollViewDelegate>
@property (nonatomic,strong) UISegmentedControl *segmented;
@property (nonatomic,strong) UIScrollView *baseScrollView;
@property (nonatomic,strong) PrDetailVC *detail_VC;
@property (nonatomic,strong) PrFeedbackVC *feedback_VC;
//
@property (nonatomic,strong) UIButton *detailBtn;//项目详情
@property (nonatomic,strong) UIButton *feedbackBtn;//项目反馈
@property (nonatomic,strong) UIView *baseline;//底线

@end

@implementation PrBaseVC
//初始化方法
-(instancetype)init{
    if (self = [super init]) {
       self.hidesBottomBarWhenPushed = YES;
    }
    return self;
}
#pragma mark - 导航栏设置
-(void)setUpNavi{
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
    //配置导航栏
    [self setUpNavi];
    //添加标题按钮
    [self createTitleSeleterView];
    //创建secrollView
    [self createBaseScrollView];
}

//创建secrollView
-(void)createBaseScrollView{
    //解决无故偏移的问题
    self.automaticallyAdjustsScrollViewInsets = NO;
    //添加scrollView
    _baseScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, (64 + btnH + baselineH), KScreenWidth, KScreenHeight - (64 + btnH + baselineH))];//创建
    [self.view addSubview:_baseScrollView];//添加
    _baseScrollView.delegate = self;//代理
    _baseScrollView.pagingEnabled = YES;//翻页
    _baseScrollView.bounces = NO;
    _baseScrollView.contentSize = CGSizeMake(KScreenWidth * 2, KScreenHeight - (64 + btnH + baselineH));//内容大小
    _baseScrollView.showsVerticalScrollIndicator = NO;//导航条
    _baseScrollView.showsHorizontalScrollIndicator = NO;//导航条
    _baseScrollView.directionalLockEnabled = YES;//方向锁
    //添加子控制器
    _detail_VC = [[PrDetailVC alloc]init];
    _detail_VC.activity_id = self.activity_id;
    _feedback_VC = [[PrFeedbackVC alloc]init];
    _feedback_VC.activity_id = self.activity_id;
    _detail_VC.view.frame = CGRectMake(0, 0, KScreenWidth, KScreenHeight - (64 + btnH + baselineH));
    _feedback_VC.view.frame = CGRectMake(KScreenWidth, 0, KScreenWidth, KScreenHeight - (64 + btnH + baselineH));
    [self addChildViewController:_detail_VC];
    [self addChildViewController:_feedback_VC];
    [_baseScrollView addSubview:_detail_VC.view];
    [_baseScrollView addSubview:_feedback_VC.view];
}
//添加标题选择器
-(void)createTitleSeleterView{
    
    UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 64, KScreenWidth, btnH + baselineH)];
    bgView.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:bgView];
    //添加btn1
    _detailBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _detailBtn.frame = CGRectMake(0, 0, btnW, btnH);
    [_detailBtn setBackgroundColor:[UIColor whiteColor]];
    [_detailBtn setTitle:@"项目详情" forState:UIControlStateNormal];
    [_detailBtn setTitleColor:KRGB(0, 172, 204, 1) forState:UIControlStateNormal];
    [_detailBtn addTarget:self action:@selector(titleBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:_detailBtn];
    //添加btn2
    _feedbackBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _feedbackBtn.frame = CGRectMake(btnW + 1, 0, btnW, btnH);
    [_feedbackBtn setBackgroundColor:[UIColor whiteColor]];
    [_feedbackBtn setTitle:@"项目反馈" forState:UIControlStateNormal];
    [_feedbackBtn setTitleColor:KRGB(0, 172, 204, 1) forState:UIControlStateNormal];
    [_feedbackBtn addTarget:self action:@selector(titleBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:_feedbackBtn];
    //添加底线baseline1
    _baseline = [[UIView alloc]initWithFrame:CGRectMake(0, btnH, btnW, baselineH)];
    _baseline.backgroundColor = KRGB(0, 172, 204, 1);
    [bgView addSubview:_baseline];
    
}
//点击标题
-(void)titleBtnAction:(UIButton *)sender {
    if (sender == _detailBtn) {
        [UIView animateWithDuration:0.1 animations:^{
            _baseline.frame = CGRectMake(0, btnH, btnW, baselineH);
        }];
        self.baseScrollView.contentOffset = CGPointMake(0, 0);
    }else if (sender == _feedbackBtn) {
        [UIView animateWithDuration:0.1 animations:^{
            _baseline.frame = CGRectMake(btnW + 1, btnH, btnW, baselineH);
        }];
        self.baseScrollView.contentOffset = CGPointMake(KScreenWidth, 0);
    }
}

#pragma mark -UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView.contentOffset.x > scrollView.frame.size.width/2) {
        [UIView animateWithDuration:0.1 animations:^{
            _baseline.frame = CGRectMake(btnW + 1, btnH, btnW, baselineH);
        }];
    }else{
        [UIView animateWithDuration:0.1 animations:^{
            _baseline.frame = CGRectMake(0, btnH, btnW, baselineH);
        }];
    }
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

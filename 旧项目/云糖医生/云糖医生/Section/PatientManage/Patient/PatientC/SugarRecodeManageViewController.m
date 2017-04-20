//
//  SugarRecodeManageViewController.m
//  yuntangyi
//
//  Created by yuntangyi on 16/9/18.
//  Copyright © 2016年 yuntangyi. All rights reserved.
//

#import "SugarRecodeManageViewController.h"
#import "SugarRecordTableViewController.h"
#import "OtherViewController.h"
#import "PicAndWheetViewController.h"



@interface SugarRecodeManageViewController ()<UIScrollViewDelegate>
@property (nonatomic, strong)UISegmentedControl *segmented;
@property (nonatomic, strong)UIScrollView *scrollView;
@end

@implementation SugarRecodeManageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithRed:0.910 green:0.910 blue:0.941 alpha:1.000];
    self.automaticallyAdjustsScrollViewInsets = NO;
     self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"返回"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStyleDone target:self action:@selector(goToBack)];
    //创建右边图表按钮
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, 44, 44);
    [btn setTitle:@"图表" forState:UIControlStateNormal];
    [btn setTitleColor: KRGB(0, 172, 204, 1.0) forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(tubiaoBtn:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithCustomView:btn];
    [rightItem setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17],NSForegroundColorAttributeName:KRGB(0, 172, 204, 1.0)} forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem = rightItem;
    [self creatSegmentedC];
    [self creatScrollView];
}
-(void)tubiaoBtn:(UIButton *)btn{
     PicAndWheetViewController * Pic_VC = [[PicAndWheetViewController alloc]init];
    [self.navigationController pushViewController:Pic_VC animated:YES];
}
- (void)goToBack {
   
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)creatSegmentedC{
    self.segmented = [[UISegmentedControl alloc]initWithItems:@[@"血糖", @"其它"]];
    if (self.flag == 1) {
        self.segmented.selectedSegmentIndex = 0;
    }else {
        self.segmented.selectedSegmentIndex = 1;
    }
    
    self.segmented.tintColor = KRGB(0, 172, 204, 1.0);
    [self.segmented addTarget:self action:@selector(handleSegmented:) forControlEvents:UIControlEventValueChanged];
    self.navigationItem.titleView = self.segmented;
    _segmented.frame = CGRectMake(0, 0, 160, 30);
}
-(void)creatScrollView{
    self.scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight)];
    self.scrollView.contentSize = CGSizeMake(KScreenWidth * 2, KScreenHeight);
    self.scrollView.bounces = NO;
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.directionalLockEnabled = YES;
    self.scrollView.pagingEnabled = YES;
    
    //当时名字取反了
    //血糖
    OtherViewController *Other_VC = [[OtherViewController alloc]init];
    //其它
    SugarRecordTableViewController *Sugar_VC = [[SugarRecordTableViewController alloc]init];
   
    
    Other_VC.view.frame = CGRectMake(0, 64, self.scrollView.bounds.size.width, self.scrollView.bounds.size.height - 64);
    Sugar_VC.view.frame = CGRectMake(self.scrollView.bounds.size.width, 0, self.scrollView.bounds.size.width, self.scrollView.bounds.size.height);
    if (self.flag == 1) {
        self.scrollView.contentOffset = CGPointMake(0, 0);
    }else {
        self.scrollView.contentOffset = CGPointMake(KScreenWidth, 0);
    }
    [self addChildViewController:Other_VC];
    [self addChildViewController:Sugar_VC];
    [self.scrollView addSubview:Sugar_VC.view];
    [self.scrollView addSubview:Other_VC.view];
    self.scrollView.delegate = self;
    [self.view addSubview:self.scrollView];
}

-(void)handleSegmented:(UISegmentedControl *)segmented {
    [self.view endEditing:YES];
    self.scrollView.contentOffset = CGPointMake(self.scrollView.bounds.size.width * segmented.selectedSegmentIndex, 0);
}
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    self.segmented.selectedSegmentIndex = self.scrollView.contentOffset.x / scrollView.frame.size.width;
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

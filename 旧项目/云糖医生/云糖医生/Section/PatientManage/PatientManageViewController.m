//
//  PatientManageViewController.m
//  yuntangyi
//
//  Created by yuntangyi on 16/9/2.
//  Copyright © 2016年 yuntangyi. All rights reserved.
//

#import "PatientManageViewController.h"
#import "SystemNewsVC.h"
#import "chatVC.h"

@interface PatientManageViewController ()<UIScrollViewDelegate>
@property (nonatomic, strong)UISegmentedControl *segmented;
@property (nonatomic, strong)UIScrollView *scrollView;
@end

@implementation PatientManageViewController
#pragma mark  -添加系统消息
-(void)addPatientBtn{
    //加号
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"添加患者"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStyleDone target:self action:@selector(AddPatientBtn:)];
}
//跳转到添加病人
- (void)AddPatientBtn:(UIBarButtonItem *)btn {
    
    AddPatientViewController *PA_V = [[AddPatientViewController alloc]init];
    [self.navigationController pushViewController:PA_V animated:YES];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self creatSegmentedC];
    [self creatScrollView];
    //添加病人
    [self addPatientBtn];

}
-(void)creatSegmentedC{
    self.segmented = [[UISegmentedControl alloc]initWithItems:@[@"消息", @"患者"]];
    self.segmented.selectedSegmentIndex = 0;
    self.segmented.tintColor = [UIColor whiteColor];
    [self.segmented addTarget:self action:@selector(handleSegmented:) forControlEvents:UIControlEventValueChanged];
    self.navigationItem.titleView = self.segmented;
    _segmented.frame = CGRectMake(0, 0, 160, 30);
}
-(void)creatScrollView{
    self.scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 64, KScreenWidth, KScreenHeight - 110)];
    self.scrollView.contentSize = CGSizeMake(KScreenWidth * 2, KScreenHeight - 110);
    self.scrollView.bounces = NO;
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.directionalLockEnabled = YES;
    self.scrollView.scrollEnabled = NO;//禁止scrollView的滑动
    self.scrollView.pagingEnabled = YES;
   
    chatVC *messageVC = [[chatVC alloc]init];
    [messageVC hehe];
    PatientVC * patientVC = [[PatientVC alloc]init];
    
    messageVC.view.frame = CGRectMake(0, 0, self.scrollView.bounds.size.width, self.scrollView.bounds.size.height);
    patientVC.view.frame = CGRectMake(self.scrollView.bounds.size.width, 0, self.scrollView.bounds.size.width, self.scrollView.bounds.size.height);
    [self addChildViewController:messageVC];
    [self addChildViewController:patientVC];
    [self.scrollView addSubview:messageVC.view];
    [self.scrollView addSubview:patientVC.view];
    self.scrollView.delegate = self;
    [self.view addSubview:self.scrollView];
}

-(void)handleSegmented:(UISegmentedControl *)segmented {
     self.scrollView.contentOffset = CGPointMake(self.scrollView.bounds.size.width * segmented.selectedSegmentIndex, 0);
}
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    self.segmented.selectedSegmentIndex = self.scrollView.contentOffset.x / scrollView.frame.size.width;
}
-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
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

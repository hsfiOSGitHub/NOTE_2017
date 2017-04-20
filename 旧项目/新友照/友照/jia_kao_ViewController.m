//
//  jia_kao_ViewController.m
//  友照
//
//  Created by ZX on 16/11/18.
//  Copyright © 2016年 ZX_XPH. All rights reserved.
//

#import "jia_kao_ViewController.h"

#import "JK_Class1VC.h"
#import "JK_Class2VC.h"
#import "JK_Class3VC.h"
#import "JK_Class4VC.h"
#import "JK_GetLicense.h"
#import "ZXCityTableViewController.h"
#import "ZXMessageVCTableViewController.h"

@interface jia_kao_ViewController ()<SGSegmentedControlStaticDelegate, UIScrollViewDelegate>

@property (nonatomic, strong) SGSegmentedControlStatic *topSView;
@property (nonatomic, strong) SGSegmentedControlBottomView *bottomSView;

@end

@implementation jia_kao_ViewController
#pragma mark -viewWillAppear
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
}

#pragma mark -viewDidLoad
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    //创建子控制器
    [self createSubVC];
}

//创建子控制器
-(void)createSubVC{
    //科一
    JK_Class1VC *class1_VC = [[JK_Class1VC alloc]init];
    [self addChildViewController:class1_VC];
    //科二
    JK_Class2VC *class2_VC = [[JK_Class2VC alloc]init];
    [self addChildViewController:class2_VC];
    //科三
    JK_Class3VC *class3_VC = [[JK_Class3VC alloc]init];
    [self addChildViewController:class3_VC];
    //科四
    JK_Class4VC *class4_VC = [[JK_Class4VC alloc]init];
    [self addChildViewController:class4_VC];
    //拿本
    JK_GetLicense *getLicense_VC = [[JK_GetLicense alloc]init];
    [self addChildViewController:getLicense_VC];
    
    NSArray *childVC = @[class1_VC, class2_VC, class3_VC, class4_VC, getLicense_VC];
    NSArray *title_arr = @[@"科一", @"科二", @"科三", @"科四", @"拿本"];
    
    self.bottomSView = [[SGSegmentedControlBottomView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    _bottomSView.childViewController = childVC;
    _bottomSView.backgroundColor = [UIColor clearColor];
    _bottomSView.delegate = self;
    //_bottomView.scrollEnabled = NO;
    [self.view addSubview:_bottomSView];
    
    self.topSView = [SGSegmentedControlStatic segmentedControlWithFrame:CGRectMake(0, 64, self.view.frame.size.width, 44) delegate:self childVcTitle:title_arr];
//   _topSView.showsBottomScrollIndicator = NO;
    _topSView.titleColorStateNormal = [UIColor darkGrayColor];
    _topSView.titleColorStateSelected = KRGB(77, 153, 235, 1);
    _topSView.indicatorColor = KRGB(77, 153, 235, 1);
    [self.view addSubview:_topSView];
    
    // 1.添加子控制器view
    for (int index = 0; index < self.childViewControllers.count; index++) {
        [self.bottomSView showChildVCViewWithIndex:index outsideVC:self];
    }
    
}

- (void)SGSegmentedControlStatic:(SGSegmentedControlStatic *)segmentedControlStatic didSelectTitleAtIndex:(NSInteger)index {
    YZLog(@"index - - %ld", (long)index);
    // 计算滚动的位置
    CGFloat offsetX = index * self.view.frame.size.width;
    self.bottomSView.contentOffset = CGPointMake(offsetX, 0);
    [self.bottomSView showChildVCViewWithIndex:index outsideVC:self];
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
//    // 计算滚动到哪一页
//    NSInteger index = scrollView.contentOffset.x / scrollView.frame.size.width;
//    
//    // 1.添加子控制器view
//    [self.bottomSView showChildVCViewWithIndex:index outsideVC:self];
    
    // 2.把对应的标题选中
    [self.topSView changeThePositionOfTheSelectedBtnWithScrollView:scrollView];
}

#pragma mark -didReceiveMemoryWarning
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end

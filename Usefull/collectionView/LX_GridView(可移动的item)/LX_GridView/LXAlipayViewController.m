//
//  LXAlipayViewController.m
//  DemoSummary
// //仿支付宝。
//  Created by chuanglong02 on 16/9/20.
//  Copyright © 2016年 chuanglong02. All rights reserved.
//

#import "LXAlipayViewController.h"
#import "GridView.h"
#import "GridButton.h"
@interface LXAlipayViewController ()<UIScrollViewDelegate,GridViewDelegate>
@property(nonatomic,strong)GridView *gridView;
@property(nonatomic,strong)UIScrollView *myScrollview;
@property (strong,nonatomic) NSMutableArray * showGridTitleArray; // 标题
@property (strong,nonatomic) NSMutableArray * showImageGridArray; // 图片
@property (strong,nonatomic) NSMutableArray * showGridIDArray;//ID
@end

@implementation LXAlipayViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"移动格子";
    self.view.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:self.myScrollview];
    self.gridView =[[GridView alloc]initWithFrame:CGRectMake(0, 0, KScreenW, 200) showGridTitleArray:self.showGridTitleArray showImageGridArray:self.showImageGridArray showGridIDArray:self.showGridIDArray];
    self.gridView.backgroundColor = [UIColor whiteColor];
    self.gridView.gridViewDelegate = self;
    [self.myScrollview addSubview:_gridView];
    [self.gridView updateNewFrame];
}
//2个代理方法
-(void)updateHeight:(CGFloat)height
{
    self.gridView.height = height;
    self.myScrollview.contentSize = CGSizeMake(KScreenW, height);
}
-(void)clickGridView:(GridButton *)item
{
    NSLog(@"%@",item.gridTitle);
}


- (UIScrollView *)myScrollview {
	if(_myScrollview == nil) {
		_myScrollview = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, KScreenW, KScreenH)];
        _myScrollview.contentSize = CGSizeMake(KScreenW, KScreenH *2);
        _myScrollview.contentOffset = CGPointMake(0, -64);
        _myScrollview.contentInset = UIEdgeInsetsMake(64, 0, 0, 0);
        _myScrollview.showsHorizontalScrollIndicator = NO;
        _myScrollview.showsVerticalScrollIndicator = YES;
        _myScrollview.bounces = NO;
        _myScrollview.backgroundColor =[UIColor clearColor];
    }
	return _myScrollview;
}

#pragma mark---懒加载---
- (NSMutableArray *)showGridTitleArray {
    if(_showGridTitleArray == nil) {
        _showGridTitleArray = [NSMutableArray arrayWithObjects:@"收银台",@"结算",@"分享", @"T+0", @"中心",@"D+1", @"商店",@"P2P", @"开通", @"充值", @"转账", @"扫码", @"记录" , @"快捷支付", @"明细", @"收款",@"更多", nil];
    }
    return _showGridTitleArray;
}

- (NSMutableArray *)showImageGridArray {
    if(_showImageGridArray == nil) {
        _showImageGridArray = [NSMutableArray arrayWithObjects:
                               @"more_icon_Transaction_flow",@"more_icon_cancle_deal", @"more_icon_Search",
                               @"more_icon_t0",@"more_icon_shouyin" ,@"more_icon_d1",
                               @"more_icon_Settlement",@"more_icon_Mall", @"more_icon_gift",
                               @"more_icon_licai",@"more_icon_-transfer",@"more_icon_Recharge" ,
                               @"more_icon_Transfer-" , @"more_icon_Credit-card-",@"more_icon_Manager",@"work-order",@"add_businesses", nil];
        ;
    }
    return _showImageGridArray;
}

- (NSMutableArray *)showGridIDArray {
    if(_showGridIDArray == nil) {
        _showGridIDArray = [NSMutableArray arrayWithObjects:
                            @"1000",@"1001", @"1002",
                            @"1003",@"1004",@"1005" ,@"1006",
                            @"1007",@"1008", @"1009",
                            @"1010",@"1011",@"1012" ,
                            @"1013" , @"1014",@"1015",@"0", nil];
    }
    return _showGridIDArray;
}

@end

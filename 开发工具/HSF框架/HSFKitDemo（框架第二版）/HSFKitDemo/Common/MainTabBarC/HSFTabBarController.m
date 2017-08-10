//
//  HSFTabBarController.m
//  HCJ
//
//  Created by JuZhenBaoiMac on 2017/7/13.
//  Copyright © 2017年 JuZhenBaoiMac. All rights reserved.
//

#import "HSFTabBarController.h"

@interface HSFTabBarController ()


@property (nonatomic,strong) NSMutableArray *itemsArr;
@property (nonatomic,strong) NSMutableArray *childVCArr_copy;
@property (nonatomic,strong) UIButton *oldBtn;
@property (nonatomic,strong) NSDictionary *oldDic;
@end

@implementation HSFTabBarController
#pragma mark -viewDidLoad
- (void)viewDidLoad {
    [super viewDidLoad];
}
//配置
-(void)setUp{
    CGFloat w = kScreenWidth/self.source.count;
    CGFloat h = 50.0;
    for (int i = 0; i < self.source.count; i++) {
        CGFloat x = w*i;
        CGFloat y = 0.0;
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(x, y, w, h);
        //配置
        NSDictionary *dic = self.source[i];
        [btn setTitle:dic[@"title"] forState:UIControlStateNormal];
        [btn setTitleColor:self.norColor forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:9];
        [btn setImage:[UIImage imageNamed:dic[@"norImg"]] forState:UIControlStateNormal];
        [btn layoutButtonWithEdgeInsetsStyle:HSFButtonEdgeInsetsStyleTop imageTitleSpace:0];
        [btn setTag:i];
        [btn addTarget:self action:@selector(itemACTION:) forControlEvents:UIControlEventTouchUpInside];
        [self.tabBar addSubview:btn];
        
        if (i == 0) {
            self.oldBtn = btn;
            self.oldDic = dic;
            [self.oldBtn setTitleColor:self.selColor forState:UIControlStateNormal];
            [self.oldBtn setImage:[UIImage imageNamed:dic[@"selImg"]] forState:UIControlStateNormal];
            [self.oldBtn layoutButtonWithEdgeInsetsStyle:HSFButtonEdgeInsetsStyleTop imageTitleSpace:0];
        }
    }
    [self.view addSubview:self.tabBar];
    __weak typeof(self) weakSelf = self;
    [self.tabBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.equalTo(weakSelf.view);
        make.height.mas_equalTo(50);
    }];
    //添加第一个vc
    UIViewController *vc = self.childVCArr.firstObject;
    [self addChildViewController:vc];
    [self.view addSubview:vc.view];
    [self.childVCArr_copy addObject:vc];
    [self addLayoutForView:vc.view];
}
#pragma mark -点击事件
-(void)itemACTION:(UIButton *)sender{
    //状态处理
    NSDictionary *dic = self.source[sender.tag];
    [self.oldBtn setTitleColor:self.norColor forState:UIControlStateNormal];
    [self.oldBtn setImage:[UIImage imageNamed:self.oldDic[@"norImg"]] forState:UIControlStateNormal];
    [self.oldBtn layoutButtonWithEdgeInsetsStyle:HSFButtonEdgeInsetsStyleTop imageTitleSpace:0];
    [sender setTitleColor:self.selColor forState:UIControlStateNormal];
    [sender setImage:[UIImage imageNamed:dic[@"selImg"]] forState:UIControlStateNormal];
    [sender layoutButtonWithEdgeInsetsStyle:HSFButtonEdgeInsetsStyleTop imageTitleSpace:0];
    self.oldBtn = sender;
    self.oldDic = dic;
    
    UIViewController *vc = self.childVCArr[sender.tag];
    if ([self.childVCArr_copy containsObject:vc]) {
        [self.view bringSubviewToFront:vc.view];
    }else{
        [self addChildViewController:vc];
        [self.view addSubview:vc.view];
        [self.childVCArr_copy addObject:vc];
        [self addLayoutForView:vc.view];
    }
}

#pragma mark -添加约束
-(void)addLayoutForView:(UIView *)view{
    __weak typeof(self) weakSelf = self;
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(weakSelf.view);
        make.bottom.equalTo(weakSelf.tabBar.mas_top);
    }];
}

#pragma mark -懒加载
-(UIView *)tabBar{
    if (!_tabBar) {
        _tabBar = [[UIView alloc]init];
        _tabBar.backgroundColor = [UIColor whiteColor];
    }
    return _tabBar;
}
-(NSMutableArray *)itemsArr{
    if (!_itemsArr) {
        _itemsArr = [NSMutableArray array];
    }
    return _itemsArr;
}
-(NSMutableArray *)childVCArr_copy{
    if (!_childVCArr_copy) {
        _childVCArr_copy = [NSMutableArray array];
    }
    return _childVCArr_copy;
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

//
//  ViewController.m
//  YLChartDemo
//
//  Created by LELE on 17/4/12.
//  Copyright © 2017年 rect. All rights reserved.
/*
*******************************************************************************
        *                项目需要一些图表，顺便学习了一下                 *
        *             因时间有限，暂目前只绘制了一些基本图表,              *
        *             后续有时间会继续补充完整不足之处还请见谅！            *
        *             如有需要或疑问，欢迎互相交流                       *
        *           http://blog.csdn.net/lele9096_bk                *
*******************************************************************************
*/

#import "ViewController.h"
#import "YLChartController.h"
@interface ViewController ()<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic,strong)NSArray* items;
@end

@implementation ViewController
-(NSArray *)items
{
    if (_items == nil) {
        _items = @[@"绘制渐变色圆环进度条",@"同步绘制多色环状图--顺序绘制",@"异步绘制多色环状图--同时绘制",@"渐变色弧形",@"折线图--Demo",@"仿加载进度条--多色旋转"];
    }
    return _items;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    UITableView* tabView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width,self.view.frame.size.height) style:UITableViewStylePlain];
    tabView.dataSource = self;
    tabView.delegate  =self;
    [self.view addSubview:tabView];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.items.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"reuseIdentifier"];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"reuseIdentifier"];
    }
    
    cell.textLabel.text = self.items[indexPath.row];
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    YLChartController *show = [YLChartController new];
    show.index = indexPath.row;
    show.title = self.items[indexPath.row];
    [self.navigationController pushViewController:show animated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

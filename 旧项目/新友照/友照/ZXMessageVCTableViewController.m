//
//  ZXMessageVCTableViewController.m
//  ZXJiaXiao
//
//  Created by Finsen on 16/6/23.
//  Copyright © 2016年 ZX. All rights reserved.
//

#import "ZXMessageVCTableViewController.h"
#import "ZXMessageTableViewCell.h"
#import "ZXCycleDetailViewController.h"

@interface ZXMessageVCTableViewController()<UITableViewDataSource, UITableViewDelegate>
@end
@implementation ZXMessageVCTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = ZX_BG_COLOR;
    _tableView = [[UITableView alloc]initWithFrame:self.view.frame style:UITableViewStylePlain];
    self.title = @"消息";
    [self.tableView registerNib:[UINib nibWithNibName:@"ZXMessageTableViewCell" bundle:nil] forCellReuseIdentifier:@"ZXMessageTableViewCellID"];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.backgroundColor = ZX_BG_COLOR;
    _tableView.showsVerticalScrollIndicator = NO;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ZXMessageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ZXMessageTableViewCellID" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell setModel:_dataSource[indexPath.row]];
    return cell;
}

//跳转到消息详情
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([[_dataSource[indexPath.row] allKeys] containsObject:@"url"])
    {
        ZXCycleDetailViewController * cycleDetailVC = [[ZXCycleDetailViewController alloc] init];
        cycleDetailVC.url = _dataSource[indexPath.row][@"url"];
        cycleDetailVC.title = @"消息详情";
        [self.navigationController pushViewController:cycleDetailVC animated:YES];
    }
}



@end

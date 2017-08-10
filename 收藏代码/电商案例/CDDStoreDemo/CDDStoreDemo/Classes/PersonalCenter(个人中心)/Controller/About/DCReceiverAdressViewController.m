//
//  DCReceiverAdressViewController.m
//  CDDMall
//
//  Created by apple on 2017/6/20.
//  Copyright © 2017年 RocketsChen. All rights reserved.
//

#import "DCReceiverAdressViewController.h"

// Controllers

// Models
#import "DCAddressItem.h"
// Views
#import "DCReceiverAddressCell.h"
// Vendors
#import <MJExtension.h>
// Categories
#import "UIBarButtonItem+DCBarButtonItem.h"
// Others

@interface DCReceiverAdressViewController ()<UITableViewDelegate,UITableViewDataSource>

/* tableView */
@property (strong , nonatomic)UITableView *tableView;
/* 地址数组 */
@property (strong , nonatomic)NSMutableArray<DCAddressItem *> *addItem;

@end

static NSString *const DCReceiverAddressCellID = @"DCReceiverAddressCell";

@implementation DCReceiverAdressViewController

#pragma mark - LazyLoad
- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.dataSource = self;
        _tableView.delegate = self;
        
        _tableView.frame = CGRectMake(0, DCTopNavH, ScreenW, ScreenH - DCTopNavH);
        [self.view addSubview:_tableView];
        
        [_tableView registerClass:[DCReceiverAddressCell class] forCellReuseIdentifier:DCReceiverAddressCellID];
    }
    return _tableView;
}

#pragma mark - LifeCyle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUpTab];
    
    [self setUpNav];
    
    [self setUpAdrressData];
}

- (void)setUpTab
{
    self.view.backgroundColor = DCBGColor;
    self.tableView.backgroundColor = self.view.backgroundColor;
    self.automaticallyAdjustsScrollViewInsets = NO;
}

- (void)setUpNav
{
    self.title = @"收货地址管理";
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem ItemWithImage:[UIImage imageNamed:@"jr_add"] WithHighlighted:[UIImage imageNamed:@"jr_add"] Target:self action:@selector(addItemClick)];
}

#pragma mark - 地址数据
- (void)setUpAdrressData
{
    _addItem = [DCAddressItem mj_objectArrayWithFilename:@"DeliveryAdress.plist"];
}

#pragma mark - <UITableViewDataSource>
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _addItem.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DCReceiverAddressCell *cell = [tableView dequeueReusableCellWithIdentifier:DCReceiverAddressCellID forIndexPath:indexPath];
    cell.adItem = _addItem[indexPath.row];
    
    cell.defaultClickBlock = ^{
        NSLog(@"点击了默认地址");
    };
    
    cell.delectClickBlock = ^{
        NSLog(@"点击了删除");
    };
    cell.editClickBlock = ^{
        NSLog(@"点击了编辑");
    };
    
    return cell;
}

#pragma mark - <UITableViewDelegate>

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return _addItem[indexPath.row].cellHeight;
}

#pragma mark - 点击事件
#pragma mark - 添加地址
- (void)addItemClick
{
    
}

@end

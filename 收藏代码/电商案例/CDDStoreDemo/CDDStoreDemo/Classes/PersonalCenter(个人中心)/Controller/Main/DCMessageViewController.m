//
//  DCMessageViewController.m
//  CDDMall
//
//  Created by apple on 2017/5/31.
//  Copyright © 2017年 RocketsChen. All rights reserved.
//

#import "DCMessageViewController.h"

// Controllers

// Models
#import "DCMessageItem.h"
// Views
#import "DCMessageNoteCell.h"
// Vendors
#import <MJExtension.h>
// Categories

// Others

@interface DCMessageViewController ()<UITableViewDelegate,UITableViewDataSource>

/* tableView */
@property (strong , nonatomic)UITableView *tableView;

/* plist字典 */
@property (nonatomic, strong) NSDictionary *property;
/* 数组 */
@property (strong , nonatomic)NSMutableArray<DCMessageItem *> *messageItems;
@end

static NSString *const DCMessageNoteCellID = @"DCMessageNoteCell";

@implementation DCMessageViewController

#pragma mark - LazyLoad
- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.frame = CGRectMake(0, 64, ScreenW, ScreenH - 64);
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self.view addSubview:_tableView];
        
        [_tableView registerClass:[DCMessageNoteCell class] forCellReuseIdentifier:DCMessageNoteCellID];
    }
    return _tableView;
}

- (NSMutableArray<DCMessageItem *> *)messageItems
{
    if (!_messageItems) {
        _messageItems = [NSMutableArray array];
    }
    return _messageItems;
}

#pragma mark - LifeCyle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUpTab];
    
    [self setUpMessageData];
}

#pragma mark - initialize
- (void)setUpTab
{
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = DCBGColor;
    self.tableView.backgroundColor = self.view.backgroundColor;
}

#pragma mark - 消息数据
- (void)setUpMessageData
{
    _messageItems = [DCMessageItem mj_objectArrayWithFilename:@"MessageNote.plist"];
}

#pragma mark - <UITableViewDataSource>
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.messageItems.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DCMessageNoteCell *cell = [tableView dequeueReusableCellWithIdentifier:DCMessageNoteCellID forIndexPath:indexPath];
    cell.messageItem = _messageItems[indexPath.row];
    return cell;
}

#pragma mark - <UITableViewDelegate>

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 66;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
}

@end

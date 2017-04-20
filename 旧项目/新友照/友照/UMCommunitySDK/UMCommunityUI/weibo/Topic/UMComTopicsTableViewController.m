//
//  UMComTopicsTableViewController.m
//  UMCommunity
//
//  Created by umeng on 15/7/15.
//  Copyright (c) 2015年 Umeng. All rights reserved.
//

#import "UMComTopicsTableViewController.h"
#import <UMComDataStorage/UMComTopic.h>
#import "UMComTopicListDataController.h"
#import "UMComCommonTopicTableViewCell.h"
#import "UMComLoginManager.h"
#import "UMComShowToast.h"
#import "UMComTopicFeedViewController.h"
#import "UMComBarButtonItem.h"
#import <UMComDataStorage/UMComTopicType.h>
#import "UIViewController+UMComAddition.h"
#import "UMComTopicListDataController.h"
#import "UMComShowToast.h"
#import "UMComNotificationMacro.h"


@interface UMComTopicsTableViewController ()

@property (nonatomic, strong) NSArray *originDataArray;
@end

@implementation UMComTopicsTableViewController

- (instancetype)initWithCompletion:(void (^)(UIViewController *viewController))completion
{
    self = [super init];
    if (self) {
        self.completion = completion;
        UMComBarButtonItem *rightButtonItem = [[UMComBarButtonItem alloc] initWithTitle:UMComLocalizedString(@"um_com_nextStep",@"下一步") target:self action:@selector(onClickNext)];
        [self.navigationItem setRightBarButtonItem:rightButtonItem];
    }
    return self;
}

-(void) handleFollowTopicNotification:(NSNotification*)notification
{
    
    //    NSLog(@"UMComForumTopicFocusedTableViewController:%@",notification.userInfo);
    
    UMComTopic* topic =  (UMComTopic*)notification.object;
    if (!topic) {
        return;
    }
    if ([self.dataController isKindOfClass:[UMComTopicsFocusDataController class]]) {
        //判断是否是我的关注界面
        if(topic.is_focused.intValue == 0)
        {
            [self deleteTopicFromTableView:topic];
        }
        else
        {
            [self insertTopicToTableView:topic];
        }
    }else{
        [self.tableView reloadData];
    }
    
}


- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.tableView.rowHeight = UMCom_Forum_Topic_Cell_Height;
    
    if (self.title) {
        [self setForumUITitle:self.title];
    }else{
        [self setForumUITitle:UMComLocalizedString(@"um_com_topicList", @"话题列表")];
    }
    //    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    // Do any additional setup after loading the view.
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleFollowTopicNotification:) name:kUMComFollowTopicNotification object:nil];
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)onClickNext
{
    if (self.completion) {
        self.completion(self);
    }
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.tableView setSeparatorInset:UIEdgeInsetsMake(UMCom_Forum_Topic_Edge_Left*2 + UMCom_Forum_Topic_Icon_Width, UMCom_Forum_Topic_Cell_Height, 0, 0)];
    }
    if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)])
    {
        [self.tableView setLayoutMargins:UIEdgeInsetsMake(UMCom_Forum_Topic_Edge_Left*2 + UMCom_Forum_Topic_Icon_Width, UMCom_Forum_Topic_Cell_Height, 0, 0)];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UMComCommonTopicTableViewCell *cell = (UMComCommonTopicTableViewCell *)[self cellForIndexPath:indexPath];
    return cell;
    // return [self recommendTopicCellForRowAtIndexPath:indexPath];
}

- (UITableViewCell *)cellForIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"TopicCellID";
    UMComCommonTopicTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[UMComCommonTopicTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId cellSize:CGSizeMake(self.tableView.frame.size.width, self.tableView.rowHeight)];
    }
    __weak typeof(self) weakSelf = self;
    cell.index = indexPath.row;
    [cell.button setBackgroundImage:nil forState:UIControlStateNormal];
    UMComTopic *topic  = self.dataController.dataArray[indexPath.row];
    [cell reloadWithTopic:topic];
    cell.clickOnButton = ^(UMComCommonTopicTableViewCell *cell){
        [weakSelf followTopicAtCell:cell index:indexPath];
    };
    return cell;
}


- (void)followTopicAtCell:(UMComCommonTopicTableViewCell *)cell index:(NSIndexPath *)indexPath
{
    UMComTopic* topic = self.dataController.dataArray[indexPath.row];
    if (![topic isKindOfClass:[UMComTopic class]]) {
        return;
    }
    __weak typeof(self) weakSelf = self;
    [UMComLoginManager performLogin:self completion:^(id responseObject, NSError *error) {
        if (!error) {
            [(UMComTopicListDataController *)self.dataController followOrDisfollowTopic:topic completion:^(id responseObject, NSError *error) {
                BOOL isFollow = NO;
                if ([topic.is_focused isKindOfClass:[NSNumber class]]) {
                    
                    isFollow =  (topic.is_focused.integerValue == 1);
                }
                [UMComShowToast focuseUserSuccess:error focused:isFollow];
                [weakSelf.tableView reloadData];
            }];
        }
    }];
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
{
    [self showTopicPostTableViewWithTopicAtIndexPath:indexPath];
}


- (void)showTopicPostTableViewWithTopicAtIndexPath:(NSIndexPath *)indexPath
{
    UMComTopic *topic = self.dataController.dataArray[indexPath.row];
    
    UMComTopicFeedViewController *topicPostListController = [[UMComTopicFeedViewController alloc] initWithTopic:topic];
    
    [self.navigationController pushViewController:topicPostListController animated:YES];
}


- (void)insertTopicToTableView:(UMComTopic *)topic
{
    if (!topic) {
        return;
    }
    if ([topic isKindOfClass:[UMComTopic class]]) {
        NSMutableArray *topicList = nil;
        if (self.dataController.dataArray.count > 0) {
            topicList = [NSMutableArray arrayWithArray:self.dataController.dataArray];
            if (![topicList containsObject:topic]) {
                [topicList insertObject:topic atIndex:0];
            }
        }else{
            topicList = [NSMutableArray arrayWithObject:topic];
        }
        self.dataController.dataArray = topicList;
        [self.tableView reloadData];
    }
}

- (void)deleteTopicFromTableView:(UMComTopic *)topic
{
    if (!topic) {
        return;
    }
    __weak typeof(self) weakSelf = self;
    if ([topic isKindOfClass:[UMComTopic class]]) {
        NSMutableArray *topicList = [NSMutableArray arrayWithArray:self.dataController.dataArray];
        [topicList enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            UMComTopic* item = (UMComTopic*)obj;
            if ([item.topicID isEqualToString:topic.topicID]) {
                *stop = YES;
                [topicList removeObject:topic];
                weakSelf.dataController.dataArray = topicList;
                [weakSelf.tableView reloadData];
            }
        }];
    }
}


@end

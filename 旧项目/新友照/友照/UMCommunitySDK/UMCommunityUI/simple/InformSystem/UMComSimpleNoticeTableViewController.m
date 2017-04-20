//
//  UMComSimpleNoticeTableViewController.m
//  UMCommunity
//
//  Created by umeng on 16/5/17.
//  Copyright © 2016年 Umeng. All rights reserved.
//

#import "UMComSimpleNoticeTableViewController.h"
#import "UMComSimpleNotificationCell.h"
#import "UMComNoticeListDataController.h"
#import <UMComDataStorage/UMComNotification.h>
#import "UIViewController+UMComAddition.h"
#import <UMComDataStorage/UMComUser.h>
#import <UMCommunitySDK/UMComSession.h>
#import <UMComDataStorage/UMComUnReadNoticeModel.h>
#import <UMComFoundation/UMComKit+Color.h>
#import "UMComResouceDefines.h"
#import "UMComSimplicityUserCenterViewController.h"

static NSString *kUMComSimpleNotificationCellID = @"UMComSimpleNotificationCell";

@interface UMComSimpleNoticeTableViewController ()

@property (nonatomic, strong) NSMutableDictionary *cellHeightDict;

@property (nonatomic, strong) UMComSimpleNotificationCell *baseCell;

@end



@implementation UMComSimpleNoticeTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setForumUITitle:UMComLocalizedString(@"um_com_notification", @"通知")];

    UINib *cellNib = [UINib nibWithNibName:kUMComSimpleNotificationCellName bundle:nil];
    [self.tableView registerNib:cellNib forCellReuseIdentifier:kUMComSimpleNotificationCellID];

    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.rowHeight = 203;

    
    self.cellHeightDict = [NSMutableDictionary dictionary];
    
    self.dataController = [[UMComNoticeListDataController alloc] initWithCount:UMCom_Limit_Page_Count];
    
    self.tableView.backgroundColor = [UIColor clearColor];
    self.view.backgroundColor = UMComColorWithHexString(@"#e8eaee");
    
    [UMComSession sharedInstance].unReadNoticeModel.notiByAdministratorCount = 0;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.tableView reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return  [super tableView:tableView numberOfRowsInSection:section];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UMComSimpleNotificationCell *cell = [tableView dequeueReusableCellWithIdentifier:kUMComSimpleNotificationCellID];
    __weak typeof(self) weakSelf = self;
    cell.tapAvatorAction = ^(UMComNotification *notification){
        UMComSimplicityUserCenterViewController *userCenter = [[UMComSimplicityUserCenterViewController alloc] init];
        [weakSelf.navigationController pushViewController:userCenter animated:YES];
    };
    UMComNotification* notice = self.dataController.dataArray[indexPath.row];
    [cell reloadCellWithNotification:notice];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UMComNotification* notice = self.dataController.dataArray[indexPath.row];
    NSString *heightKey = notice.id;
    CGFloat height = 0;
    if ([self.cellHeightDict valueForKey:heightKey]) {
        height = [[self.cellHeightDict valueForKey:heightKey] floatValue];
    }else{
        if (!_baseCell) {
            NSArray *array = [[NSBundle mainBundle] loadNibNamed:kUMComSimpleNotificationCellName owner:self options:nil];
            self.baseCell = [array objectAtIndex:0];
            _baseCell.bounds = CGRectMake(0.0f, 0.0f, CGRectGetWidth(self.tableView.bounds), CGRectGetHeight(_baseCell.bounds));
        }
        [_baseCell setNeedsLayout];
        [_baseCell layoutIfNeeded];
        [_baseCell reloadCellWithNotification:notice];
         height = [_baseCell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
        height += 1;
        [self.cellHeightDict setValue:@(height) forKey:heightKey];
    }
    return height;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

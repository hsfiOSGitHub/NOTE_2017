//
//  UMComPrivateLetterTableViewController.m
//  UMCommunity
//
//  Created by umeng on 15/11/30.
//  Copyright © 2015年 Umeng. All rights reserved.
//

#import "UMComPrivateLetterTableViewController.h"
#import "UMComImageView.h"
#import <UMCommunitySDK/UMComSession.h>
#import <UMComDataStorage/UMComPrivateLetter.h>
#import <UMComDataStorage/UMComPrivateMessage.h>
#import <UMComDataStorage/UMComImageUrl.h>
#import "UMComPrivateChatTableViewController.h"
#import "UIViewController+UMComAddition.h"
#import "UMComShowToast.h"
#import "UMComSysPrivateLetterCell.h"
#import "UMComPrivateLetterListDataController.h"


@interface UMComPrivateLetterTableViewController ()

@end

@implementation UMComPrivateLetterTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.rowHeight = UMCom_Forum_LetterList_Cell_Height;
    
    [self setForumUITitle:UMComLocalizedString(@"um_com_privateLetterTitle", @"私信管理员")];
    self.dataController = [[UMComPrivateLetterListDataController alloc] initWithCount:UMCom_Limit_Page_Count];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.tableView reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataController.dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"PrivateLetterTableViewCellIdentifie";
    UMComSysPrivateLetterCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[UMComSysPrivateLetterCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID cellSize:CGSizeMake(tableView.frame.size.width, tableView.rowHeight)];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    [cell reloadCellWithPrivateLetter:self.dataController.dataArray[indexPath.row]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UMComPrivateChatTableViewController *privateViewController = [[UMComPrivateChatTableViewController alloc]initWithPrivateLetter:self.dataController.dataArray[indexPath.row]];//
    [self.navigationController pushViewController:privateViewController animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end


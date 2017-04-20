//
//  UMComBeLikedFeedViewController.m
//  UMCommunity
//
//  Created by wyq.Cloudayc on 5/19/16.
//  Copyright © 2016 Umeng. All rights reserved.
//

#import "UMComSimpleLikeMyFeedViewController.h"
#import "UMComResouceDefines.h"
#import "UIViewController+UMComAddition.h"
#import "UMComSimpleFeedDetailViewController.h"
#import "UMComSimpleAssociatedFeedTableViewCell.h"
#import "UMComFeedClickActionDelegate.h"
#import "UMComUserListDataController.h"
#import "UMComSimplicityUserCenterViewController.h"
#import <UMComDataStorage/UMComLike.h>
#import <UMCommunitySDK/UMComSession.h>
#import <UMComDataStorage/UMComUnReadNoticeModel.h>
#import "UMComLikeListDataController.h"
#import <UMComDataStorage/UMComModelObjectHeader.h>
#import <UMComFoundation/UMComKit+Color.h>


@interface UMComSimpleLikeMyFeedViewController ()<UITableViewDataSource, UITableViewDelegate, UMComFeedClickActionDelegate>

@property (nonatomic, strong) NSMutableDictionary *cellCacheDict;

@property (nonatomic, strong) UMComSimpleAssociatedFeedTableViewCell *baseCell;

@end

@implementation UMComSimpleLikeMyFeedViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.dataController = [[UMComUserReceivedLikeDataController alloc] initWithCount:UMCom_Limit_Page_Count];

    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setForumUITitle:UMComLocalizedString(@"um_com_be_liked_feed", @"赞我的")];
    
    UINib *cellNib = [UINib nibWithNibName:kUMComSimpleAssociatedFeedTableViewCellName bundle:nil];
    [self.tableView registerNib:cellNib forCellReuseIdentifier:kUMComSimpleAssociatedFeedTableViewCellId];
    
    _baseCell = [cellNib instantiateWithOwner:nil options:nil][0];
    
    self.cellCacheDict = [NSMutableDictionary dictionary];
    self.isLoadFinish = YES;
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.view.backgroundColor = UMComColorWithHexString(@"e8eaee");
    
    [UMComSession sharedInstance].unReadNoticeModel.notiByLikeCount = 0;
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - tableview
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [super tableView:tableView numberOfRowsInSection:section];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UMComLike *like = self.dataController.dataArray[indexPath.row];
    
    UMComSimpleAssociatedFeedTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:kUMComSimpleAssociatedFeedTableViewCellId];
    
    cell.bounds = CGRectMake(0.0f, 0.0f, CGRectGetWidth(self.tableView.bounds), CGRectGetHeight(_baseCell.bounds));
    
    [cell setNeedsLayout];
    [cell layoutIfNeeded];
    
    cell.delegate = self;
    [cell refreshWithBeLiked:like];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSString *heightKey = [NSString stringWithFormat:@"height_%d",(int)indexPath.row];
    
    CGFloat height = 0;
    if (![self.cellCacheDict valueForKey:heightKey] ) {
        UMComSimpleAssociatedFeedTableViewCell *cell = self.baseCell;
        
        UMComLike *like = self.dataController.dataArray[indexPath.row];
        
        cell.bounds = CGRectMake(0.0f, 0.0f, CGRectGetWidth(self.tableView.bounds), CGRectGetHeight(_baseCell.bounds));
        
        [cell setNeedsLayout];
        [cell layoutIfNeeded];
        
        [cell refreshWithBeLiked:like];
        
        height = [cell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
        height += 1;
        [self.cellCacheDict setValue:@(height) forKey:heightKey];
    }else{
        height = [[self.cellCacheDict valueForKey:heightKey] floatValue];
    }
    return height;
}

#pragma mark - actionDeleagte
- (void)customObj:(id)obj clickOnFeedText:(UMComFeed *)feed
{
    if (![feed isKindOfClass:[UMComFeed class]]) {
        return;
    }
    if ([feed.status isKindOfClass:[NSNumber class]] && feed.status.integerValue >= 2) {
        //代表feed被删除
        return;
    }
    UMComSimpleFeedDetailViewController *detailVc = [[UMComSimpleFeedDetailViewController alloc] init];
    detailVc.feed = feed;
    [self.navigationController pushViewController:detailVc animated:YES];
}

- (void)customObj:(id)obj clickOnFeedCreator:(UMComUser *)user;
{
    UMComSimplicityUserCenterViewController *userCenterVc = [[UMComSimplicityUserCenterViewController alloc] init];
    userCenterVc.user = user;
    [self.navigationController pushViewController:userCenterVc animated:YES];
}

- (void)customObj:(id)obj clickOnImageView:(UIImageView *)imageView complitionBlock:(void (^)(UIViewController *currentViewController))block
{
    if (block) {
        block(self);
    }
}

@end

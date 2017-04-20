//
//  UMComFeedsTableViewController.m
//  UMCommunity
//
//  Created by Gavin Ye on 8/27/14.
//  Copyright (c) 2014 Umeng. All rights reserved.
//

#import "UMComSimpleFeedTableViewController.h"
#import "UMComFeedListDataController.h"
#import "UMComSimpleFeedTableViewCell.h"
#import <UMComDataStorage/UMComTopic.h>
#import <UMComDataStorage/UMComUser.h>
#import "UMComMutiText.h"
#import <UMComDataStorage/UMComFeed.h>
#import "UMComLabel.h"
#import "UMComSimpleGridView.h"
#import "UMComSimpleFeedDetailViewController.h"
#import "UMComBriefEditViewController.h"
#import "UMComSelectTopicViewController.h"
#import "UMComSimplicityUserCenterViewController.h"
#import "UMComTopicListDataController.h"
#import "UMComSimpleTopicFeedTableViewController.h"
#import "UMComLoginManager.h"
#import "UMComShowToast.h"
#import <UMCommunitySDK/UMComDataTypeDefine.h>
#import <UIKit/UIKit.h>
#import "UMComSimpleFeedOperationFinishDelegate.h"
#import <UMComDataStorage/UMComDataBaseManager.h>
#import "UIViewController+UMComAddition.h"
#import "UMComWebViewController.h"
#import <UMComFoundation/UMComKit+Color.h>
#import "UMComNotificationMacro.h"

#define BriefEditBtnHeight  100
#define BriefEditBtnWidth 100


@interface UMComSimpleFeedTableViewController ()<UITableViewDataSource, UITableViewDelegate, UMComFeedClickActionDelegate>
{
    
}
@property (nonatomic, strong) NSMutableDictionary *cellCacheDict;
@property (nonatomic, strong) NSMutableDictionary *feedMutiTextDict;

@property (nonatomic, strong) UMComSimpleFeedTableViewCell *baseCell;

- (void)createEditButton;//创建编辑按钮


- (void)handleDeleteFeedCompleteSucceed:(NSNotification *)notification;
@end

@implementation UMComSimpleFeedTableViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    if (_titleName.length > 0) {
        [self setForumUITitle:_titleName];
    }
    self.tableView.backgroundColor = [UIColor clearColor];
    self.view.backgroundColor = UMComColorWithHexString(@"#e8eaee");
    
    //在IOS8.0的系统上，设置separatorStyle会导致tableview的刷新
    //self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.separatorColor = [UIColor clearColor];
    self.tableView.rowHeight = 299;
    
    UINib *cellNib = [UINib nibWithNibName:kUMComSimpleFeedCellName bundle:nil];
    [self.tableView registerNib:cellNib forCellReuseIdentifier:kUMComSimpleFeedCellId];
    
    _baseCell = [cellNib instantiateWithOwner:nil options:nil][0];
    
    self.cellCacheDict = [NSMutableDictionary dictionary];
    self.feedMutiTextDict = [NSMutableDictionary dictionary];
    self.isLoadFinish = YES;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleDeleteFeedCompleteSucceed:) name:kUMComFeedDeletedFinishNotification object:nil];
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kUMComFeedDeletedFinishNotification object:nil];
}

- (void)createEditButton
{
    self.editButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.editButton setImage:UMComSimpleImageWithImageName(@"um_com_editBtn") forState:UIControlStateNormal];
    [self.editButton setImage:UMComSimpleImageWithImageName(@"um_com_editBtn_click") forState:UIControlStateHighlighted];
    [self.editButton addTarget:self action:@selector(onClickEdit:) forControlEvents:UIControlEventTouchUpInside];

    CGFloat x =self.view.bounds.size.width - BriefEditBtnHeight;
    CGFloat y =self.view.bounds.size.height - BriefEditBtnHeight;

    self.editButton.frame = CGRectMake(x, y, BriefEditBtnHeight, BriefEditBtnHeight);
    
    self.editButton.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleTopMargin;
    [self.view addSubview:self.editButton];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    //设置navigationBar的背景颜色问题
    //在ipod上会出现navigationBar变成系统的问题的问题
    if ([[UIDevice currentDevice].systemVersion floatValue] < 7) {
        [self.navigationController.navigationBar setBackgroundColor:UMComColorWithHexString(@"#f7f7f8")];
        [self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc]init] forBarMetrics:UIBarMetricsDefault];
    }else{
        [self.navigationController.navigationBar setBarTintColor:UMComColorWithHexString(@"#f7f7f8")];
    }
    self.navigationController.navigationBar.barTintColor = dao_hang_lan_Color;
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSFontAttributeName:[UIFont systemFontOfSize:20],
       NSForegroundColorAttributeName:[UIColor whiteColor]}];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if (self.isShowEditButton && !self.editButton) {
        [self createEditButton];
    }

}

#pragma mark -  kUMComFeedDeletedFinishNotification
- (void)handleDeleteFeedCompleteSucceed:(NSNotification *)notification
{
    __weak typeof(self) weakself = self;
    UMComFeed* feed =  notification.object;
    dispatch_async(dispatch_get_main_queue(), ^{
        if (feed && [feed isKindOfClass:[UMComFeed class]]) {
            //删除数据源下包含的删除的feed
            [weakself deleteFeed:feed];
        }
    });
}

#pragma mark - Delegate and dataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [super tableView:tableView numberOfRowsInSection:section];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UMComFeed *feed = self.dataController.dataArray[indexPath.row];
    UMComSimpleFeedTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:kUMComSimpleFeedCellId];
    cell.delegate = self;
    [self reloadCell:cell feed:feed];
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{

    UMComFeed *feed = self.dataController.dataArray[indexPath.row];
    NSString *heightKey = [NSString stringWithFormat:@"%@",feed.feedID];
    CGFloat height = 0;
    if (![self.cellCacheDict valueForKey:heightKey] ) {
        UMComSimpleFeedTableViewCell *cell = self.baseCell;
        
        [self reloadCell:cell feed:feed];

        height = [cell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
        height += 0.5;
        [self.cellCacheDict setValue:@(height) forKey:heightKey];
        [self.feedMutiTextDict setValue:cell.feedMutiText forKey:heightKey];
    }else{
       height = [[self.cellCacheDict valueForKey:heightKey] floatValue];
    }
    return height;
}


- (void)reloadCell:(UMComSimpleFeedTableViewCell *)cell feed:(UMComFeed *)feed
{
    cell.bounds = CGRectMake(0.0f, 0.0f, CGRectGetWidth(self.tableView.bounds), CGRectGetHeight(cell.bounds));
    [cell setNeedsLayout];
    [cell layoutIfNeeded];
    cell.isHideTopicName = self.isHideTopicName;
    cell.topFeedType = self.topFeedType;
    cell.feedMutiText = [self.feedMutiTextDict valueForKey:feed.feedID];
    if (self.feedType == UMComFeedType_Favorite) {
        cell.showFavoriteStatus = YES;
        if ([feed.status integerValue] >= 2) {
            feed.text = @"该内容已被删除";
            feed.image_urls = nil;
        }
    }
    [cell reloadSubViewsFeed:feed];
    [cell setNeedsUpdateConstraints];
    [cell updateConstraintsIfNeeded];
}


-(void)onClickEdit:(id)sender
{
   __weak typeof(self) weakself = self;
    [UMComLoginManager performLogin:self completion:^(id responseObject, NSError *error) {
        if (!error) {
            
            //可变话题的选择----begin
            UMComSelectTopicViewController*  selectTopicViewController = [[UMComSelectTopicViewController alloc] initWithNibName:@"UMComSelectTopicViewController" bundle:nil];
            
            //有限赋值给当前的ViewController
            UIViewController* popToViewController = weakself;
            
            //如果有父窗口就判断是不是childViewControllers中包含self,把popToViewController定位到parentViewController
            UIViewController* parentViewController = weakself.parentViewController;
            if (parentViewController) {
                BOOL isContained = [parentViewController.childViewControllers containsObject:weakself];
                if (isContained) {
                    popToViewController = parentViewController;
                }
            }
            selectTopicViewController.selectTopicViewFinishAction = ^(UMComTopic* topic){
                UMComBriefEditViewController* editViewController = [[UMComBriefEditViewController alloc] initModifiedTopic:topic withPopToViewController:popToViewController];
                [weakself.navigationController pushViewController:editViewController animated:YES];
            };
            
            selectTopicViewController.closeTopicViewAction = ^(){
                [weakself.navigationController popViewControllerAnimated:YES];
            };
            selectTopicViewController.hidesBottomBarWhenPushed=YES;
            [weakself.navigationController pushViewController:selectTopicViewController animated:YES];
            //可变话题的选择----end
        }
    }];
}


#pragma mark - actionDeleagte 
- (void)customObj:(id)obj clickOnURL:(NSString *)urlSring
{
    UMComWebViewController *webViewController = [[UMComWebViewController alloc] initWithUrl:urlSring];
    [self.navigationController pushViewController:webViewController animated:YES];
}

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
    detailVc.feedOperationDelegate = self;
    [self.navigationController pushViewController:detailVc animated:YES];
}

- (void)customObj:(id)obj clickOnFeedCreator:(UMComUser *)user;
{
    UMComSimplicityUserCenterViewController *userCenterVc = [[UMComSimplicityUserCenterViewController alloc] init];
    userCenterVc.user = user;
    [self.navigationController pushViewController:userCenterVc animated:YES];
}

- (void)customObj:(id)obj clickOnTopic:(UMComTopic *)topic
{
    UMComSimpleTopicFeedTableViewController* topicFeedViewController =  [[UMComSimpleTopicFeedTableViewController alloc] init];
    topicFeedViewController.topic = topic;
    topicFeedViewController.isShowEditButton = YES;
    [self.navigationController pushViewController:topicFeedViewController animated:YES];
}

- (void)customObj:(id)obj clickOnLikeFeed:(UMComFeed *)feed
{
    
    __weak typeof(self) weakself = self;
    
    [UMComLoginManager performLogin:self completion:^(id responseObject, NSError *error) {
        if (!error) {
            UMComFeedListDataController *feedDataController = (UMComFeedListDataController *)self.dataController;
            [feedDataController likeFeed:feed completion:^(id responseObject, NSError *error) {
                if (!error) {
                    if (feed.liked.boolValue) {
                        [UMComShowToast likeFeedSuccess];
                    }
                    else{
                        [UMComShowToast unlikeFeedSuccess];
                    }
                    [weakself reloadFeed:feed];
                }else{
                    if (ERR_CODE_LIKE_HAS_BEEN_CANCELED == error.code ||
                        ERR_CODE_FEED_HAS_BEEN_LIKED == error.code) {
                        [weakself reloadFeed:feed];
                    }
                    [UMComShowToast showFetchResultTipWithError:error];
                }
            }];
        }
    }];
}

- (void)customObj:(id)obj clickOnCommentFeed:(UMComFeed *)feed
{
    [UMComLoginManager performLogin:self completion:^(id responseObject, NSError *error) {
        if (!error) {
            UMComSimpleFeedDetailViewController *detailVc = [[UMComSimpleFeedDetailViewController alloc] init];
            detailVc.feed = feed;
            detailVc.feedOperationDelegate = self;
            detailVc.autoShowCommentEditView = YES;
            [self.navigationController pushViewController:detailVc animated:YES];
        }
    }];
}

- (void)customObj:(id)obj clickOnImageView:(UIImageView *)imageView complitionBlock:(void (^)(UIViewController *currentViewController))block
{
    if (block) {
        block(self);
    }
}

- (void)customObj:(id)obj clickOnFavouratesFeed:(UMComFeed *)feed
{
    __weak typeof(self) weakself = self;
    UMComFeedListDataController *feedDataController = (UMComFeedListDataController *)self.dataController;
    [feedDataController favouriteFeed:feed completion:^(id responseObject, NSError *error) {
        if (error) {
            [UMComShowToast showFetchResultTipWithError:error];
        }else{
            if (weakself.feedType == UMComFeedType_Favorite) {
                [weakself.dataController.dataArray removeObject:feed];
            }
            [weakself.tableView reloadData];
        }
    }];
}

#pragma mark - private method
/**
 *  刷新feed所在的cell
 *
 *  @param feed feed代表cell要显示feed
 */
-(void)reloadFeed:(UMComFeed*)feed
{
    NSInteger index = [self.dataController.dataArray indexOfObject:feed];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
    if ([self.tableView cellForRowAtIndexPath:indexPath]) {
        [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationNone];
    }
}


-(void)insertRowWithIndex:(NSInteger)index withNewFeed:(UMComFeed*)newFeed
{
    if (newFeed &&
        [newFeed isKindOfClass:[UMComFeed class]] &&
        (index <= self.dataController.dataArray.count && index >= 0)){
        NSIndexPath* indexPath =  [NSIndexPath indexPathForRow:index inSection:0];
        if (!indexPath) {
            return;
        }
        if (![self.dataController.dataArray containsObject:newFeed]) {
            [self.dataController.dataArray insertObject:newFeed atIndex:index];
            [self.tableView beginUpdates];
            [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
            [self.tableView endUpdates];
        }
        [self.tableView reloadData];
    }
}

-(void)deleteFeed:(UMComFeed*)feed
{
//    NSString *currentFeedID = feed.feedID;
    
    if ([feed isKindOfClass:[UMComFeed class]] && [self.dataController.dataArray containsObject:feed]){
        if (self.feedType == UMComFeedType_Favorite) {
            NSString *heightKey = feed.feedID;
            [self.cellCacheDict removeObjectForKey:heightKey];
            [self.tableView reloadData];
        }else{
            
            [self.dataController.dataArray removeObject:feed];
            [self.tableView reloadData];
        }
    }
}

#pragma mark - UMComFeedOperationFinishDelegate

-(void)feedLikeStatusChangeWithFeed:(UMComFeed *)feed
{
    [self reloadFeed:feed];
}

- (void)feedFavourateStatusChangeWithFeed:(UMComFeed *)feed
{
    [self reloadFeed:feed];
}

- (void)feedDeletedWithFeed:(UMComFeed *)feed
{
    [self deleteFeed:feed];
}

- (void)feedCreatedSucceedWithFeed:(UMComFeed *)feed
{
    [self insertRowWithIndex:0 withNewFeed:feed];
}

- (void)feedCommentSendSucceedWithComment:(UMComComment *)comment feed:(UMComFeed *)feed
{
    [self reloadFeed:feed];
}

- (void)feedCommentDeletedWithComment:(UMComComment *)comment feed:(UMComFeed *)feed
{
    [self reloadFeed:feed];
}

@end





@interface UMComLatestSimpleFeedTableViewController ()

- (void)handlePostFeedCompleteSucceed:(NSNotification *)notification;
@end
@implementation UMComLatestSimpleFeedTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handlePostFeedCompleteSucceed:) name:kNotificationPostFeedResultNotification object:nil];
}

-(void) dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kNotificationPostFeedResultNotification object:nil];
}

#pragma mark - private method
- (void)handlePostFeedCompleteSucceed:(NSNotification *)notification
{
    
    __weak typeof(self) weakself = self;
   UMComFeed* feed =  notification.object;
   dispatch_async(dispatch_get_main_queue(), ^{
       if (feed && [feed isKindOfClass:[UMComFeed class]]) {
           //插入到置顶数据之下
           [weakself insertRowWithIndex:self.dataController.topItemsCount withNewFeed:feed];

       }
   });
}

@end


@implementation UMComUsersFavouritesSimpleFeedTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //删除kUMComFeedDeletedFinishNotification，因为收藏界面不需要收到kUMComFeedDeletedFinishNotification的通知来删除用户已删除的feed
     [[NSNotificationCenter defaultCenter] removeObserver:self name:kUMComFeedDeletedFinishNotification object:nil];
}
@end


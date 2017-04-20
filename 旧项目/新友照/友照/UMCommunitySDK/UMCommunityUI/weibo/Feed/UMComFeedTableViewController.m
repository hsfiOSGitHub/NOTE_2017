//
//  UMComFeedsTableViewController.m
//  UMCommunity
//
//  Created by Gavin Ye on 8/27/14.
//  Copyright (c) 2014 Umeng. All rights reserved.
//

#import "UMComFeedTableViewController.h"
#import <UMComFoundation/UMUtils.h>
#import "UMComLoginManager.h"
#import "UMComResouceDefines.h"
#import "UMComShowToast.h"
#import "UMComShareCollectionView.h"
#import "UIViewController+UMComAddition.h"
#import "UMComFeedsTableViewCell.h"
#import "UMComTopicFeedViewController.h"
#import "UMComFeedStyle.h"
#import "UMComEditViewController.h"
#import "UMComNavigationController.h"
#import "UMComUserCenterViewController.h"
#import "UMComNearbyFeedViewController.h"
#import "UMComClickActionDelegate.h"
#import "UMComFeedDetailViewController.h"
#import "UMComWebViewController.h"
#import <UMCommunitySDK/UMComSession.h>
#import <UMComDataStorage/UMComFeed.h>
#import "UMComScrollViewDelegate.h"
#import "UMComFeedOperationFinishDelegate.h"
#import <UMComDataStorage/UMComTopic.h>
#import "UMComReplyEditViewController.h"
#import <UMComDataStorage/UMComComment.h>
#import "UMComFeedListDataController.h"
#import <UMComDataStorage/UMComModelObjectHeader.h>
#import "UMComCommentListDataController.h"
#import "UMComShowToast.h"
#import <UMComFoundation/UMComKit+Color.h>
#import <UMComFoundation/UMComDefines.h>



@interface UMComFeedTableViewController ()<NSFetchedResultsControllerDelegate,UITextFieldDelegate,UMComClickActionDelegate,UMComScrollViewDelegate,UMComFeedOperationFinishDelegate, UIActionSheetDelegate> {
    
    NSFetchedResultsController *_fetchedResultsController;
}

@property (nonatomic, strong) UMComShareCollectionView *shareListView;

@property (nonatomic, strong) UIView *headerView;

@property (nonatomic, strong) UMComFeed *selectedFeed;

@end

@implementation UMComFeedTableViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        //self.isLoadLoacalData = YES;
        self.feedCellBgViewTopEdge = UMCom_Micro_Feed_Cell_Space;
    }
    return self;
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        //self.isLoadLoacalData = YES;
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if (_isShowEditButton) {
        if (!self.editButton) {
            [self createEditButton];
            [self.view addSubview:self.editButton];
        }
        self.editButton.hidden = NO;
    }
    else
    {
       self.editButton.hidden = YES;
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.editButton removeFromSuperview];
    self.editButton = nil;
    [self.shareListView dismiss];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.tableView registerNib:[UINib nibWithNibName:@"UMComFeedsTableViewCell" bundle:nil] forCellReuseIdentifier:@"FeedsTableViewCell"];
    //此代码在ios.7.1.2(iphone5)上会触发重画，如果没有注册cell，会导致崩溃
    //self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.tableView.backgroundColor = UMComRGBColor(245, 246, 250);
    self.feedStyleList = [NSMutableArray array];
    if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)]) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    [self setTitleViewWithTitle:self.title];
    
}

- (void)createEditButton
{
    self.editButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.editButton.frame = CGRectMake(0, 0, 50, 50);
    self.editButton.center = CGPointMake(self.view.frame.size.width-DeltaRight, self.view.bounds.size.height-DeltaBottom);
    [self.editButton setImage:UMComImageWithImageName(@"um_edit_nomal") forState:UIControlStateNormal];
    [self.editButton setImage:UMComImageWithImageName(@"um_edit_highlight") forState:UIControlStateSelected];
    [self.editButton addTarget:self action:@selector(onClickEdit:) forControlEvents:UIControlEventTouchUpInside];
    self.editButton.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleTopMargin;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - deleagte 
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
     return self.feedStyleList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * cellIdentifier = @"FeedsTableViewCell";
    UMComFeedsTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    cell.cellBgViewTopEdge = self.feedCellBgViewTopEdge;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.delegate = self;
    if (indexPath.row < self.feedStyleList.count) {
        [cell reloadFeedWithfeedStyle:[self.feedStyleList objectAtIndex:indexPath.row] tableView:tableView cellForRowAtIndexPath:indexPath];
        if (![self checkTopFeedWithFeed:[self.feedStyleList[indexPath.row] valueForKey:@"feed"]]) {
            //如果当前view设置不显示置顶就直接不显示cell的置顶标签
            cell.topImage.hidden = YES;
        }
    }
    if (!self.isDisplayDistance) {
        cell.locationDistance.hidden = YES;
    }
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    float cellHeight = 0;
    if (indexPath.row < self.feedStyleList.count) {
        UMComFeedStyle *feedStyle = self.feedStyleList[indexPath.row];
        cellHeight = feedStyle.totalHeight;
    }
    return cellHeight;
}

- (void)customScrollViewDidScroll:(UIScrollView *)scrollView lastPosition:(CGPoint)lastPosition
{
    if (self.isShowEditButton){
        [self.view bringSubviewToFront:self.editButton];
    }
    if (self.isShowEditButton) {
        [self setEditButtonAnimationWithScrollView:scrollView lastPosition:self.lastPosition];
    }
}

- (void)setEditButtonAnimationWithScrollView:(UIScrollView *)scrollView lastPosition:(CGPoint)lastPosition
{
    if (scrollView.contentOffset.y >0 && scrollView.contentOffset.y > lastPosition.y+15) {
        if (self.editButton.center.y > self.view.bounds.size.height) {
            return;
        }
        [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
            self.editButton.center = CGPointMake(self.editButton.center.x, self.view.bounds.size.height+DeltaBottom);
        } completion:nil];
    }else{
        if (self.editButton.center.y <= (self.view.bounds.size.height-DeltaBottom)) {
            return;
        }
        if (scrollView.contentOffset.y < lastPosition.y-15) {
            [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
                self.editButton.center = CGPointMake(self.editButton.center.x, self.view.bounds.size.height-DeltaBottom);
            } completion:nil];
        }
    }
}

#pragma mark - handdle feeds data
- (NSArray *)transFormToFeedStylesWithFeedDatas:(NSArray *)feedList
{
    NSMutableArray *feedStyles = [NSMutableArray arrayWithCapacity:1];
    @autoreleasepool {
        for (UMComFeed *feed in feedList) {
            if (![feed isKindOfClass:[UMComFeed class]]) {
                continue;
            }
            if ([feed.status integerValue]>= FeedStatusDeleted) {
                continue;
            }
            UMComFeedStyle *feedStyle = [UMComFeedStyle feedStyleWithFeed:feed viewWidth:self.tableView.frame.size.width];
            if (feedStyle) {
                [feedStyles addObject:feedStyle];
            }
        }
    }
    return feedStyles;
}


- (void)reloadRowAtIndex:(NSIndexPath *)indexPath
{
    if ([self.tableView cellForRowAtIndexPath:indexPath]) {
        [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
    }
}

- (void)insertFeedStyleToDataArrayWithFeed:(UMComFeed *)newFeed
{
    __weak typeof(self) weakSlef = self;
    if ([newFeed isKindOfClass:[UMComFeed class]] && ![self.dataController.dataArray containsObject:newFeed]) {
        self.noDataTipLabel.hidden = YES;
        if (self.dataController.dataArray.count == 0) {
            [self.dataController.dataArray addObject:newFeed];
            [self.feedStyleList addObject:[UMComFeedStyle feedStyleWithFeed:newFeed viewWidth:self.view.frame.size.width]];
        }else{
            __block NSMutableArray *tempArray = [NSMutableArray arrayWithArray:self.dataController.dataArray];
            [tempArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                UMComFeed *feed = (UMComFeed *)obj;
                if ([feed.is_top boolValue] == NO) {
                    [tempArray insertObject:newFeed atIndex:idx];
                    weakSlef.dataController.dataArray = tempArray;
                    UMComFeedStyle *feedStyle = [UMComFeedStyle feedStyleWithFeed:newFeed viewWidth:weakSlef.tableView.frame.size.width];
                    [self.feedStyleList insertObject:feedStyle atIndex:idx];
                    *stop = YES;
                    //[weakSlef insertCellAtRow:idx section:0];
                }
            }];
        }
        }

    [self.tableView reloadData];
}

- (void)deleteFeedFromList:(UMComFeed *)feed
{
    __weak typeof(self) weakSelf = self;
    [self.feedStyleList enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UMComFeedStyle *feedStyle = obj;
        if ([feedStyle.feed.feedID isEqualToString:feed.feedID]) {
            *stop = YES;
            [weakSelf.feedStyleList removeObject:feedStyle];
            [weakSelf.tableView reloadData];
        }
    }];
}

#pragma mark - edit button
-(void)onClickEdit:(id)sender
{
    __weak typeof(self) weakSelf = self;
    [UMComLoginManager performLogin:self completion:^(id responseObject, NSError *error) {
        if (!error) {
            UMComEditViewController *editViewController = [[UMComEditViewController alloc] init];
            editViewController.feedOperationFinishDelegate = weakSelf;
            UMComNavigationController *editNaviController = [[UMComNavigationController alloc] initWithRootViewController:editViewController];
            [self presentViewController:editNaviController animated:YES completion:nil];
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


#pragma mark -  UMComClickActionDelegate

- (void)customObj:(id)obj clickOnUser:(UMComUser *)user
{
    //如果是在个人中心页面且点击的用户刚好是个人中心的用户， 则不跳转
    if ([self.dataController isKindOfClass:[UMComFeedTimeLineDataController class]]) {
        UMComFeedTimeLineDataController* feedListOfTimeLineController =  (UMComFeedTimeLineDataController*)self.dataController;
        if ([feedListOfTimeLineController.userID isEqualToString:user.uid]) {
            return;
        }
    }
    UMComUserCenterViewController *userCenterVc = [[UMComUserCenterViewController alloc]initWithUser:user];
    [self.navigationController pushViewController:userCenterVc animated:YES];
    
}

- (void)customObj:(id)obj clickOnTopic:(UMComTopic *)topic
{
    if (!topic) {
        return;
    }
    
    //相同的topic下的feed，点击相同的话题，不做跳转
    //...todo
    
    UMComTopicFeedViewController *oneFeedViewController = [[UMComTopicFeedViewController alloc] initWithTopic:topic];
    [self.navigationController  pushViewController:oneFeedViewController animated:YES];
}

- (void)customObj:(id)obj clickOnFeedText:(UMComFeed *)feed
{
    if (!feed) {
        return;
    }
    
    if (![feed isKindOfClass:[UMComFeed class]]) {
        return;
    }
    if ([feed.status isKindOfClass:[NSNumber class]] && feed.status.integerValue >= 2) {
        //代表feed被删除
        return;
    }
    
    UMComFeedDetailViewController * feedDetailViewController = [[UMComFeedDetailViewController alloc] initWithFeed:feed showFeedDetailShowType:UMComShowFromClickFeedText];
    feedDetailViewController.feedOperationFinishDelegate = self;
    [self.navigationController pushViewController:feedDetailViewController animated:YES];
}

- (void)customObj:(id)obj clickOnOriginFeedText:(UMComFeed *)feed
{
    
    if (!feed) {
        return;
    }
    UMComFeedDetailViewController * feedDetailViewController = [[UMComFeedDetailViewController alloc] initWithFeed:feed showFeedDetailShowType:UMComShowFromClickFeedText];
    feedDetailViewController.feedOperationFinishDelegate = self;
    [self.navigationController pushViewController:feedDetailViewController animated:YES];
}


- (void)customObj:(id)obj clickOnURL:(NSString *)url
{
    UMComWebViewController * webViewController = [[UMComWebViewController alloc] initWithUrl:url];
    [self.navigationController pushViewController:webViewController animated:YES];
}

- (void)customObj:(id)obj clickOnLocationText:(UMComFeed *)feed
{
    
    if (!feed || [feed.status intValue] >= FeedStatusDeleted) {
        return;
    }
    UMComLocation *locationDic = feed.location;
    if (!locationDic) {
        locationDic = feed.origin_feed.location;
    }
    CLLocation *location = [[CLLocation alloc] initWithLatitude:locationDic.latitude.floatValue longitude:locationDic.longitude.floatValue];
    __weak typeof(self) weakSelf = self;
    [UMComLoginManager performLogin:self completion:^(id responseObject, NSError *error) {
        if (!error) {
            UMComNearbyFeedViewController *nearbyFeedViewController = [[UMComNearbyFeedViewController alloc] initWithLocation:location title:locationDic.name];
            [weakSelf.navigationController pushViewController:nearbyFeedViewController animated:YES];
        }
    }];
     
}

- (void)customObj:(id)obj clickOnLikeFeed:(UMComFeed *)feed
{
    if (!feed) {
        return;
    }
    __weak typeof(self) weakSelf = self;
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
                        [weakSelf reloadFeed:feed];
                    }else{
                        if (ERR_CODE_LIKE_HAS_BEEN_CANCELED == error.code ||
                            ERR_CODE_FEED_HAS_BEEN_LIKED == error.code) {
                            [weakSelf reloadFeed:feed];
                        }
                        [UMComShowToast showFetchResultTipWithError:error];
                    }
                }];
            }
    }];
}

- (void)customObj:(id)obj clickOnForward:(UMComFeed *)feed
{
    if (!feed) {
        return;
    }
    __weak typeof(self) weakSelf = self;
    [UMComLoginManager performLogin:self completion:^(id responseObject, NSError *error) {
        if (!error) {
            UMComEditViewController *editViewController = [[UMComEditViewController alloc] initWithForwardFeed:feed];
            editViewController.feedOperationFinishDelegate = weakSelf;
            UMComNavigationController *editNaviController = [[UMComNavigationController alloc] initWithRootViewController:editViewController];
            [self presentViewController:editNaviController animated:YES completion:nil];
        }
    }];
    
}

- (void)customObj:(id)obj clickOnComment:(UMComComment *)comment feed:(UMComFeed *)feed
{
    if (!feed) {
        return;
    }
    
    [self showCommentEditViewWithComment:comment feed:feed];
    
}

- (void)customObj:(id)obj clickOnImageView:(UIImageView *)imageView complitionBlock:(void (^)(UIViewController *viewcontroller))block
{
    if (block) {
        block(self);
    }
}


- (void)customObj:(id)obj clikeOnMoreButton:(id)param
{
    UMComFeedsTableViewCell *cell = obj;
    [self showActionSheetWithFeed:cell.feed];
}


#pragma mark - show ActionSheet
- (void)showActionSheetWithFeed:(UMComFeed *)feed
{
    self.selectedFeed =feed;
    NSMutableArray *_menuList = [NSMutableArray array];
    NSString *destructiveButtonString = nil;
    if ([[UMComSession sharedInstance] isPermissionDeleteFeed:feed]) {
        [_menuList addObject:UMComLocalizedString(@"um_com_delete", @"删除")];
    }
    if ([feed.has_collected boolValue]) {
        [_menuList addObject:UMComLocalizedString(@"um_com_cancelCollect", @"取消收藏")];
    }else{
        [_menuList addObject:UMComLocalizedString(@"um_com_collect", @"收藏")];
    }
//    [_menuList addObject:UMComLocalizedString(@"um_com_share", @"分享")];
    
    if ([[UMComSession sharedInstance] isNeedSpamUser:feed.creator]) {
        [_menuList addObject:UMComLocalizedString(@"um_com_spamUser", @"举报用户")];
    }
    
    if (![[UMComSession sharedInstance] isPermissionDeleteFeed:feed]) {
        [_menuList addObject:UMComLocalizedString(@"um_com_spamContent", @"举报内容")];
    }
    [_menuList addObject:UMComLocalizedString(@"um_com_copy", @"拷贝")];
    
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:nil
                                                       delegate:self
                                              cancelButtonTitle:UMComLocalizedString(@"um_com_cancel", @"取消")
                                         destructiveButtonTitle:destructiveButtonString
                                              otherButtonTitles:nil];
    for (int i = 0; i < _menuList.count; ++i) {
        [sheet addButtonWithTitle:_menuList[i]];
    }
    sheet.tag = 10002;
    [sheet showInView:[UIApplication sharedApplication].keyWindow];
}



#pragma mark -  UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    NSString *title = [actionSheet buttonTitleAtIndex:buttonIndex];
    if (actionSheet.tag == 10002) {
        UMComFeed *feed = self.selectedFeed;
        if ([title isEqualToString:UMComLocalizedString(@"um_com_delete", @"删除")]) {
            [self deleteFeed:feed];
        }else if ([title isEqualToString:UMComLocalizedString(@"um_com_collect", @"收藏")] || [title isEqualToString:UMComLocalizedString(@"um_com_cancelCollect", @"取消收藏")]){
            [self collectFeed:feed];
        }else if ([title isEqualToString:UMComLocalizedString(@"um_com_share", @"分享")]){
            [self shareFeed:feed];
        }else if ([title isEqualToString:UMComLocalizedString(@"um_com_spamUser", @"举报用户")]){
            [self spamUser:feed.creator];
        }else if ([title isEqualToString:UMComLocalizedString(@"um_com_spamContent", @"举报内容")]){
            [self spamFeed:feed];
        }else if ([title isEqualToString:UMComLocalizedString(@"um_com_copy", @"拷贝")]){
            [self copyFeed:feed];
        }
    }else{
        [self showActionSheet:actionSheet didDismissWithButtonIndex:buttonIndex];
    }
}

- (void)showActionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{

}

#pragma mark - feed operation

- (void)deleteFeed:(UMComFeed *)feed
{
    if (!feed) {
        return;
    }
    __weak typeof(self) weakself = self;
    [UMComLoginManager performLogin:self completion:^(id responseObject, NSError *error) {
        if (!error) {
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
            [((UMComFeedListDataController*)self.dataController) deleteFeed:feed completion:^(id responseObject, NSError *error) {
                [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
                if (error){
                    [UMComShowToast showFetchResultTipWithError:error];
                }
                if ([feed.status integerValue] >= 2) {
                    [weakself deleteFeedFromList:feed];
                }
                
            }];
        }
    }];
    
     
}

- (void)shareFeed:(UMComFeed *)feed
{
    if (!feed) {
        return;
    }
    self.shareListView = [[UMComShareCollectionView alloc]initWithFrame:CGRectMake(0, self.view.window.frame.size.height, self.view.window.frame.size.width,120)];
    self.shareListView.feed = feed;
    self.shareListView.shareViewController = self;
    [self.shareListView shareViewShow];
}

- (void)collectFeed:(UMComFeed *)feed
{
    __weak typeof(self) weakSelf = self;
    BOOL isFavourite = ![[feed has_collected] boolValue];
    [UMComLoginManager performLogin:self completion:^(id responseObject, NSError *error) {
        if (!error) {
            
            [((UMComFeedListDataController*)self.dataController) favouriteFeed:feed completion:^(id responseObject, NSError *error) {
                
                 [UMComShowToast favouriteFeedFail:error isFavourite:isFavourite];
                 [weakSelf.tableView reloadData];
                
            }];
             
        }
    }];
}

- (void)spamUser:(UMComUser *)user
{
    [UMComLoginManager performLogin:self completion:^(id responseObject, NSError *error) {
        if (!error) {
            [((UMComFeedListDataController*)self.dataController) spamUser:user completion:^(id responseObject, NSError *error) {
                [UMComShowToast spamUser:error];
            }];
        }
    }];
}

- (void)spamFeed:(UMComFeed *)feed
{
    [UMComLoginManager performLogin:self completion:^(id responseObject, NSError *error) {
        if (!error) {
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
            [((UMComFeedListDataController*)self.dataController)  spamFeed:feed completion:^(id responseObject, NSError *error) {
                [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
                [UMComShowToast spamSuccess:error];
            }];
        }
    }];
}


- (void)copyFeed:(UMComFeed *)feed
{
    NSMutableArray *strings = [NSMutableArray arrayWithCapacity:1];
    NSMutableString *string = [[NSMutableString alloc]init];
    if (feed.text) {
        [strings addObject:feed.text];
        [string appendString:feed.text];
    }
    if (feed.origin_feed.text) {
        [strings addObject:feed.origin_feed.text];
        [string appendString:feed.origin_feed.text];
    }
    UIPasteboard *pboard = [UIPasteboard generalPasteboard];
    pboard.strings = strings;
    pboard.string = string;
    
    [UMComShowToast copySuccess];
}


#pragma mark - rotation

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    [self.shareListView dismiss];
}


#pragma mark - UMComFeedOperationFinishDelegate
- (void)reloadDataWhenFeedOperationFinish:(UMComFeed *)feed
{
    [self.tableView reloadData];
}

- (void)createFeedSucceed:(UMComFeed *)feed
{
    if (([self.dataController isKindOfClass:[UMComFeedTimeLineDataController class]] && [[(UMComFeedTimeLineDataController *)self.dataController userID] isEqualToString:[UMComSession sharedInstance].uid]) || [self.dataController isKindOfClass:[UMComTopicFeedDataController class]]) {
        if ([self.dataController isKindOfClass:[UMComTopicFeedDataController class]]) {
            UMComTopicFeedDataController *topicFeedsRequest = (UMComTopicFeedDataController *)self.dataController;
            if (topicFeedsRequest.sortType == UMComTopicFeedSortType_default) {
             [self insertFeedStyleToDataArrayWithFeed:feed];
            }
        }else{
            [self insertFeedStyleToDataArrayWithFeed:feed];
        }
    }
}

#pragma mark - 
- (void)showCommentEditViewWithComment:(UMComComment *)comment feed:(UMComFeed *)feed
{
    [UMComLoginManager performLogin:self completion:^(id responseObject, NSError *error) {
        if (!error) {
            __weak typeof(self) weakself = self;
            UMComReplyEditViewController* tempReplyController =  [[UMComReplyEditViewController alloc] init];
            
            tempReplyController.commentcreator =  comment.creator.name;
            tempReplyController.commitBlock = ^(NSString *content, NSArray *imageList) {
                [weakself replyContent:content toPost:feed fromComment:comment imageList:imageList];
                [weakself dismissViewControllerAnimated:YES completion:nil];
            };
            tempReplyController.cancelBlock = ^{                
                [weakself dismissViewControllerAnimated:YES completion:nil];
            };
            [self presentViewController:tempReplyController animated:YES completion:nil];
        }
    }];
    
}

- (void)replyContent:(NSString *)content toPost:(UMComFeed *)feed fromComment:(UMComComment *)comment imageList:(NSArray *)imageList
{
    if ((content.length == 0 && imageList.count == 0) || !feed) {
        return;
    }
    __weak typeof(self) weakself = self;
    [(UMComFeedListDataController *)self.dataController commentFeed:feed content:content images:imageList completion:^(NSDictionary *responseObject, NSError *error) {
        if (error) {
            [UMComShowToast showFetchResultTipWithError:error];
        } else {
            [UMComShowToast fetchFailWithNoticeMessage:UMComLocalizedString(@"um_com_commentSuccess", @"评论成功")];
        }
        [weakself.tableView reloadData];
        if (UMComSystem_Version_Greater_Than_Or_Equal_To(@"7.0")) {
            [weakself setNeedsStatusBarAppearanceUpdate];
        }
    }];
}


- (void)deleteFeedFinish:(UMComFeed *)feed
{
    [self deleteFeed:feed];
}

#pragma mark - overide method

/**
 *  排序回调的数据
 *
 *  @param data 源数据
 *
 *  @return 排序的数据(置顶数据在前面)
 */
-(NSArray*) sortFeedWithSourceData:(NSArray*)sourceData
{
    if (!sourceData || sourceData.count <= 0) {
        return [NSArray array];
    }
    
    NSMutableArray* topFeedStyleListArray = [NSMutableArray arrayWithCapacity:2];
    NSMutableArray* normalFeedStyleArray = [NSMutableArray arrayWithCapacity:2];
    
    for (int i = 0; i < sourceData.count; i++) {
        
        id tempSourceFeedStyle = sourceData[i];
        if (tempSourceFeedStyle && [tempSourceFeedStyle isKindOfClass:[UMComFeedStyle class]]) {
            UMComFeedStyle* sourceFeedStyle = tempSourceFeedStyle;
            if (sourceFeedStyle) {
                
                if (![self checkTopFeedWithFeed:sourceFeedStyle.feed]) {
                    [normalFeedStyleArray addObject:sourceFeedStyle];
                }
                else{
                    [topFeedStyleListArray addObject:sourceFeedStyle];
                }
            }
        }
    }
    
    NSMutableArray* resultFeedArray = [NSMutableArray arrayWithCapacity:2];
    
    [resultFeedArray addObjectsFromArray:topFeedStyleListArray];
    [resultFeedArray addObjectsFromArray:normalFeedStyleArray];
    
    return resultFeedArray;
}

#pragma mark - 判断当前Feed是否置顶(2.4新方法)
-(BOOL) checkTopFeedWithFeed:(UMComFeed*)feed
{
    if (!feed) {
        return NO;
    }
    
    BOOL isTopFeed = NO;
    switch (self.topFeedType) {
        case UMComTopFeedType_GloalTopFeed:
        {
            NSNumber* isTopValue =  feed.is_top;
            if (isTopValue && [isTopValue isKindOfClass:[NSNumber class]] &&
                (isTopValue.integerValue == 1)) {
                isTopFeed = YES;
            }
        }
            break;
        case UMComTopFeedType_TopicTopFeed:
        {
            NSNumber* isTopicTopValue =  feed.is_topic_top;
            if (isTopicTopValue && [isTopicTopValue isKindOfClass:[NSNumber class]] &&
                (isTopicTopValue.integerValue == 1)) {
                isTopFeed = YES;
            }
        }
            break;
        case UMComTopFeedType_GloalTopAndTopicTopFeed:
        {
            NSNumber* isTopValue =  feed.is_top;
            NSNumber* isTopicTopValue =  feed.is_topic_top;
            if ((isTopValue && [isTopValue isKindOfClass:[NSNumber class]] &&
                 (isTopValue.integerValue == 1))
                && ((isTopicTopValue && [isTopicTopValue isKindOfClass:[NSNumber class]] &&
                     (isTopicTopValue.integerValue == 1)))) {
                
                
                isTopFeed = YES;
            }
        }
            break;
        case UMComTopFeedType_GloalTopOrTopicTopFeed:
        {
            NSNumber* isTopValue =  feed.is_top;
            NSNumber* isTopicTopValue =  feed.is_topic_top;
            if ((isTopValue && [isTopValue isKindOfClass:[NSNumber class]] &&
                 (isTopValue.integerValue == 1))
                || ((isTopicTopValue && [isTopicTopValue isKindOfClass:[NSNumber class]] &&
                     (isTopicTopValue.integerValue == 1)))) {
                isTopFeed = YES;
            }
        }
            break;
        default:
            break;
    }
    
    return isTopFeed;
}


#pragma mark - data request

- (void)handleLocalData:(NSArray *)data error:(NSError *)error
{
    if (!error && [data isKindOfClass:[NSArray class]]) {
        
        [self.feedStyleList removeAllObjects];
        NSArray* sourceArray = [self transFormToFeedStylesWithFeedDatas:data];
        NSArray* localSourceArray = [self sortFeedWithSourceData:sourceArray];
        if (localSourceArray && localSourceArray.count > 0) {
            [self.feedStyleList addObjectsFromArray:localSourceArray];
        }
        
        //是否提示用户没有数据
        if(self.feedStyleList.count > 0)
        {
            self.noDataTipLabel.hidden = YES;
        }
        else
        {
            self.noDataTipLabel.hidden = NO;
        }
    }
}

- (void)handleFirstPageData:(NSArray *)data error:(NSError *)error
{
    if (!error) {
        
        
        if ([data isKindOfClass:[NSArray class]] && data.count > 0) {
            [self.feedStyleList removeAllObjects];
            [self.feedStyleList addObjectsFromArray:[self transFormToFeedStylesWithFeedDatas:data]];
        }
        else
        {
            //...todo
        }
        
        //是否提示用户没有数据
        if(self.feedStyleList.count > 0)
        {
            self.noDataTipLabel.hidden = YES;
        }
        else
        {
            self.noDataTipLabel.hidden = NO;
        }
    }
    else{
        [UMComShowToast showFetchResultTipWithError:error];
    }

}

- (void)handleNextPageData:(NSArray *)data error:(NSError *)error
{
    if (!error) {
        if (data.count > 0) {
            //此处去重--bengin
            //...todo
            //此处去重--end
            NSMutableArray *tempArray = [NSMutableArray arrayWithArray:self.feedStyleList];
            NSArray *array = [self transFormToFeedStylesWithFeedDatas:data];
            if (array.count > 0) {
                [tempArray addObjectsFromArray:array];
            }
            self.feedStyleList = tempArray;
            
        }else {
            [UMComShowToast showNoMore];
        }
        
    } else {
        [UMComShowToast showFetchResultTipWithError:error];
    }
}


@end

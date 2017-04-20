//
//  UMComFindViewController.m
//  UMCommunity
//
//  Created by umeng on 15-3-31.
//  Copyright (c) 2015年 Umeng. All rights reserved.
//

#import "UMComFindViewController.h"
#import "UMComUserCenterViewController.h"
#import <UMCommunitySDK/UMComSession.h>
#import "UMComNearbyFeedViewController.h"
#import "UMComTopicsTableViewController.h"
#import "UMComNoticeSystemViewController.h"
#import "UMComUserListDataController.h"
#import "UMComFeedListDataController.h"
#import "UMComTopicListDataController.h"
#import "UMComFavouratesViewController.h"
#import "UMComPhotoAlbumViewController.h"
#import "UMComUserNearbyViewController.h"
#import "UMComResouceDefines.h"


@interface UMComFindViewController ()

@end

@implementation UMComFindViewController

- (void)viewDidLoad {
    [super viewDidLoad];

}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}



- (void)tranToCircleFriends
{
    UMComFeedTableViewController *friendViewController = [[UMComFeedTableViewController alloc]init];
    friendViewController.isAutoStartLoadData = YES;
    friendViewController.dataController = [[UMComFeedFriendsDataController alloc]initWithCount:UMCom_Limit_Page_Count];
    friendViewController.dataController.isReadLoacalData = YES;
    friendViewController.dataController.isSaveLoacalData = YES;
    friendViewController.title = UMComLocalizedString(@"um_com_friend", @"好友圈");
    [self.navigationController pushViewController:friendViewController animated:YES];
}

- (void)tranToFollowedTopic
{
    UMComTopicsTableViewController *topicsViewController = [[UMComTopicsTableViewController alloc] init];
    topicsViewController.title = UMComLocalizedString(@"follow_topics", @"关注话题");
    topicsViewController.isAutoStartLoadData = YES;
    topicsViewController.dataController = [[UMComTopicsFocusDataController alloc]initWithCount:UMCom_Limit_Page_Count withUID:[UMComSession sharedInstance].uid];
    topicsViewController.dataController.isReadLoacalData = YES;
    topicsViewController.dataController.isSaveLoacalData = YES;
    [self.navigationController pushViewController:topicsViewController animated:YES];
}

- (void)tranToAlbum
{
    UMComPhotoAlbumViewController *photoAlbumVc = [[UMComPhotoAlbumViewController alloc]init];
    photoAlbumVc.user = [UMComSession sharedInstance].loginUser;
    [self.navigationController pushViewController:photoAlbumVc animated:YES];
}

- (void)tranToNearby
{
    UMComNearbyFeedViewController *nearbyFeedController = [[UMComNearbyFeedViewController alloc]init];
    //nearbyFeedController.isLoadLoacalData = NO;
    nearbyFeedController.title = UMComLocalizedString(@"um_com_nearbyRecommend", @"附近内容");
    [self.navigationController pushViewController:nearbyFeedController animated:YES];
}

- (void)tranToNearbyUsers
{
    UMComUserNearbyViewController *userViewController = [[UMComUserNearbyViewController alloc] init];
    userViewController.isAutoStartLoadData = YES;
    userViewController.callbackBlock = ^(UMComUserTableViewController *controller, UMComUserTableViewCallBackEvent event, UMComUser *user) {
        UMComUserCenterViewController *vc = [[UMComUserCenterViewController alloc] initWithUser:user];
        vc.userOperationFinishDelegate = controller.userOperationFinishDelegate;
        [controller.navigationController pushViewController:vc animated:YES];
    };
    userViewController.title = UMComLocalizedString(@"user_recommend", @"附近用户");
    [self.navigationController  pushViewController:userViewController animated:YES];
}

- (void)tranToRealTimeFeeds
{
    UMComFeedTableViewController *realTimeFeedsViewController = [[UMComFeedTableViewController alloc] init];
    //realTimeFeedsViewController.isLoadLoacalData = NO;
    realTimeFeedsViewController.isAutoStartLoadData = YES;
    realTimeFeedsViewController.dataController = [[UMComFeedRealTimeDataController alloc] initWithCount:UMCom_Limit_Page_Count];
    realTimeFeedsViewController.title = UMComLocalizedString(@"um_com_newcontent", @"实时内容");
    [self.navigationController  pushViewController:realTimeFeedsViewController animated:YES];
}

- (void)tranToRecommendUsers
{
    UMComUserTableViewController *userViewController = [[UMComUserTableViewController alloc] init];
    userViewController.dataController = [[UMComUserRecommendDataController alloc] initWithCount:UMCom_Limit_Page_Count];
    userViewController.isAutoStartLoadData = YES;
    userViewController.callbackBlock = ^(UMComUserTableViewController *controller, UMComUserTableViewCallBackEvent event, UMComUser *user) {
        UMComUserCenterViewController *vc = [[UMComUserCenterViewController alloc] initWithUser:user];
        vc.userOperationFinishDelegate = controller.userOperationFinishDelegate;
        [controller.navigationController pushViewController:vc animated:YES];
    };
    userViewController.title = UMComLocalizedString(@"user_recommend", @"用户推荐");
    [self.navigationController  pushViewController:userViewController animated:YES];
}

- (void)tranToRecommendTopics
{
    UMComTopicsTableViewController *topicsRecommendViewController = [[UMComTopicsTableViewController alloc] init];
    topicsRecommendViewController.dataController = [[UMComTopicsRecommendDataController alloc] initWithCount:UMCom_Limit_Page_Count];
    topicsRecommendViewController.isAutoStartLoadData = YES;
    topicsRecommendViewController.title = UMComLocalizedString(@"um_com_user_topic_recommend", @"推荐话题");
    [self.navigationController  pushViewController:topicsRecommendViewController animated:YES];
}

- (void)tranToUsersFavourites
{
    UMComFavouratesViewController *favouratesViewController = [[UMComFavouratesViewController alloc] init];
    favouratesViewController.dataController = [[UMComFeedFavoriteDataController alloc] initWithCount:UMCom_Limit_Page_Count];
    favouratesViewController.dataController.isReadLoacalData = YES;
    favouratesViewController.dataController.isSaveLoacalData = YES;
    favouratesViewController.isAutoStartLoadData = YES;
    favouratesViewController.title = UMComLocalizedString(@"um_com_user_collection", @"我的收藏");
    [self.navigationController  pushViewController:favouratesViewController animated:YES];
}

- (void)tranToUsersNotice
{
    UMComNoticeSystemViewController *userNewaNoticeViewController = [[UMComNoticeSystemViewController alloc] init];
    [self.navigationController  pushViewController:userNewaNoticeViewController animated:YES];
}

- (void)tranToUserCenter
{
    UMComUserCenterViewController *userCenterViewController = [[UMComUserCenterViewController alloc] initWithUser:[UMComSession sharedInstance].loginUser];
    [self.navigationController pushViewController:userCenterViewController animated:YES];
}
@end

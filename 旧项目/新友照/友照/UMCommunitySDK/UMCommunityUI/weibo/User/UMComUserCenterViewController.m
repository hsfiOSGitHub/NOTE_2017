//
//  UMComUserCenterViewController.m
//  UMCommunity
//
//  Created by Gavin Ye on 9/10/14.
//  Copyright (c) 2014 Umeng. All rights reserved.
//

#import "UMComUserCenterViewController.h"
#import <UMComDataStorage/UMComUser.h>
#import <UMCommunitySDK/UMComSession.h>
#import "UMComShowToast.h"
#import "UMComTopicsTableViewController.h"
#import "UMComPhotoAlbumViewController.h"
#import "UMComFeedTableViewController.h"
#import "UMComUserTableViewController.h"
#import "UMComPrivateChatTableViewController.h"
#import "UIViewController+UMComAddition.h"
#import "UMComBarButtonItem.h"
#import "UMComUserOperationFinishDelegate.h"
#import "UMComLoginManager.h"
#import "UMComUserProfileDetailView.h"
#import "UMComScrollViewDelegate.h"
#import <UMComDataStorage/UMComMedal.h>
#import "UMComFeedsTableViewCell.h"
#import "UMComUserDataController.h"
#import "UMComFeedListDataController.h"
#import "UMComUserListDataController.h"
#import "UMComTopicListDataController.h"
#import "UMComNotificationMacro.h"

#define SuperAdmin 3 //超级管理员

@interface UMComUserCenterViewController ()<UMComScrollViewDelegate, UIActionSheetDelegate, UMComUserProfileDetaiViewDelegate, UMComUserOperationFinishDelegate>

@property (nonatomic, strong) UMComUser *user;

@property (nonatomic, strong) UMComUserProfileDetailView *detailView;

@property (nonatomic,strong)  UMComUserDataController* userDataController;

@property (nonatomic, strong) UIViewController *lastViewController;

@property(nonatomic,readwrite,strong)UMComBarButtonItem* privateLetterItem;//操作私信的按钮
/** 判断当前私信是否显示 */
-(BOOL) isPrivateLetterItemShow;

@end

@implementation UMComUserCenterViewController


- (instancetype)initWithUser:(UMComUser *)user
{
    self = [super init];
    if (self) {
        self.user = user;
    }
    return self;
}

- (void)setUser:(UMComUser *)user
{
    _user = user;
    if (user) {
        self.userDataController = [UMComUserDataController userDataControllerWithUser:user];
    }
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //设置裁剪
    self.view.clipsToBounds = YES;
    
    [self setForumUITitle:self.user.name];
    
    //设置返回按钮
    [self setForumUIBackButton];
    
    //设置私信和更多按钮
    [self creatNavigationItemList];
    
    //创建详情按钮
    [self creatDetailView];

    //创建子ViewController
    [self creatChildViewControllers];
    
    [self getCurrentUserRequest];
    
    if ([self.user.uid isEqualToString:[UMComSession sharedInstance].uid]) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadDataWhenUserOperationFinish:) name:kUMComFeedDeletedFinishNotification object:nil];
         [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadDataWhenUserOperationFinish:) name:kNotificationPostFeedResultNotification object:nil];
    }
    
}

-(BOOL) isPrivateLetterItemShow
{
    NSString* curUserUID = self.user.uid;
    NSString* longUserUID = [UMComSession sharedInstance].loginUser.uid;
    
    //判断当前用户和自己进入个人中心的用户是否是一个人，如果是就不显示
    if (curUserUID && longUserUID && [longUserUID isEqualToString:curUserUID]) {
        return NO;
    }
    
    int curUserType = 0;
    int loginUserType = 0;
    curUserType  = self.user.atype.intValue;
    loginUserType = [UMComSession sharedInstance].loginUser.atype.intValue;
    
    if (curUserType == 1 || curUserType == 3 || loginUserType == 3 || loginUserType == 1) {
        return YES;
    }
    return NO;
}

//点击私信管理
- (void)clickOnPrivateLetter
{
    __weak typeof(self) weakSelf = self;
    [UMComLoginManager performLogin:self completion:^(id responseObject, NSError *error) {
        if (!error) {
            UMComPrivateChatTableViewController *chatTableViewController = [[UMComPrivateChatTableViewController alloc]initWithUser:weakSelf.user];
            [weakSelf.navigationController pushViewController:chatTableViewController animated:YES];
        }
    }];
}

- (void)showMoreOperationMenuView
{
    [UMComLoginManager performLogin:self completion:^(id responseObject, NSError *error) {
        if (!error) {
            UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:UMComLocalizedString(@"um_com_cancel", @"取消") destructiveButtonTitle:nil otherButtonTitles:UMComLocalizedString(@"um_com_report", @"举报"), nil];
            [actionSheet showInView:self.view];
        }
    }];
}

#pragma mark - UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    __weak typeof(self) weakSelf = self;
    if ([[actionSheet buttonTitleAtIndex:buttonIndex] isEqualToString:UMComLocalizedString(@"um_com_report", @"举报")]) {
        [UMComLoginManager performLogin:self completion:^(id responseObject, NSError *error) {
            if (!error) {
                [weakSelf.userDataController spamUserCompletion:^(id responseObject, NSError *error) {
                    [UMComShowToast spamUser:error];
                }];
            }
        }];
    }
}

#pragma mark - created subviews method
- (void)creatNavigationItemList
{
    if (![self.user.uid isEqualToString:[UMComSession sharedInstance].uid]) {
        self.privateLetterItem = [[UMComBarButtonItem alloc] initWithNormalImageName:@"um_forum_user_privateletter" target:self action:@selector(clickOnPrivateLetter)];
        self.privateLetterItem.customButtonView.frame = CGRectMake(0, 0, 20, 20);
        self.privateLetterItem.customButtonView.titleLabel.font = UMComFontNotoSansLightWithSafeSize(17);
        UMComBarButtonItem *rightButtonItem = nil;
        if ([self.user.uid isEqualToString:[UMComSession sharedInstance].uid]|| [self.user.atype intValue] == 3) {
            rightButtonItem = [[UMComBarButtonItem alloc] init];
            rightButtonItem.customButtonView.frame = CGRectMake(0, 12, 10, 4);
        }else{
            rightButtonItem = [[UMComBarButtonItem alloc] initWithNormalImageName:@"um_forum_more_gray" target:self action:@selector(showMoreOperationMenuView)];
            rightButtonItem.customButtonView.frame = CGRectMake(0, 12, 20, 4);
        }
        rightButtonItem.customButtonView.titleLabel.font = UMComFontNotoSansLightWithSafeSize(17);
        UIBarButtonItem *spaceItem = [[UIBarButtonItem alloc]init];
        UIView *spaceView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 8, 20)];
        spaceView.backgroundColor = [UIColor clearColor];
        [spaceItem setCustomView:spaceView];
        UMComBarButtonItem *rightSpaceItem = [[UMComBarButtonItem alloc] init];
        rightSpaceItem.customButtonView.frame = CGRectMake(0, 12, 20, 4);
        rightSpaceItem.customButtonView.titleLabel.font = UMComFontNotoSansLightWithSafeSize(17);
        [self.navigationItem setRightBarButtonItems:@[rightButtonItem,spaceItem,self.privateLetterItem]];
        
        //判断私信按钮是否显示
        if ([self isPrivateLetterItemShow]) {
            self.privateLetterItem.customButtonView.hidden = NO;
        }
        else{
            self.privateLetterItem.customButtonView.hidden = YES;
        }
    }
}

//创建个人信息详情页
- (void)creatDetailView
{
    CGFloat UserProfileDetailViewHeight = 220;
    UMComMedal *medal = self.user.medal_list.firstObject;
    if (medal.icon_url) {
        UserProfileDetailViewHeight += 30;
    }
    self.detailView = [[UMComUserProfileDetailView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, UserProfileDetailViewHeight) user:self.user];
    self.detailView.deleagte = self;
    [self.view addSubview:self.detailView];
}

//创建子ViewControllers
- (void)creatChildViewControllers
{
    CGRect frame = self.view.frame;
    frame.origin.y = self.detailView.frame.size.height;
    frame.size.height = self.view.frame.size.height - frame.origin.y;
    UMComFeedTableViewController *postTableViewController = [[UMComFeedTableViewController alloc] init];
    UMComFeedTimeLineDataController*  feedListOfTimeLineController =  [[UMComFeedTimeLineDataController alloc] initWithCount:UMCom_Limit_Page_Count userID:self.user.uid timeLineFeedListType:UMComUserTimeLineFeedType_Default];
//    feedListOfTimeLineController.isReadLoacalData = YES;
//    feedListOfTimeLineController.isSaveLoacalData = YES;
    postTableViewController.dataController = feedListOfTimeLineController;
    postTableViewController.isShowEditButton = YES;
    postTableViewController.view.frame = frame;
    [self.view addSubview:postTableViewController.view];
    [self addChildViewController:postTableViewController];
    postTableViewController.scrollViewDelegate = self;

    UMComUserTableViewController *followersTableViewController = [[UMComUserTableViewController alloc] init];
    UMComUserFollowingDataController* userFollowingDataController =  [[UMComUserFollowingDataController alloc] initWithCount:UMCom_Limit_Page_Count];
    userFollowingDataController.user = self.user;
//    userFollowingDataController.isReadLoacalData = YES;
//    userFollowingDataController.isSaveLoacalData = YES;
    followersTableViewController.dataController = userFollowingDataController;
    self.userOperationFinishDelegate = followersTableViewController.userOperationFinishDelegate;

    __weak typeof(self) weakSelf = self;

    followersTableViewController.callbackBlock = ^(UMComUserTableViewController *controller, UMComUserTableViewCallBackEvent event, UMComUser *user) {
        if (![weakSelf.user.uid isEqualToString:user.uid]) {
            UMComUserCenterViewController *vc = [[UMComUserCenterViewController alloc] initWithUser:user];
            [controller.navigationController pushViewController:vc animated:YES];
        }
    };
    followersTableViewController.userOperationFinishDelegate = self;
    followersTableViewController.view.frame = frame;
    [self addChildViewController:followersTableViewController];
    followersTableViewController.scrollViewDelegate = self;
    
    UMComUserTableViewController *fanTableViewController = [[UMComUserTableViewController alloc] init];
    UMComUserFansDataController* userFansDataController = [UMComUserFansDataController userFansDataControllerWithUser:self.user count:UMCom_Limit_Page_Count];
//    userFansDataController.isReadLoacalData = YES;
//    userFansDataController.isSaveLoacalData = YES;
    fanTableViewController.dataController = userFansDataController;
    self.userOperationFinishDelegate = fanTableViewController.userOperationFinishDelegate;

    fanTableViewController.callbackBlock = ^(UMComUserTableViewController *controller, UMComUserTableViewCallBackEvent event, UMComUser *user) {
        if (![weakSelf.user.uid isEqualToString:user.uid]) {
            UMComUserCenterViewController *vc = [[UMComUserCenterViewController alloc] initWithUser:user];
            [controller.navigationController pushViewController:vc animated:YES];
        }
    };
    fanTableViewController.view.frame = frame;
    [self addChildViewController:fanTableViewController];
    self.lastViewController = fanTableViewController;
    fanTableViewController.userOperationFinishDelegate = self;
    fanTableViewController.scrollViewDelegate = self;
    [self userProfileDetailView:self.detailView clickAtIndex:0];
}


#pragma mark - UserDetailViewDelgate
//点击关注按钮
- (void)userProfileDetailView:(UMComUserProfileDetailView *)userProfileDetailView clickOnfocuse:(UIButton *)focuseButton
{
    __weak typeof(self) weakSelf = self;
    [UMComLoginManager performLogin:self completion:^(id responseObject, NSError *error) {
        if (!error) {
            [weakSelf.userDataController followOrDisFollowUserCompletion:^(id responseObject, NSError *error) {
                UMComUserTableViewController *userTableViewController = nil;
                if ([weakSelf.user.uid isEqualToString:[UMComSession sharedInstance].uid]) {
                    userTableViewController = weakSelf.childViewControllers[1];
                }else{
                    userTableViewController = weakSelf.childViewControllers[2];
                }
                UMComUser *user = [UMComSession sharedInstance].loginUser;
                if (error) {
                    if (error.code == ERR_CODE_USER_HAVE_FOLLOWED) {
                        [userTableViewController insertUserToTableView:user];
                    }
                    [UMComShowToast showFetchResultTipWithError:error];
                }else{
                    if ([weakSelf.user.relation integerValue] == 1 || [weakSelf.user.relation integerValue] == 3) {
                        [userTableViewController insertUserToTableView:user];
                    }else{
                        [userTableViewController deleteUserFromTableView:user];
                    }
                }
                if (!error ||  error.code == ERR_CODE_USER_HAVE_FOLLOWED) {
                    if (weakSelf.userOperationFinishDelegate && [weakSelf.userOperationFinishDelegate respondsToSelector:@selector(focusedUserOperationFinish:)]) {
                        [weakSelf.userOperationFinishDelegate focusedUserOperationFinish:weakSelf.user];
                    }
                }
                [weakSelf.detailView reloadSubViewsWithUser:weakSelf.user];
            }];
            
        }
    }];
}



//点击相册按钮
- (void)userProfileDetailView:(UMComUserProfileDetailView *)userProfileDetailView clickOnAlbum:(UIButton *)albumButton
{
    UMComPhotoAlbumViewController *photoAlbumVc = [[UMComPhotoAlbumViewController alloc]init];
    photoAlbumVc.user = self.user;
    [self.navigationController pushViewController:photoAlbumVc animated:YES];
}

//点击关注的话题的按钮
- (void)userProfileDetailView:(UMComUserProfileDetailView *)userProfileDetailView clickOnFollowTopic:(UIButton *)topicButton
{
    UMComTopicsTableViewController *topicViewController = [[UMComTopicsTableViewController alloc]init];
    topicViewController.isAutoStartLoadData = YES;
    UMComTopicsFocusDataController* topicsFocusDataController = [[UMComTopicsFocusDataController alloc] initWithCount:UMCom_Limit_Page_Count withUID:self.user.uid];
    
    if ([self.user.uid isEqualToString:[UMComSession sharedInstance].uid]) {
        topicsFocusDataController.isReadLoacalData = YES;
        topicsFocusDataController.isSaveLoacalData = YES;
    }

    topicViewController.dataController = topicsFocusDataController;
    [self.navigationController pushViewController:topicViewController animated:YES];
}

- (void)userProfileDetailView:(UMComUserProfileDetailView *)userProfileDetailView clickAtIndex:(NSInteger)index
{
    [self transitionFromViewControllerAtIndex:self.detailView.lastIndex toViewControllerAtIndex:index animations:nil completion:nil];
}


#pragma mark - getData

- (void)getCurrentUserRequest
{
    __weak typeof(self) weakSelf = self;
    [self.userDataController fetchUserProfileCompletion:^(id responseObject, NSError *error) {
        if (!error) {
            if ([responseObject isKindOfClass:[UMComUser class]]) {
                UMComUser *user = (UMComUser*)responseObject;
                weakSelf.user = user;
                [weakSelf.detailView reloadSubViewsWithUser:user];
            }
            else
            {
                NSLog(@"the responseObject is not a user class Type");
            }
        }
        else{
            [UMComShowToast showFetchResultTipWithError:error];
        }
            
    }];
}

#pragma mark - UMComUserOperationFinishDelegate
- (void)reloadDataWhenUserOperationFinish:(UMComUser *)user
{
    for (int index = 1; index < 2; index ++) {
        UMComUserTableViewController *usertableVc = self.childViewControllers[index];
        [usertableVc.tableView reloadData];
    }
    [self.detailView reloadSubViewsWithUser:self.user];
}

- (void)focusedUserOperationFinish:(UMComUser *)user
{
    for (int index = 1; index < 2; index ++) {
        UMComUserTableViewController *usertableVc = self.childViewControllers[index];
        if ([self.user.uid isEqualToString:[UMComSession sharedInstance].uid] && index == 1) {
            if ([user.relation integerValue] == 1 || [user.relation integerValue] == 3) {
                [usertableVc insertUserToTableView:user];
            }else{
                [usertableVc deleteUserFromTableView:user];
            }
        }
        [usertableVc.tableView reloadData];
    }
    [self.detailView reloadSubViewsWithUser:self.user];
}


- (void)scrollViewDidScrollWithScrollView:(UIScrollView *)scrollView lastPosition:(CGPoint)lastPosition
{
    if (scrollView.contentOffset.y >0 && scrollView.contentOffset.y > lastPosition.y+20) {
        [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
            [self subViewControllersScrollToTop:scrollView];
        } completion:nil];
    }else{
        if (scrollView.contentOffset.y < lastPosition.y-10) {
            [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
                [self subViewControllersScrollToBottom:scrollView];

            } completion:^(BOOL finished) {
                if (self.detailView.frame.origin.y < 0 && scrollView.contentOffset.y <= 0) {
                    for (UMComRequestTableViewController *viewController in self.childViewControllers) {
                        CGRect frame = viewController.view.frame;
                        CGRect headFrame = self.detailView.frame;
                        headFrame.origin.y = 0;
                        self.detailView.frame = headFrame;
                        frame.origin.y = self.detailView.frame.size.height;
                        frame.size.height = self.view.frame.size.height - frame.origin.y;
                        viewController.view.frame = frame;
                        if (viewController.tableView.contentSize.height < frame.size.height) {
                            viewController.tableView.contentSize = CGSizeMake(viewController.tableView.contentSize.width, frame.size.height +1);
                        }
                    }
                }
            }];
        }
    }
}


- (void)subViewControllersScrollToTop:(UIScrollView *)scrollView
{
    if (self.detailView.frame.origin.y == 0 && scrollView.contentOffset.y >= 0) {
        for (UMComRequestTableViewController *viewController in self.childViewControllers) {
            CGRect frame = viewController.view.frame;
            CGRect headFrame = self.detailView.frame;
            headFrame.origin.y = - self.detailView.frame.size.height + 48;
            self.detailView.frame = headFrame;
            frame.origin.y = 48;
            frame.size.height = self.view.frame.size.height - frame.origin.y;
            viewController.view.frame = frame;
            if (viewController.tableView.contentSize.height < frame.size.height) {
                viewController.tableView.contentSize = CGSizeMake(viewController.tableView.contentSize.width, frame.size.height +1);
            }
        }
    }
}

- (void)subViewControllersScrollToBottom:(UIScrollView *)scrollView
{
    if (self.detailView.frame.origin.y < 0 && scrollView.contentOffset.y <= 0) {
        for (UMComRequestTableViewController *viewController in self.childViewControllers) {
            CGRect frame = viewController.view.frame;
            CGRect headFrame = self.detailView.frame;
            headFrame.origin.y = 0;
            self.detailView.frame = headFrame;
            frame.origin.y = self.detailView.frame.size.height;
            viewController.view.frame = frame;
        }
    }
}

#pragma mark - UMComScrollViewDelegate
- (void)customScrollViewDidScroll:(UIScrollView *)scrollView lastPosition:(CGPoint)lastPosition
{
    [self scrollViewDidScrollWithScrollView:scrollView lastPosition:lastPosition];
}

- (void)customScrollViewDidEnd:(UIScrollView *)scrollView lastPosition:(CGPoint)lastPosition
{
    [self scrollViewDidScrollWithScrollView:scrollView lastPosition:lastPosition];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end

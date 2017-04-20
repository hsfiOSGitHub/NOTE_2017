//
//  UMComOneFeedViewController.m
//  UMCommunity
//
//  Created by Gavin Ye on 9/12/14.
//  Copyright (c) 2014 Umeng. All rights reserved.
//

#import "UMComTopicFeedViewController.h"
#import <UMComDataStorage/UMComTopic.h>
#import "UMComLoginManager.h"
#import <UMCommunitySDK/UMComSession.h>
#import <UMComDataStorage/UMComUser.h>
#import "UMComShowToast.h"
#import "UIViewController+UMComAddition.h"
#import "UMComNavigationController.h"
#import "UMComHorizonCollectionView.h"
#import <UMComDataStorage/UMComFeed.h>
#import "UMComFeedTableViewController.h"
#import "UMComUserTableViewController.h"
#import "UMComUserCenterViewController.h"
#import "UMComHotFeedMenuViewController.h"
#import "UMComBarButtonItem.h"
#import "UMComFeedWithTopicTableViewController.h"
#import "UMComFeedListDataController.h"
#import "UMComUserListDataController.h"
#import "UMComTopicListDataController.h"
#import "UMComTopicDataController.h"
#import <UMComFoundation/UMComKit+Color.h>

@interface UMComTopicFeedViewController ()<UMComHorizonCollectionViewDelegate>

@property (nonatomic, strong) UMComHorizonCollectionView *menuControlView;

@property (nonatomic, strong) UMComTopicDataController *topicDataController;


@end

@implementation UMComTopicFeedViewController

-(id)initWithTopic:(UMComTopic *)topic
{
    self = [super init];
    if (self) {
        self.topic = topic;
        self.topicDataController = [UMComTopicDataController dataControllerWithTopic:topic];
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
    if (!self.menuControlView) {
        [self createMenuControlView];
        [self creatChildViewControllers];
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];

}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UMComRGBColor(245, 246, 250);

    [self setTitleViewWithTitle:[NSString stringWithFormat:TopicString,self.topic.name]];
    if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)]) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    [self creatNavigationItemList];
}

//创建子ViewControllers
- (void)creatChildViewControllers
{
    CGRect frame = self.view.frame;
    frame.origin.y = self.menuControlView .frame.size.height + UMCom_Micro_Feed_Cell_Space;
    frame.size.height = self.view.frame.size.height - frame.origin.y;

    UMComFeedTableViewController*lastPublicTableViewController = [[UMComFeedWithTopicLatestFeedTableViewController alloc] initWithTopic:self.topic];

    UMComTopicFeedDataController*  lastPublicTopicFeedDataController = [UMComTopicFeedDataController fetchFeedsTopicRelatedWithTopicId:self.topic.topicID sortType:UMComTopicFeedSortType_default isReverse:NO count:UMCom_Limit_Page_Count];
    lastPublicTableViewController.dataController = lastPublicTopicFeedDataController;
    
    lastPublicTableViewController.isShowEditButton = YES;
    lastPublicTableViewController.view.frame = frame;
    lastPublicTableViewController.feedCellBgViewTopEdge = 0;
    
    UMComTopTopicFeedListDataController* topTopicFeedListDataController = [[UMComTopTopicFeedListDataController alloc] initWithCount:UMCom_Limit_Page_Count];
    topTopicFeedListDataController.topicID = self.topic.topicID;
    lastPublicTopicFeedDataController.topFeedListDataController = topTopicFeedListDataController;
    
    //添加置顶类---end
    [self addChildViewController:lastPublicTableViewController];
    [self.view addSubview:lastPublicTableViewController.view];

    UMComFeedTableViewController *lastReplyTableViewController = [[UMComFeedWithTopicTableViewController alloc] initWithTopic:self.topic];

    UMComTopicFeedDataController*  lastReplyTopicFeedDataController = [UMComTopicFeedDataController fetchFeedsTopicRelatedWithTopicId:self.topic.topicID sortType:UMComTopicFeedSortType_Comment isReverse:YES count:UMCom_Limit_Page_Count];
    lastReplyTableViewController.dataController = lastReplyTopicFeedDataController;
    
    lastReplyTableViewController.isShowEditButton = YES;
    lastReplyTableViewController.feedCellBgViewTopEdge = 0;
    lastReplyTableViewController.view.frame = frame;
    [self addChildViewController:lastReplyTableViewController];
    
    
    UMComFeedTableViewController *recommendTableViewController = [[UMComFeedWithTopicTableViewController alloc] initWithTopic:self.topic];
    
    UMComFeedTopicRecommendDataController* feedListOfTopicRecommendController =  [[UMComFeedTopicRecommendDataController alloc] initWithCount:UMCom_Limit_Page_Count topicId:self.topic.topicID];
    recommendTableViewController.dataController = feedListOfTopicRecommendController;
    recommendTableViewController.isShowEditButton = YES;
    recommendTableViewController.feedCellBgViewTopEdge = 0;
    recommendTableViewController.view.frame = frame;
    [self addChildViewController:recommendTableViewController];
    
    UMComHotFeedMenuViewController *topicFeedTableViewController = [[UMComHotFeedMenuViewController alloc]initWithTopic:self.topic];
    topicFeedTableViewController.view.frame = frame;
    [self addChildViewController:topicFeedTableViewController];
    
    UMComUserTableViewController *followersTableViewController = [[UMComUserTableViewController alloc] init];
    UMComUserTopicHotDataController* userTopicHotDataController =  [[UMComUserTopicHotDataController alloc] init];
    userTopicHotDataController.topic = self.topic;
    followersTableViewController.dataController = userTopicHotDataController;
    
    followersTableViewController.callbackBlock = ^(UMComUserTableViewController *controller, UMComUserTableViewCallBackEvent event, UMComUser *user) {
        UMComUserCenterViewController *vc = [[UMComUserCenterViewController alloc] initWithUser:user];
        vc.userOperationFinishDelegate = controller.userOperationFinishDelegate;
        [controller.navigationController pushViewController:vc animated:YES];
    };
    
    followersTableViewController.view.frame = frame;
    [self addChildViewController:followersTableViewController];
    [self transitionSubViewControllers];
}


- (void)createMenuControlView
{
    UMComHorizonCollectionView *menuControlView = [[UMComHorizonCollectionView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 49) itemCount:5];
    menuControlView.bottomLineHeight = 1;
    menuControlView.topLine.backgroundColor = UMComColorWithHexString(@"#EEEFF3");
    menuControlView.bottomLine.backgroundColor = UMComColorWithHexString(@"#EEEFF3");
    menuControlView.itemSpace = 1;
    menuControlView.backgroundColor = UMComTableViewSeparatorColor;
    menuControlView.cellDelegate = self;
    [self.view addSubview:menuControlView];
    self.menuControlView = menuControlView;
}


- (void)creatNavigationItemList
{
    UMComBarButtonItem *topicFocusedButton = nil;
    if ([[self.topic is_focused] boolValue]) {
        topicFocusedButton = [[UMComBarButtonItem alloc] initWithNormalImageName:@"um_forum_topic_focused" target:self action:@selector(followTopic:)];;
    }else{
        topicFocusedButton = [[UMComBarButtonItem alloc] initWithNormalImageName:@"um_forum_topic_nofocused" target:self action:@selector(followTopic:)];
    }
    topicFocusedButton.customButtonView.frame = CGRectMake(0, 0, 20, 20);
    topicFocusedButton.customButtonView.titleLabel.font = UMComFontNotoSansLightWithSafeSize(17);
    [self.navigationItem setRightBarButtonItem:topicFocusedButton];
}


- (void)followTopic:(UIButton *)sender
{
    __weak typeof(self) weakSelf = self;
    [UMComLoginManager performLogin:self completion:^(id responseObject, NSError *error) {
        if (!error) {
            [weakSelf.topicDataController followOrDisfollowCompletion:^(id responseObject, NSError *error) {
                if ([weakSelf.topicDataController.topic.is_focused boolValue]) {
                    [sender setBackgroundImage:UMComImageWithImageName(@"um_forum_topic_focused") forState:UIControlStateNormal];
                }else{
                    [sender setBackgroundImage:UMComImageWithImageName(@"um_forum_topic_nofocused") forState:UIControlStateNormal];
                }
                [UMComShowToast showFetchResultTipWithError:error];
            }];
        }
    }];
}



#pragma mark - UMComHorizonCollectionViewDelegate
- (NSInteger)numberOfRowInHorizonCollectionView:(UMComHorizonCollectionView *)collectionView
{
    return 5;
}

- (void)horizonCollectionView:(UMComHorizonCollectionView *)collectionView reloadCell:(UMComHorizonCollectionCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    NSString *title = nil;
    if (indexPath.row == 0) {
        title = UMComLocalizedString(@"um_com_topic_latest_post", @"最新发布");
    }else if (indexPath.row == 1){
        title = UMComLocalizedString(@"um_com_topic_latest_reply", @"最后回复");
    }else if (indexPath.row == 2){
        title = UMComLocalizedString(@"um_com_recommend", @"推荐");
    }else if (indexPath.row == 3){
        title = UMComLocalizedString(@"um_com_topic_hot", @"最热");
    }else if (indexPath.row == 4){
        title = UMComLocalizedString(@"um_com_topic_related_user", @"活跃用户");
    }
    if (indexPath.row == collectionView.currentIndex) {
        cell.label.textColor = UMComColorWithHexString(FontColorBlue);
    }else{
        cell.label.textColor = [UIColor blackColor];
    }
    cell.label.text = title;
}

- (void)horizonCollectionView:(UMComHorizonCollectionView *)collectionView didSelectedColumn:(NSInteger)column
{
    [self transitionSubViewControllers];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


- (void)transitionSubViewControllers
{
    [self transitionFromViewControllerAtIndex:self.menuControlView.lastIndex toViewControllerAtIndex:self.menuControlView.currentIndex animations:nil completion:nil];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

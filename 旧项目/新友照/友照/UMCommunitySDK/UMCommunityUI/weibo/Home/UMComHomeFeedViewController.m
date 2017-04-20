//
//  UMComHomeFeedViewController.m
//  UMCommunity
//
//  Created by umeng on 15-4-2.
//  Copyright (c) 2015年 Umeng. All rights reserved.
//

#import "UMComHomeFeedViewController.h"
#import "UMComNavigationController.h"
#import "UMComSearchBar.h"
#import "UMComLoginManager.h"
#import "UMComSearchViewController.h"
#import "UIViewController+UMComAddition.h"
#import "UMComBarButtonItem.h"
#import "UMComFindViewController.h"
#import <UMCommunitySDK/UMComSession.h>
#import "UMComLoginManager.h"
#import "UMComTopicFeedViewController.h"
#import "UMComShowToast.h"
#import <UMComDataStorage/UMComUnReadNoticeModel.h>
#import <UMComDataStorage/UMComFeed.h>
#import "UMComFeedTableViewController.h"
#import "UMComTopicsTableViewController.h"
#import "UMComHotFeedMenuViewController.h"
#import "UMComMicroTopicSearchViewController.h"
#import "UMComHorizonCollectionView.h"
#import "UMComFocusFeedTableViewController.h"
#import "UMComSegmentedControl.h"
#import "UMComFeedListDataController.h"
#import "UMComTopicListDataController.h"
#import <UMComFoundation/UMComKit+Color.h>
#import "UMComNotificationMacro.h"

#define kTagRecommend 100
#define kTagAll 101

#define DeltaBottom  45
#define DeltaRight 45

//#define  USING_SearchBarInTableviewHeader //searchbar是否在tableview的header中，还是和以前一样保持一个searchbar

@interface UMComHomeFeedViewController ()<UISearchBarDelegate, UMComHorizonCollectionViewDelegate>


@property (strong, nonatomic) UMComSearchBar *searchBar;

@property (nonatomic, strong) UMComHorizonCollectionView *menuView;

@property (nonatomic, strong) UIButton *findButton;

@property (nonatomic, strong) UIView *itemNoticeView;

@property (nonatomic, assign) CGFloat searchBarOriginY;

@property (nonatomic, strong) UISegmentedControl *segmentControl;

-(UMComSearchBar*) createSearchBarWithPlaceholder:(NSString*)placeholder;

@end

@implementation UMComHomeFeedViewController
{
    BOOL  isTransitionFinish;
    CGPoint originOffset;
}


- (void)viewDidLoad {
    
    [super viewDidLoad];
    [UMComResourceManager setResourceType:UMComResourceType_WeiBo];

    self.view.backgroundColor = UMComRGBColor(245, 246, 250);
//    UIViewController *rootViewController = [UIApplication sharedApplication].keyWindow.rootViewController;
    //    如果当前NavigationViewController是跟视图， 则不需要显示返回按钮
//  /  if ((rootViewController == self.navigationController && rootViewController.childViewControllers.count == 1) || rootViewController == self) {
        self.navigationItem.leftBarButtonItem = nil;
//    }else{
//        [self setForumUIBackButton];
//    }
    //创建导航条视图
    [self creatNigationItemView];

    //创建serchBar
    //屏蔽2.3版本前,只创建一个searbar,主页每个tableview都挂着一个searchbar
    //搜索框
//    [self creatSearchBar];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(refreshAllDataWhenLoginUserChange:) name:kUserLoginSucceedNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(refreshAllDataWhenUserLogout:) name:kUserLogoutSucceedNotification object:nil];
    
    //当删除自己的Feed时更新关注列表
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateMyDataWhenDeletedFeed:) name:kUMComFeedDeletedFinishNotification object:nil];
    //当创建新Feed时通知关注页面刷新
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addNewFeedWhenCreatSucceed:) name:kNotificationPostFeedResultNotification object:nil];
    [self.view bringSubviewToFront:self.searchBar];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshUnreadMessageNotification) name:kUMComUnreadNotificationRefreshNotification object:nil];
    
    [self createSubControllers];
    [[UMComDataRequestManager defaultManager] updateTemplateChoice:0 completion:nil];
    //注册通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(Login:) name:@"Login" object:nil];
}
-(void)Login:(NSNotification *)noti{
    ZX_Login_ViewController *VC = [[ZX_Login_ViewController alloc] init];
    UINavigationController *navi = [[UINavigationController alloc]initWithRootViewController:VC];
    [self presentViewController:navi animated:YES completion:nil];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    isTransitionFinish = YES;
    originOffset = self.navigationController.navigationBar.frame.origin;
    self.findButton.center = CGPointMake(self.view.frame.size.width-27, self.findButton.center.y);
    self.findButton.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleTopMargin;
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:0.3 animations:^{
        weakSelf.findButton.alpha = 1;
    }];
    [self.navigationController.navigationBar addSubview:self.menuView];
    [self refreshUnreadMessageNotification];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshMessageData:) name:UIApplicationWillEnterForegroundNotification object:nil];
    
    self.findButton.hidden = NO;
}


- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self hidenKeyBoard];
    self.findButton.alpha = 0;
    [self.menuView removeFromSuperview];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationWillEnterForegroundNotification object:nil];
    
    self.findButton.hidden = YES;
}

-(void) resetFrameForChildViewControllers
{
    NSArray *childViewControllers = self.childViewControllers;
    if (childViewControllers && childViewControllers.count > 0) {
        CGRect viewFrame =  self.view.frame;
        for (int i = 0; i < childViewControllers.count > 0; i++) {
            UIViewController*  childViewController = self.childViewControllers[i];
            if (childViewController) {
                CGRect childViewControllerRC =  childViewController.view.frame;
                childViewControllerRC.size.height = viewFrame.size.height - self.searchBar.frame.size.height;
                if ([childViewController isKindOfClass:[UMComHotFeedMenuViewController class]]) {
                    childViewControllerRC.size.height -= 27;//27为segmentedControl的高度
                }
                childViewController.view.frame = childViewControllerRC;
            }
        }
    }
}

-(void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self resetFrameForChildViewControllers];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    self.searchBar = nil;
    self.findButton = nil;
    self.itemNoticeView = nil;
    self.menuView = nil;
}

#pragma mark - 



#pragma mark - privite methods
/************************************************************************************/
- (void)createSubControllers
{
    UMComSegmentedControl *segmentedControl = [[UMComSegmentedControl alloc]initWithItems:[NSArray arrayWithObjects:@"1天内",@"3天内",@"7天内",@"30天内", nil]];
    segmentedControl.frame = CGRectMake(40, 8, self.view.frame.size.width - 80, 27);
    [segmentedControl addTarget:self action:@selector(didSelectedHotFeedAtIndex:) forControlEvents:UIControlEventValueChanged];
    segmentedControl.tintColor = UMComColorWithHexString(@"#008BEA");
    segmentedControl.hidden = YES;
    segmentedControl.selectedSegmentIndex = 3;
    [segmentedControl setfont:UMComFontNotoSansLightWithSafeSize(14) titleColor:UMComColorWithHexString(@"#008BEA") selectedColor:[UIColor whiteColor]];
    self.segmentControl = segmentedControl;
    [self.view addSubview:segmentedControl];
   
    CGRect commonFrame = self.view.frame;
    commonFrame.origin.y = self.searchBar.frame.size.height;
    commonFrame.size.height = commonFrame.size.height - commonFrame.origin.y;
    
    UMComHotFeedMenuViewController *hotMenuVc = [[UMComHotFeedMenuViewController alloc]init];
    hotMenuVc.view.frame = commonFrame;
    hotMenuVc.page = segmentedControl.selectedSegmentIndex;
    [self addChildViewController:hotMenuVc];
    [self.view addSubview:hotMenuVc.view];

    UMComFeedTableViewController *recommendPostListController = [[UMComFeedTableViewController alloc] init];
    UMComFeedRecommendDataController* feedListOfRecommendController = [[UMComFeedRecommendDataController alloc] initWithCount:UMCom_Limit_Page_Count];
    feedListOfRecommendController.isReadLoacalData = YES;
    feedListOfRecommendController.isSaveLoacalData = YES;
    recommendPostListController.dataController = feedListOfRecommendController;
    [self addChildViewController:recommendPostListController];
    //添加置顶类---begin
    feedListOfRecommendController.topFeedListDataController = [[UMComGlobalTopFeedListDataController alloc] init];
    recommendPostListController.topFeedType = UMComTopFeedType_GloalTopFeed;
    //添加置顶类---end
    recommendPostListController.isShowEditButton = YES;
    recommendPostListController.feedCellBgViewTopEdge = 0;
    recommendPostListController.view.frame = commonFrame;

    
    UMComFocusFeedTableViewController *focusedListController = [[UMComFocusFeedTableViewController alloc] init];
    focusedListController.isShowEditButton = YES;
    focusedListController.feedCellBgViewTopEdge = 0;
    [self addChildViewController:focusedListController];
    focusedListController.view.frame = commonFrame;
    
    __weak typeof(self) weakSelf = self;
    focusedListController.refreshSeverDataCompletionHandler = ^(NSArray *data, NSError *error)
    {
        if (!error) {
            [weakSelf showTipLableFromTopWithTitle:@"数据已更新"];
        }
    };
    
    UMComTopicsTableViewController *followingPostListController = [[UMComTopicsTableViewController alloc] init];
    UMComTopicsAllDataController* allTopicDataController = [[UMComTopicsAllDataController alloc] initWithCount:UMCom_Limit_Page_Count];
    followingPostListController.dataController = allTopicDataController;
    followingPostListController.dataController.isReadLoacalData = YES;
    followingPostListController.dataController.isSaveLoacalData = YES;
    [self addChildViewController:followingPostListController];
    followingPostListController.view.frame = commonFrame;
    
    [self transitionViewControllers];
}

- (void)creatSearchBar
{
    UMComSearchBar *searchBar = [[UMComSearchBar alloc] initWithFrame:CGRectMake(-2.5, 0, self.view.frame.size.width+5, 44)];
    searchBar.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    searchBar.placeholder = UMComLocalizedString(@"um_com_searchUserAndContent", @"搜索用户和内容");
    searchBar.backgroundColor = UMComColorWithHexString(@"#F5F6FA");
    searchBar.delegate = self;
    [self.view addSubview:searchBar];
    self.searchBar = searchBar;
}

- (void)hidenKeyBoard
{
    [self.searchBar resignFirstResponder];
}

- (void)creatNigationItemView
{
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    rightButton.frame = CGRectMake(self.view.frame.size.width-27, self.navigationController.navigationBar.frame.size.height/2-22, 44, 44);
    CGFloat delta = 9;
    rightButton.imageEdgeInsets =  UIEdgeInsetsMake(delta, delta, delta, delta);
    [rightButton setImage:UMComImageWithImageName(@"find+") forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(onClickFind:) forControlEvents:UIControlEventTouchUpInside];
//    [self.navigationController.navigationBar addSubview:rightButton];
    self.findButton = rightButton;
    
    self.itemNoticeView = [self creatNoticeViewWithOriginX:rightButton.frame.size.width-10];
    [self.findButton addSubview:self.itemNoticeView];
//    [self refreshMessageData:nil];
    //创建菜单栏
    UMComHorizonCollectionView *collectionMenuView = [[UMComHorizonCollectionView alloc]initWithFrame:CGRectMake(40, 0, self.view.frame.size.width - 80, 44) itemCount:4];
    collectionMenuView.cellDelegate = self;
    collectionMenuView.indicatorLineHeight = 2;
    collectionMenuView.indicatorLineWidth = UMComWidthScaleBetweenCurentScreenAndiPhone6Screen(35.f);
    collectionMenuView.scrollIndicatorView.backgroundColor = UMComColorWithHexString(FontColorBlue);
    collectionMenuView.backgroundColor = [UIColor clearColor];
    [self.navigationController.navigationBar addSubview:collectionMenuView];
    self.menuView = collectionMenuView;
}

- (void)horizonCollectionView:(UMComHorizonCollectionView *)collectionView reloadCell:(UMComHorizonCollectionCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    CGRect labelFrame = cell.label.frame;
    cell.label.textAlignment = NSTextAlignmentLeft;
    if (indexPath.row == 0) {
        cell.label.text = UMComLocalizedString(@"um_com_hot",@"热门");
    }else if (indexPath.row == 1){
        cell.label.text = UMComLocalizedString(@"um_com_recommend",@"推荐");
    }else if (indexPath.row == 2){
        cell.label.text = UMComLocalizedString(@"um_com_following", @"关注");
    }else if (indexPath.row == 3){
        cell.label.text = UMComLocalizedString(@"um_com_topic",@"话题");
    }
    if (indexPath.row == collectionView.currentIndex) {
        cell.label.textColor = UMComColorWithHexString(@"#178DE7");
    }else{
        cell.label.textColor = UMComColorWithHexString(@"#999999");
    }
    cell.label.font = UMComFontNotoSansLightWithSafeSize(18);
    cell.contentView.backgroundColor = [UIColor clearColor];
    cell.label.frame = labelFrame;
    cell.label.textAlignment = NSTextAlignmentCenter;
}


- (NSInteger)numberOfRowInHorizonCollectionView:(UMComHorizonCollectionView *)collectionView
{
    return 4;
}

- (void)horizonCollectionView:(UMComHorizonCollectionView *)collectionView didSelectedColumn:(NSInteger)column
{
    [self transitionViewControllers];
}

- (UIView *)creatNoticeViewWithOriginX:(CGFloat)originX
{
    CGFloat noticeViewWidth = 8;
    UIView *itemNoticeView = [[UIView alloc]initWithFrame:CGRectMake(originX,5, noticeViewWidth, noticeViewWidth)];
    itemNoticeView.backgroundColor = [UIColor redColor];
    itemNoticeView.layer.cornerRadius = noticeViewWidth/2;
    itemNoticeView.clipsToBounds = YES;
    itemNoticeView.hidden = YES;
    return itemNoticeView;
}


#pragma mark - 
- (void)updateMyDataWhenDeletedFeed:(NSNotification *)notification
{
    UMComFeedTableViewController *feedTableVc = self.childViewControllers[2];
    [feedTableVc deleteFeedFromList:notification.object];
}

- (void)addNewFeedWhenCreatSucceed:(NSNotification *)notification
{
    UMComFeedTableViewController *feedTableVc = self.childViewControllers[2];
    [feedTableVc insertFeedStyleToDataArrayWithFeed:notification.object];
}


- (void)refreshMessageData:(id)sender
{
    if (![[UMComSession sharedInstance] isLogin]) {
        return;
    }
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    [[UMComSession sharedInstance] refreshConfigDataWithCompletion:^(NSDictionary *configData, NSError *error) {
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    }];

}


- (void)refreshUnreadMessageNotification
{
    UMComUnReadNoticeModel *unReadNotice = [UMComSession sharedInstance].unReadNoticeModel;
    if (unReadNotice.totalNotiCount == 0) {
        self.itemNoticeView.hidden = YES;
    }else{
        self.itemNoticeView.hidden = NO;
    }
}

#pragma mark - notifcation action
- (void)refreshAllDataWhenLoginUserChange:(NSNotification *)notification
{
    
    UMComRequestTableViewController *requestTableView = self.childViewControllers[self.menuView.currentIndex];
    if (self.menuView.currentIndex > 0) {
        [requestTableView.dataController.dataArray removeAllObjects];
        [requestTableView.tableView reloadData];
    }else{
        UMComHotFeedMenuViewController *hotMenuVc = self.childViewControllers[0];
        [hotMenuVc setPage:hotMenuVc.page];
    }
    
    if ([[UMComSession sharedInstance] isLogin]) {
        UMComRequestTableViewController *focusViewController = self.childViewControllers[2];
        [focusViewController refreshData];
    }

    UMComRequestTableViewController *topicViewController = self.childViewControllers[3];
    [topicViewController refreshData];
    
}


- (void)refreshAllDataWhenUserLogout:(NSNotification *)notification
{

    UMComRequestTableViewController *focusViewController = self.childViewControllers[2];
    UMComRequestTableViewController *topicViewController = self.childViewControllers[3];
    [focusViewController refreshData];
    [topicViewController refreshData];
     [self refreshUnreadMessageNotification];
}

#pragma mark - 视图切换逻辑


- (void)transitionViewControllers
{
    [self hidenKeyBoard];
    NSInteger currentPage = self.menuView.currentIndex;
    
    UIViewController *currentViewController = self.childViewControllers[currentPage];
    UMComFeedTableViewController *focusedTableController = self.childViewControllers[1];
    UMComFeedTableViewController *recommentTableController = self.childViewControllers[2];
    if (currentPage == 0) {
        focusedTableController.editButton.hidden = NO;
        recommentTableController.editButton.hidden = YES;
    }else if (currentPage == 1){
        focusedTableController.editButton.hidden = YES;
        recommentTableController.editButton.hidden = NO;
    }else if (currentPage == 2){
        focusedTableController.editButton.hidden = YES;
        recommentTableController.editButton.hidden = YES;
    }
    if (currentPage == 3) {
        self.searchBar.placeholder = UMComLocalizedString(@"um_com_searchTopic", @"搜索话题");
    }else{
        self.searchBar.placeholder = UMComLocalizedString(@"um_com_searchUserAndContent", @"搜索用户和内容");
    }
    CGRect searchBarFrame = self.searchBar.frame;
    CGRect commonViewFrame = currentViewController.view.frame;
    if (currentPage > 0) {
        self.segmentControl.hidden = YES;
        searchBarFrame.origin.y = 0;
        
    }else{
        searchBarFrame.origin.y = self.segmentControl.frame.size.height + self.segmentControl.frame.origin.y;
        self.segmentControl.hidden = NO;
    }
    commonViewFrame.origin.y = searchBarFrame.size.height + searchBarFrame.origin.y;
    commonViewFrame.size.height = self.view.bounds.size.height - commonViewFrame.origin.y;
    if (searchBarFrame.origin.y != self.searchBar.frame.origin.y) {
        self.searchBar.frame = searchBarFrame;
        currentViewController.view.frame = commonViewFrame;
    }
    [self transitionFromViewControllerAtIndex:self.menuView.lastIndex toViewControllerAtIndex:currentPage animations:nil completion:nil];
}

- (void)didSelectedHotFeedAtIndex:(UISegmentedControl *)segmentControl
{
    UMComHotFeedMenuViewController *hotFeedMenuViewController = self.childViewControllers[0];
    [hotFeedMenuViewController setPage:segmentControl.selectedSegmentIndex];
}

-(void)onClickClose:(id)sender
{
    if ([self.navigationController isKindOfClass:[UMComNavigationController class]]) {
        [self dismissViewControllerAnimated:YES completion:nil];
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)onClickFind:(UIButton *)sender
{
    __weak typeof(self) weakSelf = self;
    //            weakSelf.findButton.hidden = YES;//隐藏发现按钮
    UMComFindViewController *findViewController = [[UMComFindViewController alloc] init];
    [weakSelf.navigationController pushViewController:findViewController animated:YES];
}

- (void)transitionToSearFeedViewController
{
    CGRect _currentViewFrame = self.view.frame;
    UINavigationBar *navigationBar = self.navigationController.navigationBar;
    UIViewController *searchViewController = nil;
    if (self.menuView.currentIndex == 3) {
        UMComMicroTopicSearchViewController* tempMicroTopicSearchViewController = [[UMComMicroTopicSearchViewController alloc] init];
        tempMicroTopicSearchViewController.isAutoStartLoadData = NO;
        searchViewController = tempMicroTopicSearchViewController;
    }else{
        searchViewController =[[UMComSearchViewController alloc]init];
    }
    UMComNavigationController *navi = [[UMComNavigationController alloc]initWithRootViewController:searchViewController];
    self.searchBarOriginY = self.searchBar.frame.origin.y;
    navi.view.frame = CGRectMake(0, navigationBar.frame.size.height+originOffset.y,self.view.frame.size.width, self.view.frame.size.height);
    UIView *spaceView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    spaceView.backgroundColor = UMComColorWithHexString(@"#f7f7f8");
    [self.navigationController.view addSubview:spaceView];
    __weak typeof(self) weakSelf = self;
    void (^dismissBlock)() = ^(){
        //[UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
            weakSelf.searchBar.alpha = 1;
            weakSelf.searchBar.frame = CGRectMake(0, self.searchBarOriginY, weakSelf.searchBar.frame.size.width, weakSelf.searchBar.frame.size.height);
            navigationBar.frame = CGRectMake(originOffset.x, 20, weakSelf.view.frame.size.width, navigationBar.frame.size.height);
            weakSelf.view.frame = _currentViewFrame;
            [navi.view removeFromSuperview];
        [navi removeFromParentViewController];
            [spaceView removeFromSuperview];
        //} completion:nil];
    };
    if (self.menuView.currentIndex == 3) {
        UMComMicroTopicSearchViewController *searchTopicViewController = (UMComMicroTopicSearchViewController *)searchViewController;
        
        searchTopicViewController.dismissBlock = dismissBlock;
    }else{
        UMComSearchViewController *searchFeedViewController = (UMComSearchViewController *)searchViewController;
        searchFeedViewController.dismissBlock = dismissBlock;
    }
    
    [self.navigationController.view addSubview:navi.view];
    [self.navigationController addChildViewController:navi];
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        weakSelf.searchBar.alpha = 0;
        weakSelf.searchBar.frame = CGRectMake(0, weakSelf.searchBarOriginY-44, weakSelf.searchBar.frame.size.width, weakSelf.searchBar.frame.size.height);
        navigationBar.frame = CGRectMake(0, -44, weakSelf.view.frame.size.width, navigationBar.frame.size.height);
        weakSelf.view.frame = CGRectMake(0,- navigationBar.frame.size.height-originOffset.y, weakSelf.view.frame.size.width, weakSelf.view.frame.size.height+navigationBar.frame.size.height+originOffset.y);
        navi.view.frame = CGRectMake(0, 20,weakSelf.view.frame.size.width, weakSelf.view.frame.size.height+navigationBar.frame.size.height);
    } completion:nil];
}

#pragma mark - searchBarDelelagte
- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
    if ([UMComSession sharedInstance].communityGuestMode == 1) {
        [self transitionToSearFeedViewController];
    }else{
        __weak typeof(self) weakSelf = self;
        [UMComLoginManager performLogin:self completion:^(id responseObject, NSError *error) {
            if (!error) {
                [weakSelf transitionToSearFeedViewController];
            }
        }];
    }
    return NO;
}

-(UMComSearchBar*) createSearchBarWithPlaceholder:(NSString*)placeholder
{
    UMComSearchBar *searchBar =
    [[UMComSearchBar alloc] initWithFrame:CGRectMake(0, 0 ,self.view.frame.size.width, 44)];
    searchBar.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    if (placeholder) {
        searchBar.placeholder = placeholder;
    }
    searchBar.frame = CGRectMake(0, 0, self.view.frame.size.width, 40);
    searchBar.delegate = self;
    searchBar.backgroundColor = UMComColorWithHexString(@"#F5F6FA");
    return searchBar;
}

#pragma mark - topic tableView scrollDelegate
- (void)customScrollViewEndDrag:(UIScrollView *)scrollView lastPosition:(CGPoint)lastPosition
{
    [self hidenKeyBoard];
}


@end

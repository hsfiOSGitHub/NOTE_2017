
//
//  UMComRequestTableViewController.m
//  UMCommunity
//
//  Created by umeng on 15/11/16.
//  Copyright © 2015年 Umeng. All rights reserved.
//

#import "UMComRequestTableViewController.h"
#import "UMComScrollViewDelegate.h"
#import "UIViewController+UMComAddition.h"
#import <UMCommunitySDK/UMComSession.h>
#import "UMComShowToast.h"
#import "UMComRefreshView.h"
#import <UMComFoundation/UMComKit+Color.h>



typedef NS_ENUM(NSInteger, UMComVisitType){
    UMComVisitType_None                         = -1,        //< 初始化状态
    UMComVisitType_VisitNeedLoginForMoreData    = 0,         //< 需要登录才能访问更多数据
    UMComVisitType_VisitNeedLoginForNoMoreData  = 1,         //< 需要登录访问，但是没有下一页数据
    
    UMComVisitType_Visit                        = 2,          //< 可以访问（目前没有用到,UMComVisitType_VisitForMoreData和UMComVisitType_VisitForNoMoreData都可以表示可以访问）
    UMComVisitType_VisitForMoreData             = 3,        //< 可以访问下一页数据
    UMComVisitType_VisitForNoMoreData           = 4         //< 可以访问没有下一页数据
};

@interface UMComRequestTableViewController ()<UITableViewDelegate, UITableViewDataSource, UMComScrollViewDelegate>

@property (nonatomic, assign) CGPoint lastPosition;


@property(nonatomic,assign)UMComVisitType visitMoreDataMode;

//检查是否访客模式
-(BOOL) canVisitNextPage;

-(void) refreshDataFromServer;


@end

@implementation UMComRequestTableViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self initData];
    }
    return self;
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self initData];
    }
    return self;
}

 - (void)initData
{
    self.isLoadFinish = YES;
    self.isAutoStartLoadData = YES;
    
    self.visitMoreDataMode = UMComVisitType_None;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.isLoadFinish = YES;
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:self.tableView];
    
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)]) {
        [self setEdgesForExtendedLayout:UIRectEdgeNone];
    }
    __weak typeof(self) weakSelf = self;
    self.refreshHeadView = (UMComHeadView *)[UMComHeadView refreshControllViewWithScrollView:self.tableView block:^{
        [weakSelf refreshData];
    }];
    
    self.refreshFootView = (UMComFootView *)[UMComFootView refreshControllViewWithScrollView:self.tableView block:^{
        [weakSelf loadMoreData];
    }];

    self.tableView.separatorColor = UMComColorWithHexString(UMCom_Feed_BgColor);
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)])
    {
        [self.tableView setLayoutMargins:UIEdgeInsetsZero];
    }
    self.scrollViewDelegate = self;
    
    [self setForumUIBackButtonWithImage:UMComImageWithImageName(@"um_forum_back_gray")];
    [self setForumUITitle:self.title];
    
    [self updateTableviewConstraints];
}


- (void)updateTableviewConstraints
{
    UITableView *tableView = self.tableView;
    
    [tableView setTranslatesAutoresizingMaskIntoConstraints:NO];
    NSDictionary *dict1 = NSDictionaryOfVariableBindings(tableView);
    NSDictionary *metrics = @{@"hPadding":@0,@"topPadding":@0,@"vPadding":@0};
    NSString *vfl = @"|-hPadding-[tableView]-hPadding-|";
    NSString *vfl0 = @"V:|-topPadding-[tableView]-vPadding-|";
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:vfl options:0 metrics:metrics views:dict1]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:vfl0 options:0 metrics:metrics views:dict1]];
}

- (void)creatNoFeedTip
{
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height/2-40, self.view.frame.size.width,40)];
    label.backgroundColor = [UIColor clearColor];
    label.text = UMComLocalizedString(@"um_com_emptyData", @"暂时没有内容哦!");
    label.font = UMComFontNotoSansLightWithSafeSize(17);
    label.textColor = UMComColorWithHexString(FontColorGray);
    label.textAlignment = NSTextAlignmentCenter;
    label.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
    label.hidden = YES;
    [self.view addSubview:label];
    self.noDataTipLabel = label;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (!self.noDataTipLabel && self.doNotShowNodataNote == NO) {
        [self creatNoFeedTip];
    }
    // 未登录时发送请求可能会不断收到未登录错误码而不断弹出登录
    // 修改为第一次加载后开始手动下拉刷新加载
    if (self.isAutoStartLoadData  && self.isLoadFinish) {
        [self refreshData];
        self.isAutoStartLoadData = NO;
    }else{
        [self.tableView reloadData];
    }
    
//    //首先判断非访客模式===begin
//    if (self.visitMoreDataMode == UMComVisitType_None) {
//        //第一次进入的时候初始化为UMComVisitType_None的时候，表示未知状态，不需要判断其是否为访客模式，需要等到第一次网络请求到了，包含的访客模式(即为visitMoreDataMode赋非UMComVisitType_None的值)
//        return;
//    }
//    
//    //如果当前是访客模式即登录了，但是visitMoreDataMode为非访客模式，就需要修改其提示加载更多
//    if ([self canVisitNextPage]) {
//        if (self.visitMoreDataMode == UMComVisitType_VisitNeedLoginForMoreData)
//        {
//            //非访客模式直接显示加载更多
//            [self.loadMoreStatusView setLoadStatus:UMComNoLoad];
//        }
//        else if (self.visitMoreDataMode == UMComVisitType_VisitNeedLoginForNoMoreData)
//        {
//            //非访客模式直接显示加载完成
//            [self.loadMoreStatusView setLoadStatus:UMComFinish];
//        }
//        else if (self.visitMoreDataMode == UMComVisitType_VisitForMoreData)
//        {
//            [self.loadMoreStatusView setLoadStatus:UMComNoLoad];
//        }
//        else if (self.visitMoreDataMode == UMComVisitType_VisitForNoMoreData)
//        {
//            [self.loadMoreStatusView setLoadStatus:UMComFinish];
//        }
//        else{}
//    }
//    //首先判断非访客模式===end
    
}


////
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.dataController.dataArray.count > 0)//有数据
    {
        self.noDataTipLabel.hidden = YES;
    }
    else//数据为空
    {
        self.noDataTipLabel.hidden = NO;
    }
    return self.dataController.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"cellId";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    return cell;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (self.isLoadFinish && self.scrollViewDelegate && [self.scrollViewDelegate respondsToSelector:@selector(customScrollViewDidScroll:lastPosition:)]) {
        [self.scrollViewDelegate customScrollViewDidScroll:scrollView lastPosition:self.lastPosition];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    
    self.lastPosition = scrollView.contentOffset;
    if (self.scrollViewDelegate && [self.scrollViewDelegate respondsToSelector:@selector(customScrollViewDidEnd:lastPosition:)]) {
        [self.scrollViewDelegate customScrollViewDidEnd:scrollView lastPosition:self.lastPosition];
    }
    self.lastPosition = scrollView.contentOffset;
}


- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
//    [self refreshScrollViewDidEndDragging:scrollView];
    if (self.scrollViewDelegate && [self.scrollViewDelegate respondsToSelector:@selector(customScrollViewEndDrag:lastPosition:)]) {
        [self.scrollViewDelegate customScrollViewEndDrag:scrollView lastPosition:self.lastPosition];
    }
    self.lastPosition = scrollView.contentOffset;
}

#pragma mark - refreshdelegate
- (void)refreshData:(UMComRefreshView *)refreshView
{
    [self refreshData];
}

- (void)loadMoreData:(UMComRefreshView *)refreshView
{
    [self loadMoreData];
}

#pragma mark - UMComRefreshTableViewDelegate


- (void) fetchLocalData
{
    __weak typeof(self) weakSelf = self;
    [self.dataController fetchLocalDataWithCompletion:^(NSArray *dataArray, NSError *error) {
        
        if (dataArray && [dataArray isKindOfClass:[NSArray class]] && dataArray.count > 0) {
            
            [weakSelf handleLocalData:dataArray error:error];
            [weakSelf.tableView reloadData];
        }
        [weakSelf refreshDataFromServer];
    }];
}

- (void)refreshData
{
    if (self.dataController.isReadLoacalData) {
        //设置NO只会第一次下拉刷新取本地数据
        self.dataController.isReadLoacalData = NO;
        //取本地数据的话，就不需要显示loadMoreStatusView的views
        [self fetchLocalData];
    }
    else{
        [self refreshDataFromServer];
    }
}

-(void)refreshDataFromServer
{
    if (!self.dataController) {
        [self.refreshHeadView noMoreData];
        return;
    }
    if (self.isLoadFinish == NO) {
        return;
    }
    self.isLoadFinish = NO;
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    __weak typeof(self) weakSelf = self;
    [self.dataController refreshNewDataCompletion:^(NSArray *responseData, NSError *error) {
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        [UMComShowToast showFetchResultTipWithError:error];
        if (!error) {
            [weakSelf.refreshHeadView endLoading];
            if (weakSelf.dataController.haveNextPage) {
                [weakSelf.refreshFootView endLoading];
            }else{
                [weakSelf.refreshFootView noMoreData];
            }
        }else{
            [weakSelf.refreshHeadView endLoading];
            weakSelf.refreshHeadView.statusLable.text = UMComLocalizedString(@"server_error", @"网络请求失败");
        }

        weakSelf.isLoadFinish = YES;
        if (weakSelf.refreshSeverDataCompletionHandler) {
            weakSelf.refreshSeverDataCompletionHandler(responseData, error);
        }
        [weakSelf handleFirstPageData:responseData error:error];
        [weakSelf.tableView reloadData];
    }];
}


- (void)loadMoreData
{
    //首先判断非访客模式===begin
    if (![self canVisitNextPage]) {
        [self.refreshFootView endLoading];
        self.refreshFootView.statusLable.text = @"登录加载更多";
        return;
    }
//    //非访客模式，并且请求了第一次的网络数据
//    if(![self canVisitNextPage] && self.visitMoreDataMode != UMComVisitType_None)
//    {
//
//        return;
//    }
    if (self.isLoadFinish == NO) {
        return;
    }
    if (!self.dataController) {
        [self.refreshFootView noMoreData];
        return;
    }
    self.isLoadFinish = NO;
    __weak typeof(self) weakSelf = self;
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    
    [self.dataController loadNextPageDataWithCompletion:^(NSArray *responseData, NSError *error) {
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        weakSelf.isLoadFinish = YES;
        if (!error) {
            if (weakSelf.dataController.haveNextPage) {
                [weakSelf.refreshFootView endLoading];
            }else{
                [weakSelf.refreshFootView noMoreData];
            }
        }else{
            [weakSelf.refreshFootView endLoading];
            weakSelf.refreshFootView.statusLable.text = UMComLocalizedString(@"server_error", @"网络请求失败");
        }
        if (weakSelf.loadMoreDataCompletionHandler) {
            weakSelf.loadMoreDataCompletionHandler(responseData, error);
        }
        [weakSelf handleNextPageData:responseData error:error];
        if (responseData) {
            [weakSelf.tableView reloadData];
        }
    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


/**
 *  登陆用户和访客模式都会返回true，因其拥有一样的权限
 *
 *  @return true 表示有权限查看下一页 false 代表没有权限查看下一页
 */
-(BOOL) canVisitNextPage
{
    //登陆用户
    if ([UMComSession sharedInstance].isLogin) {
        return YES;
    }
    return self.dataController.canVisitNextPage;
}


#pragma mark - data handle method 
/**
 *处理本地数据
 */
- (void)handleLocalData:(NSArray *)data error:(NSError *)error
{
    if (error) {
        [UMComShowToast showFetchResultTipWithError:error];
    }else{
    
    }
}

/**
 *处理网络请求第一页数据
 */
- (void)handleFirstPageData:(NSArray *)data error:(NSError *)error
{
    if (error) {
        [UMComShowToast showFetchResultTipWithError:error];
    }else{
        
    }
}
/**
 *处理网络请求下一页数据
 */
- (void)handleNextPageData:(NSArray *)data error:(NSError *)error
{
    if (error) {
        [UMComShowToast showFetchResultTipWithError:error];
    }else{
        
    }
}

@end


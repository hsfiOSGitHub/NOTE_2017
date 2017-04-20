//
//  UMComRequestTableViewController.h
//  UMCommunity
//
//  Created by umeng on 15/11/16.
//  Copyright © 2015年 Umeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "UMComListDataController.h"
#import <UMComDataStorage/UMComDataBaseManager.h>

typedef void (^UMComLoadSeverDataCompletionHandler)(NSArray *data,NSError *error);

@protocol UMComScrollViewDelegate;

@class UMComHeadView,UMComFootView;


@interface UMComRequestTableViewController : UIViewController<UITableViewDelegate, UITableViewDataSource>


/**
 *继承与UMComRequestTableViewController的TableViewController都带有一个dataController，负责处理为TableViewController处理数据和业务逻辑，并未tableView提供显示的model
 */
@property (nonatomic, strong) UMComListDataController *dataController;

/**
 * tableView
 */
@property (nonatomic, strong) UITableView *tableView;

/**
 *下拉刷新控件
 */
@property (nonatomic, strong) UMComHeadView *refreshHeadView;

/**
 *上拉加载控件
 */
@property (nonatomic, strong) UMComFootView *refreshFootView;

///**
// *下拉刷新控件
// */
//@property (nonatomic, strong) UIRefreshControl *refreshControl;

/**
 *显示数据为空或网络问题label
 */
@property (nonatomic, strong) UILabel *noDataTipLabel;

/**
 *tableView上次滚动的位置
 */
@property (nonatomic, assign, readonly) CGPoint lastPosition;

/**
 *是否自动加载数据
 */
@property (nonatomic, assign) BOOL isAutoStartLoadData;

/**
 *网络数据是否加载完成
 */
@property (nonatomic, assign) BOOL isLoadFinish;

/**
 *是否显示数据为空的提示
 */
@property (nonatomic, assign) BOOL doNotShowNodataNote;

/**
 *tableView滚动delegate
 */
@property (nonatomic, weak) id<UMComScrollViewDelegate> scrollViewDelegate;

@property (nonatomic, copy) UMComLoadSeverDataCompletionHandler refreshSeverDataCompletionHandler;
@property (nonatomic, copy) UMComLoadSeverDataCompletionHandler loadMoreDataCompletionHandler;


- (BOOL)isBeginScrollBottom:(UIScrollView *)scrollView;
- (BOOL)isScrollToBottom:(UIScrollView *)scrollView;

#pragma mark - data request method
/**
 * 请求本地数据（先请求本地数据在请求网络数据，适合没网的时候显示本地数据）
 */
- (void)fetchLocalData;

/**
 *刷新数据（第一页数据）
 */
- (void)refreshData;

/**
 * 加载更多（下一页数据）
 */
- (void)loadMoreData;

#pragma mark - data handle method 
/**
 *处理本地数据
 */
- (void)handleLocalData:(NSArray *)data error:(NSError *)error;
/**
 *处理网络请求第一页数据
 */
- (void)handleFirstPageData:(NSArray *)data error:(NSError *)error;
/**
 *处理网络请求下一页数据
 */
- (void)handleNextPageData:(NSArray *)data error:(NSError *)error;

@end


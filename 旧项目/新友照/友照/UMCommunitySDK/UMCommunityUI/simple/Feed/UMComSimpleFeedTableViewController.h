//
//  UMComFeedsTableViewController.h
//  UMCommunity
//
//  Created by Gavin Ye on 8/27/14.
//  Copyright (c) 2014 Umeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UMComRequestTableViewController.h"

#import <UMCommunitySDK/UMComDataTypeDefine.h>
#import "UMComSimpleFeedOperationFinishDelegate.h"

@class UMComFeed;


typedef enum {
    UMComFeedType_Common,
    UMComFeedType_Favorite,
    UMComFeedType_UserTimeLine,
    UMComFeedType_RealTime,
} UMComFeedTableType;



/**
 *  简版的feed列表的基类
 */
@interface UMComSimpleFeedTableViewController : UMComRequestTableViewController<UMComSimpleFeedOperationFinishDelegate>

@property (nonatomic, strong) UIButton *editButton;

@property (nonatomic, assign) BOOL isShowEditButton;

@property (nonatomic, assign) UMComFeedTableType feedType;

@property (nonatomic, copy) NSString *titleName;

//置顶Feed的类型
@property(nonatomic,assign)UMComTopFeedType topFeedType;

-(void)onClickEdit:(id)sender;




/**
 *  是否显示话题名字
 *  @discuss 在TopicFeed界面,显示的都是topic下的feed，因此不需要显示话题名字
 */
@property(nonatomic,assign)BOOL isHideTopicName;


///**
// *  刷新当前界面的cell里面的数据
// *
// *  @param cell 当前需要刷新的cell
// *  @param feed cell中包含的feed(此值目前没有用，以后可以用来通过feedID来检验)
// */
//-(void)reloadRowWithCell:(UITableViewCell*)cell withFeed:(UMComFeed*)feed;

/**
 *  插入新的一行用cell的数据
 *
 *  @param index   代表要插入的位置(不能超过当前表的count)
 *  @param newFeed 要插入的对象
 */
-(void)insertRowWithIndex:(NSInteger)index withNewFeed:(UMComFeed*)newFeed;
@end


/**
 *  最新feed列表
 */
@interface UMComLatestSimpleFeedTableViewController : UMComSimpleFeedTableViewController
@end

/**
 *  用户收藏的列表
 */
@interface UMComUsersFavouritesSimpleFeedTableViewController : UMComSimpleFeedTableViewController

@end

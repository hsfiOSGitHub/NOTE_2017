//
//  UMComFeedsTableViewController.h
//  UMCommunity
//
//  Created by Gavin Ye on 8/27/14.
//  Copyright (c) 2014 Umeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UMComFeedStyle.h"
#import <UMCommunitySDK/UMComDataTypeDefine.h>
#import "UMComRequestTableViewController.h"

#define DeltaBottom  45
#define DeltaRight 45

@class UMComComment,UMComUser;

/**
 *  微博版的feed列表的基类
 */
@interface UMComFeedTableViewController : UMComRequestTableViewController

@property (nonatomic, strong) UIButton *editButton;

@property (nonatomic, assign) BOOL isShowEditButton;

@property (nonatomic, strong) NSMutableArray *feedStyleList;

@property (nonatomic, assign) CGFloat feedCellBgViewTopEdge;

@property (nonatomic, assign) BOOL isDisplayDistance;

-(void)onClickEdit:(id)sender;

- (void)insertFeedStyleToDataArrayWithFeed:(UMComFeed *)newFeed;

- (void)deleteFeedFromList:(UMComFeed *)feed;

- (void)showActionSheetWithFeed:(UMComFeed *)feed;

- (void)showCommentEditViewWithComment:(UMComComment *)comment feed:(UMComFeed *)feed;

- (void)showActionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex;

//辅助标示当前界面是否能显示置顶标示
@property (nonatomic, assign) BOOL showTopMark;

//置顶Feed的类型
@property(nonatomic,assign)UMComTopFeedType topFeedType;

@end

//
//  UMComSimpleFeedDetailViewController.h
//  UMCommunity
//
//  Created by umeng on 16/5/17.
//  Copyright © 2016年 Umeng. All rights reserved.
//

#import "UMComSimpleFeedTableViewController.h"
#import "UMComSimpleFeedOperationFinishDelegate.h"

@class UMComFeed;
@interface UMComSimpleFeedDetailViewController : UMComSimpleFeedTableViewController


@property (nonatomic, strong) UMComFeed *feed;

@property (nonatomic, assign)BOOL autoShowCommentEditView;

@property (nonatomic,weak)id<UMComSimpleFeedOperationFinishDelegate>  feedOperationDelegate;

@end

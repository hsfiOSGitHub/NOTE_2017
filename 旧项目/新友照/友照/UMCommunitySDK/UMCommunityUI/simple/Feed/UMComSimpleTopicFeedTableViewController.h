//
//  UMComSimpleTopicFeedTableViewController.h
//  UMCommunity
//
//  Created by 张军华 on 16/5/23.
//  Copyright © 2016年 Umeng. All rights reserved.
//

#import "UMComSimpleFeedTableViewController.h"
@class UMComTopic;

/**
 *  所有话题feed的基类，用于扩展话题下feed的功能
 */
@interface UMComSimpleTopicFeedTableViewController : UMComSimpleFeedTableViewController

@property(nonatomic,strong)UMComTopic* topic;

@end


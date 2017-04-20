//
//  UMComFeedWithTopicTableViewController.h
//  UMCommunity
//
//  Created by 张军华 on 16/4/20.
//  Copyright © 2016年 Umeng. All rights reserved.
//

#import "UMComFeedTableViewController.h"

@class UMComTopic;

/**
 *  话题下进入的feed列表
 */
@interface UMComFeedWithTopicTableViewController : UMComFeedTableViewController

- (instancetype)initWithTopic:(UMComTopic *)topic;

@property (nonatomic, strong) UMComTopic *topic;

@end


/**
 *  单个话题界面，最新发布的列表(此处做子类为了获得编辑界面的发送feed的通知kNotificationPostFeedResultNotification，能够及时更新)
 */
@interface UMComFeedWithTopicLatestFeedTableViewController : UMComFeedWithTopicTableViewController

@end

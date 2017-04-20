//
//  UMComUserCommentViewController.h
//  UMCommunity
//
//  Created by wyq.Cloudayc on 5/19/16.
//  Copyright © 2016 Umeng. All rights reserved.
//

#import "UMComRequestTableViewController.h"

@protocol UMComFeedClickActionDelegate;

@interface UMComSimpleSubCommentViewController : UMComRequestTableViewController

@property (nonatomic, weak) id<UMComFeedClickActionDelegate> delegate;

@end

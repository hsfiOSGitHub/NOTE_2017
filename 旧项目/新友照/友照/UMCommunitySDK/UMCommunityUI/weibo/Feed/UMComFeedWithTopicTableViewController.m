//
//  UMComFeedWithTopicTableViewController.m
//  UMCommunity
//
//  Created by 张军华 on 16/4/20.
//  Copyright © 2016年 Umeng. All rights reserved.
//

#import "UMComFeedWithTopicTableViewController.h"
#import <UMComDataStorage/UMComFeed.h>
#import <UMComDataStorage/UMComTopic.h>
#import "UMComLoginManager.h"
#import "UMComNavigationController.h"
#import "UMComEditViewController.h"
#import "UMComFeedWithTopicTableViewController.h"
#import "UMComNotificationMacro.h"

@interface UMComFeedWithTopicTableViewController ()

@end

@implementation UMComFeedWithTopicTableViewController


- (instancetype)initWithTopic:(UMComTopic *)topic
{
    self = [super init];
    if (self) {
        self.topic = topic;
        self.isShowEditButton = YES;
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - override method
-(void)onClickEdit:(id)sender
{
    //__weak typeof(self) weakSelf = self;
    [UMComLoginManager performLogin:self completion:^(id responseObject, NSError *error) {
        if (!error) {
            UMComEditViewController *editViewController = [[UMComEditViewController alloc] initWithTopic:self.topic];
            //editViewController.feedOperationFinishDelegate = weakSelf;
            UMComNavigationController *editNaviController = [[UMComNavigationController alloc] initWithRootViewController:editViewController];
            [self presentViewController:editNaviController animated:YES completion:nil];
        }
    }];
    
}

@end



@interface UMComFeedWithTopicLatestFeedTableViewController ()

-(void)handleNewFeed:(NSNotification*)notification;

@end

@implementation UMComFeedWithTopicLatestFeedTableViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleNewFeed:) name:kNotificationPostFeedResultNotification object:nil];
}

-(void) dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:kNotificationPostFeedResultNotification];
}

#pragma mark - override From UMComPostTableViewController

- (void)insertFeedStyleToDataArrayWithFeed:(UMComFeed *)feed
{
    if (!feed) {
        return;
    }
    //判断当前话题是否属于当前话题
    for (UMComTopic *tempTopic in feed.topics) {
        if ([tempTopic isKindOfClass:[UMComTopic class]] && [self.topic.topicID isEqualToString:tempTopic.topicID]) {
            [super insertFeedStyleToDataArrayWithFeed:feed];
        }
    }
}

#pragma mark - kNotificationPostFeedResultNotification
-(void)handleNewFeed:(NSNotification*)notification;
{
    id target =  notification.object;
    if (target && [target isKindOfClass:[UMComFeed class]]) {
        
        __weak typeof(self) weakself = self;
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakself insertFeedStyleToDataArrayWithFeed:target];
        });
    }
}

@end

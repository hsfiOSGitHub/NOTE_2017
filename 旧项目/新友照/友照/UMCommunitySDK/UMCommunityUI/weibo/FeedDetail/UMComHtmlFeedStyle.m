//
//  UMComHtmlFeedStyle.m
//  UMCommunity
//
//  Created by 张军华 on 16/3/21.
//  Copyright © 2016年 Umeng. All rights reserved.
//

#import "UMComHtmlFeedStyle.h"
#import <UMCommunitySDK/UMComSession.h>
#import "UMComResouceDefines.h"
#import <UMComDataStorage/UMComFeed.h>
#import <UMComDataStorage/UMComTopic.h>
#import <UMComDataStorage/UMComLocation.h>

@interface UMComHtmlFeedStyle ()

//初始化
-(void) initArray;

@end

@implementation UMComHtmlFeedStyle

#pragma mark - overide method from UMComFeedStyle
- (instancetype)initWithFeed:(UMComFeed *)feed viewWidth:(float)viewWidth
{
    if (self = [super init]) {
        [self initArray];
        self.cellWidth = viewWidth;
        self.contentOrginX = UMCom_Micro_FeedContent_LeftEdge;
        self.contentWidth = viewWidth - UMCom_Micro_FeedContent_LeftEdge - UMCom_Micro_FeedContent_RightEdge;
    }
    return self;
}


- (void)resetWithFeed:(UMComFeed *)feed
{
    self.feed = feed;
    self.locationModel =  [self.feed location];
    
//    NSInteger resultTopType = feed.is_topType.integerValue | EUMTopFeedType_Mask;
//    if (resultTopType == EUMTopFeedType_None) {
//        self.isShowTopImage = NO;
//    }
//    else{
//        self.isShowTopImage = YES;
//    }
    
    float totalHeight = UMCom_Micro_Feed_Avata_TopEdge + UMCom_Micro_Feed_Avata_Height + UMCom_Micro_Feed_SpaceBetweenAvataAndWebView;
    
    NSString * feedSting = @"";
    if (feed.text && [feed.status intValue] < FeedStatusDeleted) {
        feedSting = feed.text;
        NSMutableArray *feedCheckWords = [NSMutableArray array];
        NSMutableArray *topicArray = [NSMutableArray array];
        for (UMComTopic *topic in feed.topics) {
            NSString *topicName = [NSString stringWithFormat:TopicString,topic.name];
            if (!topicName) {
                continue;
            }
            [feedCheckWords addObject:topicName];
            [topicArray addObject:topicName];
        }
        //设置话题Array
        self.topicArray = topicArray;
        
        NSMutableArray *userNameArray = [NSMutableArray array];
        for (UMComUser *user in feed.related_user) {
            NSString *userName = [NSString stringWithFormat:UserNameString,user.name];
            if (!userName) {
                continue;
            }
            [feedCheckWords addObject:userName];
            [userNameArray addObject:userName];
            
        }
        //设置用户Array
        self.userNameArray = userNameArray;
    }
    
    if (self.webViewHeight <= 0) {
        self.webViewHeight = 0;
    }
    totalHeight +=  self.webViewHeight;
    
    totalHeight += UMCom_Micro_FeedContent_BottomEdge;
    
//    NSLog(@"resetWithFeed>>>self.feedStyle.totalHeight = %f",totalHeight);
    self.totalHeight = totalHeight;
    
    
}


#pragma mark - new method for UMComHtmlFeedStyle
-(void) initArray
{
    self.topicArray = [NSMutableArray arrayWithCapacity:2];
    
    self.userNameArray = [NSMutableArray arrayWithCapacity:2];
}

@end

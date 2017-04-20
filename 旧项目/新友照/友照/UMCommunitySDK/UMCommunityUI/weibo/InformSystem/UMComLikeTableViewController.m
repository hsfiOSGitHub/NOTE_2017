//
//  UMComLikeTableViewController.m
//  UMCommunity
//
//  Created by umeng on 15/12/22.
//  Copyright © 2015年 Umeng. All rights reserved.
//

#import "UMComLikeTableViewController.h"
#import "UMComClickActionDelegate.h"
#import <UMComDataStorage/UMComUnReadNoticeModel.h>
#import <UMCommunitySDK/UMComSession.h>
#import "UIViewController+UMComAddition.h"
#import "UMComWebViewController.h"
#import "UMComUserCenterViewController.h"
#import "UMComTopicFeedViewController.h"
#import "UMComFeedDetailViewController.h"
#import <UMComDataStorage/UMComLike.h>
#import "UMComSysCommonTableViewCell.h"
#import "UMComSysLikeTableViewCell.h"
#import "UMComMutiStyleTextView.h"
#import "UMComResouceDefines.h"
#import <UMComDataStorage/UMComFeed.h>
#import <UMComDataStorage/UMComTopic.h>
#import "UMComLikeListDataController.h"
#import <UMComFoundation/UMComKit+Color.h>


@interface UMComLikeTableViewController ()<UITableViewDelegate, UMComClickActionDelegate>

- (NSDictionary *)likeDictDictionaryWithLike:(UMComLike *)like;

@property (nonatomic,strong) NSArray *dataArray;

@end

@implementation UMComLikeTableViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setForumUITitle:UMComLocalizedString(@"um_com_receivedLike", @"收到的赞")];
     self.dataController =  [[UMComUserReceivedLikeDataController alloc] initWithCount:UMCom_Limit_Page_Count];
    self.dataController.isReadLoacalData = YES;
    self.dataController.isSaveLoacalData = YES;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"cellID";
    UMComSysLikeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[UMComSysLikeTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID cellSize:CGSizeMake(tableView.frame.size.width, tableView.rowHeight)];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell.delegate = self;
    NSDictionary *likeDict = self.dataArray[indexPath.row];
    [cell reloadCellWithObj:[likeDict valueForKey:@"like"]
                 timeString:[likeDict valueForKey:@"creat_time"]
                   mutiText:nil
               feedMutiText:[likeDict valueForKey:@"feedMutiText"]];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *likeDict = self.dataArray[indexPath.row];
    return [[likeDict valueForKey:@"totalHeight"] floatValue];
}

#pragma mark - data handler

- (void)handleLocalData:(NSArray *)data error:(NSError *)error
{
    if ([data isKindOfClass:[NSArray class]] &&  data.count > 0) {
        self.dataArray = [self likeModelListWithLikes:data];
    }
}

- (void)handleFirstPageData:(NSArray *)data error:(NSError *)error
{
    if (!error) {
        [UMComSession sharedInstance].unReadNoticeModel.notiByLikeCount = 0;
        self.dataArray = [self likeModelListWithLikes:data];
    }
}

- (void)handleNextPageData:(NSArray *)data error:(NSError *)error
{
    if (!error && [data isKindOfClass:[NSArray class]]) {
        NSMutableArray *tempArray = [NSMutableArray arrayWithArray:self.dataArray];
        [tempArray addObjectsFromArray:[self likeModelListWithLikes:data]];
        self.dataArray = tempArray;
    }
}

- (NSArray *)likeModelListWithLikes:(NSArray *)likes
{
    if ([likes isKindOfClass:[NSArray class]] && likes.count > 0) {
        NSMutableArray *likeModels = [NSMutableArray arrayWithCapacity:likes.count];
        for (UMComLike *like in likes) {
            NSDictionary *commentDict = [self likeDictDictionaryWithLike:like];
            [likeModels addObject:commentDict];
        }
        return likeModels;
    }
    return nil;
}

- (NSDictionary *)likeDictDictionaryWithLike:(UMComLike *)like
{
    NSMutableDictionary *commentDict = [NSMutableDictionary dictionary];
    CGFloat totalHeight = UMCom_SysCommonCell_Comment_UserNameTopMargin +
    UMCom_SysCommonCell_Comment_UserNameHeight +
    UMCom_SysCommonCell_Comment_SpaceBetweenUserNameAndComment;
    
    
    //加入默认的高度来填写文字：赞了这条评论
    totalHeight += UMCom_SysCommonCell_Comment_CommentDefaultHeight;
    
    //累加评论底部的边距
    totalHeight += UMCom_SysCommonCell_Comment_CommentBotoom;
    
    //获得feed相关的
    NSMutableArray *feedCheckWords = nil;
    UMComFeed *feed = like.feed;
    
    //获得feed的内容
    NSString *feedString = @"";
    if (feed.text) {
        feedString = feed.text;
    }
    
    if ([feed.status integerValue] < FeedStatusDeleted) {
        if (feedString.length > [[UMComSession sharedInstance] maxFeedLength]) {
            feedString = [feedString substringWithRange:NSMakeRange(0, [[UMComSession sharedInstance] maxFeedLength])];
        }
        feedCheckWords = [NSMutableArray array];
        for (UMComTopic *topic in feed.topics) {
            NSString *topicName = [NSString stringWithFormat:TopicString,topic.name];
            [feedCheckWords addObject:topicName];
        }
        for (UMComUser *user in feed.related_user) {
            NSString *userName = [NSString stringWithFormat:UserNameString,user.name];
            [feedCheckWords addObject:userName];
        }
        //加入feed创建者自身
        if(feed.creator.name){
            NSString *userName = [NSString stringWithFormat:UserNameString,feed.creator.name];
            [feedCheckWords addObject:userName];
        }
        
    }else{
        feedString = UMComLocalizedString(@"um_com_deleteContent", @"该内容已被删除");
    }
    
    CGFloat feedMutiTextWidth = 0;
    if (feed.image_urls && [feed.image_urls count] > 0 ) {
        
        if ([feed.status integerValue] < FeedStatusDeleted)
        {
            //feed有图片并且不为删除状态
            //totalHeight的高度为有照片的默认高度,默认宽度也要减去UMCom_SysCommonCell_Feed_IMGWidth
            totalHeight += UMCom_SysCommonCell_FeedWithIMG_Height;
            feedMutiTextWidth = self.view.frame.size.width - UMCom_SysCommonCell_Comment_LeftMargin - UMCom_SysCommonCell_Comment_RightMargin - UMCom_SysCommonCell_Comment_UserImgWidth -UMCom_SysCommonCell_Comment_SpaceBetweenUserNameAndComment - UMCom_SysCommonCell_Feed_IMGMargin*2 - UMCom_SysCommonCell_Feed_IMGWidth;
        }
        else
        {
            
            //totalHeight的高度为无照片的默认高度
            //totalHeight的高度为有照片的默认高度,默认宽度不需要减去UMCom_SysCommonCell_Feed_IMGWidth
            totalHeight += UMCom_SysCommonCell_FeedWithoutIMG_Height;
            feedMutiTextWidth = self.view.frame.size.width - UMCom_SysCommonCell_Comment_LeftMargin - UMCom_SysCommonCell_Comment_RightMargin - UMCom_SysCommonCell_Comment_UserImgWidth -UMCom_SysCommonCell_Comment_SpaceBetweenUserNameAndComment - UMCom_SysCommonCell_Feed_IMGMargin*2;
        }
        
    }
    else
    {
        //feed没有图片 高度固定
        totalHeight += UMCom_SysCommonCell_FeedWithoutIMG_Height;
        feedMutiTextWidth = self.view.frame.size.width - UMCom_SysCommonCell_Comment_LeftMargin - UMCom_SysCommonCell_Comment_RightMargin - UMCom_SysCommonCell_Comment_UserImgWidth -UMCom_SysCommonCell_Comment_SpaceBetweenUserNameAndComment;
        
    }
    
    totalHeight += UMCom_SysCommonCell_BottomMargin;
    
    UMComMutiText *feedMutiText = [UMComMutiText mutiTextWithSize:CGSizeMake(feedMutiTextWidth, MAXFLOAT) font:UMComFontNotoSansLightWithSafeSize(12) string:feedString lineSpace:2 checkWords:feedCheckWords textColor:UMComColorWithHexString(@"#A5A5A5")];
    
    [commentDict setValue:feedMutiText forKey:@"feedMutiText"];
    
    NSString *timeString = createTimeString(like.create_time);
    [commentDict setValue:like forKey:@"like"];
    [commentDict setValue:@(totalHeight) forKey:@"totalHeight"];
    [commentDict setValue:timeString forKey:@"creat_time"];
    
    return commentDict;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - ClickActionDelegate
- (void)customObj:(id)obj clickOnFeedText:(UMComFeed *)feed
{
    if (![feed isKindOfClass:[UMComFeed class]]) {
        return;
    }
    if ([feed.status isKindOfClass:[NSNumber class]] && feed.status.integerValue >= 2) {
        //代表feed被删除
        return;
    }
    
    UMComFeedDetailViewController *postContent = [[UMComFeedDetailViewController alloc]initWithFeed:feed];
    [self.navigationController pushViewController:postContent animated:YES];
}

- (void)customObj:(id)obj clickOnUser:(UMComUser *)user
{
    UMComUserCenterViewController *userCenter = [[UMComUserCenterViewController alloc]initWithUser:user];
    [self.navigationController pushViewController:userCenter animated:YES];
}

- (void)customObj:(id)obj clickOnTopic:(UMComTopic *)topic
{
    UMComTopicFeedViewController *topicFeedVc = [[UMComTopicFeedViewController alloc]initWithTopic:topic];
    [self.navigationController pushViewController:topicFeedVc animated:YES];
}

- (void)customObj:(id)obj clickOnURL:(NSString *)url
{
    UMComWebViewController * webViewController = [[UMComWebViewController alloc] initWithUrl:url];
    [self.navigationController pushViewController:webViewController animated:YES];
}

@end

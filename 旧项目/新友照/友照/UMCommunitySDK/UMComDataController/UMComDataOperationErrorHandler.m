//
//  UMComDataOperationErrorHandler.m
//  UMCommunity
//
//  Created by umeng on 16/7/8.
//  Copyright © 2016年 Umeng. All rights reserved.
//

#import "UMComDataOperationErrorHandler.h"
#import <UMCommunitySDK/UMComSession.h>
#import "UMComLoginManager.h"
#import <UMComDataStorage/UMComUser.h>
#import <UMComDataStorage/UMComComment.h>
#import <UMComDataStorage/UMComFeed.h>
#import <UMComDataStorage/UMComTopic.h>
#import <UMComNetwork/UMComHttpCode.h>
#import "UMComResouceDefines.h"
#import "UMComNotificationMacro.h"


@implementation UMComDataOperationErrorHandler

#pragma mark - User related Operation
/*****************************************************************************/
+ (void)handelUserErrorWithUser:(UMComUser *)user error:(NSError *)error
{
    if (error.code == ERR_CODE_USER_NOT_EXIST) {//用户不存在
    }else if (error.code == ERR_CODE_USER_NOT_LOGIN){//
        if ([UMComSession sharedInstance].uid) {
//            [UMComSession sharedInstance].uid = nil;
//            [UMComSession sharedInstance].token = nil;
        }
    }else if (error.code == ERR_CODE_USER_NO_PRIVILEGE){//对不起，你没有这个操作的权限
        if ([user.permissions containsObject:@"permission_delete_content"]) {
            NSMutableArray *permissions = [NSMutableArray arrayWithArray:user.permissions];
            [permissions removeObject:@"permission_delete_content"];
            user.permissions = permissions;
        }
        if ([user.permissions containsObject:@"permission_delete_content"]) {
            NSMutableArray *permissions = [NSMutableArray arrayWithArray:user.permissions];
            [permissions removeObject:@"permission_delete_content"];
            user.permissions = permissions;
        }
    }else if (error.code == ERR_CODE_USER_IDENTITY_INVAILD){//当前用户无效
        
    }else if (error.code == ERR_CODE_USER_HAVE_FOLLOWED){//你已经关注过了
        if ([user.relation intValue] == 2) {
            user.relation = @(3);
        }else{
            user.relation = @(1);
        }
    }else if (error.code == ERR_CODE_USER_FOLLOW_RELATION_NOT_EXIST){
        if ([user.relation intValue] == 3) {
            user.relation = @(2);
        }else{
            user.relation = @(0);
        }

    }else if (error.code == ERR_CODE_INVALID_AUTH_TOKEN){//token无效
        [[UMComSession sharedInstance] userLogout];
    }
}

/*****************************************************************************/
+ (void)handleFeedErrorWithFeed:(UMComFeed *)feed error:(NSError *)error
{
    if (error.code == ERR_CODE_FEED_UNAVAILABLE){//该内容已被删除
        feed.status = @3;
        [[NSNotificationCenter defaultCenter] postNotificationName:kUMComFeedDeletedFinishNotification object:feed];
    }else if (error.code == ERR_CODE_FEED_NOT_EXSIT){//该Feed不存在
        feed.status = @3;
        [[NSNotificationCenter defaultCenter] postNotificationName:kUMComFeedDeletedFinishNotification object:feed];
    }else if (error.code == ERR_CODE_FEED_HAS_BEEN_LIKED){//已经赞过
        feed.liked = @(1);
    }else if (error.code == ERR_CODE_LIKE_HAS_BEEN_CANCELED){//已经取消过赞啦
        feed.liked = @(0);
    }else if (error.code == ERR_CODE_HAS_ALREADY_COLLECTED){//你已经收藏过啦
        feed.has_collected = @1;
    }else if (error.code == ERR_CODE_HAS_NOT_COLLECTED){//还没有收藏
        feed.has_collected = @0;
    }
    [self handelUserErrorWithUser:[UMComSession sharedInstance].loginUser error:error];
}

+ (void)handleCommentErrorWithComment:(UMComComment *)comment error:(NSError *)error
{
    if (error.code == ERR_CODE_FEED_COMMENT_UNAVAILABLE){//该评论无效
        comment.status = @3;
    }else  if (error.code == ERR_CODE_FEED_HAS_BEEN_LIKED) {
        comment.liked = @1;
    }else if (error.code == ERR_CODE_LIKE_HAS_BEEN_CANCELED){
        comment.liked = @0;
    }
    if (error.code != ERR_CODE_FEED_COMMENT_UNAVAILABLE && error.code != ERR_CODE_LIKE_HAS_BEEN_CANCELED) {
        [self handleFeedErrorWithFeed:comment.feed error:error];
    }else{
        [self handelUserErrorWithUser:[UMComSession sharedInstance].loginUser error:error];
    }
}
/*****************************************************************************/
+ (void)handleTopicErrorWithTopic:(UMComTopic *)topic error:(NSError *)error
{
    if (error.code == ERR_CODE_HAVE_FOCUSED){//该话题已经被关注
        topic.is_focused = @1;
    }else if (error.code == ERR_CODE_NOT_EXIST){//该话题不存在
    }else if (error.code == ERR_CODE_HAVE_NOT_FOCUSED){//你还未关注该话题
        topic.is_focused = @0;
    }
    [self handelUserErrorWithUser:[UMComSession sharedInstance].loginUser error:error];
}

@end

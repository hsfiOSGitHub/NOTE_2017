//
//  UMComNotificationMacro.h
//  UMCommunity
//
//  Created by umeng on 15/11/13.
//  Copyright © 2015年 Umeng. All rights reserved.
//

#ifndef UMComNotificationMacro_h
#define UMComNotificationMacro_h
//Notification Name
#define kUserUpdateAvatarSucceedNotification @"kUserUpdateAvatarSucceedNotification" //更新头像成功
#define kUserUpdateProfileSucceedNotification @"kUserUpdateProfileSucceedNotification"//更新用户信息成功

#define kNotificationPostFeedResultNotification @"kNotificationPostFeedResultNotification"//feed发送完成通知
#define kUMComFeedDeletedFinishNotification @"kUMComFeedDeletedFinishNotification"//feed删除成功通知
#define kUMComCommentOperationFinishNotification @"kUMComCommentOperationFinishNotification"//评论发送完成通知
#define kUMComLikeOperationFinishNotification @"kUMComLikeOperationFinishNotification"//点赞或取消点赞操作完成通知
#define kUMComFavouratesFeedOperationFinishNotification @"kUMComFavouratesFeedOperationFinishNotification"//收藏或取消收藏操作完成通知


//话题关注通知
#define kUMComFollowTopicNotification @"kUMComFollowTopicNotification"//用户关注话题通知
#define kUMComFollowTopicIDKey        @"kUMComFollowTopicIDKey" //关注或取消关注的topicID的key
#define kUMComFollowTopicFollowKey    @"kUMComFollowTopicFollowKey"//是否关注


#endif /* UMComNotificationMacro_h */

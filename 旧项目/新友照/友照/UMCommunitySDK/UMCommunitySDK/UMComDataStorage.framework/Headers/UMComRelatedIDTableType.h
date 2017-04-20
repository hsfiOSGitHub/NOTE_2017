//
//  UMComRelatedIDTableType.h
//  UMCommunity
//
//  Created by 张军华 on 16/6/15.
//  Copyright © 2016年 Umeng. All rights reserved.
//

#ifndef _UMComRelatedIDTableType_
#define _UMComRelatedIDTableType_

#import <Foundation/Foundation.h>

/*
 *  此枚举变量是简单的对应当前登录用户做的relation关系的表，用户缓存第一页面的数据
 *  @dicuss 该枚举变量只是记录当前的relation的ID，用户作为第一页面的缓存
 */
typedef NS_ENUM(NSInteger, UMComRelatedIDTableType) {
    
    UMComRelatedRecommendNone,
    //feed流
    UMComRelatedRealTimeFeedID, /// UMComRequestType_RealTimeFeed //最新
    UMComRelatedRealTimeHotFeedID, /// UMComRequestType_RealTimeHotFeed //最热
    UMComRelatedRecommendFeedID,/// 推荐
    UMComRelatedFocusedFeedID,///关注
    UMComRelatedUserBeAtFeedID,///@我的feed流
    UMComRelatedUserFavoriteFeedID,///我的收藏feed流
    UMComRelatedUserFriendsFeedID,///朋友圈的feed流
    
    //user流
    UMComRelatedRegisterUserID,///注册用户的相关列表
    
    //topic流
    UMComRelatedAllTopicID, ///所有话题的topic流
    UMComRelatedRecommendTopicID,///推荐的topic流
    UMComRelatedFocusedTopicID,///我关注的topic流
    
    //topicType流
    UMComRelatedAllTopicTypeID,///所有话题类别的流
    
    //commentID流
    UMComRelatedReceiveCommentID,///收到的评论
    UMComRelatedSendCommentID,///发送的评论
    
    //albmID流
    UMComRelatedMyFavoriteAblumID,///我的相册
    
    //likeID流
    UMComRelatedReceiveLikeID,///收到的like
    
    //NotificationID流
    UMComRelatedReceiveNotificationID,///收到的NotificationID
    
    //用于测试的
    UMComRelatedImageUrlFeedID,
};

#endif

//@interface UMComRelatedIDTableType : NSObject
//
//@end

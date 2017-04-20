//
//  UMComNetworkConstant.h
//  UMComNetwork
//
//  Created by wyq.Cloudayc on 7/7/16.
//  Copyright © 2016 umeng. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  微社区host
 *  - 接口域名
 */
extern NSString * __nonnull const UMCommunityHost;

/**
 *  阿里百川host
 *  - 图片上传地址域名
 */
extern NSString * __nonnull const UMComABCHost;


extern NSString * __nonnull const UMComTokenKey;

extern NSString * __nonnull const UMComSDKVersion;

typedef void (^UMComHttpRequestCompletion)(id __nullable responseData, NSError * __nullable error);


#define SafeCompletionData(completion,data) if(completion){completion(data);}
#define SafeCompletionDataAndError(completion,data,error) if(completion){completion(data,error);}
#define SafeCompletionDataNextPageAndError(completion,data,haveNext,error) if(completion){completion(data,haveNext,error);}
#define SafeCompletionAndError(completion,error) if(completion){completion(error);}

#define kUMComCommunityInvalidErrorNotification @"kUMComCommunityInvalidErrorNotification"//社区被关闭导致请求错误的通知
#define kUMComUserDidNotLoginErrorNotification @"kUMComUserDidNotLoginErrorNotification"
#define kUMComTokenInvalidNotification @"kUMComTokenInvalidNotification"

/**
 登录source源
 @warming 这个枚举要跟Android保持一致
 */
typedef enum {
    UMComSnsTypeNone = -1,
    UMComSnsTypeSina = 1,
    UMComSnsTypeQQ,
    UMComSnsTypeWechat,
    UMComSnsTypeRenren,
    UMComSnsTypeDouban,
    UMComSnsTypeQzone,
    UMComSnsTypeTencent,
    UMComSnsTypeFacebook,
    UMComSnsTypeTwitter,
    UMComSnsTypeYixin,
    UMComSnsTypeInstagram,
    UMComSnsTypeTumblr,
    UMComSnsTypeLine,
    UMComSnsTypeKakaoTalk,
    UMComSnsTypeFlickr,
}UMComSnsType;


/**
 feed的评论列表排序类型
 
 */
typedef enum {
    UMComCommentSortType_Default = 0,//默认按时间倒序排序
    UMComCommentSortType_TimeDesc = 1,//按时间倒序排序
    UMComCommentSortType_TimeAsc = 2, //按时间正序排序
    UMComCommentSortType_LikeCount = 3,//按点赞次数倒序排列
}UMComCommentListSortType;


//enum
typedef enum {//用户名格式配置策略枚举类型
    userNameDefault = 0,                //默认格式
    userNameNoBlank = 1,                //不包含空格
    userNameNoRestrict = 2              //没有字符限制
}UMComUserNameType;

typedef enum {//用户名长度配置策略枚举类型
    userNameLengthDefault = 0,          //默认长度 2~20
    userNameLengthNoRestrict = 1        //1~50个字数
}UMComUserNameLength;




/**
 话题下feed的排序类型
 
 */
typedef enum{
    UMComTopicFeedSortType_default,
    UMComTopicFeedSortType_Comment,   //评论时间
    UMComTopicFeedSortType_Like,      //赞时间
    UMComTopicFeedSortType_Forward,     //转发时间
    UMComTopicFeedSortType_Action,       //评论或赞或转发时间
}UMComTopicFeedListSortType;

/**
 用户个人feed列表的排序类型
 
 */
typedef enum {
    UMComUserTimeLineFeedType_Default = 0,//默认返回所有feed
    UMComUserTimeLineFeedType_Origin = 1,//只获取原feed，不带转发
    UMComUserTimeLineFeedType_Forward = 2//只获取转发的feed
}UMComTimeLineFeedListType;




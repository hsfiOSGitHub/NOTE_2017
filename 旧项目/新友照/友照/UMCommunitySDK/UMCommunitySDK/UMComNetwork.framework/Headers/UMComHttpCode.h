//
//  UMComErrorCode.h
//  UMCommunity
//
//  Created by umeng on 15/9/9.
//  Copyright (c) 2015年 Umeng. All rights reserved.
//

#import <Foundation/Foundation.h>

//@sdk， 用户禁言请求接口添加两个异常码，分别是10027(用户不能被话题解禁)，10028(用户不能被话题禁言)

typedef enum {
    //===user===
    ERR_CODE_USER_NOT_EXIST = 10002,//用户不存在
    ERR_CODE_USER_NOT_LOGIN = 10003,//未登录
    ERR_CODE_USER_NO_PRIVILEGE = 10004,//没有操作权限
    ERR_CODE_USER_IDENTITY_INVAILD = 10005,//无效用户ID
    ERR_CODE_USER_HAS_CREATED = 10006,//用户已被创建
    ERR_CODE_USER_HAVE_FOLLOWED = 10007,//已经关注过了
    ERR_CODE_USER_LOGIN_INFO_NOT_COMPLETE = 10008,//登录信息不全
    ERR_CODE_USER_CANNOT_FOLLOW_SELF = 10009,//用户不能自己关注自己
    ERR_CODE_USER_NAME_LENGTH_ERROR = 10010,//用户名长度错误
    ERR_CODE_USER_IS_UNUSABLE = 10011,//用户已被删除
    ERR_CODE_USER_NAME_SENSITIVE = 10012,//用户名包含敏感词汇
    ERR_CODE_USER_NAME_DUPLICATE = 10013,//用户名重复
    ERR_CODE_USER_CUSTOM_LENGTH_ERROR = 10014,//用户名长度
    ERR_CODE_ONE_TIME_ONE_USER = 10015,//同一时间只允许一个用户操作
    ERR_CODE_USER_NAME_CONTAINS_ILLEGAL_CHARS = 10016,//用户名包含非法字符
    ERR_CODE_DEVICE_IN_BLACKLIST = 10017,//设备已被列入黑名单
    ERR_CODE_FAVOURITES_OVER_LIMIT = 10018,//收藏列表已达上限
    ERR_CODE_HAS_ALREADY_COLLECTED = 10019,//Feed已被收藏
    ERR_CODE_HAS_NOT_COLLECTED = 10020,//还为收藏或已经取消收藏了
    ERR_CODE_MEDAL_NOT_EXIST = 10021,//勋章不存在
    ERR_CODE_MEDALNAME_DUPLICATE =10022,//勋章名重复
    ERR_CODE_USER_HAS_BEEN_BAN =10023,//已经举报过了
    ERR_CODE_USER_HAS_THIS_MEDAL =10024,//勋章已经存在
    ERR_CODE_USER_CANNOT_BE_LIFTED =10027,//用户不能被话题解禁
    ERR_CODE_USER_CANNOT_BE_BAN =10028,//用户不能被话题禁言
    ERR_CODE_USER_FOLLOW_RELATION_NOT_EXIST = 10029,//用户不存在任何关系
    ERR_CODE_USER_PWD_ERROR =10031,//用户密码错误
    ERR_CODE_STRING_CANNOT_CONVERT_TO_INTEGER=11000,//此字符串无法转换成int类型
    ERR_CODE_THERE_ISNOT_CHAT_CHANNEL_BETWEEN_THESE_USERS = 11001,//两用户之间无法进行私信聊天
    ERR_CODE_MESSAGE_CONTENT_IS_EMPTY = 11002,//消息内容为空
    ERR_CODE_MESSAGE_TOO_LONG = 11003,//消息内容太长
    ERR_CODE_CANNOT_SEND_MESSAGE_TO_USER_SELF = 11004,//不能自己给自己发送私信
    //===Feed===
    ERR_CODE_FEED_UNAVAILABLE = 20001,//该Feed已被删除
    ERR_CODE_FEED_NOT_EXSIT = 20002,//该Feed不存在
    ERR_CODE_FEED_HAS_BEEN_LIKED = 20003,//该Feed已经被赞过
    ERR_CODE_FEED_RELATED_USER_ID_INVALID = 20004,//相关用户ID无效
    ERR_CODE_FEED_CANNOT_FORWARD = 20005,//该Feed不能转发
    ERR_CODE_FEED_RELATED_TOPIC_ID_INVALID = 20006,//相关话题ID无效
    ERR_CODE_COMMENT_CONTENT_LENGTH_ERROR = 20007,//评论内容长度错误
    ERR_CODE_FEED_CONTENT_LENGTH_ERROR = 20008,//Feed内容长度错误
    ERR_CODE_FEED_TYPE_INVALID = 20009,//Feed类型无效
    ERR_CODE_FEED_CUSTOM_LENGTH_ERROR = 20010,//Feed自定义字段长度错误
    ERR_CODE_FEED_SHARE_CALLBACK_PLATFORM_ERROR = 20011,//Feed分享平台错误
    ERR_CODE_LIKE_HAS_BEEN_CANCELED = 20012,//Feed点赞已被取消
    ERR_CODE_TITLE_LENGTH_ERROR = 20013,//Feed title 长度错误
    ERR_CODE_FEED_COMMENT_UNAVAILABLE = 20014,//该评论已被删除
    ERR_CODE_FEED_IS_LOCKED = 20015,//Feed已被锁住
    ERR_CODE_FEED_CANNOT_FORWARD_RICH_TEXT_FEED = 20016,//富文本Feed不能被转发
    ERR_CODE_FEED_DUPLICATEDFEED_INSHORTTIME = 20024,//短时间内发送相同内容的feed的错误码
    //===topic==
    ERR_CODE_HAVE_FOCUSED = 30001,//话题已被关注
    ERR_CODE_NOT_EXIST = 30002,//话题不存在
    ERR_CODE_TOPIC_CANNOT_CREATE = 30003,//该话题不能被创建
    ERR_CODE_TOPIC_RANK_ERROR = 30004,//无效话题组
    ERR_CODE_HAVE_NOT_FOCUSED = 30005,//话题未关注或已被取消关注
    ERR_CODE_Topic_Secret = 30014,//此话题对此用户加密
    //===spammer===
    ERR_CODE_STATUS_INVILD = 40001,//举报操作无效
    ERR_CODE_SPAMMER_HAS_CREATED = 40002,//已经举报过了
    ERR_CODE_INVALID_TYPE = 40003,//无效举报类型
    ERR_CODE_SPAMMER_HAS_BEEN_CREATED = 40004,//用户已被举报
    //===midgard_common===
    ERR_CODE_REQUEST_PRARMS_ERROR = 50001,//请求参数错误
    ERR_CODE_IMAGE_UPLOAD_FAILED = 50002,//图片上传失败
    ERR_CODE_INVALID_AUTH_TOKEN = 50003,//token无效
    ERR_CODE_ACCESS_TOKEN_EXPIRED = 50005,//token过期
    ERR_CODE_DECRYPT_DATA_INCORREC = 50007,//加密数据错误
    ERR_CODE_ENCRYPTED_DATA_IS_INCOMPLETE = 50008,//加密数据不完整
    ERR_CODE_REQUEST_MISS_THE_ACCESS_TOKEN = 50009,//请求token为空
    //Community
    ERR_CODE_INVALID_COMMUNITY = 70017,//社区无效
    //APPKEY
    ERR_CODE_INVALID_COMMUNITY_APPKEY = 70011,//appkey无效
    ERR_CODE_REQUEST_TOO_OFTEN = 121212,//同一个请求太过频繁
    //error urlpath
    ERR_CODE_NULL_URLPATH = 121213,//空url
    
}UMComErrorCodeType;

//user
extern  NSString * const  ERR_MSG_USER_BASE_INFO_NOT_COMPLETE;
extern  NSString * const  ERR_MSG_USER_NOT_EXIST;
extern  NSString * const  ERR_MSG_USER_NOT_LOGIN;
extern  NSString * const  ERR_MSG_USER_NO_PRIVILEGE;
extern  NSString * const  ERR_MSG_USER_IDENTITY_INVAILD;
extern  NSString * const  ERR_MSG_USER_HAS_CREATED;
extern  NSString * const  ERR_MSG_USER_HAVE_FOLLOWED;
extern  NSString * const  ERR_MSG_USER_LOGIN_INFO_NOT_COMPLETE;
extern  NSString * const  ERR_MSG_USER_PWD_ERROR;
extern  NSString * const  ERR_MSG_USER_CANNOT_FOLLOW_SELF;
extern  NSString * const  ERR_MSG_USER_NAME_LENGTH_ERROR;
extern  NSString * const  ERR_MSG_USER_IS_UNUSABLE;
extern  NSString * const  ERR_MSG_USER_NAME_SENSITIVE;
extern  NSString * const  ERR_MSG_USER_NAME_DUPLICATE;
extern  NSString * const  ERR_MSG_USER_CUSTOM_LENGTH_ERROR;
extern  NSString * const  ERR_MSG_ONE_TIME_ONE_USER_ERROR;
extern  NSString * const  ERR_MSG_USER_NAME_CONTAINS_ILLEGAL_CHARS;
extern  NSString * const  ERR_MSG_DEVICE_IN_BLACKLIST;
extern  NSString * const  ERR_MSG_FAVOURITES_OVER_LIMIT;
extern  NSString * const  ERR_MSG_HAS_ALREADY_COLLECTED;
extern  NSString * const  ERR_MSG_HAS_NOT_COLLECTED;
extern  NSString * const  ERR_MSG_MEDAL_NOT_EXIST;
extern  NSString * const  ERR_MSG_MEDALNAME_DUPLICATE;
extern  NSString * const  ERR_MSG_USER_HAS_BEEN_BAN;
extern  NSString * const  ERR_MSG_USER_HAS_THIS_MEDAL;
extern  NSString * const  ERR_MSG_STRING_CANNOT_CONVERT_TO_INTEGER;
extern  NSString * const  ERR_MSG_THERE_ISNOT_CHAT_CHANNEL_BETWEEN_THESE_USERS;
extern  NSString * const  ERR_MSG_MESSAGE_CONTENT_IS_EMPTY;
extern  NSString * const  ERR_MSG_MESSAGE_TOO_LONG;
extern  NSString * const  ERR_MSG_CANNOT_SEND_MESSAGE_TO_USER_SELF;

//feed
extern  NSString * const  ERR_MSG_FEED_UNAVAILABLE;
extern  NSString * const  ERR_MSG_FEED_NOT_EXSIT;
extern  NSString * const  ERR_MSG_FEED_HAS_BEEN_LIKED;
extern  NSString * const  ERR_MSG_FEED_RELATED_USER_ID_INVALID;
extern  NSString * const  ERR_MSG_FEED_CANNOT_FORWARD;
extern  NSString * const  ERR_MSG_FEED_RELATED_TOPIC_ID_INVALID;
extern  NSString * const  ERR_MSG_COMMENT_CONTENT_LENGTH_ERROR;
extern  NSString * const  ERR_MSG_FEED_CONTENT_LENGTH_ERROR;
extern  NSString * const  ERR_MSG_FEED_CUSTOM_LENGTH_ERROR;
extern  NSString * const  ERR_MSG_FEED_TYPE_INVALID;
extern  NSString * const  ERR_MSG_FEED_SHARE_CALLBACK_PLATFORM_ERROR;
extern  NSString * const  ERR_MSG_LIKE_HAS_BEEN_CANCELED;
extern  NSString * const  EER_MSG_TITLE_LENGTH_ERROR;
extern  NSString * const  ERR_MSG_FEED_COMMENT_UNAVAILABLE;
extern  NSString * const  ERR_MSG_FEED_IS_LOCKED;
extern  NSString * const  ERR_MSG_FEED_CANNOT_FORWARD_RICH_TEXT_FEED;
extern  NSString * const  ERR_MSG_FEED_DUPLICATEDFEED_INSHORTTIME;


//topic
extern  NSString * const  ERR_MSG_HAVE_FOCUSED;
extern  NSString * const  ERR_MSG_NOT_EXSIT;
extern  NSString * const  ERR_MSG_TOPIC_CANNOT_CREATE;
extern  NSString * const  ERR_MSG_HAVE_NOT_FOCUSED;
extern  NSString * const  ERR_MSG_TOPIC_RANK_ERROR;
extern  NSString * const  ERR_MSG_TOPIC_SECRET;

//spammer
extern  NSString * const  ERR_MSG_STATUS_INVILD;
extern  NSString * const  ERR_MSG_SPAMMER_HAS_CREATED;
extern  NSString * const  ERR_MSG_INVALID_TYPE;
extern  NSString * const  ERR_MSG_SPAMMER_HAS_BEEN_CREATED;

//===midgard_commen===
extern  NSString * const  ERR_MSG_REQUEST_PRARMS_ERROR;
extern  NSString * const  ERR_MSG_IMAGE_UPLOAD_FAILED;
extern  NSString * const  ERR_MSG_INVALID_AUTH_TOKEN;

//Community
extern  NSString * const  ERR_MSG_INVALID_COMMUNITY;

//Appekey
extern  NSString * const  ERR_MSG_INVALID_COMMUNITY_APPKEY;

//error urlpath
extern  NSString * const  ERR_MSG_NULL_URLPATH;//空url


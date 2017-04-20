//
//  UMComUser.h
//  UMCommunity
//
//  Created by umeng on 15/11/20.
//  Copyright (c) 2015年 Umeng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "UMComModelObject.h"


typedef enum IconType {
    UMComIconSmallType,
    UMComIconMiddleType,
    UMComIconLargeType
} UMComIconType;


//#pragma mark - 固定的base属性
//
//#pragma mark - 固定的relation属性
//
//#pragma mark - 可变的基本属性(随着情景值会发生变化)
//
//#pragma mark - 可变的relation属性(随着情景值会发生变化)
//
//#pragma mark - 自定义字段
//
//#pragma mark -

@class UMComAlbum, UMComComment, UMComFeed, UMComLike, UMComTopic, UMComUser,UMComPrivateLetter,UMComPrivateMessage,UMComImageUrl,UMComMedal,UMComCreatorIconUrl;



@interface UMComUser : UMComModelObject


#pragma mark - 固定的base属性

/**用户在友盟微社区的uid，可以作为用户在社区里的唯一标识*/
@property (nonatomic, retain) NSString * uid;
/**0表示普通用户；1表示全局管理员；2暂时没用；3创建社区时的默认管理员；4.话题管理员。*/
@property (nonatomic, retain) NSNumber * atype;
/**等级*/
@property (nonatomic, retain) NSNumber * level;
/**开发者自己账号系统的用户id*/
@property (nonatomic, retain) NSString * source_uid;
/*用户状态：0#正常，1#被举报，2#垃圾用户，3#删除用户(用户自己删除)，4#删除用户(管理员删除), 5#包含敏感词, 6#话题下垃圾用户**/
@property (nonatomic, retain) NSNumber * status;
/**用户名*/
@property (nonatomic, retain) NSString * name;
/**性别*/
@property (nonatomic, retain) NSNumber * gender;
/*是否被关注*/
@property (nonatomic, retain) NSNumber * has_followed;
/**自定义字段，扩展字段*/
@property (nonatomic, retain) NSString * custom;

#pragma mark - 固定的relation属性
/**用户头像icon_url数据模型*/
@property (nonatomic, retain) UMComCreatorIconUrl *icon_url;
/**勋章列表*/
@property (nonatomic, retain) NSArray *medal_list;

#pragma mark - 可变的基本属性(随着情景值会发生变化)
/**关注的话题数,登陆用户个人中心下该属性有意义*/
@property (nonatomic, retain) NSNumber * topic_focused_count;

/**关注的人的个数,登陆用户个人中心下该属性有意义*/
@property (nonatomic, retain) NSNumber * following_count;

/**友盟微社区积分系统下的积分*/
@property (nonatomic, retain) NSNumber * point;

/*是否是推荐用户*/
@property (nonatomic, retain) NSNumber * is_recommended;
/*???*/
@property (nonatomic, retain) NSNumber * accout_type;
/**粉丝数*/
@property (nonatomic, retain) NSNumber * fans_count;
/**年龄*/
@property (nonatomic, retain) NSNumber * age;
/**用户的注册账号平台名称*/
@property (nonatomic, retain) NSString * source;
/**开发者自己账号积分系统的积分*/
@property (nonatomic, retain) NSNumber * score;
/**点赞个数*/
@property (nonatomic, retain) NSNumber * like_count;
/**创建Feed的个数*/
@property (nonatomic, retain) NSNumber * feed_count;
/**用户等级的名称*/
@property (nonatomic, retain) NSString * level_title;

/**关系字段 （0:无关系， 1:关注， 2:被关注， 3:双向关注）*/
@property (nonatomic, retain) NSNumber * relation;

/**被点赞个数*/
@property (nonatomic, retain) NSNumber * liked_count;

///**被@个数*/
//@property (nonatomic, retain) NSNumber * be_at_count;
///**评论个数*/
//@property (nonatomic, retain) NSNumber * comment_count;

/* 用户距离 since 2.5.0 */
@property (nullable,nonatomic, retain) NSNumber * distance;

#pragma mark - 可变的relation属性(随着情景值会发生变化)
//个人中心会返回
/**权限字段 (结构是数据，如果有管理权限的话保存的是字符串是@"permission_delete_content",@"permission_bulletin") permission_delete_content删除权限，permission_bulletin发公告权限*/
@property (nullable,nonatomic, retain) NSArray* permissions;

#pragma mark - 自定义字段

#pragma mark - 登录用户返回的字段(第一次登录的时候，返回下面的字段)
/** 货币,与积分对应  since 2.5.0*/
@property (nullable,nonatomic,retain) NSNumber* cur_currency;

/** 当前锁定的货币  since 2.5.0*/
@property (nullable, nonatomic, retain) NSNumber *lock_currency;

/**是否第一次登录*/
@property (nullable,nonatomic, retain) NSNumber* registered;

/** 未读消息数量 (与user/initial_data的接口函数中的未读消息数totalNotiCount一样,此变量不用，通过user/initial_data的接口获得最全的用户未读信息)*/
@property (nullable,nonatomic,retain) NSNumber* unread_count;


#pragma mark -

/***/
//@property (nonatomic, retain) NSNumber * sum;

///**相册*/
//@property (nonatomic, retain) UMComAlbum *album;
///**评论列表*/
//@property (nonatomic, retain) NSArray *comment;
///**粉丝列表*/
//@property (nonatomic, retain) NSArray *fans;
///**创建的Feed列表*/
//@property (nonatomic, retain) NSArray *feeds;
///**关注的用户列表*/
//@property (nonatomic, retain) NSArray *followers;
///**点赞列表*/
//@property (nonatomic, retain) NSArray *likes;
///**相关的Feed列表*/
//@property (nonatomic, retain) NSArray *related_feeds;
///**回复的评论列表*/
//@property (nonatomic, retain) NSArray *reply_comments;
///**关注的话题列表*/
//@property (nonatomic, retain) NSArray *topics;
///**私信列表*/
//@property (nonatomic, retain) NSArray *private_letters;
///**私信消息列表*/
//@property (nonatomic, retain) NSArray *private_messages;

- (NSString *)iconUrlStrWithType:(UMComIconType)type;



@end



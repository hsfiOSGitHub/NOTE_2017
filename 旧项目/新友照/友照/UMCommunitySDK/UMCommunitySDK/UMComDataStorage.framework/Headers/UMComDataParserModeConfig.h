//
//  UMComDataParserModeConfig.h
//  UMCommunity
//
//  Created by 张军华 on 16/5/6.
//  Copyright © 2016年 Umeng. All rights reserved.
//

#import <Foundation/Foundation.h>



typedef NS_ENUM(NSInteger, UMComDataType)
{
    UMComDataType_None               = 0,
    /*单个的entity的类型*/
    UMComDataType_Feed               = 1,       ///单个Feed
    UMComDataType_User               = 2,       ///单个User
    UMComDataType_Medal              = 3,       ///单个Medal
    UMComDataType_ImageUrl           = 4,       ///单个ImageUrl
    UMComDataType_CreatorIconUrl     = 5,       ///单个用户的url对象
    UMComDataType_TopicIconUrls      = 6,       ///话题的iconurls对象
    UMComDataType_Topic              = 7,       ///单个Topic
    UMComDataType_TopicGroup         = 8,       ///单个TopicGroup
    UMComDataType_Like               = 9,       ///单个Like
    UMComDataType_Comment            = 10,      ///单个Comment
    UMComDataType_Album              = 11,      ///单个Album
    UMComDataType_Notification       = 12,      ///单个Notification
    UMComDataType_PrivateMessage     = 13,      ///单个PrivateMessage
    UMComDataType_PrivateLetter      = 14,      ///单个PrivateLetter
    UMComDataType_Location           = 15,      ///单个Location
    
    //积分相关类型(since 2.5)
    UMComDataType_PointResult        = 16,       ///积分的结果
    UMComDataType_PointDetail        = 17,       ///积分的明细
    UMComDataType_CurrencyDetail     = 18,      ///货币的明细
};

//@interface UMComDataParserModeConfig : NSObject
//
//@end

//定义是否需要内存中唯一的UMComModelObject
#define UniquedUMComModelObject


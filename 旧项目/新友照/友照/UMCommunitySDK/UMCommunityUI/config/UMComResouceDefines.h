//
//  UMComResouceDefines.h
//  UMCommunity
//
//  Created by luyiyuan on 14/10/9.
//  Copyright (c) 2014年 Umeng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "UMComResourceManager.h"

#define UMComLocalizedString(key,defaultValue) NSLocalizedStringWithDefaultValue(key,@"UMCommunityStrings",[NSBundle mainBundle],defaultValue,nil)

#define UMComUIScaleBetweenCurentScreenAndiPhone6Screen [UIScreen mainScreen].bounds.size.width/375  //屏幕适配系数比(以iPhone6的屏幕宽度为基准)

#define UMComWidthScaleBetweenCurentScreenAndiPhone6Screen(width) width*UMComUIScaleBetweenCurentScreenAndiPhone6Screen


#define UMComFontNotoSansLightWithSafeSize(FontSize) [UIFont fontWithName:@"FZLanTingHei-L-GBK-M" size:FontSize*UMComUIScaleBetweenCurentScreenAndiPhone6Screen]?[UIFont fontWithName:@"FZLanTingHei-L-GBK-M" size:FontSize*UMComUIScaleBetweenCurentScreenAndiPhone6Screen]:[UIFont systemFontOfSize:FontSize]

#define UMComImageWithImageName(imageName) [UMComResourceManager UMComImageWithImageName:imageName]

#define UMComImageName(imangeName) [NSString stringWithFormat:@"UMComSimpleSDKResources.bundle/images/%@",imageName]

#define UMComSimpleImageWithImageName(imageName) [UIImage imageNamed:[NSString stringWithFormat:@"UMComSimpleSDKResources.bundle/images/%@",imageName]]


#define UMComTableViewSeparatorColor UMComColorWithHexString(@"#F5F6FA")


#define FontColorForFeedLike        @"#a5a5a5"
#define FontColorForFeedComment     @"#a5a5a5"
#define FontColorForFeedLocation    @"#a5a5a5"
#define FontColorForFeedNickName    @"#a5a5a5"


//常用颜色值
#define FontColorGray @"#666666"
#define FontColorBlue @"#4A90E2"
#define FontColorLightGray @"#8E8E93"
#define TableViewSeparatorColor @"#C8C7CC"
#define FeedTypeLabelBgColor @"#DDCFD5"
#define LocationTextColor  @"#9B9B9B"
#define ViewGreenBgColor @"#B8E986"
#define ViewGrayColor    @"#D8D8D8"
#define LightGrayColor  @"#ececec"

#define UMCom_Feed_BgColor @"#F5F6FA"

#define UMCom_ForumUI_Title_Color  @"#666666"
#define UMCom_ForumUI_Title_Font  20

#define TableViewCellSpace  0.3
#define BottomLineHeight    0.3

#define TopicRulerString @"(#([^*]+)#)" //匹配 “#所有字符#”
#define UserRulerString @"(@[^ ]+)" //匹配 “@所有字符 ” 后面要有个空格
#define UrlRelerSring   @"((http[s]{0,1}|ftp)://[a-zA-Z0-9\\.\\-]+\\.([a-zA-Z]{2,4})(:\\d+)?(/[a-zA-Z0-9\\,\\.\\-~!@#$%^&*+?:_/=<>]*)?)|(www.[a-zA-Z0-9\\.\\-]+\\.([a-zA-Z]{2,4})(:\\d+)?(/[a-zA-Z0-9\\,\\.\\-~!@#$%^&*+?:_/=<>]*)?)" //匹配url

#define TopicString     @"#%@#"
#define UserNameString  @"@%@"




//Common block
typedef void (^PageDataResponse)(id responseData,NSString * navigationUrl,NSError *error);

typedef void (^LoadDataCompletion)(NSArray *data, NSError *error);

typedef void (^LoadServerDataCompletion)(NSArray *data, BOOL haveChanged, NSError *error);

typedef void (^LoadChangedDataCompletion)(NSArray *data);

typedef void (^PostDataResponse)(NSError *error);

extern NSString * createTimeString(NSString * create_time);

extern NSString *countString(NSNumber *count);

extern NSString *distanceString(NSNumber *count);


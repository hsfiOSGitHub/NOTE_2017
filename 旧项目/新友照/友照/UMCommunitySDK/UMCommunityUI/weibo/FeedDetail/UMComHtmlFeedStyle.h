//
//  UMComHtmlFeedStyle.h
//  UMCommunity
//
//  Created by 张军华 on 16/3/21.
//  Copyright © 2016年 Umeng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#define UMCom_Micro_FeedContentLength 300

#define OriginUserNameString @"@%@：%@"

#define LocationBackgroundViewHeight 21
#define UserNameLabelViewHeight      20 //用户名字控件的高度

#define UMCom_Micro_Feed_CellBgCollor @"#F5F6FA" //feed背景的颜色
#define UMCom_Micro_Feed_NameCollor @"#333333"//feed名字的颜色
#define UMCom_Micro_Feed_CreateTimeCollor @"#A5A5A5"//feed时间的颜色
#define UMCom_Micro_Feed_ContentCollor @"#666666"//feed内容的颜色
#define UMCom_Micro_Feed_LocationCollor @"#A5A5A5"//feed位置的颜色

#define UMCom_Micro_FeedContent_FontSize 15
#define UMCom_Micro_FeedName_FontSize 14

#define UMCom_Micro_Feed_Avata_Width 39
#define UMCom_Micro_Feed_Avata_Height 39
#define UMCom_Micro_Feed_Avata_LeftEdge  11
#define UMCom_Micro_Feed_Avata_TopEdge  16 //头像的上边距（和name共用）


#define UMCom_Micro_FeedContent_LeftEdge 11 //内容的左边距
#define UMCom_Micro_FeedContent_RightEdge 11//内容的右边距
#define UMCom_Micro_FeedContent_TopEdge 16  //内容的上边距
#define UMCom_Micro_FeedContent_BottomEdge 11  //内容的下边距


#define UMCom_Micro_Feed_SpaceBetweenNameAndAvata 10 //水平方向头像和名字的间距
#define UMCom_Micro_Feed_SpaceBetweenNameAndTime 6 //垂直方向名字和时间的间距
#define UMCom_Micro_Feed_CreateTimeHeight 12 //时间的高度


#define UMCom_Micro_Feed_LocationNameTopMargin 26
#define UMCom_Micro_Feed_LocationNameMaxWidth 60
#define UMCom_Micro_Feed_LocationNameMaxHeight 15

#define UMCom_Micro_Feed_SpaceBetweenLocationNameAndIMG 2 //水平方向地理位置和图片的间距

#define UMCom_Micro_Feed_LocationIMGWidth 10
#define UMCom_Micro_Feed_LocationIMGHeight 15

#define UMCom_Micro_Feed_SpaceBetweenAvataAndWebView 10 //头像和webview的间距
#define UMCom_Micro_Feed_WebViewDefaultHeight 0 //webView的默认高度

#define FeedFont UMComFontNotoSansLightWithSafeSize(UMCom_Micro_FeedContent_FontSize)

@class UMComFeed,UMComLocation;

/**
 *  feed详情页面的数据模型
 */
@interface UMComHtmlFeedStyle : NSObject
/**
 *  高亮话题的数组
 */
@property(nonatomic,readwrite,strong)NSMutableArray* topicArray;

/**
 *  高亮的用户需要的数组
 */
@property(nonatomic,readwrite,strong)NSMutableArray* userNameArray;


//总共的高度
@property (nonatomic,assign) float totalHeight;


@property (nonatomic, strong) UMComFeed *feed;
@property (nonatomic, strong) UMComLocation *locationModel;

@property (nonatomic, assign) BOOL isShowTopImage;//是否显示置顶

@property(nonatomic,assign) CGFloat cellWidth;//cell的宽度
@property(nonatomic,assign) CGFloat contentWidth;//内容的宽度
@property(nonatomic,assign) CGFloat contentOrginX;//内容的左上角x(name,content,img,转发的feed的背景公用)
@property(nonatomic,assign) CGFloat webViewHeight;//webview的高度


- (instancetype)initWithFeed:(UMComFeed *)feed viewWidth:(float)viewWidth;

- (void)resetWithFeed:(UMComFeed *)feed;

@end

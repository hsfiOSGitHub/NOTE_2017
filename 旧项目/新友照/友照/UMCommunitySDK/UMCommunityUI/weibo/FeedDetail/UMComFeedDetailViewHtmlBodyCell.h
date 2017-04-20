//
//  UMComFeedDetailViewHtmlBodyCell.h
//  UMCommunity
//
//  Created by 张军华 on 16/3/21.
//  Copyright © 2016年 Umeng. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "UMComFeedsTableViewCell.h"




@class UMComFeedStyle,UMComFeed,UMComMutiStyleTextView, UMComImageView,UMComGridViewfeed,UMComWebView,UMComGridView,UMComHtmlFeedStyle,UMComFeedDetailViewHtmlBodyCell;
@protocol UMComClickActionDelegate;

@protocol UMComHtmlBodyCellDelegate <NSObject>

@optional
//html加载完成回调
-(void)UMComHtmlBodyCellDidFinishLoad:(UMComFeedDetailViewHtmlBodyCell*)cell;

-(void)handleClickCell:(UMComFeedDetailViewHtmlBodyCell*)cell withDataObject:(id)object userInfo:(NSDictionary*)userInfo;
@end

/**
 *  微博版本的feed详情页面显示feed富文本的cell
 *  @discuss feed的详情页面主体内容用UIWebView显示
 */
@interface UMComFeedDetailViewHtmlBodyCell : UITableViewCell

@property (nonatomic, strong) UMComFeed *feed;

//整个feed详情的背景
@property (nonatomic,strong)  UIView *feedBgView;

//置顶的图片
@property (nonatomic,strong)  UIImageView *topImage;
//加精的图片
@property (nonatomic,strong)  UIImageView *eletImage;
//公告的图片
@property (nonatomic,strong)  UIImageView *publicImage;

//用户的名字
@property (nonatomic, strong) UILabel *nameLabel;
//用户的图片
@property (nonatomic, strong)  UMComImageView *portrait;
//feed的创建时间
@property (nonatomic, strong) UILabel *createTime;

//位置图片
@property(nonatomic,strong) UMComImageView* loacationIMG;
//位置的名称
@property(nonatomic,strong) UILabel* loacationName;


//显示feed详情的webview
@property(nonatomic,readwrite,strong)UMComWebView* webView;

@property (nonatomic, weak) id<UMComClickActionDelegate> delegate;
@property (nonatomic, strong) NSIndexPath *indexPath;
@property (nonatomic, strong) UMComHtmlFeedStyle *feedStyle;
@property (nonatomic, assign) CGFloat cellBgViewTopEdge;

@property (nonatomic,weak)UITableView* tableview;
@property (nullable, nonatomic, weak) id <UMComHtmlBodyCellDelegate> UMComHtmlBodyCellDelegate;




/**
 *  布局包含html的富文本feed
 *
 *  @param feedStyle
 *  @param tableView
 *  @param indexPath
 */
- (void)layoutFeedWithfeedStyle:(UMComHtmlFeedStyle *)feedStyle tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;


@end

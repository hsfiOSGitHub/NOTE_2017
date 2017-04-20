//
//  UMComFeedsTableViewCell.h
//  UMCommunity
//
//  Created by Gavin Ye on 8/27/14.
//  Copyright (c) 2014 Umeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UMComFeedClickActionDelegate.h"
#import <UMCommunitySDK/UMComDataTypeDefine.h>

#define UMCom_Feed_Image_Space 6
#define UMCom_FeedContent_LineSpace 4
#define UMCom_FeedCellItem_Vertical_Space 10


static NSString *kUMComSimpleFeedCellId = @"kUMComSimpleFeedCellId";
static NSString *kUMComSimpleFeedCellName = @"UMComSimpleFeedTableViewCell";


@class UMComFeed,UMComLabel, UMComImageView,UMComSimpleGridView, UMComFeedImageCollectionView,UMComUser,UMComTopic, UMComMutiStyleTextView, UMComMutiText;

@interface UMComSimpleFeedTableViewCell : UITableViewCell

@property (nonatomic, weak) UMComFeed *feed;

@property (weak, nonatomic) IBOutlet UIView *feedBgView;

@property (weak, nonatomic) IBOutlet UIView *topListView;
@property (weak, nonatomic) IBOutlet UIImageView *topImage;
@property (weak, nonatomic) IBOutlet UIImageView *eletImage;
@property (weak, nonatomic) IBOutlet UIImageView *publicImage;
@property (weak, nonatomic) IBOutlet UIView *imageAndNameBgView;

@property (weak, nonatomic) IBOutlet UIImageView *avatorImage;

@property (nonatomic, weak) IBOutlet UILabel *nameLabel;

@property (weak, nonatomic) IBOutlet UIView *medalBgView;

@property (weak, nonatomic) IBOutlet UIImageView *favoriteImageView;

@property (weak, nonatomic) IBOutlet UIButton *topicButton;

@property (nonatomic, strong)  UMComImageView *portrait;

@property (nonatomic, weak) IBOutlet UMComMutiStyleTextView *feedTextView;

@property (weak, nonatomic) IBOutlet UMComSimpleGridView *imageGridView;

@property (weak, nonatomic) IBOutlet UILabel *dateLabel;

//
@property (weak, nonatomic) IBOutlet UIView *bottomMenuBgView;


@property (weak, nonatomic) IBOutlet UIButton *likeButton;
@property (weak, nonatomic) IBOutlet UIButton *commentButton;


@property (nonatomic, strong) NSArray *imageArray;

@property (nonatomic, strong) UMComMutiText *feedMutiText;

@property (nonatomic, weak) id<UMComFeedClickActionDelegate> delegate;

@property (nonatomic, strong) NSIndexPath *indexPath;

@property (nonatomic, strong) UMComFeedImageCollectionView *feedImageCollectionView;


//置顶Feed的类型
@property(nonatomic,assign)UMComTopFeedType topFeedType;

@property (nonatomic, assign) BOOL showFavoriteStatus;

- (void)reloadSubViewsFeed:(UMComFeed *)feed;

- (IBAction)clickOnLikeButton:(id)sender;

- (IBAction)clickOnCommentButton:(id)sender;

- (IBAction)clickOnTopicButton:(UIButton *)sender;


#pragma mark - 约束

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topItemListViewHeightConstraint;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topImageWidthConstraint;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *elitImageWidthConstraint;


@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topicButtonWidthConstraint;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *favoriteImageWidthConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *medalImageWidthConstraint;
//
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *nameLabelWidthConstraint;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *medalTrailingToSuperViewConstraint;

//头像约束
/**
 *头像到topItemListView的约束
 */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *avatorTopSpaceToTopConstraint;

/**
 *feed图片背景到feedView的约束
 */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *feedImageTopSpaceToFeedConstraint;

/**
 *dateLabel到feed图片的约束
 */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *dateTopSpaceToFeedImageConstraint;
/**
 *feed图片显示区域的高度约束
 */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *feedImageViewHeightConstraint;

/**
 *feed文字高度约束
 */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *feedTextViewHeightConstraint;


#pragma mark -

/**
 *  是否显示话题名字
 *  @discuss 在TopicFeed界面,显示的都是topic下的feed，因此不需要显示话题名字
 */
@property(nonatomic,assign)BOOL isHideTopicName;


@end

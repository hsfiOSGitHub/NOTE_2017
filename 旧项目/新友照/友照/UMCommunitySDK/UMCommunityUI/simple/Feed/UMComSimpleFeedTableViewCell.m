//
//  UMComFeedsTableViewCell.m
//  UMCommunity
//
//  Created by Gavin Ye on 8/27/14.
//  Copyright (c) 2014 Umeng. All rights reserved.
//

#import "UMComSimpleFeedTableViewCell.h"
#import <UMCommunitySDK/UMComSession.h>
#import <UMComDataStorage/UMComTopic.h>
#import "UMComImageView.h"
#import "UMComSimpleGridView.h"
#import "UMComResouceDefines.h"
#import <UMComDataStorage/UMComLocation.h>
#import "UMComMedalImageView.h"
#import <UMComDataStorage/UMComFeed.h>
#import <UMComDataStorage/UMComUser.h>
#import <UMComDataStorage/UMComMedal.h>
#import "UIView+UMComAddition.h"
#import "UMComLabel.h"
#import "UMComFeedImageCollectionView.h"
#import <UMComFoundation/UMComKit+Image.h>
#import "UMComMutiStyleTextView.h"
#import <UMComFoundation/UMComKit+Color.h>


#define UMCom_Feed_CellBgCollor @"#F5F6FA"
#define UMCom_Feed_ForwardBgCollor @"#F5F6FA"
#define UMCom_Feed_NameCollor @"#333333"
#define UMCom_Feed_ContentCollor @"#666666"
#define UMCom_Feed_LocationCollor @"#A5A5A5"
#define UMCom_Feed_ForwardNameCollor @"#507DAF"
#define UMCom_Feed_ForwardContentCollor @"#7D7D7D"
#define UMCom_Feed_ButtonTitleCollor @"#A5A5A5"
#define UMCom_Feed_DateColor @"#A5A5A5"

#define FeedFont UMComFontNotoSansLightWithSafeSize(14)

#define UMCom_Feed_TopImage_Width 34

@interface UMComSimpleFeedTableViewCell ()<UMComFeedClickActionDelegate,UMComImageViewDelegate>

@property (nonatomic, assign) CGFloat cellSubviewCommonWidth;

@property (nonatomic, strong) UMComImageView *medalImageView;


@property (nonatomic) BOOL hasUpdate;

@end



@implementation UMComSimpleFeedTableViewCell

-(void)awakeFromNib
{
    
    self.feedBgView.layer.borderColor = UMComColorWithHexString(@"#dfdfdf").CGColor;
    self.feedBgView.layer.borderWidth = 1.f;

    self.feedBgView.clipsToBounds = YES;

    self.portrait = [[[UMComImageView imageViewClassName] alloc]initWithFrame:CGRectMake(0, 0, 24, 24)];
    self.portrait.userInteractionEnabled = YES;
    [self.imageAndNameBgView addSubview:self.portrait];

    
    UITapGestureRecognizer *tapPortrait = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(didOnUserAvatar:)];
    [self.portrait addGestureRecognizer:tapPortrait];
    

    self.nameLabel.font = UMComFontNotoSansLightWithSafeSize(12);

    self.dateLabel.font = UMComFontNotoSansLightWithSafeSize(10);
    
    self.feedTextView.font = UMComFontNotoSansLightWithSafeSize(14);

    UITapGestureRecognizer *tapSelfView = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(goToFeedDetaiView)];
    [self addGestureRecognizer:tapSelfView];
    
    _topicButton.layer.cornerRadius = 3;
    _topicButton.layer.borderWidth = 1.f;
    _topicButton.layer.borderColor = UMComColorWithHexString(@"#4a98f6").CGColor;
    [_topicButton setTitleColor:UMComColorWithHexString(@"#4a98f6") forState:UIControlStateNormal];
    
    self.medalImageView = [[[UMComImageView imageViewClassName] alloc] init];
    self.medalImageView.frame = self.medalBgView.bounds;
    [self.medalBgView addSubview:self.medalImageView];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapInFavoriteImageView)];
    self.favoriteImageView.userInteractionEnabled = YES;
    [self.favoriteImageView addGestureRecognizer:tapGesture];
    
    UIImage *buttonHighlightImage = [UMComKit imageWithColor:UMComColorWithHexString(@"#EEEEEE")];
    [self.likeButton setBackgroundImage:buttonHighlightImage forState:UIControlStateHighlighted];
    [self.commentButton setBackgroundImage:buttonHighlightImage forState:UIControlStateHighlighted];
    
    [self.commentButton setTitleColor:UMComColorWithHexString(@"#999999") forState:UIControlStateNormal];
    
    self.nameLabel.textColor = UMComColorWithHexString(@"#999999");
    self.dateLabel.textColor = UMComColorWithHexString(@"#999999");
    
    self.feedTextView.textColor = UMComColorWithHexString(@"#333333");
    self.feedTextView.font = FeedFont;
    self.feedTextView.lineSpace = UMCom_FeedContent_LineSpace;
    

}

/****************************reload cell views start *****************************/

-(BOOL) checkTopFeedWithFeed:(UMComFeed*)feed
{
    if (!feed) {
        return NO;
    }
    
    BOOL isTopFeed = NO;
    switch (self.topFeedType) {
        case UMComTopFeedType_GloalTopFeed:
        {
            NSNumber* isTopValue =  feed.is_top;
            if (isTopValue && [isTopValue isKindOfClass:[NSNumber class]] &&
                (isTopValue.integerValue == 1)) {
                isTopFeed = YES;
            }
        }
            break;
        case UMComTopFeedType_TopicTopFeed:
        {
            NSNumber* isTopicTopValue =  feed.is_topic_top;
            if (isTopicTopValue && [isTopicTopValue isKindOfClass:[NSNumber class]] &&
                (isTopicTopValue.integerValue == 1)) {
                isTopFeed = YES;
            }
        }
            break;
        case UMComTopFeedType_GloalTopAndTopicTopFeed:
        {
            NSNumber* isTopValue =  feed.is_top;
            NSNumber* isTopicTopValue =  feed.is_topic_top;
            if ((isTopValue && [isTopValue isKindOfClass:[NSNumber class]] &&
                 (isTopValue.integerValue == 1))
                && ((isTopicTopValue && [isTopicTopValue isKindOfClass:[NSNumber class]] &&
                                                      (isTopicTopValue.integerValue == 1)))) {
                
                
                isTopFeed = YES;
            }
        }
            break;
        case UMComTopFeedType_GloalTopOrTopicTopFeed:
        {
            NSNumber* isTopValue =  feed.is_top;
            NSNumber* isTopicTopValue =  feed.is_topic_top;
            if ((isTopValue && [isTopValue isKindOfClass:[NSNumber class]] &&
                 (isTopValue.integerValue == 1))
                || ((isTopicTopValue && [isTopicTopValue isKindOfClass:[NSNumber class]] &&
                     (isTopicTopValue.integerValue == 1)))) {
                isTopFeed = YES;
            }
        }
            break;
        default:
            break;
    }
    
    return isTopFeed;
}

//去掉字符串所有的空白和换行字符
-(NSString*)filterBlankAndBlankLines:(NSString*)orgString
{
    if (!orgString) {
        return nil;
    }
    
    NSString* resultData = orgString;
    resultData = [resultData stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];  //去除掉首尾的空白字符和换行字符
    resultData = [resultData stringByReplacingOccurrencesOfString:@"\r" withString:@""];
    resultData = [resultData stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    return resultData;
}

- (void)reloadSubViewsFeed:(UMComFeed *)feed
{
    if (self.showFavoriteStatus == NO) {
        self.favoriteImageView.hidden = YES;
        self.favoriteImageWidthConstraint.constant = 0;
    }else{
        self.favoriteImageView.hidden = NO;
        self.favoriteImageWidthConstraint.constant = 16;
    }
    self.feed = feed;

    [self reloadAvatarImageViewWithFeed:self.feed];
    self.feedBgView.backgroundColor = [UIColor whiteColor];

    if (feed.topics.count > 0) {
        UMComTopic *topic = feed.topics.firstObject;
        [self.topicButton setTitle:topic.name forState:UIControlStateNormal];
        self.topicButton.hidden = NO;
    }else{
        [self.topicButton setTitle:@"" forState:UIControlStateNormal];
        self.topicButton.hidden = YES;
    }
    if (feed.creator.medal_list.count > 0) {
        UMComMedal *medal = feed.creator.medal_list.firstObject;
        [self.medalImageView setImageURL:medal.icon_url placeHolderImage:nil];
        self.medalBgView.hidden = NO;
        self.nameLabelWidthConstraint.constant = -16;
    }else{
        self.nameLabelWidthConstraint.constant = 0;
        self.medalBgView.hidden = YES;
    }
    self.nameLabel.text = feed.creator.name;

    if ([self.feed.liked boolValue]) {
        [self.likeButton setImage:UMComSimpleImageWithImageName(@"um_like_blue") forState:UIControlStateNormal];
            [self.likeButton setTitleColor:UMComColorWithHexString(@"#4a98f6") forState:UIControlStateNormal];
    }else{
         [self.likeButton setImage:UMComSimpleImageWithImageName(@"um_like_gray") forState:UIControlStateNormal];
            [self.likeButton setTitleColor:UMComColorWithHexString(@"#999999") forState:UIControlStateNormal];
    }
    self.dateLabel.font = UMComFontNotoSansLightWithSafeSize(10);
    self.dateLabel.text = createTimeString(self.feed.create_time);
    [self.likeButton setTitle:[NSString stringWithFormat:@"%@",countString(feed.likes_count)] forState:UIControlStateNormal];
    [self.commentButton setTitle:[NSString stringWithFormat:@"%@",countString(feed.comments_count)] forState:UIControlStateNormal];

    if (![self checkTopFeedWithFeed:feed]) {
        self.topImage.hidden = YES;
    }else{
        self.topImage.hidden = NO;
    }
    if ([self.feed.tag intValue] == 1) {
        self.eletImage.hidden = NO;
    }else {
        self.eletImage.hidden = YES;
    }
    
    if ([self.feed.type intValue] == 1) {
        self.publicImage.hidden = NO;
    }else{
        self.publicImage.hidden = YES;
    }

    if (!self.eletImage.hidden && !self.topImage.hidden) {
        self.topImageWidthConstraint.constant = UMCom_Feed_TopImage_Width;
        self.elitImageWidthConstraint.constant = UMCom_Feed_TopImage_Width;
    }else if(self.eletImage.hidden == YES && self.topImage.hidden == NO){
        self.topImageWidthConstraint.constant = UMCom_Feed_TopImage_Width;
        self.elitImageWidthConstraint.constant = 0;
    }else if (self.eletImage.hidden == NO && self.topImage.hidden == YES){
        self.topImageWidthConstraint.constant = 0;
        self.elitImageWidthConstraint.constant = UMCom_Feed_TopImage_Width;
    }else{
        self.topImageWidthConstraint.constant = 0;
        self.elitImageWidthConstraint.constant = 0;
    }
    
    if (self.topImage.hidden && self.publicImage.hidden && self.eletImage.hidden) {
        self.avatorTopSpaceToTopConstraint.constant = 0;
    }else{
        self.avatorTopSpaceToTopConstraint.constant = UMCom_FeedCellItem_Vertical_Space;
    }
    [self.imageAndNameBgView updateConstraints];
//
    if (self.feed.text.length > 0) {
        self.feedTextView.hidden = NO;
        NSString *feedContent = self.feed.text;
        if (feedContent.length > 300) {
            feedContent = [feedContent substringWithRange:NSMakeRange(0, 300)];
        }
        feedContent = [self filterBlankAndBlankLines:feedContent];
        UMComMutiText *mutiText = self.feedMutiText;
        if (!mutiText) {
            mutiText = [UMComMutiText mutiTextWithSize:CGSizeMake(self.feedTextView.width_, MAXFLOAT) font:FeedFont string:feedContent lineSpace:UMCom_FeedContent_LineSpace checkWords:nil textColor:UMComColorWithHexString(@"#333333") highLightColor:UMComColorWithHexString(@"#4a98f6")];
            self.feedTextView.pointOffset = CGPointMake(0, UMCom_FeedContent_LineSpace/2);
            CGSize textSize = mutiText.textSize;
            textSize.height = mutiText.textSize.height+UMCom_FeedContent_LineSpace;
            mutiText.textSize = textSize;
            self.feedMutiText = mutiText;
        }
        [self.feedTextView setMutiStyleTextViewWithMutiText:mutiText];
        __weak typeof(self) weakSelf = self;
        self.feedTextView.clickOnlinkText = ^(UMComMutiStyleTextView *feedTextView,UMComMutiTextRun *run){
            if ([run isKindOfClass:[UMComMutiTextRunURL class]]) {
                [weakSelf clickOnUrl:run.text];
            }else{
                [weakSelf goToFeedDetaiView];
            }
        };
        self.feedImageTopSpaceToFeedConstraint.constant = UMCom_FeedCellItem_Vertical_Space;
        self.feedTextViewHeightConstraint.constant = mutiText.textSize.height;
    }else{
        self.feedTextView.hidden = YES;
        self.feedTextViewHeightConstraint.constant = 0;
         self.feedImageTopSpaceToFeedConstraint.constant = 0;
    }
    //图片
    NSArray *imageArray = self.feed.image_urls;
    if (imageArray && imageArray.count > 0) {
        if (imageArray.count > 3) {
            imageArray = [imageArray subarrayWithRange:NSMakeRange(0, 3)];
        }
        self.imageGridView.hidden = NO;
        CGFloat imageHeight = (self.imageGridView.width_ - UMCom_Feed_Image_Space*2)/ 3;
        self.imageGridView.height_ = imageHeight;
        self.feedImageViewHeightConstraint.constant = imageHeight;
        self.dateTopSpaceToFeedImageConstraint.constant = UMCom_FeedCellItem_Vertical_Space;
        [self reloadGridViewWithImagesArr:imageArray];

    }else{
        self.imageGridView.hidden = YES;
        self.feedImageViewHeightConstraint.constant = 0;
        self.dateTopSpaceToFeedImageConstraint.constant = 0;
    }

    if (self.isHideTopicName) {
        [self.topicButton removeFromSuperview];
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [self.feedBgView setNeedsLayout];
    [self.feedBgView layoutIfNeeded];
    
    [self.contentView setNeedsLayout];
    [self.contentView layoutIfNeeded];

    self.nameLabel.preferredMaxLayoutWidth = CGRectGetWidth(self.nameLabel.frame);
    self.dateLabel.preferredMaxLayoutWidth = CGRectGetHeight(self.dateLabel.frame);
}

#pragma mark - Action
- (void)reloadAvatarImageViewWithFeed:(UMComFeed *)feed
{
    //头像
    self.portrait.frame = self.avatorImage.frame;
    NSString *iconString = [feed.creator iconUrlStrWithType:UMComIconSmallType];
    UIImage *placeHolderImage = [UMComImageView placeHolderImageGender:[feed.creator.gender integerValue]];
    [self.portrait setImageURL:iconString placeHolderImage:placeHolderImage];
    self.portrait.clipsToBounds = YES;
    self.portrait.layer.cornerRadius = self.portrait.frame.size.width/2;
}


- (void)reloadGridViewWithImagesArr:(NSArray *)imagesArray
{
    [self.imageGridView setImages:imagesArray placeholder:UMComImageWithImageName(@"image-placeholder") cellPad:UMCom_Feed_Image_Space];
    __weak typeof(self) weakSelf = self;
    self.imageGridView.TapInImage = ^(UMComSimpleGridViewerController *viewerController, UIImageView *imageView){
        if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(customObj:clickOnImageView:complitionBlock:)]) {
            __strong typeof(self) strongSelf = weakSelf;
            [weakSelf.delegate customObj:strongSelf clickOnImageView:imageView complitionBlock:^(UIViewController *currentViewController) {
                [currentViewController presentViewController:viewerController animated:YES completion:^{
                }];
            }];
        }
    };
}

#pragma mark - action

- (void)clickOnUrl:(NSString *)urlString
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(customObj:clickOnURL:)]) {
        [self.delegate customObj:self clickOnURL:urlString];
    }
}

- (void)didOnUserAvatar:(id)sender
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(customObj:clickOnFeedCreator:)]) {
        [self.delegate customObj:self clickOnFeedCreator:self.feed.creator];
    }
}

- (void)tapInFavoriteImageView
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(customObj:clickOnFavouratesFeed:)]) {
        [self.delegate customObj:self clickOnFavouratesFeed:self.feed];
    }
}

- (void)goToFeedDetaiView
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(customObj:clickOnFeedText:)]) {
        [self.delegate customObj:self clickOnFeedText:self.feed];
    }
}

- (IBAction)clickOnLikeButton:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(customObj:clickOnLikeFeed:)]) {
        [self.delegate customObj:self clickOnLikeFeed:self.feed];
    }
}

- (IBAction)clickOnCommentButton:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(customObj:clickOnCommentFeed:)]) {
        [self.delegate customObj:self clickOnCommentFeed:self.feed];
    }
}

- (IBAction)clickOnTopicButton:(UIButton *)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(customObj:clickOnTopic:)]) {  
        if (self.feed.topics.count > 0) {
            UMComTopic *topic = self.feed.topics.firstObject;
            [self.delegate customObj:self clickOnTopic:topic];
        }

    }
}

@end

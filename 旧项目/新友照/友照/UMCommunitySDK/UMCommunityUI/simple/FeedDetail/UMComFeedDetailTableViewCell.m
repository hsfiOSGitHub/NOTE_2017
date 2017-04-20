//
//  UMComFeedDetailTableViewCell.m
//  UMCommunity
//
//  Created by umeng on 16/5/18.
//  Copyright © 2016年 Umeng. All rights reserved.
//

#import "UMComFeedDetailTableViewCell.h"
#import <UMComDataStorage/UMComFeed.h>
#import "UMComAvatarImageView.h"
#import <UMComDataStorage/UMComImageUrl.h>
#import "UMComMutiStyleTextView.h"
#import <UMComDataStorage/UMComTopic.h>
#import <UMComDataStorage/UMComUser.h>
#import "UMComResouceDefines.h"
#import <UMComDataStorage/UMComMedal.h>
#import "UIView+UMComAddition.h"
#import <UMComFoundation/UMComKit+Color.h>


@interface UMComFeedDetailTableViewCell ()

@property (nonatomic, assign) CGFloat lastImageFeedHeight;

@property (nonatomic, strong) UMComFeed *feed;

@property (nonatomic, strong) UMComTopic *topic;

@property (nonatomic, strong) UMComImageView *medalImageView;

@end

@implementation UMComFeedDetailTableViewCell

- (void)awakeFromNib {
    
    self.realAvatar = [UMComAvatarImageView filletAvatarWithFrame:self.avatarImageView.bounds];
    [self.avatarImageView addSubview:_realAvatar];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapInAvatar:)];
    [self.realAvatar addGestureRecognizer:tap];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    self.nameLabel.textColor = UMComColorWithHexString(@"#999999");
    self.dateLabel.textColor = UMComColorWithHexString(@"#999999");
    self.feedTextView.textColor = UMComColorWithHexString(@"#333333");
    [self.topicButton setTitleColor:UMComColorWithHexString(@"#469EF8") forState:UIControlStateNormal];
    self.topicButton.layer.borderWidth = 1;
    self.topicButton.layer.cornerRadius = 3;
    self.topicButton.clipsToBounds = YES;
    self.topicButton.layer.borderColor = UMComColorWithHexString(@"#469EF8").CGColor;
    self.medalImageView = [[[UMComImageView imageViewClassName] alloc] init];
    self.medalImageView.frame = self.medalBgView.bounds;
    [self.medalBgView addSubview:self.medalImageView];
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}


- (void)reloadCellWithFeed:(UMComFeed *)feed
{
    self.feed = feed;
    [self.realAvatar resetAvatarWithUser:feed.creator];
    
    if (feed.topics.count > 0) {
        UMComTopic *topic = feed.topics.firstObject;
        NSString *topicName = topic.name;
        [self.topicButton setTitle:topicName forState:UIControlStateNormal];
        self.topic = topic;
        self.topicButton.hidden = NO;

    }else{
        self.topicButtonWitdhConstraint.constant = 0;
        self.topicButton.hidden = YES;
    }
    
    if (feed.creator.medal_list.count > 0) {
        UMComMedal *medal = feed.creator.medal_list.firstObject;
        [self.medalImageView setImageURL:medal.icon_url placeHolderImage:nil];
        self.nameLabelWidthConstraint.constant = -20;
        self.medalBgView.hidden = NO;
    }else{
        self.nameLabelWidthConstraint.constant = 0;
        self.medalBgView.hidden = YES;
    }
    self.nameLabel.text = feed.creator.name;
    if (feed.text.length > 0) {
        self.feedTextView.lineSpace = 4;
        UMComMutiText *mutiText = [UMComMutiText mutiTextWithSize:CGSizeMake(self.feedTextView.width_, MAXFLOAT) font:self.feedTextView.font string:feed.text lineSpace:self.feedTextView.lineSpace checkWords:nil textColor:UMComColorWithHexString(@"#333333") highLightColor:UMComColorWithHexString(@"#469EF8")];
        self.feedTextView.pointOffset = CGPointMake(0, self.feedTextView.lineSpace/2);
        self.feedTextView.height_ = mutiText.textSize.height+self.feedTextView.lineSpace;
        self.feedTextView.height_ = mutiText.textSize.height;
        [self.feedTextView setMutiStyleTextViewWithMutiText:mutiText];
        self.feedTextLabelHeightConstraint.constant = _feedTextView.height_;
        __weak typeof(self) weakSelf = self;
        self.feedTextView.clickOnlinkText = ^(UMComMutiStyleTextView *feedTextView,UMComMutiTextRun *run){
            if ([run isKindOfClass:[UMComMutiTextRunURL class]]) {
                [weakSelf clickOnUrl:run.text];
            }
        };
    }else{
        [self.feedTextView removeFromSuperview];
    }
    self.dateLabel.text = createTimeString(feed.create_time);
    
    if (self.isHideTopicName) {
        [self.topicButton removeFromSuperview];
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [self.customBgView setNeedsLayout];
    [self.customBgView layoutIfNeeded];
    
    [self.contentView setNeedsLayout];
    [self.contentView layoutIfNeeded];
    
    self.nameLabel.preferredMaxLayoutWidth = CGRectGetWidth(self.nameLabel.frame);
}

#pragma mark - action 

- (void)clickOnUrl:(NSString *)urlString
{
    if (self.clickActionDelegate && [self.clickActionDelegate respondsToSelector:@selector(customObj:clickOnURL:)]) {
        [self.clickActionDelegate customObj:self clickOnURL:urlString];
    }
}

- (void)tapInAvatar:(UITapGestureRecognizer *)sender
{
    if (self.clickActionDelegate && [self.clickActionDelegate respondsToSelector:@selector(customObj:clickOnFeedCreator:)]) {
        [self.clickActionDelegate customObj:self clickOnFeedCreator:self.feed.creator];
    }
}


- (IBAction)clickOnTopicButton:(id)sender {
    
    if (self.clickActionDelegate && [self.clickActionDelegate respondsToSelector:@selector(customObj:clickOnTopic:)]) {
        [self.clickActionDelegate customObj:self clickOnTopic:self.topic];
    }
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

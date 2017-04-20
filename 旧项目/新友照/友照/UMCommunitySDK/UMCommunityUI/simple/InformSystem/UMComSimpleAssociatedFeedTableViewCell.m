//
//  UMComSimpleAssociatedFeedTableViewCell.m
//  UMCommunity
//
//  Created by wyq.Cloudayc on 5/24/16.
//  Copyright © 2016 Umeng. All rights reserved.
//

#import "UMComSimpleAssociatedFeedTableViewCell.h"
#import <UMComDataStorage/UMComComment.h>
#import <UMComDataStorage/UMComUser.h>
#import <UMComDataStorage/UMComFeed.h>
#import "UMComImageView.h"
#import <UMComDataStorage/UMComImageUrl.h>
#import "UMComResouceDefines.h"
#import "UMComMutiStyleTextView.h"
#import <UMComFoundation/UMComKit+Autolayout.h>
#import <UMComFoundation/UMComConstraintCache.h>
#import "UMComSimpleGridViewerController.h"
#import <UMComDataStorage/UMComLike.h>
#import <UMComFoundation/UMComKit+Color.h>

@interface UMComSimpleAssociatedFeedTableViewCell ()

@property (nonatomic, strong) UMComConstraintCacheManager *cacheManager;

@property (nonatomic, strong) UMComUser *creator;
@property (nonatomic, strong) UMComUser *replyUser;

@property (nonatomic, strong) UMComFeed *feed;

@end

@implementation UMComSimpleAssociatedFeedTableViewCell

- (void)awakeFromNib {
    self.backgroundColor = [UIColor clearColor];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    self.cardView.layer.borderColor = UMComColorWithHexString(@"#dfdfdf").CGColor;
    self.cardView.layer.borderWidth = 1.f;
    
    self.cacheManager = [[UMComConstraintCacheManager alloc] init];
    
    //设置所有label的textAlignment
    //http://stackoverflow.com/questions/16144671/nstextalignmentjustified-throws-error
    self.creatorNameLabel.textAlignment = NSTextAlignmentLeft;
    self.timeLabel.textAlignment =  NSTextAlignmentLeft;
    self.feedCreatorNameLabel.textAlignment = NSTextAlignmentLeft;
    self.feedTextLabel.textAlignment = NSTextAlignmentLeft;
    self.textFeedCreatorNameLabel.textAlignment = NSTextAlignmentLeft;
    self.textFeedTextLabel.textAlignment = NSTextAlignmentLeft;
    
    [self initEventForViews];
}

- (void)initEventForViews
{
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(enterFeedDetailView:)];
    [_picFeedView addGestureRecognizer:tap];
    
    tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(enterFeedDetailView:)];
    [_textFeedView addGestureRecognizer:tap];
    
    tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(enterCreatorUserCenter:)];
    [_creatorAvatar addGestureRecognizer:tap];
    
    tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(enterFeedCreatorUserCenter:)];
    [_feedCreatorNameLabel addGestureRecognizer:tap];
    
    tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(enterFeedCreatorUserCenter:)];
    [_textFeedCreatorNameLabel addGestureRecognizer:tap];
    
    tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(openFeedImage:)];
    [_feedImageView addGestureRecognizer:tap];
}

- (void)enterFeedDetailView:(id)sender
{
    if (_feed.status.integerValue >= 2) {
        return;
    }
    if (_delegate && [self.delegate respondsToSelector:@selector(customObj:clickOnFeedText:)]) {
        [_delegate customObj:self clickOnFeedText:_feed];
    }
}

- (void)enterCreatorUserCenter:(id)sender
{
    if ([_delegate respondsToSelector:@selector(customObj:clickOnFeedCreator:)]) {
        [_delegate customObj:self clickOnFeedCreator:_creator];
    }
}

- (void)enterFeedCreatorUserCenter:(id)sender
{
    if ([_delegate respondsToSelector:@selector(customObj:clickOnFeedCreator:)]) {
        [_delegate customObj:self clickOnFeedCreator:_feed.creator];
    }
}

- (void)enterReplyUserCenter:(UMComUser *)user
{
    if (!user) {
        return;
    }
    if ([_delegate respondsToSelector:@selector(customObj:clickOnFeedCreator:)]) {
        [_delegate customObj:self clickOnFeedCreator:user];
    }
}

- (void)enterUrlWithString:(NSString *)url
{
    if (!url) {
        return;
    }
    if ([_delegate respondsToSelector:@selector(customObj:clickOnURL:)]) {
        [_delegate customObj:self clickOnURL:url];
    }
}

- (void)openFeedImage:(id)sender
{
    if (_feed.image_urls.count == 0) {
        return;
    }
    UMComImageUrl *imageUrl = _feed.image_urls[0];
    UMComSimpleGridViewerController *controller = [[UMComSimpleGridViewerController alloc] initWithArray:@[imageUrl] index:0];
    if ([_delegate respondsToSelector:@selector(customObj:clickOnImageView:complitionBlock:)]) {
        [_delegate customObj:self clickOnImageView:nil complitionBlock:^(UIViewController *currentViewController) {
            [currentViewController presentViewController:controller animated:YES completion:nil];
        }];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

- (void)refreshWithBeLiked:(UMComLike *)like
{
    [self refreshCellWithFeed:like.feed creator:like.creator time:like.create_time content:UMComLocalizedString(@"um_com_liked_feed", @"赞了这条动态") checkWords:nil];
}

- (void)refreshWithComment:(UMComComment *)comment
{
    UMComFeed *originFeed = comment.feed;
    
    _replyUser = comment.reply_user;

    NSString *commentContent = comment.content;
    NSString *name = nil;
    if (_replyUser) {
        name = [NSString stringWithFormat:@"@%@", _replyUser.name];
        commentContent = [NSString stringWithFormat:@"%@%@: %@", UMComLocalizedString(@"reply", @"回复"), name, commentContent];
    }
    
    [self refreshCellWithFeed:originFeed creator:comment.creator time:comment.create_time content:commentContent checkWords:name ? @[name] : nil];
}

- (void)refreshCellWithFeed:(UMComFeed *)feed creator:(UMComUser *)creator time:(NSString *)time content:(NSString *)content checkWords:(NSArray *)checkWords
{
    self.feed = feed;
    self.creator = creator;
    
    [_creatorAvatar setImageURL:creator.icon_url.midle_url_string placeHolderImage:[UMComImageView placeHolderImageGender:creator.gender.integerValue]];
    _creatorNameLabel.text = creator.name;
    UMComMutiText *text = [UMComMutiText mutiTextWithSize:CGSizeMake(_commentLabel.frame.size.width, INT_MAX)
                                                     font:[UIFont systemFontOfSize:12.f]
                                                   string:content
                                                lineSpace:2.f
                                               checkWords:checkWords
                                                textColor:UMComColorWithHexString(@"#666666")
                                           highLightColor:UMComColorWithHexString(@"#469ef8")];
    [_commentLabel setMutiStyleTextViewWithMutiText:text];
    __weak typeof(self) ws = self;
    _commentLabel.clickOnlinkText = ^(UMComMutiStyleTextView *mutiStyleTextView,UMComMutiTextRun *run) {
        if (run) {
            if ([run.text hasPrefix:@"@"]) {
                [ws enterReplyUserCenter:ws.replyUser];
            } else if ([run.text hasPrefix:@"http"]) {
                [ws enterUrlWithString:run.text];
            }
        }
    };
    [UMComKit ALView:_commentLabel setConstraintConstant:text.textSize.height forAttribute:NSLayoutAttributeHeight];
    
    [_timeIcon setImage:UMComSimpleImageWithImageName(@"um_time")];
    _timeLabel.text = createTimeString(time);
    
    NSString *textFeedViewKey = @"textFeedView";
    NSString *picFeedViewKey = @"picFeedView";
    
    
    if (feed.image_urls.count == 0 || feed.status.integerValue >= 2) {
        [_cacheManager cacheViewConstraints:_picFeedView forKey:picFeedViewKey];
        [_picFeedView removeFromSuperview];
        [_cacheManager restoreViewConstraintsToSuperView:_textFeedView forKey:textFeedViewKey];
        
        NSString *feedCreatrName = nil;
        NSString *feedText = nil;
        if (feed.status.integerValue < 2) {
            feedCreatrName = [NSString stringWithFormat:@"@%@", feed.creator.name];
            feedText = [NSString stringWithFormat:@": %@", feed.text];
        } else {
            feedCreatrName = @"";
            feedText = UMComLocalizedString(@"um_com_feed_deleted", @"该内容已被删除");
        }
        _textFeedCreatorNameLabel.text = feedCreatrName;
        _textFeedTextLabel.text = feedText;
    } else {
        [_cacheManager cacheViewConstraints:_textFeedView forKey:textFeedViewKey];
        [_textFeedView removeFromSuperview];
        [_cacheManager restoreViewConstraintsToSuperView:_picFeedView forKey:picFeedViewKey];
        
        UMComImageUrl *urlObj = feed.image_urls[0];
        [_feedImageView setImageURL:urlObj.midle_url_string placeHolderImage:nil];
        
        _feedCreatorNameLabel.text = [NSString stringWithFormat:@"@%@", feed.creator.name];
        _feedTextLabel.text = feed.text;
    }
}

#pragma mark - action

- (void)didOnUserAvatar:(id)sender
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(customObj:clickOnFeedCreator:)]) {
        [self.delegate customObj:self clickOnFeedCreator:self.feed.creator];
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

//
//  UMComFeedDetailCommentCell.m
//  UMCommunity
//
//  Created by umeng on 16/5/18.
//  Copyright © 2016年 Umeng. All rights reserved.
//

#import "UMComFeedDetailCommentCell.h"
#import <UMComDataStorage/UMComComment.h>
#import "UMComLabel.h"
#import <UMComDataStorage/UMComUser.h>
#import <UMComDataStorage/UMComImageUrl.h>
#import "UMComResouceDefines.h"
#import "UMComAvatarImageView.h"
#import "UMComMutiStyleTextView.h"
#import <UMCommunitySDK/UMComSession.h>
#import <UMComFoundation/UMComKit+Color.h>

@interface UMComFeedDetailCommentCell ()<UIActionSheetDelegate>

@property (nonatomic, strong) UMComAvatarImageView *realAvatar;

@property (nonatomic, strong) UMComComment *comment;


@end

@implementation UMComFeedDetailCommentCell

- (void)awakeFromNib {
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    // Initialization code
    self.realAvatar = [UMComAvatarImageView filletAvatarWithFrame:self.avatorImageView.bounds];
    [self.avatorImageView addSubview:_realAvatar];
    self.realAvatar.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapInAvatar:)];
    [self.realAvatar addGestureRecognizer:tap];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.nameLabel.textColor = UMComColorWithHexString(@"#666666");
    self.dateLabel.textColor = UMComColorWithHexString(@"#999999");
}

- (void)reloadCellWithComment:(UMComComment *)comment
{
    self.comment = comment;
    self.nameLabel.text = comment.creator.name;
    self.dateLabel.text = createTimeString(comment.create_time);
    
    self.commentContentView.lineSpace = 3;
    NSArray *checkWords = nil;
    NSString *contentString = comment.content;
    if (comment.reply_comment || comment.reply_user) {
        NSString *name = comment.reply_comment.creator.name;
        if (!name) {
            name = comment.reply_user.name;
        }
        if ([name isKindOfClass:[NSString class]]) {
            contentString = [NSString stringWithFormat:@"回复@%@：%@",name, contentString];
            name = [NSString stringWithFormat:@"@%@",name];
            checkWords = [NSArray arrayWithObject:name];
        }
    }
    UMComMutiText *contentMutiText = [UMComMutiText mutiTextWithSize:CGSizeMake(self.commentContentView.frame.size.width, MAXFLOAT) font:UMComFontNotoSansLightWithSafeSize(14) string:contentString lineSpace:3 checkWords:checkWords textColor:UMComColorWithHexString(@"#999999") highLightColor:UMComColorWithHexString(@"#469ef8")];
    self.commentContentConstraint.constant = contentMutiText.textSize.height;
    [self.commentContentView setMutiStyleTextViewWithMutiText:contentMutiText];
    __weak typeof(self) weakSelf = self;
    self.commentContentView.clickOnlinkText = ^(UMComMutiStyleTextView *mutiStyleTextView, UMComMutiTextRun *run){
        if ([run isKindOfClass:[UMComMutiTextRunClickUser class]]) {
            if (weakSelf.commentActionDelegate && [weakSelf.commentActionDelegate respondsToSelector:@selector(customObj:clickOnCommentUser:)]) {
                [weakSelf.commentActionDelegate customObj:weakSelf clickOnCommentUser:comment.reply_comment.creator];
            }
        }else if ([run isKindOfClass:[UMComMutiTextRunURL class]]){
            if (weakSelf.commentActionDelegate && [weakSelf.commentActionDelegate respondsToSelector:@selector(customObj:clickOnURL:)]) {
                [weakSelf.commentActionDelegate customObj:weakSelf clickOnURL:run.text];
            }
        }
    };
    [self.realAvatar resetAvatarWithUser:comment.creator];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [self.commentContentView setNeedsLayout];
    [self.commentContentView layoutIfNeeded];
    
    [self.customBgView setNeedsLayout];
    [self.customBgView layoutIfNeeded];
    
    [self.contentView setNeedsLayout];
    [self.contentView layoutIfNeeded];
    
//    self.contentLabel.preferredMaxLayoutWidth = CGRectGetWidth(self.contentLabel.frame);
}


#pragma mark - action 
- (void)tapInAvatar:(UITapGestureRecognizer *)sender
{
    if (self.commentActionDelegate && [self.commentActionDelegate respondsToSelector:@selector(customObj:clickOnCommentUser:)]) {
        [self.commentActionDelegate customObj:self clickOnCommentUser:self.comment.creator];
    }
}


- (IBAction)clickOnReplyButton:(UIButton*)sender
{
    [sender setImage:UMComSimpleImageWithImageName(@"um_comment_highlight") forState:UIControlStateHighlighted];

    if (self.commentActionDelegate && [self.commentActionDelegate respondsToSelector:@selector(customObj:clickOnReplyComment:)]) {
        [self.commentActionDelegate customObj:self clickOnReplyComment:self.comment];
    }
}

- (IBAction)clickOnMoreButton:(id)sender {
   
    NSMutableArray *itemTitles = [NSMutableArray array];
    NSString *title = @"";
    if ([self checkAuthDeleteComment]) {
        title = UMComLocalizedString(@"deleted", @"删除");
        [itemTitles addObject:title];
        title = UMComLocalizedString(@"copy_comment", @"复制");
        [itemTitles addObject:title];
        if (![self.comment.creator.uid isEqualToString:[UMComSession sharedInstance].uid]) {
            title = UMComLocalizedString(@"spam_user", @"举报用户");
            [itemTitles addObject:title];

        }
    }else{
        title = UMComLocalizedString(@"spam_user", @"举报用户");
         [itemTitles addObject:title];
        title = UMComLocalizedString(@"spam_comment", @"举报内容");
         [itemTitles addObject:title];
        
        title = UMComLocalizedString(@"copy_comment", @"复制");
        [itemTitles addObject:title];
    }
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:nil];
    for (NSString *title in itemTitles) {
        [actionSheet addButtonWithTitle:title];
    }
    
    [actionSheet showInView:self];
}


- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString *title = [actionSheet buttonTitleAtIndex:buttonIndex];
    
    if ([title isEqualToString:UMComLocalizedString(@"deleted", @"删除")]) {
        if (self.commentActionDelegate && [self.commentActionDelegate respondsToSelector:@selector(customObj:clickOnDeleteComment:)]) {
            [self.commentActionDelegate customObj:self clickOnDeleteComment:self.comment];
        }
    }else if ([title isEqualToString:UMComLocalizedString(@"spam_user", @"举报用户")]){
        if (self.commentActionDelegate && [self.commentActionDelegate respondsToSelector:@selector(customObj:clickOnSpamUser:)]) {
            [self.commentActionDelegate customObj:self clickOnSpamUser:self.comment.creator];
        }
    }else if ([title isEqualToString:UMComLocalizedString(@"spam_comment", @"举报内容")]){
        if (self.commentActionDelegate && [self.commentActionDelegate respondsToSelector:@selector(customObj:clickOnSpamComment:)]) {
            [self.commentActionDelegate customObj:self clickOnSpamComment:self.comment];
        }
    }else if ([title isEqualToString:UMComLocalizedString(@"copy_comment", @"复制")]){
        if (self.commentActionDelegate && [self.commentActionDelegate respondsToSelector:@selector(customObj:clickOnCopyComment:)]) {
            [self.commentActionDelegate customObj:self clickOnCopyComment:self.comment];
        }
    }
}

- (BOOL)checkAuthDeleteComment
{
    BOOL permission = NO;
    if ([self.comment.creator.uid isEqualToString:[UMComSession sharedInstance].uid] || (self.comment.permission.integerValue >= 100)) {
        permission = YES;
    }
    return permission;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

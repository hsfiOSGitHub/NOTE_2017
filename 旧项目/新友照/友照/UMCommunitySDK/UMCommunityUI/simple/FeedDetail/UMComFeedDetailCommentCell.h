//
//  UMComFeedDetailCommentCell.h
//  UMCommunity
//
//  Created by umeng on 16/5/18.
//  Copyright © 2016年 Umeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@class UMComComment, UMComLabel, UMComUser, UMComMutiStyleTextView;

@protocol UMComClickCommentActionDelegate <NSObject>

- (void)customObj:(id)obj clickOnCommentUser:(UMComUser *)user;
- (void)customObj:(id)obj clickOnSpamUser:(UMComUser *)user;
- (void)customObj:(id)obj clickOnLikeComment:(UMComComment *)comment;
- (void)customObj:(id)obj clickOnDeleteComment:(UMComComment *)comment;
- (void)customObj:(id)obj clickOnSpamComment:(UMComComment *)comment;
- (void)customObj:(id)obj clickOnCopyComment:(UMComComment *)comment;
- (void)customObj:(id)obj clickOnReplyComment:(UMComComment *)comment;
- (void)customObj:(id)obj clickOnURL:(NSString *)urlSring;


@end

@interface UMComFeedDetailCommentCell : UITableViewCell

@property (nonatomic, weak) id<UMComClickCommentActionDelegate> commentActionDelegate;

@property (weak, nonatomic) IBOutlet UIView *customBgView;

@property (weak, nonatomic) IBOutlet UIImageView *avatorImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *dateIcon;

@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UMComMutiStyleTextView *commentContentView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *commentContentConstraint;



- (IBAction)clickOnReplyButton:(id)sender;

- (IBAction)clickOnMoreButton:(id)sender;

- (void)reloadCellWithComment:(UMComComment *)comment;


@end

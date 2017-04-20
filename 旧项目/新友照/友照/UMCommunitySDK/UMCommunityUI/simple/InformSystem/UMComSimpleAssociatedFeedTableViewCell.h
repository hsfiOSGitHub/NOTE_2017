//
//  UMComSimpleAssociatedFeedTableViewCell.h
//  UMCommunity
//
//  Created by wyq.Cloudayc on 5/24/16.
//  Copyright © 2016 Umeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UMComFeedClickActionDelegate.h"

static NSString *kUMComSimpleAssociatedFeedTableViewCellId = @"UMComSimpleAssociatedFeedTableViewCellId";
static NSString *kUMComSimpleAssociatedFeedTableViewCellName = @"UMComSimpleAssociatedFeedTableViewCell";

@class UMComMutiStyleTextView;
@class UMComImageView;
@class UMComComment;
@class UMComImageView;

@interface UMComSimpleAssociatedFeedTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *cardView;

@property (weak, nonatomic) IBOutlet UILabel *creatorNameLabel;
@property (weak, nonatomic) IBOutlet UMComImageView *creatorAvatar;

@property (weak, nonatomic) IBOutlet UIImageView *timeIcon;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@property (weak, nonatomic) IBOutlet UMComMutiStyleTextView *commentLabel;

@property (weak, nonatomic) IBOutlet UIView *picFeedView;
@property (weak, nonatomic) IBOutlet UMComImageView *feedImageView;
@property (weak, nonatomic) IBOutlet UILabel *feedCreatorNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *feedTextLabel;


@property (weak, nonatomic) IBOutlet UIView *textFeedView;
@property (weak, nonatomic) IBOutlet UILabel *textFeedCreatorNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *textFeedTextLabel;

@property (nonatomic, weak) id<UMComFeedClickActionDelegate> delegate;

- (void)refreshWithBeLiked:(UMComLike *)like;
- (void)refreshWithComment:(UMComComment *)comment;

@end

//
//  UMComFeedDetailTableViewCell.h
//  UMCommunity
//
//  Created by umeng on 16/5/18.
//  Copyright © 2016年 Umeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UMComFeedClickActionDelegate.h"

@class UMComLabel, UMComFeedLargeImageView, UMComFeed,UMComAvatarImageView, UMComMutiStyleTextView;
@interface UMComFeedDetailTableViewCell : UITableViewCell

@property (nonatomic, strong) UMComAvatarImageView *realAvatar;

@property (nonatomic, weak) id<UMComFeedClickActionDelegate> clickActionDelegate;

@property (weak, nonatomic) IBOutlet UIView *customBgView;

@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@property (weak, nonatomic) IBOutlet UIView *medalBgView;

@property (weak, nonatomic) IBOutlet UIButton *topicButton;

@property (weak, nonatomic) IBOutlet UMComMutiStyleTextView *feedTextView;

@property (weak, nonatomic) IBOutlet UILabel *dateLabel;

@property (weak, nonatomic) IBOutlet UIView *topBgView;

//约束

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *medalTrailingToSuperViewConstraint;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *nameLabelWidthConstraint;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topicButtonWitdhConstraint;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *feedTextLabelHeightConstraint;

/**
 *  是否显示话题名字
 *  @discuss 在TopicFeed界面,显示的都是topic下的feed，因此不需要显示话题名字
 */
@property(nonatomic,assign)BOOL isHideTopicName;

- (IBAction)clickOnTopicButton:(id)sender;


- (void)reloadCellWithFeed:(UMComFeed *)feed;



@end

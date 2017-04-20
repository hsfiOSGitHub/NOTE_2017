//
//  UMComSimpleNotificationCell.m
//  UMCommunity
//
//  Created by umeng on 16/5/17.
//  Copyright © 2016年 Umeng. All rights reserved.
//

#import "UMComSimpleNotificationCell.h"
#import <UMComDataStorage/UMComNotification.h>
#import <UMComDataStorage/UMComUser.h>
#import "UMComLabel.h"
#import <UMComDataStorage/UMComImageUrl.h>
#import "UMComResouceDefines.h"
#import "UMComAvatarImageView.h"
#import <UMComFoundation/UMComKit+Color.h>

@interface UMComSimpleNotificationCell ()

@property (nonatomic, strong) UMComAvatarImageView *realAvatar;

@property (nonatomic, strong) UMComNotification *notification;


@end

@implementation UMComSimpleNotificationCell

- (void)awakeFromNib {
    
    self.dateIcon.image = UMComSimpleImageWithImageName(@"um_time");
    self.realAvatar = [UMComAvatarImageView filletAvatarWithFrame:self.avatorImageView.bounds];
    self.realAvatar.userInteractionEnabled = YES;
    self.avatorImageView.userInteractionEnabled = YES;
    [self.avatorImageView addSubview:_realAvatar];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTapInAvator)];
    [self.realAvatar addGestureRecognizer:tap];
    
    self.customBgView.layer.borderColor = UMComColorWithHexString(@"#dfdfdf").CGColor;
    self.customBgView.layer.borderWidth = 1.f;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    self.contentLabel.preferredMaxLayoutWidth = CGRectGetWidth(self.contentLabel.frame);
    self.contentLabel.lineSpace = 2;
}

- (void)didTapInAvator
{
    if (self.tapAvatorAction) {
        self.tapAvatorAction(self.notification);
    }
}

- (void)reloadCellWithNotification:(UMComNotification *)notification
{
    self.notification = notification;
    self.nameLabel.text = notification.creator.name;
    self.dateLabel.text = createTimeString(notification.create_time);
    [self.realAvatar resetAvatarWithUser:notification.creator];
    self.contentLabel.textForAttribute = notification.content;
    //更新约束
    [self.contentLabel updateConstraintsIfNeeded];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [self.customBgView setNeedsLayout];
    [self.customBgView layoutIfNeeded];
    
    [self.contentView setNeedsLayout];
    [self.contentView layoutIfNeeded];
    
    self.contentLabel.preferredMaxLayoutWidth = CGRectGetWidth(self.contentLabel.frame);
}
@end

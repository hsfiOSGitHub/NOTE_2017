//
//  UMComUserTableViewCell.m
//  UMCommunity
//
//  Created by wyq.Cloudayc on 3/22/16.
//  Copyright © 2016 Umeng. All rights reserved.
//

#import "UMComUserTableViewCell.h"
#import <UMComDataStorage/UMComUser.h>
#import "UMComImageView.h"
#import "UMComResouceDefines.h"
#import <UMComDataStorage/UMComImageUrl.h>
#import <UMCommunitySDK/UMComSession.h>
#import "UMComClickActionDelegate.h"


@interface UMComUserTableViewCell()

@property (nonnull, nonatomic, strong) UMComUser *user;

@end

@implementation UMComUserTableViewCell

- (void)awakeFromNib {
    _avatarImageView.layer.cornerRadius = _avatarImageView.frame.size.width / 2.f;
    _avatarImageView.clipsToBounds = YES;
    [_locationIcon setImage:UMComImageWithImageName(@"um_forum_location.png")];

    _showDistance = NO;
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)onTouchFollowButton:(id)sender
{
    if (_delegate && [_delegate respondsToSelector:@selector(customObj:clickOnFollowUser:)]) {
        [_delegate customObj:self clickOnFollowUser:self.user];
    }
}

- (void)reloadCellWithUser:(UMComUser *)user
{
    self.user = user;
    
    if (_showDistance) {
            _distanceLabel.text = distanceString(user.distance);
    } else {
        [_distanceLabel removeFromSuperview];
        [_locationIcon removeFromSuperview];
    }
    
    [_avatarImageView setImageURL:_user.icon_url.small_url_string placeHolderImage:UMComImageWithImageName(@"um_forum_user_smile_gray")];
    self.userNameLabel.text = user.name;
    self.messageCountLabel.text = [NSString stringWithFormat:UMComLocalizedString(@"feedsSent", @"发表动态:%@"),countString(_user.feed_count)];
    self.followersCountLabel.text = [NSString stringWithFormat:UMComLocalizedString(@"followerCount", @"粉丝数:%@"),countString(_user.fans_count)];
    if ([_user.uid isEqualToString:[UMComSession sharedInstance].uid] || [_user.atype integerValue] == 3) {
        self.followButton.hidden = YES;
    }else{
        self.followButton.hidden = NO;
        if ([_user.relation integerValue] == 3) {
            [_followButton setBackgroundImage:UMComImageWithImageName(@"um_forum_user_interfocuse") forState:UIControlStateNormal];
        }else if ([user.relation integerValue] == 1){
            [_followButton setBackgroundImage:UMComImageWithImageName(@"um_forum_user_hasfocused") forState:UIControlStateNormal];
        }else{
            [_followButton setBackgroundImage:UMComImageWithImageName(@"um_forum_user_focuse") forState:UIControlStateNormal];
        }
    }
    
    if ([self.user.gender intValue] == 0) {
        self.genderImageView.image = UMComImageWithImageName(@"♀.png");
        
    } else {
        self.genderImageView.image = UMComImageWithImageName(@"♂.png");
    }
}


@end

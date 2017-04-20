//
//  UMComUserTableViewCell.h
//  UMCommunity
//
//  Created by wyq.Cloudayc on 3/22/16.
//  Copyright © 2016 Umeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@class UMComImageView, UMComUser;

@protocol UMComClickActionDelegate;

@interface UMComUserTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UMComImageView *avatarImageView;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *distanceLabel;
@property (weak, nonatomic) IBOutlet UIImageView *locationIcon;
@property (weak, nonatomic) IBOutlet UILabel *messageCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *followersCountLabel;
@property (weak, nonatomic) IBOutlet UIImageView *genderImageView;

@property (weak, nonatomic) IBOutlet UIButton *followButton;

@property (nonatomic, assign) id <UMComClickActionDelegate> delegate;

@property (nonatomic, assign) BOOL showDistance;

- (IBAction)onTouchFollowButton:(id)sender;
- (void)reloadCellWithUser:(UMComUser *)user;

@end

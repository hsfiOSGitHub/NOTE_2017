//
//  UMComSimpleNotificationCell.h
//  UMCommunity
//
//  Created by umeng on 16/5/17.
//  Copyright © 2016年 Umeng. All rights reserved.
//

#import <UIKit/UIKit.h>

static NSString *kUMComSimpleNotificationCellName = @"UMComSimpleNotificationCell";

@class UMComNotification, UMComLabel;

@interface UMComSimpleNotificationCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIView *customBgView;

@property (weak, nonatomic) IBOutlet UIImageView *avatorImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *dateIcon;

@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UMComLabel *contentLabel;

@property (nonatomic, copy) void (^tapAvatorAction)(UMComNotification *notification);

- (void)reloadCellWithNotification:(UMComNotification *)notification;

@end

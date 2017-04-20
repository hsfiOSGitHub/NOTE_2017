//
//  UMComLikeButtonTableViewCell.h
//  UMCommunity
//
//  Created by umeng on 16/6/2.
//  Copyright © 2016年 Umeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UMComLikeButtonTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIButton *likeButton;

@property (nonatomic, copy) void (^clickOnLikeButton)(UIButton *button);

- (IBAction)onClikOnLikeButton:(UIButton *)sender;

@end

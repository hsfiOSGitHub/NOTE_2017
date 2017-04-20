//
//  UMComAvatarImageView.h
//  UMCommunity
//
//  Created by umeng on 16/5/18.
//  Copyright © 2016年 Umeng. All rights reserved.
//

#import "UMComImageView.h"

@class UMComUser;

@interface UMComAvatarImageView : UMComImageView

+ (UMComAvatarImageView *)filletAvatarWithFrame:(CGRect)frame;

- (void)resetAvatarWithUser:(UMComUser *)user;


@end

//
//  UMComAvatarImageView.m
//  UMCommunity
//
//  Created by umeng on 16/5/18.
//  Copyright © 2016年 Umeng. All rights reserved.
//

#import "UMComAvatarImageView.h"
#import <UMComDataStorage/UMComUser.h>
#import <UMComDataStorage/UMComImageUrl.h>

@implementation UMComAvatarImageView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

+ (UMComAvatarImageView *)filletAvatarWithFrame:(CGRect)frame
{
    UMComAvatarImageView *imageView = [[UMComAvatarImageView alloc] init];
    imageView.frame = frame;
    imageView.clipsToBounds = YES;
    imageView.userInteractionEnabled = YES;
    imageView.layer.cornerRadius = frame.size.width/2;
    return imageView;
}

- (void)resetAvatarWithUser:(UMComUser *)user
{
    NSString *iconString = [user iconUrlStrWithType:UMComIconSmallType];
    UIImage *placeHolderImage = [UMComImageView placeHolderImageGender:[user.gender integerValue]];
    [self setImageURL:iconString placeHolderImage:placeHolderImage];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.layer.cornerRadius = self.frame.size.width/2;
}

@end

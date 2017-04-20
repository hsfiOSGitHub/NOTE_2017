//
//  UMComFeedImageCollectionViewCell.m
//  UMCommunity
//
//  Created by umeng on 16/5/15.
//  Copyright © 2016年 Umeng. All rights reserved.
//

#import "UMComFeedImageCollectionViewCell.h"
#import "UMComImageView.h"
#import "UMComResouceDefines.h"

const CGFloat UMCom_A_WEEK_SECONDES = 60*60*24*7;

@interface UMComFeedImageCollectionViewCell ()


@end

@implementation UMComFeedImageCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self creatUMComImageView];
    }
    return self;
}

- (void)awakeFromNib {
    if (!self.umcomImageView) {
        [self creatUMComImageView];
    }
    // Initialization code
}

- (void)creatUMComImageView
{
    UMComImageView *imageView = [[[UMComImageView imageViewClassName] alloc] init];
    [imageView setIsAutoStart:NO];
    [imageView setCacheSecondes:UMCom_A_WEEK_SECONDES];
    imageView.userInteractionEnabled = YES;
    self.umcomImageView = imageView;
    self.umcomImageView.frame = self.feedImageView.bounds;
    [self.feedImageView addSubview:self.umcomImageView];
    //    //添加触控
//    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapImageView:)];
//    [iv addGestureRecognizer:tapGesture];
}



@end

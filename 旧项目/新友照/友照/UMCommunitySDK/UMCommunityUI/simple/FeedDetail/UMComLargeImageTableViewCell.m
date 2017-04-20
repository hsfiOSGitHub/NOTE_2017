//
//  UMComLargeImageTableViewCell.m
//  UMCommunity
//
//  Created by umeng on 16/6/1.
//  Copyright © 2016年 Umeng. All rights reserved.
//

#import "UMComLargeImageTableViewCell.h"
#import "UMComImageView.h"
#import <UMComDataStorage/UMComImageUrl.h>
#import "UMComSimpleGridViewerController.h"

@interface UMComLargeImageTableViewCell()

@end


@implementation UMComLargeImageTableViewCell

- (void)awakeFromNib {
    // Initialization code
    
    self.umImageView = [[[UMComImageView imageViewClassName] alloc] init];
    self.umImageView.frame = self.imageBgView.bounds;
    [self.imageBgView addSubview:self.umImageView];
    
    self.umImageView.backgroundColor = [UIColor whiteColor];
    self.imageBgView.backgroundColor = [UIColor whiteColor];
    self.contentView.backgroundColor = [UIColor whiteColor];
    
    self.umImageView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showImageBrowserViewWithSender:)];
    [self.umImageView addGestureRecognizer:tap];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    self.umImageView.contentMode = UIViewContentModeScaleAspectFit;
}


- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [self.imageBgView setNeedsLayout];
    [self.imageBgView layoutIfNeeded];
    
    [self.contentView setNeedsLayout];
    [self.contentView layoutIfNeeded];
}


- (void)showImageBrowserViewWithSender:(UITapGestureRecognizer *)tap
{
    UMComImageView *imageView = (UMComImageView *)tap.view;
    NSInteger index = 0;
    for (UMComImageUrl *imageUrl in self.imageUrlArray) {
        if ([imageUrl.midle_url_string isEqualToString:[imageView.imageURL absoluteString]]) {
            index = [self.imageUrlArray indexOfObject:imageUrl];
        }
    }
    UMComSimpleGridViewerController *viewerController = [[UMComSimpleGridViewerController alloc] initWithArray:self.imageUrlArray index:index];
    viewerController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:viewerController animated:YES completion:nil];
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

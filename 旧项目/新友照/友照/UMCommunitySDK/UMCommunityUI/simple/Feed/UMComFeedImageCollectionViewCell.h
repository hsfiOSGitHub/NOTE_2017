//
//  UMComFeedImageCollectionViewCell.h
//  UMCommunity
//
//  Created by umeng on 16/5/15.
//  Copyright © 2016年 Umeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@class UMComImageView;
@interface UMComFeedImageCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *feedImageView;

@property (nonatomic,strong) UMComImageView *umcomImageView;

//- (void)resetImageViewWithImageUrl:(NSString *)imageUrl placeholder:(UIImage *)placeholder;

@end

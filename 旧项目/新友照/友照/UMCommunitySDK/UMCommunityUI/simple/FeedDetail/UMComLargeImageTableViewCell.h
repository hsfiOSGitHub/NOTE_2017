//
//  UMComLargeImageTableViewCell.h
//  UMCommunity
//
//  Created by umeng on 16/6/1.
//  Copyright © 2016年 Umeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@class UMComImageView;
@interface UMComLargeImageTableViewCell : UITableViewCell

@property (nonatomic, strong) UMComImageView *umImageView;

@property (nonatomic, strong) NSArray *imageUrlArray;

@property (weak, nonatomic) IBOutlet UIView *imageBgView;

@end

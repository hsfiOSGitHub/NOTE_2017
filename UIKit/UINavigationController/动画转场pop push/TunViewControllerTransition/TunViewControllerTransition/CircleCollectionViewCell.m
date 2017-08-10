//
//  CircleCollectionViewCell.m
//  TunViewControllerTransition
//
//  Created by 涂育旺 on 2017/7/18.
//  Copyright © 2017年 Qianhai Jiutong. All rights reserved.
//

#import "CircleCollectionViewCell.h"

@implementation CircleCollectionViewCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.imageView.layer.cornerRadius = 72;
    self.imageView.layer.masksToBounds = YES;
}
@end

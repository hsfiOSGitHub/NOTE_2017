//
//  ZXKeSanMoNiTableViewCell.h
//  ZXJiaXiao
//
//  Created by yujian on 16/5/12.
//  Copyright © 2016年 ZX. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZXKeSanMoNiTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *jiaxiaomingzi;
@property (weak, nonatomic) IBOutlet UIImageView *headImageView;
@property (weak, nonatomic) IBOutlet UILabel *carIdImageView;
@property (weak, nonatomic) IBOutlet UIImageView *star1Image;
@property (weak, nonatomic) IBOutlet UIImageView *star2Image;
@property (weak, nonatomic) IBOutlet UIImageView *star3Image;
@property (weak, nonatomic) IBOutlet UIImageView *star4Image;
@property (weak, nonatomic) IBOutlet UIImageView *star5Image;
@property (weak, nonatomic) IBOutlet UILabel *coachNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *saleLabel;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *manjian;
@property(strong,nonatomic)UIImageView* image11;
@property(strong,nonatomic)UIImageView* image22;
@property(strong,nonatomic)UIImageView* image33;
@property(strong,nonatomic)UIImageView* image44;
@property(strong,nonatomic)UIImageView* image55;
//通过model配置cell
- (void)setKeSanMoNiCellWith:(NSDictionary *)model;

@end

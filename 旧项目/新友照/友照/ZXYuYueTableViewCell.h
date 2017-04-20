//
//  ZXYuYueTableViewCell.h
//  ZXJiaXiao
//
//  Created by ZX on 16/3/15.
//  Copyright © 2016年 ZX. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZXYuYueTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *numOfYuYue;
@property (nonatomic, copy) NSArray *imageViewArr;
@property (weak, nonatomic) IBOutlet UIImageView *imageView1;
@property (weak, nonatomic) IBOutlet UIImageView *imageView2;
@property (weak, nonatomic) IBOutlet UIImageView *imageView3;
@property (weak, nonatomic) IBOutlet UIImageView *imageView4;
@property (weak, nonatomic) IBOutlet UIImageView *imageView5;
@property (weak, nonatomic) IBOutlet UIImageView *imageView6;
@property (weak, nonatomic) IBOutlet UIImageView *imageView7;
@property (weak, nonatomic) IBOutlet UIImageView *imageView8;
@property (weak, nonatomic) IBOutlet UIButton *yuYueButton;
@property (strong, nonatomic)  UIImageView *imgView;
- (void)setUpCell:(NSDictionary *)model;
@end

//
//  ZXCommentTableViewCell.h
//  ZXJiaXiao
//
//  Created by ZX on 16/3/19.
//  Copyright © 2016年 ZX. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZXCommentTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *headImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *commentLabel;
@property (weak, nonatomic) IBOutlet UIImageView *startImage1;
@property (weak, nonatomic) IBOutlet UIImageView *startImage2;
@property (weak, nonatomic) IBOutlet UIImageView *startImage3;
@property (weak, nonatomic) IBOutlet UIImageView *startImage4;
@property (weak, nonatomic) IBOutlet UIImageView *startImage5;

+(CGFloat )calculateContentHeight:(NSDictionary *)model;
- (void)setUpCellWith:(NSDictionary *)model;
-(void)resetContentLabelFrame:(NSDictionary *)model;
@end

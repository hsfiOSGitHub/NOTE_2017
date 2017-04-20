//
//  SchoolDetailHeader.h
//  友照
//
//  Created by monkey2016 on 16/11/24.
//  Copyright © 2016年 ZX_XPH. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SchoolDetailHeader : UITableViewHeaderFooterView

@property (weak, nonatomic) IBOutlet UIImageView *moreImgV;
@property (weak, nonatomic) IBOutlet UIButton *moreBtn;
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UIImageView *image1;
@property (weak, nonatomic) IBOutlet UIImageView *image2;
@property (weak, nonatomic) IBOutlet UIImageView *image3;
@property (weak, nonatomic) IBOutlet UIImageView *image4;
@property (weak, nonatomic) IBOutlet UIImageView *image5;
@property (weak, nonatomic) IBOutlet UILabel *fenlable;
@property (weak, nonatomic) IBOutlet UILabel *noCommentLable;
@property(strong,nonatomic)UIImageView* img11;
@property(strong,nonatomic)UIImageView* img22;
@property(strong,nonatomic)UIImageView* img33;
@property(strong,nonatomic)UIImageView* img44;
@property(strong,nonatomic)UIImageView* img55;

-(void)setHeaderWith:(NSDictionary *)model;

@end

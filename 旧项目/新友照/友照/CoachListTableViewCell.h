//
//  CoachListTableViewCell.h
//  友照
//
//  Created by chaoyang on 16/11/22.
//  Copyright © 2016年 ZX_XPH. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CoachListTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imageV;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *age;
@property (weak, nonatomic) IBOutlet UIImageView *starImageV;
@property (weak, nonatomic) IBOutlet UILabel *agv_rate;
@property (weak, nonatomic) IBOutlet UIImageView *starImageV1;
@property (weak, nonatomic) IBOutlet UIImageView *starImageV2;
@property (weak, nonatomic) IBOutlet UIImageView *starImageV3;
@property (weak, nonatomic) IBOutlet UIImageView *starImageV4;
@property (weak, nonatomic) IBOutlet UIImageView *starImageV5;
@property(strong,nonatomic) UIImageView* img11;
@property(strong,nonatomic) UIImageView* img22;
@property(strong,nonatomic) UIImageView* img33;
@property(strong,nonatomic) UIImageView* img44;
@property(strong,nonatomic) UIImageView* img55;

-(void)setModel:(NSDictionary *)Dic;
@end

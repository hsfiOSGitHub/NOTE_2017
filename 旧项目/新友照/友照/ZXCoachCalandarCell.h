//
//  ZXCoachCalandarCell.h
//  ZXJiaXiao
//
//  Created by Finsen on 16/4/7.
//  Copyright © 2016年 ZX. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FyCalendarView.h"

typedef void(^PingLunStyle)();

@interface ZXCoachCalandarCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIView *keyue;
@property (weak, nonatomic) IBOutlet UIView *xinrili;
@property (nonatomic, strong) NSDate *xindate;
@property (weak, nonatomic) IBOutlet UIView *keman;
@property (weak, nonatomic) IBOutlet UILabel *zanwupingjia;
@property (weak, nonatomic) IBOutlet UIImageView *image1;
@property (weak, nonatomic) IBOutlet UIImageView *image2;
@property (weak, nonatomic) IBOutlet UIImageView *image3;
@property (weak, nonatomic) IBOutlet UIImageView *image4;
@property (weak, nonatomic) IBOutlet UIImageView *image5;
@property (weak, nonatomic) IBOutlet UIView *commentBGV;
@property (weak, nonatomic) IBOutlet UILabel *fenlable;
@property (weak, nonatomic) IBOutlet UILabel *noCommentLable;
@property(strong,nonatomic)UIImageView* img11;
@property(strong,nonatomic)UIImageView* img22;
@property(strong,nonatomic)UIImageView* img33;
@property(strong,nonatomic)UIImageView* img44;
@property(strong,nonatomic)UIImageView* img55;

-(void)setCellWith:(NSDictionary *)model;
@end

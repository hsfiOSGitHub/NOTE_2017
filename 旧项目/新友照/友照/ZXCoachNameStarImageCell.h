//
//  ZXCoachNameStarImageCell.h
//  ZXJiaXiao
//
//  Created by Finsen on 16/4/7.
//  Copyright © 2016年 ZX. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZXCoachNameStarImageCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *CoachName;
@property (weak, nonatomic) IBOutlet UILabel *CarNumber;
@property (weak, nonatomic) IBOutlet UILabel *schoolName;
@property (weak, nonatomic) IBOutlet UILabel *lable1;
@property (weak, nonatomic) IBOutlet UILabel *lable2;
@property (weak, nonatomic) IBOutlet UILabel *lable3;
@property (weak, nonatomic) IBOutlet UILabel *lable4;

-(void)setCellWith:(NSDictionary *)model;
@end

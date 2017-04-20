//
//  ScheduleCell_1.h
//  CalendarDemo
//
//  Created by monkey2016 on 16/12/23.
//  Copyright © 2016年 monkey2016. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ScheduleCell_1 : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *emergency;
@property (weak, nonatomic) IBOutlet UILabel *titleName;
@property (weak, nonatomic) IBOutlet UILabel *time;
@property (weak, nonatomic) IBOutlet UILabel *tag1;
@property (weak, nonatomic) IBOutlet UILabel *tag2;
@property (weak, nonatomic) IBOutlet UILabel *tag3;
@property (weak, nonatomic) IBOutlet UILabel *content;
@property (weak, nonatomic) IBOutlet UIImageView *pic1;
@property (weak, nonatomic) IBOutlet UIImageView *pic2;
@property (weak, nonatomic) IBOutlet UIImageView *pic3;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *picWidthCons;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *picBottomCons;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *picTopCons;

@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bgViewTopCons;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bgViewBottomCons;



@end

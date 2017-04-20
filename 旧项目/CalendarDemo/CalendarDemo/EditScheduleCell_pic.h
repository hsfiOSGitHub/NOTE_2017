//
//  EditScheduleCell_pic.h
//  CalendarDemo
//
//  Created by monkey2016 on 16/12/27.
//  Copyright © 2016年 monkey2016. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EditScheduleCell_pic : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *pic1;
@property (weak, nonatomic) IBOutlet UIImageView *pic2;
@property (weak, nonatomic) IBOutlet UIImageView *pic3;

@property (weak, nonatomic) IBOutlet UIButton *deleteBtn1;
@property (weak, nonatomic) IBOutlet UIButton *deleteBtn2;
@property (weak, nonatomic) IBOutlet UIButton *deleteBtn3;

@property (weak, nonatomic) IBOutlet UIButton *addPicBtn;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *pictopCons;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *picBottomCons;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *picWidthCons;//图片宽度约束
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *deleteBtn1widthCons;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *deleteBtn2WidthCons;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *deleteBtn3WidthCons;

@property (weak, nonatomic) IBOutlet UIView *bgView1;
@property (weak, nonatomic) IBOutlet UIView *bgView2;
@property (weak, nonatomic) IBOutlet UIView *bgView3;


@end

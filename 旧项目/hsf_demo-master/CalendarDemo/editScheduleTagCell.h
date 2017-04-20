//
//  editScheduleTagCell.h
//  CalendarDemo
//
//  Created by monkey2016 on 16/12/30.
//  Copyright © 2016年 monkey2016. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface editScheduleTagCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *seleteBtn;
@property (weak, nonatomic) IBOutlet UIButton *selete_editBtn;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *seleteBtnLeftCons;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *selete_editBtnRightCons;


@end

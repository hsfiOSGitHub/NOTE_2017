//
//  EditEmergencyView.h
//  CalendarDemo
//
//  Created by monkey2016 on 16/12/28.
//  Copyright © 2016年 monkey2016. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EditEmergencyView : UIView
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bgViewWidthCons;
@property (weak, nonatomic) IBOutlet UIButton *maskBtn;

//展示
-(void)show;

@end

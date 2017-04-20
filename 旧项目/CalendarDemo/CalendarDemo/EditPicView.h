//
//  EditPicView.h
//  CalendarDemo
//
//  Created by monkey2016 on 16/12/28.
//  Copyright © 2016年 monkey2016. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EditPicView : UIView
@property (weak, nonatomic) IBOutlet UIButton *maskBtn_pic;
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UIButton *photo;
@property (weak, nonatomic) IBOutlet UIButton *camera;

//展示
-(void)show;

@end

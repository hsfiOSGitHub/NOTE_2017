//
//  AlertView.h
//  SZB_doctor
//
//  Created by monkey2016 on 16/9/7.
//  Copyright © 2016年 monkey2016. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AlertView : UIView
@property (nonatomic,strong) UILabel *alertLabel;
//展示方法
-(void)showAlertViewForTime:(NSTimeInterval)during;
@end

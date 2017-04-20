//
//  DatePicker24HoursView.h
//  CalendarDemo
//
//  Created by monkey2016 on 17/1/16.
//  Copyright © 2017年 monkey2016. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DatePicker24HoursView : UIView<UIPickerViewDelegate,UIPickerViewDataSource>
@property (weak, nonatomic) IBOutlet UIButton *maskBtn;
@property (weak, nonatomic) IBOutlet UIView *keyboardView;
@property (weak, nonatomic) IBOutlet UILabel *descLabel;
@property (weak, nonatomic) IBOutlet UIButton *rightBtn;
@property (weak, nonatomic) IBOutlet UIPickerView *date24Picker;

@property (nonatomic,strong) NSString *dateType;//开始时间、结束时间

//show
-(void)show;

@end

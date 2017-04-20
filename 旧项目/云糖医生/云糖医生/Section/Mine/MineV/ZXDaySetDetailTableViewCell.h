//
//  ZXDaySetDetailTableViewCell.h
//  ZXCoachApp
//
//  Created by Finsen on 16/5/25.
//  Copyright © 2016年 ZX. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UUDatePicker.h"
@interface ZXDaySetDetailTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *SetLable;
@property (weak, nonatomic) IBOutlet UITextField *SetTextField;
@property (nonatomic, strong) UUDatePicker *datePicker;
@property (nonatomic, strong) UIButton *btn;
@end

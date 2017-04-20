//
//  DateDetailTableViewCell.h
//  yuntangyi
//
//  Created by yuntangyi on 16/9/18.
//  Copyright © 2016年 yuntangyi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DateDetailTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UITextField *dateTF;

@property (weak, nonatomic) IBOutlet UITextField *TF1;
@property (weak, nonatomic) IBOutlet UITextField *TF2;
@property (weak, nonatomic) IBOutlet UITextField *TF3;
@property (weak, nonatomic) IBOutlet UITextField *TF4;
@property (weak, nonatomic) IBOutlet UITextField *TF5;
@property (weak, nonatomic) IBOutlet UITextField *TF6;
@property (weak, nonatomic) IBOutlet UITextField *TF7;
@property (weak, nonatomic) IBOutlet UITextField *TF8;
- (void)steDetaiData:(NSDictionary *)dic;
@end

//
//  DateAndSugarHeaderView.h
//  yuntangyi
//
//  Created by yuntangyi on 16/9/18.
//  Copyright © 2016年 yuntangyi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DateAndSugarHeaderView : UITableViewHeaderFooterView
@property (weak, nonatomic) IBOutlet UITextField *startDateTF;
@property (weak, nonatomic) IBOutlet UITextField *endDateTF;
@property (weak, nonatomic) IBOutlet UIImageView *startimageV;
@property (weak, nonatomic) IBOutlet UIImageView *endImageV;
@property (weak, nonatomic) IBOutlet UIView *bgView;

@end

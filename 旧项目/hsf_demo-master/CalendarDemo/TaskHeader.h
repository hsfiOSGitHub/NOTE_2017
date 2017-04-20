//
//  TaskHeader.h
//  CalendarDemo
//
//  Created by monkey2016 on 17/1/11.
//  Copyright © 2017年 monkey2016. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TaskHeader : UITableViewHeaderFooterView
@property (weak, nonatomic) IBOutlet UIImageView *icon;
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UIButton *detailBtn;

@end

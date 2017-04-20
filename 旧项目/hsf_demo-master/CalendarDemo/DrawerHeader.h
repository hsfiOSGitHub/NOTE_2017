//
//  DrawerHeader.h
//  CalendarDemo
//
//  Created by monkey2016 on 16/12/21.
//  Copyright © 2016年 monkey2016. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DrawerHeader : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *icon;
@property (weak, nonatomic) IBOutlet UILabel *userName;
@property (weak, nonatomic) IBOutlet UILabel *info;
@property (weak, nonatomic) IBOutlet UIButton *codeBtn;

@end

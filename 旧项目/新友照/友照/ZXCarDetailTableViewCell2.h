//
//  ZXCarDetailTableViewCell2.h
//  ZXJiaXiao
//
//  Created by Finsen on 16/5/12.
//  Copyright © 2016年 ZX. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZXCarDetailTableViewCell2 : UITableViewCell

@property (weak, nonatomic) IBOutlet UIButton *firstDayBtn;
@property (weak, nonatomic) IBOutlet UILabel *firstDaylabel;
@property (weak, nonatomic) IBOutlet UIButton *secDayBtn;
@property (weak, nonatomic) IBOutlet UILabel *secDaylabel;
@property (weak, nonatomic) IBOutlet UIButton *thrsrDayBtn;
@property (weak, nonatomic) IBOutlet UILabel *thrDaylabel;
@property (weak, nonatomic) IBOutlet UIButton *fouDayBtn;
@property (weak, nonatomic) IBOutlet UILabel *fouDaylabel;
@property (weak, nonatomic) IBOutlet UIButton *fivDayBtn;
@property (weak, nonatomic) IBOutlet UILabel *fivDaylabel;
@property (weak, nonatomic) IBOutlet UIButton *sixDayBtn;
@property (weak, nonatomic) IBOutlet UILabel *sixDaylabel;
@property (weak, nonatomic) IBOutlet UIButton *sevDayBtn;
@property (weak, nonatomic) IBOutlet UILabel *sevDaylabel;
@property (weak, nonatomic) IBOutlet UIButton *btn1;
@property (weak, nonatomic) IBOutlet UIButton *btn2;

- (void)setUpCellWith:(NSDictionary *)model;

@end

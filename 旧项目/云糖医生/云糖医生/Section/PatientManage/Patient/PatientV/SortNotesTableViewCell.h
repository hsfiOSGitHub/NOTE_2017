//
//  SortNotesTableViewCell.h
//  yuntangyi
//
//  Created by yuntangyi on 16/9/12.
//  Copyright © 2016年 yuntangyi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SortNotesTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *leftImageV;
@property (weak, nonatomic) IBOutlet UIImageView *rightImageV;
@property (weak, nonatomic) IBOutlet UILabel *leftTopLable;
@property (weak, nonatomic) IBOutlet UILabel *leftLowLable;
@property (weak, nonatomic) IBOutlet UILabel *rightTopLable;
@property (weak, nonatomic) IBOutlet UILabel *rightLowLable;
@property (weak, nonatomic) IBOutlet UIView *LeftView;

@property (weak, nonatomic) IBOutlet UIView *RightView;
@end

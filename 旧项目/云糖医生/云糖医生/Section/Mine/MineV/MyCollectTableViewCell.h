//
//  MyCollectTableViewCell.h
//  yuntangyi
//
//  Created by yuntangyi on 16/9/13.
//  Copyright © 2016年 yuntangyi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyCollectTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *contentLable;
@property (weak, nonatomic) IBOutlet UIImageView *imageV;
@property (weak, nonatomic) IBOutlet UILabel *timeLable;
@property (weak, nonatomic) IBOutlet UILabel *LookNumLable;
@property (weak, nonatomic) IBOutlet UILabel *collectNum;

@end

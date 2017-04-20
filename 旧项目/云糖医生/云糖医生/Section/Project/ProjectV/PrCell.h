//
//  PrCell.h
//  yuntangyi
//
//  Created by yuntangyi on 16/9/14.
//  Copyright © 2016年 yuntangyi. All rights reserved.
//

#import <UIKit/UIKit.h>
@class PrActivityListModel;

@interface PrCell : UITableViewCell
@property (nonatomic,strong) PrActivityListModel *activityListModel;

@property (weak, nonatomic) IBOutlet UIImageView *pic;//图片

@end

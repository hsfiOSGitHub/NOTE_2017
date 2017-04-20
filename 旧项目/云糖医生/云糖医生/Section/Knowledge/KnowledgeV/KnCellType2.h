//
//  KnCellType2.h
//  yuntangyi
//
//  Created by yuntangyi on 16/9/12.
//  Copyright © 2016年 yuntangyi. All rights reserved.
//

#import <UIKit/UIKit.h>
@class KnNewsListModel;

@interface KnCellType2 : UITableViewCell
@property (nonatomic,strong) KnNewsListModel *listModel;

@property (weak, nonatomic) IBOutlet UILabel *title;//标题
@property (weak, nonatomic) IBOutlet UIImageView *picView;//图片

@property (weak, nonatomic) IBOutlet UIImageView *numIcon;//人数icon
@property (weak, nonatomic) IBOutlet UILabel *numLabel;//人数
@property (weak, nonatomic) IBOutlet UIImageView *collectIcon;//收藏icon
@property (weak, nonatomic) IBOutlet UILabel *collectLabel;//收藏
@property (weak, nonatomic) IBOutlet UIImageView *timeIcon;//时间icon
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;//时间

@end

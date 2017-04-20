//
//  KnCellType2_2Cell.h
//  yuntangyi
//
//  Created by yuntangyi on 16/8/30.
//  Copyright © 2016年 yuntangyi. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface KnCellType1_2Cell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *icon;//图片
@property (weak, nonatomic) IBOutlet UILabel *title;//标题
@property (weak, nonatomic) IBOutlet UILabel *content;//内容
@property (nonatomic,strong) NSDictionary *iconAndTitleDic;//图片和标题

@end

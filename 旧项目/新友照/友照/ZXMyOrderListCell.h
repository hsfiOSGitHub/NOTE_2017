//
//  ZXMyOrderListCell.h
//  ZXJiaXiao
//
//  Created by yujian on 16/5/23.
//  Copyright © 2016年 ZX. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZXMyOrderListCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *dingDanNameLab;
@property (weak, nonatomic) IBOutlet UIButton *dingDanStatusBtn;
@property (weak, nonatomic) IBOutlet UIImageView *dingDanPic;
@property (weak, nonatomic) IBOutlet UILabel *jiaXiaoNameLab;
@property (weak, nonatomic) IBOutlet UILabel *keMuLab;
@property (weak, nonatomic) IBOutlet UILabel *jiaoLianNameLab;
@property (weak, nonatomic) IBOutlet UILabel *dingDanNumLab;

@property (weak, nonatomic) IBOutlet UILabel *dingDanPriceLab;
@property (weak, nonatomic) IBOutlet UILabel *dingDanTimeLab;
@property (weak, nonatomic) IBOutlet UIButton *payCoinBtn;

@property (weak, nonatomic) IBOutlet UIButton *cancelBtn;
@property (weak, nonatomic) IBOutlet UIButton *tuiKuanBtn;

@end

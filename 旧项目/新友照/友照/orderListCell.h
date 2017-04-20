//
//  orderListCell.h
//  友照
//
//  Created by cleloyang on 2017/2/7.
//  Copyright © 2017年 ZX_XPH. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface orderListCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *dingDanNameLab;
@property (weak, nonatomic) IBOutlet UIButton *dingDanStatusBtn;
@property (weak, nonatomic) IBOutlet UILabel *schoolNameLab;
@property (weak, nonatomic) IBOutlet UILabel *priceLab;
@property (weak, nonatomic) IBOutlet UILabel *gouMaiDateLab;
@property (weak, nonatomic) IBOutlet UILabel *keMuLab;
@property (weak, nonatomic) IBOutlet UIButton *payCoinBtn;
@property (weak, nonatomic) IBOutlet UIButton *payCancelBtn;

@end

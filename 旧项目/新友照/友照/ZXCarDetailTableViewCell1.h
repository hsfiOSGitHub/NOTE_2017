//
//  ZXCarDetailTableViewCell1.h
//  ZXJiaXiao
//
//  Created by Finsen on 16/5/12.
//  Copyright © 2016年 ZX. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZXCarDetailTableViewCell1 : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *PriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *oldPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *youhui;

- (void)setUpCellWith:(NSArray *)model;

@end

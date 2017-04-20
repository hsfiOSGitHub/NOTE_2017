//
//  ZXMyOrderListTableViewCell1.h
//  ZXJiaXiao
//
//  Created by Finsen on 16/7/26.
//  Copyright © 2016年 ZX. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZXMyOrderListTableViewCell1 : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *moNiBaCheLabel;
@property (weak, nonatomic) IBOutlet UIButton *payStateBtn;
@property (weak, nonatomic) IBOutlet UIImageView *headImageView;

@property (weak, nonatomic) IBOutlet UILabel *BuyCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;


@property (weak, nonatomic) IBOutlet UIView *sahnchuView;

@property (weak, nonatomic) IBOutlet UIButton *shanchu;
@property (weak, nonatomic) IBOutlet UILabel *dateLable;

@end

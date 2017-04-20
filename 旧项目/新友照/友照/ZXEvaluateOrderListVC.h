//
//  ZXEvaluateOrderListVC.h
//  ZXJiaXiao
//
//  Created by yujian on 16/5/21.
//  Copyright © 2016年 ZX. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZXEvaluateOrderListVC : ZXSeconBaseViewController

@property (nonatomic, strong)NSString *star_hd;//几颗星
@property (nonatomic, copy) NSString *tid;//教练id
@property (nonatomic, copy) NSString *sid;//驾校id
@property (nonatomic, copy) NSString *orderID;//订单id
@property (nonatomic, copy) NSString *bid;//科二学习的次数
@property (nonatomic, copy) NSString *order_sn;


@end

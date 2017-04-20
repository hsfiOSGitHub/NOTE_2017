//
//  ZX_TuiKuan_ViewController.h
//  友照
//
//  Created by cleloyang on 2016/12/8.
//  Copyright © 2016年 ZX_XPH. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZX_TuiKuan_ViewController : ZXSeconBaseViewController

//订单号
@property (nonatomic ,copy) NSString *orderNum;
//订单价格
@property (nonatomic,strong) NSString *Price;
//订单id
@property(nonatomic,strong)NSString *order_id;

@end

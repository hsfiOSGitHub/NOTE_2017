//
//  ZX_YouHuiQuan_ViewController.h
//  友照
//
//  Created by cleloyang on 2017/1/10.
//  Copyright © 2017年 ZX_XPH. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZX_TiJiaoDingDan_ViewController.h"

@interface ZX_YouHuiQuan_ViewController : ZXSeconBaseViewController

//订单id
@property (nonatomic, strong) NSString *orderId;
//商品数量
@property (nonatomic) NSInteger goodsNum;
//商品类型
@property (nonatomic, strong) NSString *goodsType;
//优惠券使用状态(是否可用)
@property (nonatomic, strong) NSString *useType;
//优惠券列表
@property (nonatomic, strong) NSString *list;
//商品总价
@property (nonatomic) float price;

@property (nonatomic) ZX_TiJiaoDingDan_ViewController *tiJiaoDingDanVC;
@end

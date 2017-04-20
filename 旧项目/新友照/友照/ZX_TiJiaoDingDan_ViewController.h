//
//  ZX_TiJiaoDingDan_ViewController.h
//  友照
//
//  Created by cleloyang on 2016/11/25.
//  Copyright © 2016年 ZX_XPH. All rights reserved.
//

#import <UIKit/UIKit.h>

//代理
@protocol ZXTiaoJiaoViewControllerDelegate<NSObject>
- (void)changerNumValue:(int)num;

@end

@interface ZX_TiJiaoDingDan_ViewController : ZXSeconBaseViewController

@property (nonatomic, assign) id<ZXTiaoJiaoViewControllerDelegate>delegate;

@property (nonatomic, copy) NSString *priceValue;
//赠送数量
@property (nonatomic) NSString *zengsongshuliang ;
//优惠活动
@property (nonatomic) NSString *youhuihuodong ;
//课时
@property (nonatomic) BOOL boo;
@property (nonatomic) NSInteger shuLiang;

//购买产品的id
@property (nonatomic, copy) NSString *productId;
//优惠券id
@property (nonatomic, copy) NSString *discount_id;
//优惠价格
@property (nonatomic, copy) NSString *money_discount;
//优惠券类型
@property (nonatomic, copy) NSString *discount;
//订单类型 12.科二学时卡 1.科二模拟卡 13.科三学时卡 2.科三模拟卡
@property (nonatomic, copy) NSString *goods_type;
//考场
@property (nonatomic, copy) NSString *kaoChangName;
//驾校
@property (nonatomic, copy) NSString *jiaXiaoName;
//教练
@property (nonatomic, copy) NSString *jiaoLianName;
//卡券剩余总数量
@property (nonatomic) NSInteger cardNum;
@property (nonatomic, copy) NSString *baocheleixing;
@end

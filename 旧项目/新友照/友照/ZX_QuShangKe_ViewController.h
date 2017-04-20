//
//  ZX_QuShangKe_ViewController.h
//  友照
//
//  Created by cleloyang on 2016/12/5.
//  Copyright © 2016年 ZX_XPH. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZX_QuShangKe_ViewController : ZXSeconBaseViewController

@property (nonatomic,copy) NSString *subId; //预约教练的id
@property (nonatomic, strong) NSString *jiaoLianName; //预约的教练的名字
@property (nonatomic, strong) NSString *subject;
@property (nonatomic ,strong) NSString *selectDate;
@property (nonatomic,strong) UITableView* quShangKeTabv;
@property (nonatomic ,strong) NSString *goods_type;
@property (nonatomic) BOOL isPaySuccess;

@end

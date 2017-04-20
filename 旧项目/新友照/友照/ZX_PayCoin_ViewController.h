//
//  ZX_PayCoin_ViewController.h
//  友照
//
//  Created by cleloyang on 2016/11/26.
//  Copyright © 2016年 ZX_XPH. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZX_PayCoin_ViewController : ZXSeconBaseViewController

@property (weak, nonatomic) IBOutlet UILabel *gouMaiLeiXingLab;
@property (weak, nonatomic) IBOutlet UILabel *gouMaiPriceLab;
@property (weak, nonatomic) IBOutlet UIButton *selectWXBtn;
@property (weak, nonatomic) IBOutlet UIButton *selectZFBtn;
@property (weak, nonatomic) IBOutlet UIButton *confirmPayBtn;
@property (weak, nonatomic) IBOutlet UIImageView *zhiFuBaoImg;

@property(nonatomic) BOOL fukuan;

//定时器
@property(strong,nonatomic) NSTimer *myTimer;
@property(nonatomic) NSInteger miao;
//从哪传来的
@property (nonatomic) BOOL fromOrderList;
//传过来服务器时间间隔
@property (nonatomic) int timebetween;

@property (nonatomic, copy) NSString *riQi;
@property (nonatomic, copy) NSString *orderId;
@property (nonatomic, copy) NSString *froms;
@property (nonatomic, copy) NSString *payPrice;

//来自补考缴费
@property (nonatomic) BOOL fromBuKaoJiaoFei;
@end

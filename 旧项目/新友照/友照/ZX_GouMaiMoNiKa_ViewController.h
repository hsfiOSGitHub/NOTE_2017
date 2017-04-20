//
//  ZX_GouMaiMoNiKa_ViewController.h
//  友照
//
//  Created by cleloyang on 2016/11/24.
//  Copyright © 2016年 ZX_XPH. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZX_GouMaiMoNiKa_ViewController : ZXSeconBaseViewController

//第几个考场，当前选中的是哪个考场
@property(nonatomic)NSInteger selectKaoChang;
//考场ID
@property (nonatomic, copy) NSString* kaoChangId;

@property (nonatomic, copy) NSString *goods_type;
//购买模拟卡详情数据
- (void)gouMaiMoNiKaData;
@end

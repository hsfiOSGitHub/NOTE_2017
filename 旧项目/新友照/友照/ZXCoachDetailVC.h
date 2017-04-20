//
//  ZXCoachDetailVC.h
//  ZXJiaXiao
//
//  Created by Finsen on 16/4/7.
//  Copyright © 2016年 ZX. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface ZXCoachDetailVC : ZXSeconBaseViewController

@property (nonatomic, copy) NSString *tid;//教练的tid
@property (nonatomic, copy) NSString *name;//教练的名字
@property(nonatomic)BOOL kesan;
@property(nonatomic)BOOL benxiao;

@end

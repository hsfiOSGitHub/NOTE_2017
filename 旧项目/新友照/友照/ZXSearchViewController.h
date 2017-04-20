//
//  ZXSearchViewController.h
//  ZXJiaXiao
//
//  Created by ZX on 16/4/22.
//  Copyright © 2016年 ZX. All rights reserved.
//

#import "ZXSeconBaseViewController.h"

@interface ZXSearchViewController : ZXSeconBaseViewController
@property (nonatomic, assign) BOOL isSearchCoach;//是否是搜搜教练
@property (nonatomic, copy) NSString *sid;
//搜索教练科目是必要的参数
@property (nonatomic, copy) NSString *subject;
@property (nonatomic, copy) NSString *tid;
@property(nonatomic,strong)NSString* city;

@end

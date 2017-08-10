//
//  HSFNestVC.h
//  HSFDemo
//
//  Created by JuZhenBaoiMac on 2017/6/23.
//  Copyright © 2017年 JuZhenBaoiMac. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HSFBaseTableVC;
@class HSFTableView;
#import "BaseVC.h"

#define k_Header_Height 200

@interface HSFNestVC : BaseVC


@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,assign) CGFloat segHead_height;
@property (nonatomic,assign) BOOL isClearNavi;//导航栏是否透明


@property (nonatomic, strong) MLMSegmentHead *segHead;
@property (nonatomic, strong) MLMSegmentScroll *segScroll;


-(void)setUpWithVCs:(NSArray*)VCs titles:(NSArray *)titles;
-(void)setUpHeaderImg:(NSString *)imgName;
-(void)setUpMoreBtn:(UIView *)moreBtn;

@end

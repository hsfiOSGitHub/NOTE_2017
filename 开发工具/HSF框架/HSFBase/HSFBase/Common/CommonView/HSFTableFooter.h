//
//  HSFTableFooter.h
//  HSFBase
//
//  Created by JuZhenBaoiMac on 2017/6/17.
//  Copyright © 2017年 JuZhenBaoiMac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HSFTableFooter : UIView

//tableView的footer
@property (nonatomic,strong) UIView *footer;
@property (nonatomic,strong) UIView *footer_bgView;
@property (nonatomic,strong) UILabel *footer_titleLabel;
@property (nonatomic,strong) UIButton *footer_clickBtn;

@end

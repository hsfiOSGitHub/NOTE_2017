//
//  HSFTableHeader.h
//  HSFBase
//
//  Created by JuZhenBaoiMac on 2017/6/17.
//  Copyright © 2017年 JuZhenBaoiMac. All rights reserved.
//

#import <UIKit/UIKit.h>

#define k_headerHeight 200


@interface HSFTableHeader : UIView

@property (nonatomic,strong) UIImageView *bgPic;//背景图片
@property (nonatomic,strong) UIView *titleBgView;
@property (nonatomic,strong) UIView *alphaView;
@property (nonatomic,strong) UIButton *titleBtn;



@end

//
//  HSFDetailCell_T.h
//  HSFBase
//
//  Created by JuZhenBaoiMac on 2017/6/26.
//  Copyright © 2017年 JuZhenBaoiMac. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, HSFDetailCell_TStyle) {
    TStyle_detail,//点击页面跳转
    TStyle_selete//点击选择
};

@interface HSFDetailCell_T : UITableViewCell

@property (nonatomic,assign) HSFDetailCell_TStyle style;

@property (weak, nonatomic) IBOutlet UILabel *title;

//选择
@property (weak, nonatomic) IBOutlet UIImageView *seleteIcon;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *rightCons;

@end

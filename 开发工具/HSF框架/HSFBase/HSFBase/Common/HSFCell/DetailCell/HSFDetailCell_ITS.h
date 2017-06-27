//
//  HSFDetailCell_ITS.h
//  HSFBase
//
//  Created by JuZhenBaoiMac on 2017/6/26.
//  Copyright © 2017年 JuZhenBaoiMac. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, HSFDetailCell_ITSStyle) {
    ITSStyle_detail,//点击页面跳转
    ITSStyle_selete//点击选择
};


@interface HSFDetailCell_ITS : UITableViewCell

@property (nonatomic,assign) HSFDetailCell_ITSStyle style;

@property (weak, nonatomic) IBOutlet UIImageView *icon;
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *subTitle;

//选择
@property (weak, nonatomic) IBOutlet UIImageView *seleteIcon;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *rightCons;

@end

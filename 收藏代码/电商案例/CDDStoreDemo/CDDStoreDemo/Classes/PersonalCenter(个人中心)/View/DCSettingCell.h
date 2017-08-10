//
//  DCSettingCell.h
//  CDDMall
//
//  Created by apple on 2017/6/4.
//  Copyright © 2017年 RocketsChen. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger , cellType) {
    cellTypeOne     =  0,
    cellTypeTwo     =  1,
    cellTypeThree   =  2
};

@interface DCSettingCell : UITableViewCell

/* title */
@property (strong , nonatomic)UILabel *titleLabel;
/* UISwitch */
@property (strong , nonatomic)UISwitch *setSwitch;
/* 指示按钮 */
@property (strong , nonatomic)UIButton *indicateButton;
/* 内容 */
@property (strong , nonatomic)UILabel *contentLabel;
/* 日期 */
@property (strong , nonatomic)UITextField *birthField;

/* cell类型 */
@property (assign , nonatomic)cellType type;

@end

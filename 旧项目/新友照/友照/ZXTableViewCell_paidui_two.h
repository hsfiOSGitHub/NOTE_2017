//
//  ZXTableViewCell_paidui_two.h
//  ZXJiaXiao
//
//  Created by ZX on 16/6/20.
//  Copyright © 2016年 ZX. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZXTableViewCell_paidui_two : UITableViewCell
//当前上车号码的标签
@property (weak, nonatomic) IBOutlet UILabel *dangqianhaoma_biaoqian;
//您的上车号码内容
@property (weak, nonatomic) IBOutlet UILabel *sahngchehaoma_wode;
//背景色
@property (weak, nonatomic) IBOutlet UIButton *beijing;

//当前上车号码的内容
@property (weak, nonatomic) IBOutlet UILabel *dangqianshangchehaoma_wenzi;
//当前上车号码没有内容是显示的标签
@property (weak, nonatomic) IBOutlet UILabel *meiyoudangqianhaoma;
//您的上车号码没有内容时显示的标签
@property (weak, nonatomic) IBOutlet UILabel *meiyouhaoma;
//预计上车时间
@property (weak, nonatomic) IBOutlet UILabel *shangcheshijian;
//上车号码标签
@property (weak, nonatomic) IBOutlet UILabel *shangchehaoma_biaoqian;

@end

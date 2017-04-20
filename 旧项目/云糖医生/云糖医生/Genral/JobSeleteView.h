//
//  SZBAlertView4.h
//  yuntangyi
//
//  Created by yuntangyi on 16/9/19.
//  Copyright © 2016年 yuntangyi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JobSeleteView : UIView<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UILabel *title;//标题
@property (weak, nonatomic) IBOutlet UITableView *tableView;//tableView
@property (weak, nonatomic) IBOutlet UIButton *cancelBtn;//取消按钮
@property (weak, nonatomic) IBOutlet UIButton *okBtn;//确认按钮

@property (nonatomic,strong) NSArray *source;//数据源

@property (nonatomic,strong) NSString *headerStr;//header 的 title
@end

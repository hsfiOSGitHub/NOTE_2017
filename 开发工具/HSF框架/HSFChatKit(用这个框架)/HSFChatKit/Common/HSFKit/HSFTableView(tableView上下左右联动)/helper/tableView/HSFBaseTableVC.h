//
//  HSFBaseTableVC.h
//  HSFDemo
//
//  Created by JuZhenBaoiMac on 2017/6/23.
//  Copyright © 2017年 JuZhenBaoiMac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HSFBaseTableVC : UIViewController<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, assign) BOOL vcCanScroll;
@property (nonatomic,strong) HSFTableView *tableView;

@end

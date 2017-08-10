//
//  BaseTableVC.h
//  SuperCar
//
//  Created by JuZhenBaoiMac on 2017/5/19.
//  Copyright © 2017年 JuZhenBaoiMac. All rights reserved.
//

#import "BaseVC.h"



@class HSFTableHeader;
@class HSFTableFooter;
@class HSFSearchTF;

@interface BaseTableVC : BaseVC


@property (nonatomic,strong) UITableView *tableView;
//tableView的 footer
@property (nonatomic,strong) HSFTableFooter *footer;
//header
@property (nonatomic,strong) HSFTableHeader *header;
//搜索框
@property (nonatomic,strong) HSFSearchTF *searchTF;

//数据源
@property (nonatomic,strong) NSMutableArray *source;





//注册cell cellClassArr --> @{@"class":@"",@"identifier":@""}
-(void)registerCellWithCellClassArray:(NSArray *)cellClassArr;





@end

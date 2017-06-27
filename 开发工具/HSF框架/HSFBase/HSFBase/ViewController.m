//
//  ViewController.m
//  HSFBase
//
//  Created by JuZhenBaoiMac on 2017/6/17.
//  Copyright © 2017年 JuZhenBaoiMac. All rights reserved.
//

#import "ViewController.h"

//HSFDetailCell
#import "HSFDetailCell_ITS.h"
#import "HSFDetailCell_IT.h"
#import "HSFDetailCell_TS.h"
#import "HSFDetailCell_T.h"
#import "HSFDetailCell_ITI.h"
#import "HSFDetailCell_TI.h"
//HSFInfoCell
#import "HSFInfoCell_LeftImg.h"
#import "HSFInfoCell_RightImg.h"
//HSFSwitchCell
#import "HSFSwitchCell_ITS.h"
#import "HSFSwitchCell_TS.h"
#import "HSFSwitchCell_IT.h"
#import "HSFSwitchCell_T.h"

@interface ViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.estimatedRowHeight = 44;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    //注册cell
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([HSFDetailCell_ITS class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([HSFDetailCell_ITS class])];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([HSFDetailCell_IT class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([HSFDetailCell_IT class])];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([HSFDetailCell_TS class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([HSFDetailCell_TS class])];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([HSFDetailCell_T class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([HSFDetailCell_T class])];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([HSFDetailCell_ITI class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([HSFDetailCell_ITI class])];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([HSFDetailCell_TI class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([HSFDetailCell_TI class])];
    
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([HSFInfoCell_LeftImg class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([HSFInfoCell_LeftImg class])];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([HSFInfoCell_RightImg class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([HSFInfoCell_RightImg class])];
    
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([HSFSwitchCell_ITS class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([HSFSwitchCell_ITS class])];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([HSFSwitchCell_TS class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([HSFSwitchCell_TS class])];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([HSFSwitchCell_IT class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([HSFSwitchCell_IT class])];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([HSFSwitchCell_T class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([HSFSwitchCell_T class])];
}

#pragma mark -UITableViewDelegate, UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 6;
    }
    else if (section == 1) {
        return 2;
    }
    else if (section == 2) {
        return 4;
    }
    return 0;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            HSFDetailCell_ITS *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HSFDetailCell_ITS class]) forIndexPath:indexPath];
            cell.style = ITSStyle_selete;
            return cell;
        }
        else if (indexPath.row == 1) {
            HSFDetailCell_IT *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HSFDetailCell_IT class]) forIndexPath:indexPath];
            cell.style = ITStyle_selete;
            return cell;
        }
        else if (indexPath.row == 2) {
            HSFDetailCell_TS *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HSFDetailCell_TS class]) forIndexPath:indexPath];
            cell.style = TSStyle_selete;
            return cell;
        }
        else if (indexPath.row == 3) {
            HSFDetailCell_T *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HSFDetailCell_T class]) forIndexPath:indexPath];
            cell.style = TStyle_selete;
            return cell;
        }
        else if (indexPath.row == 4) {
            HSFDetailCell_ITI *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HSFDetailCell_ITI class]) forIndexPath:indexPath];
            return cell;
        }
        else{
            HSFDetailCell_TI *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HSFDetailCell_TI class]) forIndexPath:indexPath];
            return cell;
        }
    }
    else if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            HSFInfoCell_LeftImg *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HSFInfoCell_LeftImg class]) forIndexPath:indexPath];
            return cell;
        }
        else{
            HSFInfoCell_RightImg *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HSFInfoCell_RightImg class]) forIndexPath:indexPath];
            return cell;
        }
    }
    else if (indexPath.section == 2) {
        if (indexPath.row == 0) {
            HSFSwitchCell_ITS *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HSFSwitchCell_ITS class]) forIndexPath:indexPath];
            return cell;
        }
        if (indexPath.row == 1) {
            HSFSwitchCell_TS *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HSFSwitchCell_TS class]) forIndexPath:indexPath];
            return cell;
        }
        if (indexPath.row == 2) {
            HSFSwitchCell_IT *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HSFSwitchCell_IT class]) forIndexPath:indexPath];
            return cell;
        }
        else{
            HSFSwitchCell_T *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HSFSwitchCell_T class]) forIndexPath:indexPath];
            return cell;
        }
    }
    return nil;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 30;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.1;
}
- (nullable NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return @"HSFDetailCell";
    }
    else if (section == 1) {
        return @"HSFInfoCell";
    }
    else if (section == 2) {
        return @"HSFSwitchCell";
    }
    return nil;
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

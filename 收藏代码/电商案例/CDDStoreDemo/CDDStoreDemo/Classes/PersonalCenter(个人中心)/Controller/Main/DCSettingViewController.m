//
//  DCSettingViewController.m
//  CDDMall
//
//  Created by apple on 2017/5/31.
//  Copyright © 2017年 RocketsChen. All rights reserved.
//

#import "DCSettingViewController.h"

// Controllers
#import "DCHelpBackViewController.h"
// Models

// Views
#import "DCSettingCell.h"
// Vendors
#import "WJYAlertView.h"
// Categories

// Others

@interface DCSettingViewController ()<UITableViewDelegate,UITableViewDataSource>

/* tableView */
@property (strong , nonatomic)UITableView *tableView;

@end

static NSString *const DCSettingCellID = @"DCSettingCell";

@implementation DCSettingViewController

#pragma mark - LazyLoad
- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.frame = CGRectMake(0, DCTopNavH, ScreenW, ScreenH - DCTopNavH);
        _tableView.delegate = self;
        _tableView.dataSource = self;
        
        [self.view addSubview:_tableView];
        
        [_tableView registerClass:[DCSettingCell class] forCellReuseIdentifier:DCSettingCellID];
    }
    return _tableView;
}


#pragma mark - LifeCyle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUpTab];
    
    [self setUpBottonButton];
}


#pragma mark - initizlize
- (void)setUpTab
{
    self.view.backgroundColor = DCBGColor;
    self.tableView.backgroundColor = self.view.backgroundColor;
    self.automaticallyAdjustsScrollViewInsets = NO;
}

#pragma mark - 退出登录按钮
- (void)setUpBottonButton
{
    UIView *buttonView = [[UIView alloc] init];
    buttonView.dc_height = 44;
    
    UIButton *logOffBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [logOffBtn setBackgroundImage:[UIImage imageNamed:@"btn_LogOff_red"] forState:UIControlStateNormal];
    
    [logOffBtn setTitle:@"注销登录" forState:UIControlStateNormal];
    logOffBtn.dc_height = buttonView.dc_height;
    logOffBtn.dc_x = 20;
    logOffBtn.dc_width = ScreenW - 40;
    
    [buttonView addSubview:logOffBtn];
    
    [logOffBtn addTarget:self action:@selector(logOffBtnClick) forControlEvents:UIControlEventTouchUpInside];
    self.tableView.tableFooterView = buttonView;
    
}

#pragma mark - <UITableViewDataSource>

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return (section == 0) ? 1: (section == 1)? 2 : (section == 2) ? 1: (section == 3) ? 4:0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DCSettingCell *cell = [tableView dequeueReusableCellWithIdentifier:DCSettingCellID forIndexPath:indexPath];
    [cell setAccessoryType:UITableViewCellAccessoryNone];
    
    if (indexPath.section == 0) {
        cell.type = cellTypeOne;
        cell.titleLabel.text = @"账户安全";
        cell.contentLabel.text = @"安全等级：高";
        [DCSpeedy dc_setSomeOneChangeColor:cell.contentLabel SetSelectArray:@[@"低",@"中",@"高"] SetChangeColor:[UIColor orangeColor]];
        [cell.indicateButton setImage:[UIImage imageNamed:@"icon_charge_jiantou"] forState:UIControlStateNormal];
        
    }else if (indexPath.section == 1){
        if (indexPath.row == 0) {
            cell.type = cellTypeTwo;
            cell.titleLabel.text = @"智能省流量";
            cell.setSwitch.on = YES;
        }else if (indexPath.row == 1){
            cell.type = cellTypeOne;
            cell.titleLabel.text = @"清除缓存";
            cell.contentLabel.text = @"6.66M";
            [cell.indicateButton setImage:[UIImage imageNamed:@"icon_charge_jiantou"] forState:UIControlStateNormal];
        }
        
    }else if (indexPath.section == 2){
        cell.type = cellTypeTwo;
        cell.titleLabel.text = @"接受消息通知";
        cell.setSwitch.on = NO;
        
    }else if (indexPath.section == 3){
        cell.type = cellTypeOne;
        NSArray *titles = @[@"关于作者",@"帮助反馈",@"给我的GitHub点星",@"邮箱地址：rocketschen@foxmail.com"];
        cell.titleLabel.text = titles[indexPath.row];
        if (indexPath.row == 3) {
            [cell.indicateButton setImage:[UIImage imageNamed:@"BZFK_newdianhua"] forState:UIControlStateNormal];
        }else{
            [cell.indicateButton setImage:[UIImage imageNamed:@"icon_charge_jiantou"] forState:UIControlStateNormal];
        }
    }
    
    return cell;
}

#pragma mark - <UITableViewDelegate>
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.0001;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 30;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    DCHelpBackViewController *helpVc = [[DCHelpBackViewController alloc] init];
    [self.navigationController pushViewController:helpVc animated:YES];
}

#pragma mark - 点击事件
- (void)logOffBtnClick
{
    __weak typeof(self)weakSelf = self;
    [WJYAlertView showTwoButtonsWithTitle:@"温馨提示" Message:@"是否确定退出登录" ButtonType:WJYAlertViewButtonTypeWarn ButtonTitle:@"确定" Click:^{
        [weakSelf.navigationController popViewControllerAnimated:YES];
    } ButtonType:WJYAlertViewButtonTypeCancel ButtonTitle:@"取消" Click:nil];
}

@end

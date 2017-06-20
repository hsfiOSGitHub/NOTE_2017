//
//  ViewController.m
//  ProgressCus
//
//  Created by ZhangWeichen on 2017/6/2.
//  Copyright © 2017年 Avcon. All rights reserved.
//

#import "ViewController.h"
#import "ProgressTableViewCell.h"
@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>


@property (nonatomic,strong) UITableView *processTableView;
@property (nonatomic,strong) NSArray *titleArr;
@property (nonatomic,strong) NSArray *contentArr;

@end

@implementation ViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.titleArr = @[@"互助申请",@"时间调查",@"直接划款"];
    self.contentArr = @[@"拨打电话400-900-7787发起请求",@"第三方专业公估机构核实后,全平台公示",@"公示通过无异议,从互助金中划款"];

    [self.view addSubview:self.processTableView];
}

-(UITableView *)processTableView{
    if (!_processTableView) {
        _processTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) style:UITableViewStylePlain];
        _processTableView.delegate = self;
        _processTableView.dataSource = self;
        _processTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _processTableView;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return self.titleArr.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    return 100;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    static NSString *cellid = @"cellid";
    ProgressTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellid];
    if (!cell) {
        cell = [[ProgressTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell assignmentCellModel:indexPath.row :_titleArr :_contentArr];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    NSLog(@"---------------------");
}

@end

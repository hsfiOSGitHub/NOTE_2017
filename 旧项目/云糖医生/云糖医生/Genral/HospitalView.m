//
//  SZBAlertView5.m
//  yuntangyi
//
//  Created by yuntangyi on 16/9/20.
//  Copyright © 2016年 yuntangyi. All rights reserved.
//

#import "HospitalView.h"

#import "SZBAlertViewHeader.h"
#define space 30
#define rowH 50

static NSString *identifierHeader = @"identifierHeader";
@implementation HospitalView


//初始化方法
-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self = (HospitalView *)[self loadNibView];
        self.frame = frame;
        [self setUpSubviews];
    }
    return self;
}
//获取到xib中的View
-(UIView *)loadNibView{
    NSArray *views = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil];
    return views.firstObject;
}
//配置
-(void)setUpSubviews{
    //配置self
    self.layer.masksToBounds = YES;
    self.layer.cornerRadius = 10;
    //配置按钮、
    _cancelBtn.layer.masksToBounds = YES;
    _cancelBtn.layer.cornerRadius = 5;
    [_cancelBtn setBackgroundColor:[UIColor lightGrayColor]];
    [_cancelBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    _okBtn.layer.masksToBounds = YES;
    _okBtn.layer.cornerRadius = 5;
    [_okBtn setBackgroundColor:KRGB(20, 157, 192, 1)];
    [_okBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    //配置tableView
    _tableView1.layer.masksToBounds = YES;
    _tableView1.layer.cornerRadius = 10;
    _tableView1.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _tableView1.layer.borderWidth = 1;
    _tableView1.delegate = self;
    _tableView1.dataSource = self;
    _tableView1.showsVerticalScrollIndicator = NO;
    _tableView1.rowHeight = rowH;
    _tableView1.sectionHeaderHeight = rowH;
    _tableView1.sectionFooterHeight = 0.1;
    [_tableView1 registerNib:[UINib nibWithNibName:NSStringFromClass([SZBAlertViewHeader class]) bundle:nil] forHeaderFooterViewReuseIdentifier:identifierHeader];
    
    _tableView2.layer.masksToBounds = YES;
    _tableView2.layer.cornerRadius = 10;
    _tableView2.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _tableView2.layer.borderWidth = 1;
    _tableView2.delegate = self;
    _tableView2.dataSource = self;
    _tableView2.showsVerticalScrollIndicator = NO;
    _tableView2.rowHeight = rowH;
    _tableView2.sectionHeaderHeight = rowH;
    _tableView2.sectionFooterHeight = 0.1;
    [_tableView2 registerNib:[UINib nibWithNibName:NSStringFromClass([SZBAlertViewHeader class]) bundle:nil] forHeaderFooterViewReuseIdentifier:identifierHeader];
    
    _tableView3.layer.masksToBounds = YES;
    _tableView3.layer.cornerRadius = 10;
    _tableView3.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _tableView3.layer.borderWidth = 1;
    _tableView3.delegate = self;
    _tableView3.dataSource = self;
    _tableView3.showsVerticalScrollIndicator = NO;
    _tableView3.rowHeight = rowH;
    _tableView3.sectionHeaderHeight = rowH;
    _tableView3.sectionFooterHeight = 0.1;
    [_tableView3 registerNib:[UINib nibWithNibName:NSStringFromClass([SZBAlertViewHeader class]) bundle:nil] forHeaderFooterViewReuseIdentifier:identifierHeader];
    
}
//绘制
- (void)drawRect:(CGRect)rect {
    [self setUpSubviews];
}
-(void)awakeFromNib{
    [super awakeFromNib];
    [self setUpSubviews];
}
//点击展开 收回 1
- (void)showBtnAction1:(UIButton *)sender {
    if (![self.currentBtn isEqual:sender]) {
        if (self.currentBtn.tag == 200) {
            [self showBtnAction2:self.currentBtn];
        }else if (self.currentBtn.tag == 300) {
            [self showBtnAction3:self.currentBtn];
        }
    }
    sender.selected = !sender.selected;
    [UIView animateWithDuration:0.5 animations:^{
        if (sender.selected) {
            self.frame = CGRectMake(space, 0, KScreenWidth - 2 * space, 115 + (rowH + 15) * 3 + rowH * 2);
            self.tableView1Height.constant = rowH * 3;
        }else{
            self.frame = CGRectMake(space, 0, KScreenWidth - 2 * space, 115 + (rowH + 15) * 3 );
            self.tableView1Height.constant = rowH;
        }
        self.center = CGPointMake(KScreenWidth/2, KScreenHeight/2);
        sender.transform = CGAffineTransformRotate(sender.transform, M_PI);
    }];
    
    if (self.tableView1Height.constant == rowH && self.tableView2Height.constant == rowH && self.tableView3Height.constant == rowH) {
        self.currentBtn = nil;
    }else{
        self.currentBtn = sender;
    }
}
//点击展开 收回 2
- (void)showBtnAction2:(UIButton *)sender {
    if (![self.currentBtn isEqual:sender]) {
        if (self.currentBtn.tag == 100) {
            [self showBtnAction1:self.currentBtn];
        }else if (self.currentBtn.tag == 300) {
            [self showBtnAction3:self.currentBtn];
        }
    }
    sender.selected = !sender.selected;
    [UIView animateWithDuration:0.5 animations:^{
        if (sender.selected) {
            self.frame = CGRectMake(space, 0, KScreenWidth - 2 * space, 115 + (rowH + 15) * 3 + rowH * 2);
            self.tableView2Height.constant = rowH * 3;
        }else{
            self.frame = CGRectMake(space, 0, KScreenWidth - 2 * space, 115 + (rowH + 15) * 3 );
            self.tableView2Height.constant = rowH;
        }
        self.center = CGPointMake(KScreenWidth/2, KScreenHeight/2);
        sender.transform = CGAffineTransformRotate(sender.transform, M_PI);
    }];
    
    if (self.tableView1Height.constant == rowH && self.tableView2Height.constant == rowH && self.tableView3Height.constant == rowH) {
        self.currentBtn = nil;
    }else{
        self.currentBtn = sender;
    }
}
//点击展开 收回 3
- (void)showBtnAction3:(UIButton *)sender {
    if (![self.currentBtn isEqual:sender]) {
        if (self.currentBtn.tag == 100) {
            [self showBtnAction1:self.currentBtn];
        }else if (self.currentBtn.tag == 200) {
            [self showBtnAction2:self.currentBtn];
        }
    }
    sender.selected = !sender.selected;
    [UIView animateWithDuration:0.5 animations:^{
        if (sender.selected) {
            self.frame = CGRectMake(space, 0, KScreenWidth - 2 * space, 115 + (rowH + 15) * 3 + rowH * 2);
            self.tableView3Height.constant = rowH * 3;
        }else{
            self.frame = CGRectMake(space, 0, KScreenWidth - 2 * space, 115 + (rowH + 15) * 3 );
            self.tableView3Height.constant = rowH;
        }
        self.center = CGPointMake(KScreenWidth/2, KScreenHeight/2);
        sender.transform = CGAffineTransformRotate(sender.transform, M_PI);
    }];
    
    if (self.tableView1Height.constant == rowH && self.tableView2Height.constant == rowH && self.tableView3Height.constant == rowH) {
        self.currentBtn = nil;
    }else{
        self.currentBtn = sender;
    }
}

#pragma mark -UITableViewDelegate,UITableViewDataSource
//组数
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
//行数
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    //    return [self.source count];
    return 10;
}
//行内容
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell;
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"alertCell"];
    }else{
        cell = [tableView dequeueReusableCellWithIdentifier:@"alertCell"];
    }
    //赋值
    cell.textLabel.text = self.source[indexPath.row];
    return cell;
}
//自定义header
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    SZBAlertViewHeader *header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:identifierHeader];
    //点击showBtn事件
    if (tableView == _tableView1) {
        [header.showBtn setTag:100];
        [header.showBtn addTarget:self action:@selector(showBtnAction1:) forControlEvents:UIControlEventTouchUpInside];
    }else if (tableView == _tableView2) {
        [header.showBtn setTag:200];
        [header.showBtn addTarget:self action:@selector(showBtnAction2:) forControlEvents:UIControlEventTouchUpInside];
    }else if (tableView == _tableView3) {
        [header.showBtn setTag:300];
        [header.showBtn addTarget:self action:@selector(showBtnAction3:) forControlEvents:UIControlEventTouchUpInside];
    }
    return header;
}



@end

//
//  SZBAlertView4.m
//  yuntangyi
//
//  Created by yuntangyi on 16/9/19.
//  Copyright © 2016年 yuntangyi. All rights reserved.
//

#import "JobSeleteView.h"

#import "SZBAlertViewHeader.h"
#define space 30
#define rowH 50
#import "ValueHelper.h"

@interface JobSeleteView ()

@property (nonatomic,strong) SZBAlertViewHeader *header;


@end

static NSString *identifierHeader = @"identifierHeader";
@implementation JobSeleteView
#pragma mark -懒加载


#pragma mark -初始化方法
-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self = (JobSeleteView *)[self loadNibView];
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
    _tableView.layer.masksToBounds = YES;
    _tableView.layer.cornerRadius = 10;
    _tableView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _tableView.layer.borderWidth = 1;
    
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.rowHeight = rowH;
    _tableView.sectionHeaderHeight = rowH;
    _tableView.sectionFooterHeight = 0.1;
    [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([SZBAlertViewHeader class]) bundle:nil] forHeaderFooterViewReuseIdentifier:identifierHeader];
    
    _title.text = @"选择职称";
}
//绘制
- (void)drawRect:(CGRect)rect {
    [self setUpSubviews];
}
-(void)awakeFromNib{
    [super awakeFromNib];
    [self setUpSubviews];
}
//点击展开 收回
- (void)showBtnAction:(UIButton *)sender {
    sender.selected = !sender.selected;
    [UIView animateWithDuration:0.5 animations:^{
        sender.transform = CGAffineTransformRotate(sender.transform, M_PI);
    }];
    [UIView animateWithDuration:0.5 animations:^{
        if (sender.selected) {
            self.frame = CGRectMake(space, 0, KScreenWidth - 2 * space, 130 + rowH * 3);
            self.tableView.scrollEnabled = YES;
        }else{
            self.frame = CGRectMake(space, 0, KScreenWidth - 2 * space, 130 + rowH);
            self.tableView.scrollEnabled = NO;
        }
        self.center = CGPointMake(KScreenWidth/2, KScreenHeight/2);
    }];
}

#pragma mark -UITableViewDelegate,UITableViewDataSource
//组数
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
//行数
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.source count];
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
//点击cell
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *name = self.source[indexPath.row];
    _header.title.text = name;
}
//自定义header
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    _header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:identifierHeader];
    [_header.showBtn addTarget:self action:@selector(showBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    _header.title.text = self.headerStr;
    return _header;
}
//点击取消
- (IBAction)cancelBtnAction:(UIButton *)sender {
    [[NSNotificationCenter defaultCenter] postNotificationName:JobView_cancel_noti object:nil];
}
//点击确认
- (IBAction)okBtnAction:(id)sender {
    NSString *result = _header.title.text;
    [[NSNotificationCenter defaultCenter] postNotificationName:JobView_ok_noti  object:nil userInfo:@{@"title":result}];
    
}








@end

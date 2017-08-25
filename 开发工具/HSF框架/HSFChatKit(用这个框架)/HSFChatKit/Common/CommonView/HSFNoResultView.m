//
//  HSFNoResultView.m
//  HSFBase
//
//  Created by JuZhenBaoiMac on 2017/6/17.
//  Copyright © 2017年 JuZhenBaoiMac. All rights reserved.
//

#import "HSFNoResultView.h"

@implementation HSFNoResultView

#pragma mark - 约束方法
//初始化方法
-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
        [self addSubview:self.bgView];
        [self.bgView addSubview:self.icon];
        [self.bgView addSubview:self.title];
        [self.bgView addSubview:self.bottomBtn];
        
        [self layoutSubviews];
    }
    return self;
}

#pragma mark -懒加载
-(UIImageView *)icon{
    if (!_icon) {
        _icon = [[UIImageView alloc]init];
        _icon.layer.masksToBounds = YES;
        _icon.layer.cornerRadius = 8;
        _icon.layer.borderColor = [UIColor whiteColor].CGColor;
        _icon.layer.borderWidth = 1;
        
    }
    return _icon;
}
-(UILabel *)title{
    if (!_title) {
        _title = [[UILabel alloc]init];
        _title.font = [UIFont systemFontOfSize:17];
        _title.textColor = [UIColor whiteColor];
        _title.textAlignment = NSTextAlignmentCenter;
    }
    return _title;
}
-(UIButton *)bottomBtn{
    if (!_bottomBtn) {
        _bottomBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_bottomBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _bottomBtn.backgroundColor = kRGBColor(202, 31, 29);
        _bottomBtn.titleLabel.font = [UIFont systemFontOfSize:17];
        _bottomBtn.layer.masksToBounds = YES;
        _bottomBtn.layer.cornerRadius = 8;
    }
    return _bottomBtn;
}
-(UIView *)bgView{
    if (!_bgView) {
        _bgView = [[UIView alloc]init];
        _bgView.backgroundColor = [UIColor clearColor];
    }
    return _bgView;
}

#pragma mark -添加约束
-(void)layoutSubviews{
    __weak typeof(self) weakSelf = self;
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(weakSelf.width - 20);
        make.centerX.mas_equalTo(kScreenWidth/2);
        make.centerY.mas_equalTo((kScreenHeight-64)/2);
    }];
    
    [self.icon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.bgView);
        make.centerX.mas_equalTo(weakSelf.bgView.mas_centerX);
        make.width.mas_equalTo(150);
        make.height.mas_equalTo(150);
    }];
    
    [self.title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.icon.mas_bottom).offset(20);
        make.left.equalTo(weakSelf.bgView);
        make.right.equalTo(weakSelf.bgView);
        make.height.mas_equalTo(30);
    }];
    
    [self.bottomBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.title.mas_bottom).offset(30);
        make.left.equalTo(weakSelf.bgView).offset(10);
        make.right.equalTo(weakSelf.bgView).offset(-10);
        make.height.mas_equalTo(50);
        make.bottom.equalTo(weakSelf.bgView);
    }];
    
    [super layoutSubviews];
}

@end

//
//  HSFTableHeader.m
//  HSFBase
//
//  Created by JuZhenBaoiMac on 2017/6/17.
//  Copyright © 2017年 JuZhenBaoiMac. All rights reserved.
//

#import "HSFTableHeader.h"

@implementation HSFTableHeader

#pragma mark -初始化方法
-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self addSubview:self.bgPic];
        [self addSubview:self.titleBgView];
        [self.titleBgView addSubview:self.alphaView];
        [self.titleBgView addSubview:self.titleBtn];
        
        [self layoutSubviews];
    }
    return self;
}

#pragma mark -懒加载
-(UIImageView *)bgPic{
    if (!_bgPic) {
        _bgPic = [[UIImageView alloc]init];
        _bgPic.contentMode = UIViewContentModeScaleAspectFill;//必须是这个模式 才能下拉放大
        _bgPic.layer.masksToBounds = YES;
    }
    return _bgPic;
}
-(UIButton *)titleBtn{
    if (!_titleBtn) {
        _titleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _titleBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    }
    return _titleBtn;
}
-(UIView *)titleBgView{
    if (!_titleBgView) {
        _titleBgView = [[UIView alloc]init];
        _titleBgView.backgroundColor = [UIColor clearColor];
    }
    return _titleBgView;
}
-(UIView *)alphaView{
    if (!_alphaView) {
        _alphaView = [[UIView alloc]init];
        _alphaView.backgroundColor = [UIColor darkGrayColor];
        _alphaView.alpha = 0.5;
    }
    return _alphaView;
}


#pragma mark -添加约束
-(void)layoutSubviews{
    [self.bgPic mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self);
        make.left.equalTo(self);
        make.bottom.equalTo(self);
        make.right.equalTo(self);
        make.width.mas_equalTo(self.width);
        make.height.mas_equalTo(self.height);
    }];
    
    [self.titleBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self);
        make.bottom.equalTo(self);
        make.right.equalTo(self);
        make.height.mas_equalTo(30);
    }];
    
    [self.titleBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleBgView);
        make.left.greaterThanOrEqualTo(self.titleBgView);
        make.bottom.equalTo(self.titleBgView);
        make.right.equalTo(self.titleBgView).offset(-10);
    }];
    
    [self.alphaView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleBgView);
        make.left.equalTo(self.titleBgView);
        make.bottom.equalTo(self.titleBgView);
        make.right.equalTo(self.titleBgView);
    }];
    
    [super layoutSubviews];
}
@end

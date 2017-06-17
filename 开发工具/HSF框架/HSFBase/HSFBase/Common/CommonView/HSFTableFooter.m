//
//  HSFTableFooter.m
//  HSFBase
//
//  Created by JuZhenBaoiMac on 2017/6/17.
//  Copyright © 2017年 JuZhenBaoiMac. All rights reserved.
//

#import "HSFTableFooter.h"

@implementation HSFTableFooter

//初始化方法
-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
        [self.footer_bgView addSubview:self.footer_titleLabel];
        [self.footer_bgView addSubview:self.footer_clickBtn];
        
        [self addSubview:_footer_bgView];
        
        [self layoutSubviews];
        
    }
    return self;
}

#pragma mark -懒加载
-(UIView *)footer_bgView{
    if (!_footer_bgView) {
        _footer_bgView = [[UIView alloc]init];
        _footer_bgView.backgroundColor = [UIColor clearColor];
    }
    return _footer_bgView;
}
-(UILabel *)footer_titleLabel{
    if (!_footer_titleLabel) {
        _footer_titleLabel = [[UILabel alloc]init];
    }
    return _footer_titleLabel;
}
-(UIButton *)footer_clickBtn{
    if (!_footer_clickBtn) {
        _footer_clickBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    }
    return _footer_clickBtn;
}

#pragma mark -约束
-(void)layoutSubviews{
    //添加约束
    [self.footer_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.footer_bgView);
        make.left.equalTo(self.footer_bgView);
        make.bottom.equalTo(self.footer_bgView);
    }];
    
    [self.footer_clickBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.footer_bgView);
        make.left.equalTo(self.footer_titleLabel.mas_right);
        make.bottom.equalTo(self.footer_bgView);
        make.right.equalTo(self.footer_bgView);
    }];
    
    [self.footer_bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(self);
    }];
    
    [super layoutSubviews];
}

@end

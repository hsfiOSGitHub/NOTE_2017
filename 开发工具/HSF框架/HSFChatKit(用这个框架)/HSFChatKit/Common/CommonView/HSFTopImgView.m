//
//  HSFTopImgView.m
//  HSFBase
//
//  Created by JuZhenBaoiMac on 2017/6/17.
//  Copyright © 2017年 JuZhenBaoiMac. All rights reserved.
//

#import "HSFTopImgView.h"

@implementation HSFTopImgView

#pragma mark - 初始化方法
//初始化方法
-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self addSubview:self.icon];
        [self addSubview:self.title];
        [self addSubview:self.clickBtn];
        
        [self layoutSubviews];
    }
    return self;
}

#pragma mark -懒加载
-(UIImageView *)icon{
    if (!_icon) {
        _icon = [[UIImageView alloc]init];
        _icon.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _icon;
}
-(UILabel *)title{
    if (!_title) {
        _title = [[UILabel alloc]init];
        _title.font = [UIFont systemFontOfSize:12];
        _title.textColor = [UIColor blackColor];
        _title.textAlignment = NSTextAlignmentCenter;
    }
    return _title;
}
-(UIButton *)clickBtn{
    if (!_clickBtn) {
        _clickBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _clickBtn.backgroundColor = [UIColor clearColor];
    }
    return _clickBtn;
}


#pragma mark -添加约束
-(void)layoutSubviews{
    __weak typeof(self) weakSelf = self;
    
    [self.icon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf).offset(10);
        make.left.equalTo(weakSelf).offset(10);
        make.right.equalTo(weakSelf).offset(-10);
    }];
    
    [self.title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.icon.mas_bottom).offset(10);
        make.left.equalTo(weakSelf);
        make.right.equalTo(weakSelf);
        make.bottom.equalTo(weakSelf).offset(-10);
        make.height.mas_equalTo(30);
    }];
    
    [self.clickBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf);
        make.left.equalTo(weakSelf);
        make.right.equalTo(weakSelf);
        make.bottom.equalTo(weakSelf);
    }];
    
    [super layoutSubviews];
}

@end

//
//  DCReceiverAddressCell.m
//  CDDMall
//
//  Created by apple on 2017/6/20.
//  Copyright © 2017年 RocketsChen. All rights reserved.
//

#import "DCReceiverAddressCell.h"

// Controllers

// Models
#import "DCAddressItem.h"
// Views

// Vendors

// Categories

// Others

@interface DCReceiverAddressCell ()

/* 收件人名称 */
@property (strong , nonatomic)UILabel *adNameLabel;
/* 收件人电话 */
@property (strong , nonatomic)UILabel *adPhoneLabel;
/* 收件人详细地址 */
@property (strong , nonatomic)UILabel *adDetailLabel;

/* 默认地址 */
@property (strong , nonatomic)UIButton *defaultAddressButton;
/* 编辑 */
@property (strong , nonatomic)UIButton *editButton;
/* 删除 */
@property (strong , nonatomic)UIButton *deleteButton;

/* 分割线(heng) */
@property (strong , nonatomic)UIView *partingLine;
/* 分割线(shu) */
@property (strong , nonatomic)UIView *verticalLine;

@end

@implementation DCReceiverAddressCell


#pragma mark - Intial
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        [self setUpUI];
    }
    return self;
}

- (void)setUpUI
{
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.backgroundColor = [UIColor whiteColor];
    
    _adNameLabel = [[UILabel alloc] init];
    _adNameLabel.font = PFR15Font;
    [self addSubview:_adNameLabel];
    
    _adPhoneLabel = [[UILabel alloc] init];
    _adPhoneLabel.font = _adNameLabel.font;
    [self addSubview:_adPhoneLabel];
    
    _adDetailLabel = [[UILabel alloc] init];
    _adDetailLabel.font = PFR13Font;
    _adDetailLabel.numberOfLines = 0; 
    _adDetailLabel.textColor = [UIColor lightGrayColor];
    [self addSubview:_adDetailLabel];
    
    _partingLine = [[UIView alloc] init];
    _partingLine.backgroundColor = [[UIColor lightGrayColor]colorWithAlphaComponent:0.4];
    [self addSubview:_partingLine];
    
    _defaultAddressButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_defaultAddressButton setTitle:@"默认地址" forState:UIControlStateNormal];
    _defaultAddressButton.titleLabel.font = PFR13Font;
    [_defaultAddressButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [_defaultAddressButton setImage:[UIImage imageNamed:@"fix_user_address_moren"] forState:UIControlStateNormal];
    [_defaultAddressButton setImage:[UIImage imageNamed:@"fix_user_address_moren_check"] forState:UIControlStateSelected];
    [self addSubview:_defaultAddressButton];
    [_defaultAddressButton addTarget:self action:@selector(defaultAddressButtonSelect:) forControlEvents:UIControlEventTouchUpInside];
    
    _editButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_editButton setTitle:@"编辑" forState:UIControlStateNormal];
    _editButton.titleLabel.font = PFR13Font;
    [_editButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [_editButton setImage:[UIImage imageNamed:@"Address_bianji"] forState:UIControlStateNormal];
    [self addSubview:_editButton];
    [_editButton addTarget:self action:@selector(editButtonClick) forControlEvents:UIControlEventTouchUpInside];
    
    _deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_deleteButton setTitle:@"删除" forState:UIControlStateNormal];
    _deleteButton.titleLabel.font = PFR13Font;
    [_deleteButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [_deleteButton setImage:[UIImage imageNamed:@"Address_shanchu"] forState:UIControlStateNormal];
    [self addSubview:_deleteButton];
    [_deleteButton addTarget:self action:@selector(deleteButtonClick) forControlEvents:UIControlEventTouchUpInside];
    
    _verticalLine = [[UIView alloc] init];
    _verticalLine.backgroundColor = _partingLine.backgroundColor;
    [self addSubview:_verticalLine];
    
}

-(void)setFrame:(CGRect)frame
{
    frame.size.height -= DCMargin;
    frame.origin.y += DCMargin;
    
    frame.origin.x += DCMargin;
    frame.size.width -=  2 * DCMargin;
    
    [super setFrame:frame];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [_adNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        [make.left.mas_equalTo(self)setOffset:DCMargin];
        [make.top.mas_equalTo(self)setOffset:DCMargin];
        make.height.mas_equalTo(30);
    }];
    
    [_adPhoneLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        [make.left.mas_equalTo(_adNameLabel.mas_right)setOffset:DCMargin * 2];
        make.centerY.mas_equalTo(_adNameLabel);
    }];
    
    [_adDetailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_adNameLabel);
        [make.right.mas_equalTo(self)setOffset:-DCMargin];
        [make.top.mas_equalTo(_adNameLabel.mas_bottom)setOffset:DCMargin];
        
    }];
    
    [_partingLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self);
        make.right.mas_equalTo(self);
        make.width.mas_equalTo(self);
        [make.top.mas_equalTo(_adDetailLabel.mas_bottom)setOffset:DCMargin];
        make.height.mas_equalTo(1);
    }];
    
    [_defaultAddressButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self);
        [make.left.mas_equalTo(self)setOffset:DCMargin];
        make.height.mas_equalTo(35);
    }];
    
    [_deleteButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self);
        [make.right.mas_equalTo(self)setOffset:-DCMargin];
        make.height.mas_equalTo(35);
    }];

    
    [_verticalLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(_deleteButton);
        [make.right.mas_equalTo(_deleteButton.mas_left)setOffset:-5];
        make.height.mas_equalTo(20);
        make.width.mas_equalTo(1);
    }];
    
    
    [_editButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self);
        [make.right.mas_equalTo(_verticalLine.mas_left)setOffset:-5];
        make.height.mas_equalTo(35);
    }];
}



#pragma mark - 点击事件
- (void)defaultAddressButtonSelect:(UIButton *)button
{
    button.selected = !button.selected;
    if (!button.selected) {
        !_defaultClickBlock ? : _defaultClickBlock();
    }
}
- (void)editButtonClick
{
    !_editClickBlock ? : _editClickBlock();
}
- (void)deleteButtonClick
{
    !_delectClickBlock ? : _delectClickBlock();
}


#pragma mark - Setter Getter Methods
- (void)setAdItem:(DCAddressItem *)adItem
{
    _adItem = adItem;
    _adNameLabel.text = adItem.adName;
    _adPhoneLabel.text = adItem.adPhone;
    _adDetailLabel.text = [NSString stringWithFormat:@"%@%@",adItem.adCity,adItem.adDetail];
    
    _adPhoneLabel.text = [DCSpeedy dc_EncryptionDisplayMessageWith:adItem.adPhone WithFirstIndex:3]; //电话号码保密

    _defaultAddressButton.selected = adItem.isDefault;
}



@end

//
//  DCMessageNoteCell.m
//  CDDMall
//
//  Created by apple on 2017/6/4.
//  Copyright © 2017年 RocketsChen. All rights reserved.
//

#import "DCMessageNoteCell.h"

// Controllers

// Models
#import "DCMessageItem.h"
// Views

// Vendors

// Categories

// Others

@interface DCMessageNoteCell ()

/* 标题Label */
@property (strong , nonatomic)UILabel *titleLabel;
/* 图片 */
@property (strong , nonatomic)UIImageView *imageNameView;
/* 消息 */
@property (strong , nonatomic)UILabel *messageLabel;
/* 底部分割线 */
@property (strong , nonatomic)UIView *cellLine;
@end

@implementation DCMessageNoteCell

#pragma mark - Intial
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        [self setupUI];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

#pragma mark - UI
- (void)setupUI
{
    _titleLabel = [[UILabel alloc] init];
    _titleLabel.font = PFR14Font;
    [self addSubview:_titleLabel];
    
    _messageLabel = [[UILabel alloc] init];
    _messageLabel.font = PFR13Font;
    _messageLabel.textColor = [UIColor darkGrayColor];
    [self addSubview:_messageLabel];
    
    _imageNameView = [[UIImageView alloc] init];
    [self addSubview:_imageNameView];
    
    _cellLine = [[UIView alloc] init];
    _cellLine.backgroundColor = [[UIColor lightGrayColor]colorWithAlphaComponent:0.3];
    [self addSubview:_cellLine];
}

#pragma mark - 布局
- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [_imageNameView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        [make.left.mas_equalTo(self)setOffset:DCMargin];
        [make.top.mas_equalTo(self)setOffset:DCMargin];
        make.size.mas_equalTo(CGSizeMake(44, 44));
        
    }];
    
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        [make.left.mas_equalTo(self)setOffset:64];
        [make.right.mas_equalTo(self)setOffset:-DCMargin];
        [make.top.mas_equalTo(self)setOffset:DCMargin];
    }];
    
    [_messageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(_titleLabel);
        [make.right.mas_equalTo(self.mas_right)setOffset:-DCMargin];
        [make.top.mas_equalTo(_titleLabel.mas_bottom)setOffset:5];
    }];
    
    
    
    [_cellLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_titleLabel);
        make.right.mas_equalTo(self);
        make.bottom.mas_equalTo(self);
        make.height.mas_equalTo(1);
    }];
    
}

#pragma mark - Setter Getter Methods
- (void)setMessageItem:(DCMessageItem *)messageItem
{
    _messageItem = messageItem;
    self.titleLabel.text = messageItem.title;
    self.imageNameView.image = [UIImage imageNamed:messageItem.imageName];
    self.messageLabel.text = messageItem.message;
}

@end

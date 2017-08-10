//
//  DCFiltrateAttrCell.m
//  CDDMall
//
//  Created by apple on 2017/6/17.
//  Copyright © 2017年 RocketsChen. All rights reserved.
//

#import "DCFiltrateAttrCell.h"

// Controllers

// Models
#import "DCFiltrateItem.h"
// Views

// Vendors

// Categories

// Others

@interface DCFiltrateAttrCell ()

/* 属性 */
@property (strong , nonatomic)UILabel *contentLabel;

@end

@implementation DCFiltrateAttrCell

#pragma mark - Intial
- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        
        [self setUpUI];
    }
    return self;
}

- (void)setUpUI
{
    self.backgroundColor = RGB(240, 240, 240);
    _contentLabel = [[UILabel alloc] init];
    _contentLabel.textAlignment = NSTextAlignmentCenter;
    _contentLabel.textColor = [UIColor darkGrayColor];
    _contentLabel.font = PFR12Font;
    [self addSubview:_contentLabel];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [_contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self);
    }];
}


#pragma mark - cell点击
- (void)setSelected:(BOOL)selected
{
    [super setSelected:selected];
    if (selected) {
        _contentLabel.textColor = [UIColor redColor];
        [DCSpeedy dc_chageControlCircularWith:self AndSetCornerRadius:0 SetBorderWidth:1.0 SetBorderColor:[UIColor redColor] canMasksToBounds:YES];
        self.backgroundColor = [UIColor whiteColor];
    }else{
        [DCSpeedy dc_chageControlCircularWith:self AndSetCornerRadius:0 SetBorderWidth:1.0 SetBorderColor:[UIColor clearColor] canMasksToBounds:YES];
        _contentLabel.textColor = [UIColor darkGrayColor];
        self.backgroundColor = RGB(240, 240, 240);
    }
}

#pragma mark - Setter Getter Methods

- (void)setContent:(NSString *)content {
    _content = content;
    self.contentLabel.text = content;
}


@end

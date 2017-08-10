//
//  DCGoodsGridCell.m
//  CDDMall
//
//  Created by apple on 2017/6/5.
//  Copyright © 2017年 RocketsChen. All rights reserved.
//

#import "DCGoodsGridCell.h"

// Controllers

// Models
#import "DCGridItem.h"
// Views

// Vendors
#import <UIImageView+WebCache.h>
// Categories

// Others

@interface DCGoodsGridCell ()

/* imageView */
@property (strong , nonatomic)UIImageView *gridImageView;
/* label */
@property (strong , nonatomic)UILabel *gridLabel;
@end

@implementation DCGoodsGridCell

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
    _gridImageView = [[UIImageView alloc] init];
    _gridImageView.contentMode = UIViewContentModeScaleAspectFill;
    [self addSubview:_gridImageView];
    
    _gridLabel = [[UILabel alloc] init];
    _gridLabel.font = PFR13Font;
    _gridLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:_gridLabel];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [_gridImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        [make.top.mas_equalTo(self)setOffset:DCMargin];
        if (iphone5) {
            make.size.mas_equalTo(CGSizeMake(40, 40));
        }else{
            make.size.mas_equalTo(CGSizeMake(50, 50));
        }
        make.centerX.mas_equalTo(self);
    }];
    
    [_gridLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self);
        [make.top.mas_equalTo(_gridImageView.mas_bottom)setOffset:5];
    }];
}

#pragma mark - Setter Getter Methods
- (void)setGridItem:(DCGridItem *)gridItem
{
    _gridItem = gridItem;
    
    [_gridImageView sd_setImageWithURL:[NSURL URLWithString:gridItem.iconImage]];
    _gridLabel.text = gridItem.gridTitle;
}

@end

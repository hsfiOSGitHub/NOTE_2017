//
//  DCMySelfHeadView.m
//  CDDMall
//
//  Created by apple on 2017/6/7.
//  Copyright © 2017年 RocketsChen. All rights reserved.
//

#import "DCMySelfHeadView.h"

// Controllers

// Models

// Views

// Vendors

// Categories

// Others

@interface DCMySelfHeadView ()



@end

@implementation DCMySelfHeadView

#pragma mark - Intial
- (void)awakeFromNib {
    [super awakeFromNib];
    
    [DCSpeedy dc_setUpBezierPathCircularLayerWith:_headImageButton :CGSizeMake(self.headImageButton.dc_width * 0.5, self.headImageButton.dc_width * 0.5)];

}

#pragma mark - Setter Getter Methods

#pragma mark - 点击事件
- (IBAction)GoodsCollectionClick {
    !_goodsCollectionClickBlock  ? : _goodsCollectionClickBlock();
}
- (IBAction)ShopCollectionClick {
    !_shopCollectionClickBlock ? : _shopCollectionClickBlock();
}
- (IBAction)MyFootprintClick {
    !_myFootprintClickBlock ? : _myFootprintClickBlock();
}
- (IBAction)MySideClick {
    !_mySideClickBlock ? : _mySideClickBlock();
}
- (IBAction)imageButtonClick {
    !_myHeadImageViewClickBlock ? : _myHeadImageViewClickBlock();
}

@end

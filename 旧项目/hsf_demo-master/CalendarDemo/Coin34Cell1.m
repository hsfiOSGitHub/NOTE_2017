//
//  Coin34Cell1.m
//  CalendarDemo
//
//  Created by monkey2016 on 17/1/11.
//  Copyright © 2017年 monkey2016. All rights reserved.
//

#import "Coin34Cell1.h"

@implementation Coin34Cell1

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.time.layer.masksToBounds = YES;
    self.time.layer.cornerRadius = 10;
    
    self.content.layer.masksToBounds = YES;
    self.content.layer.cornerRadius = 10;
    self.content.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.content.layer.borderWidth = 1;
    
}

-(void)setCoinsCount:(NSInteger)coinsCount{
    _coinsCount = coinsCount;
    for (int i = 0; i < coinsCount; i++) {
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 10, 10)];
        [self.lineView addSubview:view];
        view.backgroundColor = KRGB(255, 147, 18, 1);
        view.layer.masksToBounds = YES;
        view.layer.cornerRadius = 5;
        //布局view
//        CGFloat topHeight = 
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

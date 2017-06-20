//
//  ProgressTableViewCell.m
//  ProgressCus
//
//  Created by ZhangWeichen on 2017/6/2.
//  Copyright © 2017年 Avcon. All rights reserved.
//

#import "ProgressTableViewCell.h"

#define kColor(hex) [UIColor colorWithRed:((CGFloat)((hex & 0xFF0000) >> 16)) / 255.0 green:((CGFloat)((hex & 0xFF00) >> 8)) / 255.0 blue:((CGFloat)(hex & 0xFF)) / 255.0 alpha:1]

// 起始位置的Y
#define Start_Position_Y  15
// 起始位置的Y
#define Start_Position_X  15
// 直径
#define Round_Directly  23
// 连接的线长
#define Line_Length   100

@interface ProgressTableViewCell ()

{
    UIButton *btn;
    UILabel *titleLb;
    UILabel *contentlb;
}

@end

@implementation ProgressTableViewCell


-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // 阶段
        btn = [[UIButton alloc] initWithFrame:CGRectMake(Start_Position_X, Start_Position_Y, Round_Directly, Round_Directly)];
        btn.layer.cornerRadius = Round_Directly * 0.5;
        btn.layer.masksToBounds = YES;
        btn.layer.borderColor = kColor(0x358fd7).CGColor;
        btn.layer.borderWidth = 1;
        [btn setTitleColor:kColor(0x358fd7) forState:UIControlStateNormal];
        [self addSubview:btn];
        
        titleLb = [self lableWithFrame:CGRectMake(CGRectGetMaxX(btn.frame) + 15, CGRectGetMidY(btn.frame) - Round_Directly * 0.5, self.frame.size.width - CGRectGetMaxX(btn.frame) - 15, Round_Directly) text:@"测试" textColor:kColor(0x358fd7) font:19];
        [self addSubview:titleLb];
        
        contentlb = [self lableWithFrame:CGRectMake(CGRectGetMinX(titleLb.frame), CGRectGetMaxY(titleLb.frame) + Round_Directly, titleLb.frame.size.width, 17) text:@"测试" textColor:kColor(0x666666) font:14];
        [self addSubview:contentlb];
        
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(Start_Position_X + Round_Directly * 0.5 - 0.5,0, 1, 15)];
        lineView.backgroundColor = kColor(0x358fd7);
        [self addSubview:lineView];
        
        UIView *linetView = [[UIView alloc] initWithFrame:CGRectMake(Start_Position_X + Round_Directly * 0.5 - 0.5,Start_Position_X + Round_Directly, 1, Line_Length - Start_Position_X - Round_Directly)];
        linetView.backgroundColor = kColor(0x358fd7);
        [self addSubview:linetView];

    }
    return self;
}
- (UILabel *)lableWithFrame:(CGRect)frame text:(NSString *)text textColor:(UIColor *)textColor font:(NSInteger)font {
    
    UILabel *cusLb = [[UILabel alloc] initWithFrame:frame];
    cusLb.text = text;
    cusLb.textColor = textColor;
    cusLb.font = [UIFont systemFontOfSize:font];
    
    return cusLb;
}
-(void)assignmentCellModel:(NSInteger)row :(NSArray *)titleArr :(NSArray*)contentArr
{
    [btn setTitle:[NSString stringWithFormat:@"%ld",row + 1] forState:UIControlStateNormal];
    [titleLb setText:titleArr[row]];
    [contentlb setText:contentArr[row]];
}

@end

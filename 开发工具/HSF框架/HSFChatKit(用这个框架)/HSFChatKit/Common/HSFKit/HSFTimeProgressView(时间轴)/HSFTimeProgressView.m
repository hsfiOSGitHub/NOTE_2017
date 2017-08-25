//
//  HSFTimeProgressView.m
//  HCJ
//
//  Created by JuZhenBaoiMac on 2017/7/19.
//  Copyright © 2017年 JuZhenBaoiMac. All rights reserved.
//

#import "HSFTimeProgressView.h"

#define kColor(hex) [UIColor colorWithRed:((CGFloat)((hex & 0xFF0000) >> 16)) / 255.0 green:((CGFloat)((hex & 0xFF00) >> 8)) / 255.0 blue:((CGFloat)(hex & 0xFF)) / 255.0 alpha:1]

// 起始位置的Y
#define Start_Position_Y  0
// 起始位置的Y
#define Start_Position_X  15
// 直径
#define Round_Directly  23
// 连接的线长
#define Line_Length   88

@implementation HSFTimeProgressView

- (void)timeProgressViewWithTitleArr:(NSArray *)titleArr iconArr:(NSArray *)iconArr contentArr: (NSArray *)contentArr inScrollview:(UIScrollView*)scrollview{
    self.backgroundColor = [UIColor whiteColor];
    CGFloat contentH = 0;
    CGFloat viewH = 0;
    for (NSInteger i = 0; i < titleArr.count; i ++) {
        
        CGFloat contentWideth = self.frame.size.width - Round_Directly -Start_Position_X*3;
        CGFloat contentHeight = [self calculteTheSizeWithContent:contentArr[i] rect:CGSizeMake(contentWideth, MAXFLOAT) font:[UIFont systemFontOfSize:14]].height;
        CGFloat labelH = contentHeight + Round_Directly;
        contentH += labelH ;
        viewH += contentHeight;
        CGFloat contentY =Start_Position_Y +contentH-labelH +( Round_Directly)*(i+1);
        
        // 阶段
        
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(Start_Position_X, contentY, Round_Directly, Round_Directly)];
        
        if (iconArr.count > 0) {
            [btn setImage:[UIImage imageNamed:iconArr[i]] forState:UIControlStateNormal];
        }else{
            btn.layer.cornerRadius = Round_Directly * 0.5;
            btn.layer.masksToBounds = YES;
            btn.layer.borderColor = kColor(0x358fd7).CGColor;
            btn.layer.borderWidth = 1;
            [btn setTitle:[NSString stringWithFormat:@"%ld", i + 1] forState:UIControlStateNormal];
            [btn setTitleColor:kColor(0x358fd7) forState:UIControlStateNormal];
        }
        btn.tag = i + 1;
        [btn addTarget:self action:@selector(sequenceBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btn];
        
        // 标题
        UILabel *titleLb = [self lableWithFrame:CGRectMake(CGRectGetMaxX(btn.frame) + 15, CGRectGetMidY(btn.frame) - Round_Directly*0.5,contentWideth , Round_Directly) text:titleArr[i] textColor:kColor(0x358fd7) font:19];
        titleLb.backgroundColor = [UIColor clearColor];
        [self addSubview:titleLb];
        
        // 内容
        UILabel *contentlb = [self lableWithFrame:CGRectMake(CGRectGetMinX(titleLb.frame), CGRectGetMaxY(titleLb.frame) + Round_Directly * 0.5, titleLb.frame.size.width, contentHeight) text:contentArr[i] textColor:kColor(0x666666) font:14];
        contentlb.numberOfLines = 0;
        contentlb.backgroundColor = [UIColor clearColor];
        [self addSubview:contentlb];
        
        // 连接线
        if (i < titleArr.count - 1) {
            
            UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(Start_Position_X + Round_Directly * 0.5 - 0.5,CGRectGetMaxY(titleLb.frame) , 1, labelH)];
            lineView.backgroundColor = kColor(0x358fd7);
            [self addSubview:lineView];
        }
    }
    
    //设置scrollview的contentsize
    CGFloat H = Start_Position_Y + viewH + Round_Directly*titleArr.count*2 +Round_Directly*0.5;
    scrollview.contentSize = CGSizeMake(self.frame.size.width, H);
}
- (UILabel *)lableWithFrame:(CGRect)frame text:(NSString *)text textColor:(UIColor *)textColor font:(NSInteger)font {
    
    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    label.text = text;
    label.textColor = textColor;
    label.font = [UIFont systemFontOfSize:font];
    label.textAlignment = NSTextAlignmentLeft;
    return label;
}

#pragma mark -阶段按钮点击事件

- (void)sequenceBtnClick: (UIButton *)sequenceBtn {
    
    if ([self.delegate respondsToSelector:@selector(timeProgressViewWithSequenceView:sequenceBtn:)]) {
        
        [self.delegate timeProgressViewWithSequenceView:self sequenceBtn:sequenceBtn];
    }
}

#pragma mark -计算文字的CGSize

- (CGSize)calculteTheSizeWithContent:(NSString*)content rect:(CGSize)rect font:(UIFont*)font {
    
    NSDictionary *attribute = @{NSFontAttributeName: font};
    
    CGSize size = [content  boundingRectWithSize:rect                                        options:
                   NSStringDrawingTruncatesLastVisibleLine |
                   NSStringDrawingUsesLineFragmentOrigin |
                   NSStringDrawingUsesFontLeading
                                      attributes:attribute
                                         context:nil].size;
    return size;
}



@end

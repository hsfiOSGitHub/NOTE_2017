//
//  HSFKeyboard.m
//  PwdDemo
//
//  Created by JuZhenBaoiMac on 2017/6/20.
//  Copyright © 2017年 JuZhenBaoiMac. All rights reserved.
//

#import "HSFKeyboard.h"

#define k_cell_height 60
#define k_keyboardType_default HSFKeyboardType_Number

@interface HSFKeyboard ()

@property (nonatomic,strong) NSArray *keyboardTitleArr;

@end

@implementation HSFKeyboard
#pragma mark -懒加载
-(NSArray *)keyboardTitleArr{
    if (!_keyboardTitleArr) {
        _keyboardTitleArr = @[@"1", @"2", @"3", @"4", @"5", @"6", @"7", @"8", @"9", @"", @"0", @""];
    }
    return _keyboardTitleArr;
}
#pragma mark -初始化
//类方法
+(instancetype)keyboardWithFrame:(CGRect)frame delegate:(id<HSFKeyboardDelegate>)delegate keyboardType:(HSFKeyboardType) keyboardType{
    HSFKeyboard *keyboard = [[HSFKeyboard alloc]init];
    keyboard.frame = frame;
    keyboard.curKeyboardType = keyboardType;
    keyboard.delegate = delegate;
    [keyboard createKeyboard];
    return keyboard;
}

//初始化方法
-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor groupTableViewBackgroundColor];
        self.curKeyboardType = k_keyboardType_default;
    }
    return self;
}
//重写frame
-(void)setFrame:(CGRect)frame{
    CGRect newFrame = frame;
    newFrame = CGRectMake(frame.origin.x, frame.origin.y, [UIScreen mainScreen].bounds.size.width, (k_cell_height + 1) * 4);
    [super setFrame:newFrame];
}

//创建键盘
-(void)createKeyboard{
//    int row = 4;
    int line = 3;
    CGFloat w = (self.frame.size.width - line + 1)/line;
    CGFloat h = k_cell_height;
    for (int i = 0; i < 12; i++) {
        CGFloat x = (w + 1) * (i%line);
        CGFloat y = (h + 1) * (i/line) + 1;
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(x, y, w, h);
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:30];
        btn.backgroundColor = [UIColor whiteColor];
        [self addSubview:btn];
        //配置
        if (i == 11) {//删除
            [btn setImage:[UIImage imageNamed:@"delete_keyboard"] forState:UIControlStateNormal];
        }
        if (self.curKeyboardType == HSFKeyboardType_Number) {
            self.keyboardTitleArr = @[@"1", @"2", @"3", @"4", @"5", @"6", @"7", @"8", @"9", @"", @"0", @""];
            if (i == 9) {
                btn.backgroundColor = [UIColor clearColor];
            }
        }
        else if (self.curKeyboardType == HSFKeyboardType_Decimal) {
            self.keyboardTitleArr = @[@"1", @"2", @"3", @"4", @"5", @"6", @"7", @"8", @"9", @".", @"0", @""];
        }
        [btn setTitle:self.keyboardTitleArr[i] forState:UIControlStateNormal];
        
        //点击
        [btn setTag:(666 + i)];
        [btn addTarget:self action:@selector(keyboardClickBtn:) forControlEvents:UIControlEventTouchUpInside];
    }
}

//点击
-(void)keyboardClickBtn:(UIButton *)sender{
    NSInteger index = sender.tag - 666;
    if ([self.delegate respondsToSelector:@selector(keyboardACTIONWith: atIndex:)]) {
        [self.delegate keyboardACTIONWith:sender.currentTitle atIndex:index];
    }
}






@end

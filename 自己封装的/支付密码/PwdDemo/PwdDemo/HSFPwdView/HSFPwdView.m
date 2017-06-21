//
//  HSFPwdView.m
//  PwdDemo
//
//  Created by JuZhenBaoiMac on 2017/6/20.
//  Copyright © 2017年 JuZhenBaoiMac. All rights reserved.
//

#import "HSFPwdView.h"


#define k_pwdType_default PwdType_Star
#define k_showType_default ShowType_Baseline
//密码个数
#define k_pwdNum_default 6
#define k_pwdFontSize_default 17
#define k_pwdColor_default [UIColor blackColor]
//padding
#define k_paddingW_default 1
#define k_paddingInsert_default 0
#define k_paddingColor_default [UIColor groupTableViewBackgroundColor]
//baseline
#define k_baselineBottomH_default 10
#define k_baselineH_default 2
#define k_baselineInsert_default 10
#define k_baselineColor_default [UIColor orangeColor]

@interface HSFPwdView ()

@property (nonatomic,strong) NSMutableArray *pwdLabelArr;//label对象数组 (label)
@property (nonatomic,strong) NSMutableArray *pwdArr;//密码数组-当前密码 (数字)
@property (nonatomic,strong) NSMutableArray *pwdArr_show;//密码数组-当前密码-显示 (＊ / •)

@end

@implementation HSFPwdView
#pragma mark -懒加载
-(NSMutableArray *)pwdLabelArr{
    if (!_pwdLabelArr) {
        _pwdLabelArr = [NSMutableArray array];
    }
    return _pwdLabelArr;
}
-(NSMutableArray *)pwdArr{
    if (!_pwdArr) {
        _pwdArr = [NSMutableArray array];
    }
    return _pwdArr;
}
-(NSMutableArray *)pwdArr_show{
    if (!_pwdArr_show) {
        _pwdArr_show = [NSMutableArray array];
    }
    return _pwdArr_show;
}
#pragma mark -初始配置
//类方法
+(instancetype)pwdViewWithFrame:(CGRect)frame delegate:(id<HSFPwdViewDelegate>)delegate pwdNumber:(NSInteger) pwdNum pwdType:(PwdType)pwdType showType:(ShowType)showType{
    HSFPwdView *pwdView = [[HSFPwdView alloc]initWithFrame:frame];
    pwdView.delegate = delegate;
    pwdView.pwdNumber = pwdNum;
    pwdView.pwd_type = pwdType;
    pwdView.show_type = showType;
    //配置
    [pwdView setUp];
    return pwdView;
}
//初始化方法
-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        //默认配置
        self.pwdNumber = k_pwdNum_default;
        self.pwdColor = k_pwdColor_default;
        self.fontSize = k_pwdFontSize_default;
        self.pwd_type = k_showType_default;
        self.show_type = k_showType_default;
        self.paddingColor = k_paddingColor_default;
        self.baselineColor = k_baselineColor_default;
    }
    return self;
}
//配置
-(void)setUp{
    if (self.pwdLabelArr.count > 0) {
        [self.pwdLabelArr removeAllObjects];
    }
    
    CGFloat w = 0.0;
    CGFloat h = 0.0;
    
    if (self.show_type == ShowType_Padding) {
        w = (self.frame.size.width - k_paddingW_default * (self.pwdNumber - 1))/self.pwdNumber;
        h = self.frame.size.height;
    }else if (self.show_type == ShowType_Baseline) {
        w = (self.frame.size.width - 0 * (self.pwdNumber - 1))/self.pwdNumber;
        h = self.frame.size.height - k_baselineBottomH_default;
    }
    
    for (int i = 0; i < self.pwdNumber; i++) {
        CGFloat x = (w + k_paddingW_default) * i;
        CGFloat y = 0.0;
        UILabel *pwdLabel = [[UILabel alloc]init];
        pwdLabel.frame = CGRectMake(x, y, w, h);
        pwdLabel.textColor = self.pwdColor;
        pwdLabel.font = [UIFont systemFontOfSize:self.fontSize weight:10];
        pwdLabel.textAlignment = NSTextAlignmentCenter;
        pwdLabel.backgroundColor = [UIColor clearColor];
        [self addSubview:pwdLabel];
        //保存label对象
        [self.pwdLabelArr addObject:pwdLabel];
        
        if (self.show_type == ShowType_Padding) {
            if (i < self.pwdNumber - 1) {
                UIView *padding = [[UIView alloc]init];
                padding.frame = CGRectMake(CGRectGetMaxX(pwdLabel.frame), k_paddingInsert_default, k_paddingW_default, CGRectGetHeight(pwdLabel.frame) - 2*k_paddingInsert_default);
                padding.backgroundColor = self.paddingColor;
                [self addSubview:padding];
            }
        }else if (self.show_type == ShowType_Baseline) {
            UIView *baseline = [[UIView alloc]init];
            baseline.frame = CGRectMake(CGRectGetMinX(pwdLabel.frame) + k_baselineInsert_default, CGRectGetMaxY(pwdLabel.frame), CGRectGetWidth(pwdLabel.frame) - 2*k_baselineInsert_default, k_baselineH_default);
            baseline.backgroundColor = self.baselineColor;
            [self addSubview:baseline];
        }
    }
}

#pragma mark -调用方法
//添加密码
-(void)addPwd:(NSString *)pwdStr{
    [self.pwdArr removeObject:@""];
    [self.pwdArr_show removeObject:@""];
    
    if ([pwdStr isEqualToString:@""]) {
        [self.pwdArr_show removeLastObject];
        [self.pwdArr removeLastObject];
    }else{
        if (self.pwd_type == PwdType_Star) {
            [self.pwdArr_show addObject:@"＊"];
        }else if (self.pwd_type == PwdType_Dot) {
            [self.pwdArr_show addObject:@"•"];
        }
        [self.pwdArr addObject:pwdStr];
    }
    [self setUpPwd];
}

//填写密码
-(void)setUpPwd{
    if (self.pwdArr.count <= self.pwdNumber) {
        NSInteger count = self.pwdArr.count;
        if (self.pwdArr.count < self.pwdNumber) {
            for (int i = 0; i < (self.pwdNumber - count); i++) {
                [self.pwdArr addObject:@""];
                [self.pwdArr_show addObject:@""];
            }
        }
        [self.pwdLabelArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            UILabel *label = (UILabel *)obj;
            label.text = self.pwdArr_show[idx];
        }];
    }else{
        [self.pwdArr removeLastObject];
        [self.pwdArr_show removeLastObject];
        return;
    }
    //密码填写完整
    if (![self.pwdArr containsObject:@""]) {
        NSLog(@"*********密码填写完整**********");
        self.currentPwd = [self.pwdArr componentsJoinedByString:@""];
        if ([self.delegate respondsToSelector:@selector(inputePwdSuccess:)]) {
            [self.delegate inputePwdSuccess:self.currentPwd];
        }
    }
}

//加边框圆角
-(void)setBorderColor:(UIColor *)borderColor borderWidth:(CGFloat)borderWidth cornerRadius:(CGFloat)cornerRadius{
    self.layer.masksToBounds = YES;
    self.layer.cornerRadius = cornerRadius;
    self.layer.borderColor = borderColor.CGColor;
    self.layer.borderWidth = borderWidth;
}

#pragma mark -显示/隐藏 密码
-(void)showPwd{
    [self.pwdLabelArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UILabel *label = (UILabel *)obj;
        label.text = self.pwdArr[idx];
    }];
}
-(void)hidePwd{
    [self.pwdLabelArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UILabel *label = (UILabel *)obj;
        label.text = self.pwdArr_show[idx];
    }];
}


@end

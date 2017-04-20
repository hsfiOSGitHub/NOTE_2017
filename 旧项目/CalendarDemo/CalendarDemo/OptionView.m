//
//  OptionView.m
//  SpringAnimationDemo
//
//  Created by monkey2016 on 16/12/1.
//  Copyright © 2016年 monkey2016. All rights reserved.
//

#import "OptionView.h"


@interface OptionView ()
@property (nonatomic,strong) UIView *maskView;//萌版
@property (nonatomic,strong) UIView *contentView;//背景(用于装按钮)
@property (nonatomic,assign) CGFloat contentViewH;
@property (nonatomic,assign) CGFloat btnSpaceW;//水平间距
@property (nonatomic,strong) UIButton *closeBtn;//取消按钮
@property (nonatomic,assign) NSInteger index;
@property (nonatomic,strong) NSArray *btnArr;
@end

@implementation OptionView

//初始化方法
-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
    }
    return self;
}
//添加optionBtn
-(void)setOptionBtnArr:(NSArray *)optionBtnArr{
    _optionBtnArr = optionBtnArr;
    //创建contentView
    [self createContentViewWith:optionBtnArr];
    //创建关闭按钮
    [self createCancalBtn];
    //创建萌版
    [self createMaskView];
    //创建optionBtn
    [self createOptionBtnWith:optionBtnArr];
    //更新
    [self setNeedsLayout];
}
//创建contentView
-(void)createContentViewWith:(NSArray *)optionBtnArr{
    //先计算contentView的高度
    NSInteger count = optionBtnArr.count;
    if (count > 0) {
        if (count%lineNum == 0) {
            _contentViewH = kTop + (kBtnH + kSpaceH)*(count/lineNum) + kCloseBtnH;
        }else{
            _contentViewH = kTop + (kBtnH + kSpaceH)*(count/lineNum + 1) + kCloseBtnH;
        }
    }else{
        
    }
    CGFloat contentViewY = selfSize.height - _contentViewH;
    //创建添加
    _contentView = [[UIView alloc]initWithFrame:CGRectMake(0, contentViewY, selfSize.width, _contentViewH)];
    _contentView.backgroundColor = KRGB(52, 168, 238, 1.0);
//    _contentView.alpha = 0.8;
    [self addSubview:_contentView];
    
}
//创建关闭按钮
-(void)createCancalBtn{
    _closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self addSubview:_closeBtn];
    _closeBtn.frame = CGRectMake(0, 0, kCloseBtnH, kCloseBtnH);
    _closeBtn.center = CGPointMake(self.frame.size.width/2, selfSize.height - kCloseBtnH/2);
    _closeBtn.backgroundColor = [UIColor clearColor];
    _closeBtn.layer.masksToBounds = YES;
    _closeBtn.layer.cornerRadius = kCloseBtnH/2;
    [_closeBtn setImage:[UIImage imageNamed:@"center_hd_tabbar"] forState:UIControlStateNormal];
    [UIView animateWithDuration:0.2 animations:^{
        self.closeBtn.transform = CGAffineTransformRotate(self.closeBtn.transform, M_PI * 3/4);
    }];
    _closeBtn.userInteractionEnabled = YES;
    [_closeBtn addTarget:self action:@selector(closeBtnAction:) forControlEvents:UIControlEventTouchUpInside];
}
//创建萌版
-(void)createMaskView{
    _maskView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, selfSize.width, selfSize.height - _contentViewH)];
    _maskView.backgroundColor = [UIColor lightGrayColor];
    _maskView.alpha = 0.5;
    _maskView.userInteractionEnabled = YES;
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(maskViewACTION)];
    [_maskView addGestureRecognizer:singleTap];
    [self addSubview:_maskView];
}
-(void)maskViewACTION{
    [self closeBtnAction:self.closeBtn];
}
//创建optionBtn
-(void)createOptionBtnWith:(NSArray *)optionBtnArr{
    //水平间距
    NSInteger count = optionBtnArr.count;
    if (count < lineNum) {
        _btnSpaceW = (selfSize.width - count * kBtnW)/(count + 1);
    }else{
        _btnSpaceW = (selfSize.width - lineNum * kBtnW)/(lineNum + 1);
    }
    //创建btn
    for (int i = 0; i < count; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.contentView addSubview:btn];
        CGFloat btnX = _btnSpaceW + (_btnSpaceW + kBtnW)*(i%lineNum);
//        CGFloat btnY = (kBtnH + kSpaceH)*(i/lineNum) + kTop;
        btn.frame = CGRectMake(btnX, _contentViewH, kBtnW, kBtnH);//初始位置在底部
        //配置btn
//        [btn layoutButtonWithEdgeInsetsStyle:HSFButtonEdgeInsetsStyleTop imageTitleSpace:10];// image在上，label在下
        [btn setBackgroundColor:[UIColor clearColor]];
        [btn setImage:[UIImage imageNamed:optionBtnArr[i][@"icon"]] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:12];
        [btn setTitle:optionBtnArr[i][@"title"] forState:UIControlStateNormal];
        [btn setTag:100 + i];
        [btn addTarget:self action:@selector(optionBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    }
}
//展示 -- 核心代码
-(void)show{
    UIButton *btn = [self.contentView viewWithTag:_index + 100];
    [btn layoutButtonWithEdgeInsetsStyle:HSFButtonEdgeInsetsStyleTop imageTitleSpace:10];// image在上，label在下
    CGFloat btnX = _btnSpaceW + (_btnSpaceW + kBtnW)*(_index%lineNum);
    CGFloat btnY = (kBtnH + kSpaceH)*(_index/lineNum) + kTop;
    //弹弹弹(逐个弹)————核心代码
    [UIView animateWithDuration:0.3 delay:0 usingSpringWithDamping:0.3f initialSpringVelocity:0.5f options:UIViewAnimationOptionCurveLinear animations:^{
        btn.frame = CGRectMake(btnX, btnY, kBtnW, kBtnH);
    } completion:^(BOOL finished) {
        
    }];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.05 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        _index++;
        if (_index < self.optionBtnArr.count) {
            [self show];
        }
    });
}
//点击关闭按钮
-(void)closeBtnAction:(UIButton *)sender{
    [UIView animateWithDuration:0.2 animations:^{
        self.contentView.frame = CGRectMake(0, selfSize.height, selfSize.width, _contentViewH);
        self.closeBtn.transform = CGAffineTransformIdentity;
        self.maskView.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}
#pragma mark -点击optionBtn
//点击事件
-(void)optionBtnAction:(UIButton *)sender{
    //先模拟点击关闭按钮
    [self closeBtnAction:self.closeBtn];
    //跳转页面 or do something
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        switch (sender.tag) {
            case 100:{
                if ([self.delegate respondsToSelector:@selector(optionBtn1Action)]) {
                    [self.delegate optionBtn1Action];
                }
            }
                break;
            case 101:{
                if ([self.delegate respondsToSelector:@selector(optionBtn2Action)]) {
                    [self.delegate optionBtn2Action];
                }
            }
                break;
            case 102:{
                if ([self.delegate respondsToSelector:@selector(optionBtn3Action)]) {
                    [self.delegate optionBtn3Action];
                }
            }
                break;
            case 103:{
                if ([self.delegate respondsToSelector:@selector(optionBtn4Action)]) {
                    [self.delegate optionBtn4Action];
                }
            }
                break;
            case 104:{
                if ([self.delegate respondsToSelector:@selector(optionBtn5Action)]) {
                    [self.delegate optionBtn5Action];
                }
            }
                break;
            case 105:{
                if ([self.delegate respondsToSelector:@selector(optionBtn6Action)]) {
                    [self.delegate optionBtn6Action];
                }
            }
                break;
            case 106:{
                if ([self.delegate respondsToSelector:@selector(optionBtn7Action)]) {
                    [self.delegate optionBtn7Action];
                }
            }
                break;
            case 107:{
                if ([self.delegate respondsToSelector:@selector(optionBtn8Action)]) {
                    [self.delegate optionBtn8Action];
                }
            }
                break;
                
            default:
                break;
        }
    });
    NSLog(@"===========%ld",(long)sender.tag);
}








@end

//
//  SZBAlertView.m
//  yuntangyi
//
//  Created by yuntangyi on 16/9/19.
//  Copyright © 2016年 yuntangyi. All rights reserved.
//

#import "SZBAlertView.h"

#import "SignUpView.h"
#import "SexView.h"
#import "PhotoView.h"
#import "JobSeleteView.h"
#import "HospitalView.h"
#import "NameView.h"
#define space 30
#define rowH 50

@interface SZBAlertView ()
@property (nonatomic,strong) SignUpView *signUpView;
@property (nonatomic,strong) SexView *sexView;
@property (nonatomic,strong) PhotoView *photoView;
@property (nonatomic,strong) JobSeleteView *jobSeleteView;
@property (nonatomic,strong) HospitalView *hospitalView;
@property (nonatomic,strong) NameView *nameView;

//@property (nonatomic,strong) UIView *currentView;
@end

@implementation SZBAlertView

#pragma mark -Touch事件 点击空白移除
-(void)addTapGesture{
    _bgView.userInteractionEnabled = YES;
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(fingerTapped:)];
    [_bgView addGestureRecognizer:singleTap];
}
-(void)fingerTapped:(UITapGestureRecognizer *)gestureRecognizer{
    [self.agency removeSelfAction];
}
#pragma mark -延迟移除
-(void)removeAfterTime:(NSTimeInterval)time{
    [self performSelector:@selector(removeSelf) withObject:nil afterDelay:time];
}
-(void)removeSelf{
    [self.agency removeSelfAction];
}

//初始化方法
-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        //设置self
        self.backgroundColor = [UIColor clearColor];
        //设置背景
        _bgView = [[UIView alloc]initWithFrame:self.frame];
        _bgView.backgroundColor = [[UIColor grayColor] colorWithAlphaComponent:0.5];
        [self addTapGesture];//点击消失
        [self addSubview:_bgView];
        
    }
    return self;
}
//重绘
- (void)drawRect:(CGRect)rect {
    [self setUpSubviews];
}
//设置type
-(void)setType:(SZBAlertType)type{
    _type = type;
    [self setNeedsLayout];
    [self keyboardAction];//键盘
}
//设置子视图
-(void)setUpSubviews{
    //添加内容
    switch (self.type) {
        case SZBAlertType1:{//报名
            _signUpView = [[SignUpView alloc]initWithFrame:CGRectMake(space, 0, KScreenWidth - 2 * space, (KScreenWidth - 2 * space) * 4/5)];
            _signUpView.center = self.center;
            _signUpView.contentDic = self.contentDic;
            [self addSubview:_signUpView];
        }
            break;
        case SZBAlertType2:{//性别
            _sexView = [[SexView alloc]initWithFrame:CGRectMake(space, 0, KScreenWidth - 2 * space, (KScreenWidth - 2 * space) * 2/5)];
            _sexView.center = self.center;
            [self addSubview:_sexView];
        }
            break;
        case SZBAlertType3:{//拍照
            _photoView = [[PhotoView alloc]initWithFrame:CGRectMake(space, 0, KScreenWidth - 2 * space, (KScreenWidth - 2 * space) * 4/5)];
            _photoView.center = self.center;
            [self addSubview:_photoView];
        }
            break;
        case SZBAlertType4:{//选择职称
            _jobSeleteView = [[JobSeleteView alloc]initWithFrame:CGRectMake(space, 0, KScreenWidth - 2 * space, 115 + (rowH + 15))];
            _jobSeleteView.center = self.center;
            _jobSeleteView.headerStr = self.headerStr;
            _jobSeleteView.source = self.source;
            [self addSubview:_jobSeleteView];
        }
            break;
        case SZBAlertType5:{//选择医院
            _hospitalView = [[HospitalView alloc]initWithFrame:CGRectMake(space, 0, KScreenWidth - 2 * space, 115 + (rowH + 15) * 3)];
            _hospitalView.center = self.center;
            [self addSubview:_hospitalView];
        }
            break;
        case SZBAlertType6:{//姓名
            _nameView = [[NameView alloc]initWithFrame:CGRectMake(space, 0, KScreenWidth - 2 * space, 160)];
            _nameView.center = self.center;
            _nameView.nameTF.text = self.name;
            [self addSubview:_nameView];
        }
            break;

        default:
            break;
    }
}
#pragma mark -监听键盘弹出与回收
//监听键盘弹出与回收
-(void)keyboardAction{
    //增加监听，当键盘出现或改变时收出消息
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    //增加监听，当键退出时收出消息
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}
//当键盘出现或改变时调用
- (void)keyboardWillShow:(NSNotification *)aNotification{
    NSDictionary *userInfo = [aNotification userInfo];
    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    CGFloat height = keyboardRect.size.height;
    //动画(往上弹)
    NSNumber *duration = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSNumber *curve = [userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey];
    CGFloat keyboardY = KScreenHeight - height;
    CGFloat nameViewBottomY = self.nameView.frame.origin.y + self.nameView.frame.size.height;
    CGFloat detaY = nameViewBottomY - keyboardY;
    if (detaY > 0) {
        [UIView animateWithDuration:[duration integerValue] animations:^{
            [UIView setAnimationCurve:[curve integerValue]];
            self.nameView.center = CGPointMake(self.center.x, self.center.y - detaY - 50);
        }];
    }
}
//当键退出时调用
- (void)keyboardWillHide:(NSNotification *)aNotification{
    NSDictionary *userInfo = [aNotification userInfo];
    //动画(往下弹)
    NSNumber *duration = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSNumber *curve = [userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey];
    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    CGFloat height = keyboardRect.size.height;
    CGFloat keyboardY = KScreenHeight - height;
    CGFloat nameViewBottomY = self.nameView.frame.origin.y + self.nameView.frame.size.height;
    CGFloat detaY = nameViewBottomY - keyboardY;
    if (detaY > 0) {
        [UIView animateWithDuration:[duration integerValue] animations:^{
            [UIView setAnimationCurve:[curve integerValue]];
            self.nameView.center = self.center;
        }];
    }
}







@end

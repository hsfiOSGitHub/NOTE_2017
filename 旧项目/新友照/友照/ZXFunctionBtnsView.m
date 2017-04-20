//
//  ZXFunctionBtnsView.m
//  功能按钮
//
//  Created by ZX on 16/3/1.
//  Copyright © 2016年 ZX. All rights reserved.
//

#import "ZXFunctionBtnsView.h"
@interface ZXFunctionBtnsView()
@property (nonatomic) CGPoint startPoint;
@property (nonatomic, assign) float space;
@property (nonatomic, assign) float btnHeight;
@property (nonatomic, assign) float btnWidth;
//default is nil
@property (nonatomic, copy) UIView *backgroudTopView;
@property (nonatomic, copy) UIView *backgroudBottomView;

@property (nonatomic, strong) UIView *btnSuperView;
@end
@implementation ZXFunctionBtnsView
- (instancetype)initWithButtonNames:(NSArray *)names andStartPoint:(CGPoint)point andSpace:(float)space andBtnHeight:(float)h andXiaHuaXiaImage:(UIImage *)image{
    if (self = [super init])
    {
        _startPoint = point;
        _space = space;
        _btnHeight = h;
        _buttonArray = [NSMutableArray array];
        _buttonNames = names;
        _XiaHuaXianimage = image;
        [self createButtons];
    }
    return self;
}

- (void)buttonSelected:(NSInteger)buttonIndex
{
    for (UIButton *btn in _buttonArray)
    {
        if (btn.tag == buttonIndex + 1000)
        {
            btn.selected = YES;
            [UIView animateWithDuration:0.2 animations:^{
                _XiaHuaXianImageView.frame = CGRectMake(buttonIndex * _startPoint.x + buttonIndex * _btnWidth + buttonIndex * _space, _XiaHuaXianImageView.frame.origin.y, _btnWidth, _XiaHuaXianImageView.frame.size.height);
            }];
            
        } else {
            btn.selected = NO;
        }
        
    }
    
}

- (void)createButtons {
    for (int index = 0; index < _buttonNames.count; index++) {
        _btnWidth = (kZX_ScreenW - _space * (_buttonNames.count + 1)) / _buttonNames.count;
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(_startPoint.x + index * (_btnWidth + _space), _startPoint.y, _btnWidth, _btnHeight)];
     
        btn.backgroundColor = [UIColor whiteColor];
        [btn setTitle:_buttonNames[index] forState:UIControlStateNormal];
        //设置字体
        btn.titleLabel.font = [UIFont systemFontOfSize:14];
        [btn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor colorWithRed:74/255.0 green:163/255.0 blue:245/255.0 alpha:1] forState:UIControlStateSelected];
//        CGRect frame = _XiaHuaXianImageView.frame;
//        _XiaHuaXianImageView.frame = CGRectMake(index * btnWidth, frame.origin.y, frame.size.width, frame.size.height);
        btn.tag = 1000 + index;
        
        [_buttonArray addObject:btn];

    }
}
//粘贴按钮
- (void)btnsPasteSuperView:(UIView *)view {
    _btnSuperView = view;
       _XiaHuaXianImageView = [[UIImageView alloc] initWithFrame:CGRectMake(_startPoint.x, _startPoint.y + _btnHeight ,_btnWidth,3)];
    _XiaHuaXianImageView.image = _XiaHuaXianimage;
//    _XiaHuaXianImageView.backgroundColor = [UIColor colorWithRed:241 / 255.0 green:241 / 255.0 blue:241 / 255.0 alpha:1];
    [view addSubview:_XiaHuaXianImageView];
    [view addSubview:self.XiaHuaXianImageView];
    for (UIButton *btn in _buttonArray) {
        [view addSubview:btn];
    }
    
}

- (void)setCutHeight:(CGFloat)cutHeight {
    _cutHeight = cutHeight;
    if (_cutHeight > 0) {
        [_btnSuperView addSubview:self.backgroudBottomView];
        [_btnSuperView addSubview:self.backgroudTopView];
        //    (void)insertSubview:(UIView *)view belowSubview:(UIView *)siblingSubview;
        
        [_btnSuperView sendSubviewToBack:_backgroudTopView];
        [_btnSuperView sendSubviewToBack:_backgroudBottomView];

    } else {
        _backgroudTopView = nil;
        _backgroudBottomView = nil;
    
    }
}

- (UIView *)backgroudBottomView {
    if (_backgroudBottomView == nil) {
        _backgroudBottomView = [[UIView alloc] initWithFrame:CGRectMake(_startPoint.x, _startPoint.y, kZX_ScreenW, _cutHeight)];
        _backgroudBottomView.backgroundColor = [UIColor whiteColor];
    }
    return _backgroudBottomView;
}

- (UIView *)backgroudTopView {
    if (_backgroudTopView == nil) {
        _backgroudTopView = [[UIView alloc] initWithFrame:CGRectMake(_startPoint.x, _startPoint.y +_btnHeight - _cutHeight, kZX_ScreenW, _cutHeight)];
        _backgroudTopView.backgroundColor = [UIColor whiteColor];
    }
    return _backgroudTopView;
}
//添加集合视图
#pragma mark -- UICollectionView的定制
@end

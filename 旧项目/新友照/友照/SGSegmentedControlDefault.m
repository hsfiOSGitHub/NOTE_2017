//
//  SGSegmentedControlDefault.m
//  SGSegmentedControlExample
//
//  Created by apple on 16/11/9.
//  Copyright © 2016年 Sorgle. All rights reserved.
//
//  - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - //
//
//  - - 如在使用中, 遇到什么问题或者有更好建议者, 请于kingsic@126.com邮箱联系 - - - - //
//  - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
//  - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
//  - - GitHub下载地址 https://github.com/kingsic/SGSegmentedControl.git - - - //
//
//  - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - //

#import "SGSegmentedControlDefault.h"
#import "UIView+SGExtension.h"
#import "SGImageButton.h"

#define indicatorViewColorDefualt [UIColor redColor]

@interface SGSegmentedControlDefault ()
/** 标题数组 */
@property (nonatomic, strong) NSArray *title_Arr;
/** 标题按钮 */
@property (nonatomic, strong) UIButton *title_btn;
/** 带有图片的标题按钮 */
@property (nonatomic, strong) SGImageButton *image_title_btn;
/** 存入所有标题按钮 */
@property (nonatomic, strong) NSMutableArray *storageAlltitleBtn_mArr;
/** 普通状态下的图片数组 */
@property (nonatomic, strong) NSArray *nomal_image_Arr;
/** 选中状态下的图片数组 */
@property (nonatomic, strong) NSArray *selected_image_Arr;
/** 临时button用来转换button的点击状态 */
@property (nonatomic, strong) UIButton *temp_btn;
/** 指示器 */
@property (nonatomic, strong) UIView *indicatorView;
/** 背景指示器下面的小indicatorView */
@property (nonatomic, strong) UIView *bgIndicatorView;
/** 带有图片的指示器 */
@property (nonatomic, strong) UIImageView *indicatorViewWithImage;
/** 是否开启文字缩放功能 */
@property (nonatomic, assign) BOOL isScaleText;
/** 标记是否是一个button */
@property (nonatomic, assign) BOOL isFirstButton;
@end

@implementation SGSegmentedControlDefault

/** 按钮字体的大小(字号) */
static CGFloat const btn_fondOfSize = 16;
/** 标题按钮文字的缩放倍数 */
static CGFloat const btn_scale = 0.14;
/** 按钮之间的间距(滚动时按钮之间的间距) */
static CGFloat const btn_Margin = 15;
/** 指示器的高度(默认指示器) */
static CGFloat const indicatorViewHeight = 2;
/** 点击按钮时, 指示器的动画移动时间 */
static CGFloat const indicatorViewTimeOfAnimation = 0.15;

- (NSMutableArray *)storageAlltitleBtn_mArr {
    if (!_storageAlltitleBtn_mArr) {
        _storageAlltitleBtn_mArr = [NSMutableArray array];
    }
    return _storageAlltitleBtn_mArr;
}

- (instancetype)initWithFrame:(CGRect)frame delegate:(id<SGSegmentedControlDefaultDelegate>)delegate childVcTitle:(NSArray *)childVcTitle isScaleText:(BOOL)isScaleText {
    
    if (self = [super initWithFrame:frame]) {
        self.showsHorizontalScrollIndicator = NO;
        self.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.7];
        self.bounces = NO;

        self.delegate_SG = delegate;
        
        self.title_Arr = childVcTitle;
        
        self.isScaleText = isScaleText;
        
        [self setupSubviews];
    }
    return self;
}

+ (instancetype)segmentedControlWithFrame:(CGRect)frame delegate:(id<SGSegmentedControlDefaultDelegate>)delegate childVcTitle:(NSArray *)childVcTitle isScaleText:(BOOL)isScaleText {
    return [[self alloc] initWithFrame:frame delegate:delegate childVcTitle:childVcTitle isScaleText:isScaleText];
}

- (instancetype)initWithFrame:(CGRect)frame delegate:(id<SGSegmentedControlDefaultDelegate>)delegate nomalImageArr:(NSArray *)nomalImageArr selectedImageArr:(NSArray *)selectedImageArr childVcTitle:(NSArray *)childVcTitle {
    
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.7];
        self.showsHorizontalScrollIndicator = NO;
        self.bounces = NO;
        
        self.delegate_SG = delegate;
        self.nomal_image_Arr = nomalImageArr;
        self.selected_image_Arr = selectedImageArr;
        self.title_Arr = childVcTitle;
        
        [self setupSubviewsWithImage];
    }
    return self;
}

+ (instancetype)segmentedControlWithFrame:(CGRect)frame delegate:(id<SGSegmentedControlDefaultDelegate>)delegate nomalImageArr:(NSArray *)nomalImageArr selectedImageArr:(NSArray *)selectedImageArr childVcTitle:(NSArray *)childVcTitle {
    return [[self alloc] initWithFrame:frame delegate:delegate nomalImageArr:nomalImageArr selectedImageArr:selectedImageArr childVcTitle:childVcTitle];
}


- (void)setupSubviews {
    // 计算scrollView的宽度
    CGFloat button_X = 0;
    CGFloat button_Y = 0;
    CGFloat button_H = self.frame.size.height;
    
    for (NSUInteger i = 0; i < _title_Arr.count; i++) {
        /** 创建滚动时的标题button */
        self.title_btn = [UIButton buttonWithType:(UIButtonTypeCustom)];
        
        _title_btn.titleLabel.font = [UIFont systemFontOfSize:btn_fondOfSize];
        _title_btn.tag = i;
        
        // 计算内容的Size
        CGSize buttonSize = [self sizeWithText:_title_Arr[i] font:[UIFont systemFontOfSize:btn_fondOfSize] maxSize:CGSizeMake(MAXFLOAT, button_H)];
        
        // 计算内容的宽度
        CGFloat button_W = 2 * btn_Margin + buttonSize.width;
        _title_btn.frame = CGRectMake(button_X, button_Y, button_W, button_H);
        
        [_title_btn setTitle:_title_Arr[i] forState:(UIControlStateNormal)];
        [_title_btn setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)];
        [_title_btn setTitleColor:[UIColor redColor] forState:(UIControlStateSelected)];
        
        // 计算每个button的X值
        button_X = button_X + button_W;
        
        // 点击事件
        [_title_btn addTarget:self action:@selector(buttonAction:) forControlEvents:(UIControlEventTouchUpInside)];
        
        // 默认选中第0个button
        if (i == 0) {
            [self buttonAction:_title_btn];
        }
        
        // 存入所有的title_btn
        [self.storageAlltitleBtn_mArr addObject:_title_btn];
        [self addSubview:_title_btn];
    }
    
    // 计算scrollView的宽度
    CGFloat scrollViewWidth = CGRectGetMaxX(self.subviews.lastObject.frame);
    self.contentSize = CGSizeMake(scrollViewWidth, self.frame.size.height);
    
    // 取出第一个子控件
    UIButton *firstButton = self.subviews.firstObject;
    if (firstButton) {
        self.isFirstButton = YES;
    }
    
#pragma mark - - - 为文字缩放增加的代码
    if (self.isScaleText) {
        firstButton.titleLabel.font = [UIFont systemFontOfSize:btn_fondOfSize * btn_scale + btn_fondOfSize];
    }
    
    // 添加指示器
    self.indicatorView = [[UIView alloc] init];
    _indicatorView.backgroundColor = indicatorViewColorDefualt;
    _indicatorView.SG_height = indicatorViewHeight;
    _indicatorView.SG_y = self.frame.size.height - 2 * indicatorViewHeight;
    [self addSubview:_indicatorView];
    
    // 指示器默认在第一个选中位置
    // 计算Titlebutton内容的Size
    CGSize buttonSize = [self sizeWithText:firstButton.titleLabel.text font:[UIFont systemFontOfSize:btn_fondOfSize] maxSize:CGSizeMake(MAXFLOAT, self.frame.size.height)];
#pragma mark - - - 判断是否开启文字缩放功能
    if (self.isScaleText) {
        _indicatorView.SG_width = buttonSize.width + btn_scale * buttonSize.width;
    } else {
        _indicatorView.SG_width = buttonSize.width;
    }
    
    _indicatorView.SG_centerX = firstButton.SG_centerX;
}

/**
 *  计算文字尺寸
 *
 *  @param text    需要计算尺寸的文字
 *  @param font    文字的字体
 *  @param maxSize 文字的最大尺寸
 */
- (CGSize)sizeWithText:(NSString *)text font:(UIFont *)font maxSize:(CGSize)maxSize {
    NSDictionary *attrs = @{NSFontAttributeName : font};
    return [text boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size;
}

#pragma mark - - - 创建带有图片的button
- (void)setupSubviewsWithImage {
    CGFloat button_X = 0;
    CGFloat button_Y = 0;
    CGFloat button_H = self.frame.size.height;
    
    for (NSUInteger i = 0; i < _title_Arr.count; i++) {
        /** 创建滚动时的标题button */
        self.image_title_btn = [[SGImageButton alloc] init];
        
        _image_title_btn.titleLabel.font = [UIFont systemFontOfSize:btn_fondOfSize];
        _image_title_btn.tag = i;
        
        // 计算内容的Size
        CGSize buttonSize = [self sizeWithText:_title_Arr[i] font:[UIFont systemFontOfSize:btn_fondOfSize] maxSize:CGSizeMake(MAXFLOAT, button_H)];
        
        // 计算内容的宽度
        CGFloat button_W = 2 * btn_Margin + buttonSize.width;
        _image_title_btn.frame = CGRectMake(button_X, button_Y, button_W, button_H);
        
        [_image_title_btn setTitle:_title_Arr[i] forState:(UIControlStateNormal)];
        [_image_title_btn setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)];
        [_image_title_btn setTitleColor:[UIColor redColor] forState:(UIControlStateSelected)];
        [_image_title_btn setImage:[UIImage imageNamed:_nomal_image_Arr[i]] forState:(UIControlStateNormal)];
        [_image_title_btn setImage:[UIImage imageNamed:_selected_image_Arr[i]] forState:(UIControlStateSelected)];
        
        // 计算每个button的X值
        button_X = button_X + button_W;
        
        // 点击事件
        [_image_title_btn addTarget:self action:@selector(buttonAction:) forControlEvents:(UIControlEventTouchUpInside)];
        
        // 默认选中第0个button
        if (i == 0) {
            [self buttonAction:_image_title_btn];
        }
        
        // 存入所有的title_btn
        [self.storageAlltitleBtn_mArr addObject:_image_title_btn];
        [self addSubview:_image_title_btn];
    }
    
    // 计算scrollView的宽度
    CGFloat scrollViewWidth = CGRectGetMaxX(self.subviews.lastObject.frame);
    self.contentSize = CGSizeMake(scrollViewWidth, self.frame.size.height);
    
    // 取出第一个子控件
    UIButton *firstButton = self.subviews.firstObject;
    
    // 添加指示器
    self.indicatorView = [[UIView alloc] init];
    _indicatorView.backgroundColor = indicatorViewColorDefualt;
    _indicatorView.SG_height = indicatorViewHeight;
    _indicatorView.SG_y = self.frame.size.height - indicatorViewHeight;
    [self addSubview:_indicatorView];
    
    // 指示器默认在第一个选中位置
    // 计算Titlebutton内容的Size
    CGSize buttonSize = [self sizeWithText:firstButton.titleLabel.text font:[UIFont systemFontOfSize:btn_fondOfSize] maxSize:CGSizeMake(MAXFLOAT, self.frame.size.height)];
    _indicatorView.SG_width = buttonSize.width;
    _indicatorView.SG_centerX = firstButton.SG_centerX;
}

#pragma mark - - - 按钮的点击事件
- (void)buttonAction:(UIButton *)sender {
    // 1、代理方法实现
    NSInteger index = sender.tag;
    if ([self.delegate_SG respondsToSelector:@selector(SGSegmentedControlDefault:didSelectTitleAtIndex:)]) {
        [self.delegate_SG SGSegmentedControlDefault:self didSelectTitleAtIndex:index];
    }
    
    // 2、改变选中的button的位置
    [self selectedBtnLocation:sender];
}

/** 标题选中颜色改变以及指示器位置变化 */
- (void)selectedBtnLocation:(UIButton *)button {
    
    // 1、选中的button
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(indicatorViewTimeOfAnimation * 0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (_temp_btn == nil) {
            button.selected = YES;
            _temp_btn = button;
        }else if (_temp_btn != nil && _temp_btn == button){
            button.selected = YES;
        }else if (_temp_btn != button && _temp_btn != nil){
            _temp_btn.selected = NO;
            button.selected = YES; _temp_btn = button;
        }
    });
    
    // 2、改变指示器的位置
    if (self.segmentedControlIndicatorType == segmentedControlIndicatorTypeCenter) {
        
        [UIView animateWithDuration:indicatorViewTimeOfAnimation animations:^{
            self.indicatorView.SG_width = button.SG_width - btn_Margin;
            self.indicatorView.SG_centerX = button.SG_centerX;
        }];
        
    } else if (self.segmentedControlIndicatorType == segmentedControlIndicatorTypeBankground) {
        
        [UIView animateWithDuration:indicatorViewTimeOfAnimation animations:^{
            self.indicatorView.SG_width = button.SG_width;
            self.bgIndicatorView.SG_width = button.SG_width;
            self.indicatorView.SG_centerX = button.SG_centerX;
        }];
        
    } else if (self.segmentedControlIndicatorType == segmentedControlIndicatorTypeBottomWithImage) {
        
        [UIView animateWithDuration:indicatorViewTimeOfAnimation animations:^{
            self.indicatorViewWithImage.SG_centerX = button.SG_centerX;
        }];
        
    } else {
        
        // 改变指示器位置
        [UIView animateWithDuration:indicatorViewTimeOfAnimation animations:^{
            // 计算内容的Size
            [UIView animateWithDuration:indicatorViewTimeOfAnimation animations:^{
                self.indicatorView.SG_width = button.SG_width - 2 * btn_Margin;
                self.indicatorView.SG_centerX = button.SG_centerX;
            }];
        }];
    }
    
    // 3、滚动标题选中居中
    [self selectedBtnCenter:button];
}

/** 改变选中button的位置以及指示器位置变化（给外界scrollView提供的方法 -> 必须实现） */
- (void)changeThePositionOfTheSelectedBtnWithScrollView:(UIScrollView *)scrollView {
    // 1、计算滚动到哪一页
    NSInteger index = scrollView.contentOffset.x / scrollView.frame.size.width;
    
    // 2、把对应的标题选中
    UIButton *selectedBtn = self.storageAlltitleBtn_mArr[index];
    
    // 3、滚动时，改变标题选中
    [self selectedBtnLocation:selectedBtn];
}

/** 滚动标题选中居中 */
- (void)selectedBtnCenter:(UIButton *)centerBtn {
    // 计算偏移量
    CGFloat offsetX = centerBtn.center.x - self.frame.size.width * 0.5;
    
    if (offsetX < 0) offsetX = 0;
    
    // 获取最大滚动范围
    CGFloat maxOffsetX = self.contentSize.width - self.frame.size.width;
    
    if (offsetX > maxOffsetX) offsetX = maxOffsetX;
    
    // 滚动标题滚动条
    [self setContentOffset:CGPointMake(offsetX, 0) animated:YES];
}

/** 文字渐显、缩放效果的实现（给外界 scrollViewDidScroll 提供的方法 -> 可供选择） */
- (void)selectedTitleBtnColorGradualChangeScrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat curPage = scrollView.contentOffset.x / scrollView.bounds.size.width;
    
    // 左边button角标
    NSInteger leftIndex = curPage;
    // 右边的button角标
    NSInteger rightIndex = leftIndex + 1;
    
    // 获取左边的button
    UIButton *left_btn = self.storageAlltitleBtn_mArr[leftIndex];
    
    // 获取右边的button
    UIButton *right_btn;
    if (rightIndex < self.storageAlltitleBtn_mArr.count) {
        right_btn = self.storageAlltitleBtn_mArr[rightIndex];
    }
    
    // 计算下右边缩放比例
    CGFloat rightScale = curPage - leftIndex;
    
    // 计算下左边缩放比例
    CGFloat leftScale = 1 - rightScale;
    
    if (self.titleFondGradualChange == YES) {
        // 取出第一个子控件
        UIButton *firstButton = self.subviews.firstObject;
        if (self.isFirstButton) {
            firstButton.titleLabel.font = [UIFont systemFontOfSize:btn_fondOfSize];
        }
        
        // 左边缩放
        left_btn.transform = CGAffineTransformMakeScale(leftScale * btn_scale + 1, leftScale * btn_scale + 1);
        // 右边缩放
        right_btn.transform = CGAffineTransformMakeScale(rightScale * btn_scale + 1, rightScale * btn_scale + 1);
    }
    
    if (self.titleColorGradualChange == YES) {
        // 设置文字颜色渐变
        left_btn.titleLabel.textColor = [UIColor colorWithRed:leftScale green:0 blue:0 alpha:1];
        right_btn.titleLabel.textColor = [UIColor colorWithRed:rightScale green:0 blue:0 alpha:1];
    }
}


#pragma mark - - - setter 方法设置属性
- (void)setTitleColorStateNormal:(UIColor *)titleColorStateNormal {
    _titleColorStateNormal = titleColorStateNormal;
    for (UIView *subViews in self.storageAlltitleBtn_mArr) {
        UIButton *button = (UIButton *)subViews;
        [button setTitleColor:titleColorStateNormal forState:(UIControlStateNormal)];
    }
}

- (void)setTitleColorStateSelected:(UIColor *)titleColorStateSelected {
    _titleColorStateSelected = titleColorStateSelected;
    for (UIView *subViews in self.storageAlltitleBtn_mArr) {
        UIButton *button = (UIButton *)subViews;
        [button setTitleColor:titleColorStateSelected forState:(UIControlStateSelected)];
    }
}

- (void)setIndicatorColor:(UIColor *)indicatorColor {
    _indicatorColor = indicatorColor;
    _indicatorView.backgroundColor = indicatorColor;
}

- (void)setShowsBottomScrollIndicator:(BOOL)showsBottomScrollIndicator {
    if (self.showsBottomScrollIndicator == YES) {
        
    } else {
        [self.indicatorView removeFromSuperview];
        [self.bgIndicatorView removeFromSuperview];
        [self.indicatorViewWithImage removeFromSuperview];
    }
}

- (void)setSegmentedControlIndicatorType:(segmentedControlIndicatorType)segmentedControlIndicatorType {
    _segmentedControlIndicatorType = segmentedControlIndicatorType;
    
    // 取出第一个子控件
    UIButton *firstButton = self.subviews.firstObject;
    
    if (self.segmentedControlIndicatorType == segmentedControlIndicatorTypeBottom) {
        
    } else if (self.segmentedControlIndicatorType == segmentedControlIndicatorTypeCenter) {
        
        // 指示器默认在第一个选中位置
        // 计算TitleLabel内容的Size
        CGSize buttonSize = [self sizeWithText:firstButton.titleLabel.text font:[UIFont systemFontOfSize:btn_fondOfSize] maxSize:CGSizeMake(MAXFLOAT, self.frame.size.height)];
        
        // 改变原指示器样式
        _indicatorView.SG_width = buttonSize.width + btn_Margin;
        _indicatorView.SG_centerX = firstButton.SG_centerX;
        CGFloat indicatorViewHeight_c = 25;
        self.indicatorView.SG_height = indicatorViewHeight_c;
        self.indicatorView.SG_y = (self.frame.size.height - indicatorViewHeight_c) * 0.5;
        
        self.indicatorView.alpha = 0.3;
        self.indicatorView.layer.cornerRadius = 7;
        self.indicatorView.layer.masksToBounds = YES;
        
    } else if (self.segmentedControlIndicatorType == segmentedControlIndicatorTypeBankground) {
        
        // 计算firstButton内容的Size
        CGSize buttonSize = [self sizeWithText:firstButton.titleLabel.text font:[UIFont systemFontOfSize:btn_fondOfSize] maxSize:CGSizeMake(MAXFLOAT, self.frame.size.height)];
        
        // 改变原指示器样式
        _indicatorView.SG_x = firstButton.SG_x;
        _indicatorView.SG_width = buttonSize.width + 2 * btn_Margin;
        CGFloat indicatorViewHeight_c = self.frame.size.height;
        self.indicatorView.SG_height = indicatorViewHeight_c;
        self.indicatorView.SG_y = 0;
        self.indicatorView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.3];
        
        // 增加新的指示器（指示器底部的小指示器）
        self.bgIndicatorView = [[UIView alloc] init];
        _bgIndicatorView.backgroundColor = [UIColor redColor];
        _bgIndicatorView.SG_x = firstButton.SG_x;
        _bgIndicatorView.SG_width = _indicatorView.SG_width;
        _bgIndicatorView.SG_height = indicatorViewHeight;
        _bgIndicatorView.SG_y = _indicatorView.SG_height - indicatorViewHeight;
        [self.indicatorView addSubview:_bgIndicatorView];
        
    } else if (self.segmentedControlIndicatorType == segmentedControlIndicatorTypeBottomWithImage) {
        
        // 清除 alloc init 创建的指示器
        [self.indicatorView removeFromSuperview];
        self.indicatorView = nil;
        
        // 创建新的指示器样式（带有图片）
        self.indicatorViewWithImage = [[UIImageView alloc] init];
        _indicatorViewWithImage.image = [UIImage imageNamed:@"login_register_indicator"];
        _indicatorViewWithImage.SG_height = _indicatorViewWithImage.image.size.height;
        _indicatorViewWithImage.SG_y = self.SG_height - _indicatorViewWithImage.SG_height;
        _indicatorViewWithImage.SG_width = _indicatorViewWithImage.image.size.width;
        _indicatorViewWithImage.SG_centerX = firstButton.SG_centerX;
        [self addSubview:_indicatorViewWithImage];
    }
}

@end



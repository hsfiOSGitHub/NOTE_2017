//
//  HWAdAlretView.m
//  HWAdAlertView
//
//  Created by Lee on 2017/4/25.
//  Copyright © 2017年 cashpie. All rights reserved.
//

#import "HWAdAlretView.h"
#import "HWAdAlterModel.h"

#define kScreen_width  [UIScreen mainScreen].bounds.size.width
#define kScreen_height [UIScreen mainScreen].bounds.size.height
#define kScroll_item_width    270
#define kScroll_heigth   350

@interface HWAdAlretView ()<UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView * adScrollView;

@property (nonatomic, assign) NSInteger itemCount;

@property (nonatomic, strong) UIPageControl * pageControl;

@property (nonatomic, strong) NSArray * adArray;

@property (nonatomic, strong) UIButton * closeBtn;

@end

@implementation HWAdAlretView

+ (HWAdAlretView *)showInView:(UIView *)view delegate:(id)delegate adDataArray:(NSArray *)adList{
    if (!adList) return nil;
    HWAdAlretView * adAlertView = [[HWAdAlretView alloc]initShowInView:view delegate:delegate adDataArray:adList];
    return adAlertView;
}

- (instancetype)initShowInView:(UIView *)view delegate:(id)delegate
                     adDataArray:(NSArray *)dataList{
    
    if (self = [super init]) {
        self.frame = view.bounds;
        self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:.5];
        self.adArray = dataList;
        self.delegate = delegate;
        
        [[[UIApplication sharedApplication].windows objectAtIndex:0] endEditing:YES];
        [[[UIApplication sharedApplication].windows objectAtIndex:0] addSubview:self];
        
        [self showAlert];
    }
    return self;
}

- (void)showAlert{
    CABasicAnimation * animation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    animation.fromValue = @0;
    animation.toValue = @1;
    animation.duration = 0.25f;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    [self.layer addAnimation:animation forKey:@"opacity"];

}
#pragma mark scrollView
- (UIScrollView *)adScrollView{

    if (!_adScrollView) {
        _adScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, -(kScreen_height-kScroll_heigth)/2, kScreen_width, kScroll_heigth)];
        _adScrollView.backgroundColor = [UIColor clearColor];
        _adScrollView.delegate = self;
        _adScrollView.pagingEnabled = YES;
        _adScrollView.showsHorizontalScrollIndicator = NO;
        _adScrollView.userInteractionEnabled = YES;
        _adScrollView.contentSize = CGSizeMake(_itemCount * kScreen_width, kScroll_heigth);
    }
    return _adScrollView;
}

- (void)setAdArray:(NSArray *)adArray{
    _adArray = adArray;
    _itemCount = adArray.count;
    
    [UIView animateWithDuration:.7 animations:^{
        self.adScrollView.frame = CGRectMake(0, (kScreen_height-kScroll_heigth)/2, kScreen_width, kScroll_heigth);
        [self initAlertItemView];
    } completion:nil];
}

- (void)initAlertItemView{
    if (_itemCount == 0) return;
    [self addSubview:self.adScrollView];
    for (int index = 0; index < _itemCount; index ++) {
        HWAdAlterModel * alertModel = _adArray[index];
        HWAlterItemView * itemView = [[HWAlterItemView alloc]initWithFrame:CGRectMake((kScreen_width - kScroll_item_width)/2 + index* kScreen_width, 0, kScroll_item_width, kScroll_heigth)];
        itemView.currentIndex = index;
        itemView.tag = 100+index;
        itemView.imageView.image = [UIImage imageNamed:alertModel.imgurl];
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(adItemClicked:)];
        [itemView addGestureRecognizer:singleTap];
        [self.adScrollView addSubview:itemView];
    }
    [self addSubview:self.closeBtn];
    if (_itemCount>1) {
        
        [self addSubview:self.pageControl];
    }
}

- (UIButton *)closeBtn{
    if (!_closeBtn) {
        _closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _closeBtn.frame = CGRectMake((kScreen_width+kScroll_item_width-44-24)/2, (kScreen_height-kScroll_heigth)/2-44, 44, 44);
        [_closeBtn setImage:[UIImage imageNamed:@"close"] forState:UIControlStateNormal];
        [_closeBtn addTarget:self action:@selector(removeAlertView) forControlEvents:UIControlEventTouchUpInside];
    }
    return _closeBtn;
}

- (UIPageControl *)pageControl{
    if (!_pageControl) {
        _pageControl = [[UIPageControl alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.adScrollView.frame)+ 15, kScreen_width, 20)];
        _pageControl.numberOfPages = _itemCount;
        _pageControl.currentPage = 0;
        [_pageControl addTarget:self action:@selector(pageValueChange:) forControlEvents:UIControlEventValueChanged];
    }
    return _pageControl;
}

- (void)adItemClicked:(UITapGestureRecognizer *)recognizer{
    if ([self.delegate respondsToSelector:@selector(alertViewClickedIndex:)]) {
        [self.delegate alertViewClickedIndex:recognizer.view.tag-100];
        [self removeFromSuperview];
    }
}

- (void)pageValueChange:(UIPageControl *)pageControl{
    [UIView animateWithDuration:.35 animations:^{
        self.adScrollView.contentOffset = CGPointMake(pageControl.currentPage * kScreen_width, 0);
    }];
}

- (void)removeAlertView{
    [UIView animateWithDuration:.8 animations:^{
        self.adScrollView.frame = CGRectMake(0,  (kScreen_height-kScroll_heigth)/2, kScreen_width, 0);
    } completion:^(BOOL finished) {
        self.alpha = 0;
        [self removeFromSuperview];
    }];

}

#pragma mark scrollViewDelegate
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{

    self.pageControl.currentPage = scrollView.contentOffset.x/kScreen_width;
}

@end

@implementation HWAlterItemView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self initSubViews];
    }
    return self;
}
-(void)initSubViews{
    self.userInteractionEnabled = YES;
    self.layer.masksToBounds    = YES;
    self.layer.cornerRadius     = 4;
    self.layer.shadowOpacity    = .2;
    self.layer.shadowOffset     = CGSizeMake(0, 2.5);
    self.layer.shadowColor      = [UIColor blackColor].CGColor;
    
    [self addSubview:self.imageView];
}

-(UIImageView *)imageView{
    if (!_imageView) {
        _imageView = [[UIImageView alloc]initWithFrame:self.bounds];
        _imageView.backgroundColor        = [UIColor colorWithWhite:0.1 alpha:1.0];
        _imageView.image = [UIImage imageNamed:@"ad_placeholdImge"];
        _imageView.userInteractionEnabled = YES;
        _imageView.layer.masksToBounds    = YES;
    }
    return _imageView;
}

@end

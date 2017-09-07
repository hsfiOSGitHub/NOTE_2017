//
//  HWGuideView.m
//  HWGuideView
//
//  Created by Lee on 2017/3/30.
//  Copyright © 2017年 cashpie. All rights reserved.
//

#import "HWGuideView.h"
#import "HWButton.h"
#import "HWGuideView-Swift.h"

#define kPageNumber         3
#define kAnimationInterval  2

@interface HWGuideView ()<UIScrollViewDelegate>

@property (nonatomic, strong) CHIBasePageControl * pageControl;

@end

@implementation HWGuideView


-(instancetype)initWithFrame:(CGRect)frame{

    if (self = [super initWithFrame:frame]) {
        [self imageScroll];
        [self addSubview:self.pageControl];
    }
    return self;
}
#pragma mark -pageControl
- (CHIBasePageControl *)pageControl{
    if (!_pageControl) {
        _pageControl = [[CHIPageControlJalapeno alloc]initWithFrame:CGRectMake(0, 0, 50, 8)];
        _pageControl.center = CGPointMake(self.bounds.size.width/2, self.bounds.size.height-40);
        _pageControl.radius = 5.0;
        _pageControl.numberOfPages = kPageNumber;
        _pageControl.tintColor = hexColor(0xEAEAEAff);
        _pageControl.currentPageTintColor = hexColor(0xD2D2D2ff);
    }
    return _pageControl;
}

#pragma mark -创建滚动视图
- (void)imageScroll{
    UIScrollView * scrollView = [[UIScrollView alloc]initWithFrame:self.frame];
    scrollView.delegate = self;
    for (int index = 0; index < kPageNumber; index++) {
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"welcome_%d",index+1]];
        UIImageView * imageView = [[UIImageView alloc]initWithFrame:CGRectMake(index * self.frame.size.width, 0, self.frame.size.width, self.frame.size.height)];
        imageView.image = image;
        [scrollView addSubview:imageView];
        
        if (index ==kPageNumber-1) {
            HWButton * button = [HWButton hw_buttonWithTitle:@"立即体验" titleColor:[UIColor redColor]];
            button.frame = CGRectMake(0, 0, 100, 40);
            button.center = CGPointMake(self.bounds.size.width *index+self.bounds.size.width/2, self.bounds.size.height-80);
            [button addTarget:self action:@selector(buttonClick) forControlEvents:UIControlEventTouchUpInside];
            [scrollView addSubview:button];
        }
    }
    scrollView.pagingEnabled = YES;
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.contentSize = CGSizeMake(self.frame.size.width * kPageNumber, self.frame.size.height);
    [self addSubview:scrollView];
}

#pragma mark scrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    double total = scrollView.contentSize.width - scrollView.bounds.size.width;
    double offset = scrollView.contentOffset.x;
    double percent = (offset / total);
    double progress = percent * (scrollView.contentSize.width/self.frame.size.width - 1);
    _pageControl.progress = progress;
}
#pragma mark 按钮点击
- (void)buttonClick{
    
    [UIView animateWithDuration:kAnimationInterval animations:^{
        self.alpha = 0;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(kAnimationInterval * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self removeFromSuperview];
        });
    }];
}

@end

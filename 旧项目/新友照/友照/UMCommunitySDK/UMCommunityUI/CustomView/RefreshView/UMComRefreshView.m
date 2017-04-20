//
//  RefreshTableView.m
//  DJXRefresh
//
//  Created by Founderbn on 14-7-18.
//  Copyright (c) 2014年 Umeng 董剑雄. All rights reserved.
//

#import "UMComRefreshView.h"
#import "UMComResouceDefines.h"
#import <UMCommunitySDK/UMComSession.h>

NSString *const UMRefreshKeyPathContentOffset = @"contentOffset";
NSString *const UMRefreshKeyPathContentInset = @"contentInset";
NSString *const UMRefreshKeyPathContentSize = @"contentSize";

@interface UMComRefreshView ()

@property (nonatomic,copy) NSString *lastRefreshTime;

@end

@implementation UMComRefreshView

+ (UMComRefreshView *)refreshControllViewWithScrollView:(UIScrollView *)scrollView block:(void (^)())block
{
    UMComRefreshView *refrehView = [[self alloc]initWithFrame:CGRectMake(0, 0, scrollView.frame.size.width, 60)];
    refrehView.loadingBlock = block;
    refrehView.scrollView = scrollView;
    return refrehView;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {

        self.statusLable = [[UILabel alloc]init];
        self.dateLable = [[UILabel alloc]init];
        self.activityIndicatorView = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        self.indicateImageView = [[UIImageView alloc]init];
        self.statusLable.backgroundColor = [UIColor clearColor];
        self.dateLable.backgroundColor = [UIColor clearColor];
        self.statusLable.font = UMComFontNotoSansLightWithSafeSize(15);
        self.dateLable.font = UMComFontNotoSansLightWithSafeSize(10);
        self.statusLable.textAlignment = NSTextAlignmentCenter;
        self.dateLable.textAlignment = NSTextAlignmentCenter;
        self.statusLable.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        self.dateLable.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        self.indicateImageView.autoresizingMask = UIViewAutoresizingFlexibleRightMargin;
        self.activityIndicatorView.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleLeftMargin;
        [self addSubview:self.dateLable];
        [self addSubview:self.statusLable];
        [self addSubview:self.indicateImageView];
        [self addSubview:self.activityIndicatorView];
        self.backgroundColor = [UIColor clearColor];
        self.backgroundColor = [UIColor clearColor];
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        self.backgroundColor = [UIColor clearColor];
        self.beginPullHeight = frame.size.height;

    }
    return self;
}

- (void)resetSubViews
{
    CGRect frame = self.frame;
    frame.size.width = self.scrollView.frame.size.width;
    frame.size.height = self.beginPullHeight;
    self.frame = frame;
}

//- (void)willMoveToSuperview:(UIView *)newSuperview
//{
//    if (![newSuperview isKindOfClass:[UIScrollView class]] || newSuperview == self.scrollView) {
//        return;
//    }
////    [self removeObservers];
//
//}


- (void)setScrollView:(UIScrollView *)scrollView
{
    if (![scrollView isKindOfClass:[UIScrollView class]]) {
        return;
    }
    self.scrollViewOriginalInset = scrollView.contentInset;
    _scrollView = scrollView;
    [scrollView addSubview:self];
    [self resetSubViews];
    self.loadStatus = UMPullingStatus;
    [self addObservers];
}




- (void)dealloc
{
    [self removeObservers];
}

- (void)addObservers
{
    [self.scrollView addObserver:self forKeyPath:UMRefreshKeyPathContentOffset options:NSKeyValueObservingOptionNew context:nil];
    [self.scrollView addObserver:self forKeyPath:UMRefreshKeyPathContentSize options:NSKeyValueObservingOptionNew context:nil];
}

- (void)removeObservers
{
    [self.scrollView removeObserver:self forKeyPath:UMRefreshKeyPathContentOffset];
    [self.scrollView removeObserver:self forKeyPath:UMRefreshKeyPathContentSize];
}


- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
{
    if ([keyPath isEqualToString:UMRefreshKeyPathContentOffset]) {
        [self scrollViewDidChangeOffset:change];
    }else if ([keyPath isEqualToString:UMRefreshKeyPathContentSize]){
        [self scrollViewDidChangeContentSize:change];
    }
}

- (void)scrollViewDidChangeOffset:(NSDictionary *)change
{

}

- (void)scrollViewDidChangeContentSize:(NSDictionary *)change
{

}


- (NSString *)noticeForLoadStatus:(UMLoadStatus)loadStatus
{
    if (self.noticeForLoadStatusBlock) {
        return self.noticeForLoadStatusBlock(loadStatus);
    }else{
        return nil;
    }
}


- (void)beginLoading
{
    [self setLoadStatus:UMLoadingStatus];
}

- (void)endLoading
{
    [self setLoadStatus:UMNomalStatus];
}

- (void)noMoreData
{
    [self setLoadStatus:UMNoMoredStatus];

}

- (void)setLoadStatus:(UMLoadStatus)loadStatus
{
    _loadStatus = loadStatus;
    self.statusLable.text = [self noticeForLoadStatus:loadStatus];

}

- (NSString *)nowDateString
{
    NSDate *today = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter  alloc]init];
    NSCalendar *calendar =
    [[NSCalendar alloc]initWithCalendarIdentifier:NSGregorianCalendar];
    [formatter setCalendar:calendar];
    [formatter setDateFormat:@"HH:mm:ss"];//yyyy-MM-dd HH:mm:ss
    NSString *todayTime = [formatter stringFromDate:today];
    if (todayTime) {
        return [NSString stringWithFormat:UMComLocalizedString(@"um_com_lastRefreshTime", @"上次下拉刷新时间：%@"),todayTime];
    }
    return nil;
}

- (void)setRotation:(NSInteger)rotation animated:(BOOL)animated
{
    if (rotation < -4)
        rotation = 4 - abs((int)rotation);
    if (rotation > 4)
        rotation = rotation - 4;
    if (animated)
    {
        [UIView animateWithDuration:0.1 animations:^{
            CGAffineTransform rotationTransform = CGAffineTransformMakeRotation(rotation * M_PI / 2);
            self.indicateImageView.transform = rotationTransform;
        } completion:^(BOOL finished) {
        }];
    } else
    {
        CGAffineTransform rotationTransform = CGAffineTransformMakeRotation(rotation * M_PI / 2);
        self.indicateImageView.transform = rotationTransform;
    }
}

-(UIImage *)image:(UIImage *)image rotation:(UIImageOrientation)orientation
{
    long double rotate = 0.0;
    CGRect rect;
    float translateX = 0;
    float translateY = 0;
    float scaleX = 1.0;
    float scaleY = 1.0;
    switch (orientation) {
        case UIImageOrientationLeft:
            rotate = M_PI_2;
            rect = CGRectMake(0, 0, image.size.height, image.size.width);
            translateX = 0;
            translateY = -rect.size.width;
            scaleY = rect.size.width/rect.size.height;
            scaleX = rect.size.height/rect.size.width;
            break;
        case UIImageOrientationRight:
            rotate = 3 * M_PI_2;
            rect = CGRectMake(0, 0, image.size.height, image.size.width);
            translateX = -rect.size.height;
            translateY = 0;
            scaleY = rect.size.width/rect.size.height;
            scaleX = rect.size.height/rect.size.width;
            break;
        case UIImageOrientationDown:
            rotate = M_PI;
            rect = CGRectMake(0, 0, image.size.width, image.size.height);
            translateX = -rect.size.width;
            translateY = -rect.size.height;
            break;
        default:
            rotate = 0.0;
            rect = CGRectMake(0, 0, image.size.width, image.size.height);
            translateX = 0;
            translateY = 0;
            break;
    }
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    //做CTM变换
    CGContextTranslateCTM(context, 0.0, rect.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    CGContextRotateCTM(context, rotate);
    CGContextTranslateCTM(context, translateX, translateY);
    CGContextScaleCTM(context, scaleX, scaleY);
    //绘制图片
    CGContextDrawImage(context, CGRectMake(0, 0, rect.size.width, rect.size.height), image.CGImage);
    UIImage *newPic = UIGraphicsGetImageFromCurrentImageContext();
    return newPic;
}
@end


@interface UMComHeadView ()

@end

@implementation UMComHeadView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.indicateImageView.image = UMComImageWithImageName(@"grayArrow1");
        self.noticeForLoadStatusBlock = ^(UMLoadStatus loadStatus){
            switch (loadStatus) {
                case UMNomalStatus:
                    return @"刷新完成";
                    break;
                case UMPullingStatus:
                    return @"下拉可以刷新";
                    break;
                case UMPreLoadStatus:
                    return @"松手即可刷新";
                    break;
                case UMLoadingStatus:
                    return @"正在刷新";
                    break;
                case UMNoMoredStatus:
                    return @"已经是最新数据了";
                    break;
                default:
                    break;
            }
        };

    }
    return self;
}

- (void)scrollViewDidChangeOffset:(NSDictionary *)change
{
    [super scrollViewDidChangeOffset:change];
    if (self.loadStatus == UMLoadingStatus) {
        return;
    }
    // 跳转到下一个控制器时，contentInset可能会变
    self.scrollViewOriginalInset = self.scrollView.contentInset;
    
    // 当前的contentOffset
    CGFloat offsetY = self.scrollView.contentOffset.y;
    // 头部控件刚好出现的offsetY
    CGFloat happenOffsetY = - self.scrollViewOriginalInset.top;
    
    // 如果是向上滚动到看不见头部控件，直接返回
    if (offsetY >= happenOffsetY) return;

    // 普通 和 即将刷新 的临界点
    CGFloat normal2pullingOffsetY = happenOffsetY - self.frame.size.height;
    CGFloat pullingPercent = (happenOffsetY - offsetY) / self.frame.size.height;
    
    if (self.scrollView.isDragging) { // 如果正在拖拽
        self.pullingPercent = pullingPercent;
        if (self.loadStatus == UMNomalStatus && offsetY < happenOffsetY) {
            // 转为即将刷新状态
            self.loadStatus = UMPullingStatus;
        }else if (self.loadStatus == UMPullingStatus && offsetY < normal2pullingOffsetY){
            self.loadStatus = UMPreLoadStatus;
        }else if (self.loadStatus == UMPreLoadStatus && offsetY >= normal2pullingOffsetY) {
            // 转为普通状态
            self.loadStatus = UMNomalStatus;
        }
    } else if (self.loadStatus == UMPreLoadStatus) {// 即将刷新 && 手松开
        // 开始刷新
        // 执行代理方法
        [self setLoadStatus:UMLoadingStatus];
    } else if (pullingPercent < 1) {
        self.pullingPercent = pullingPercent;
    }
}

- (void)resetSubViews
{
    [super resetSubViews];
    CGRect frame = self.frame;
    frame.origin.y = - self.scrollViewOriginalInset.top - self.beginPullHeight;
    self.frame = frame;
    CGFloat defualtHeight = 50;
    CGFloat height = frame.size.height;
    CGFloat width = frame.size.width;
    CGFloat dateLabelHeight = defualtHeight /3;
    CGFloat statusLableHeight = defualtHeight - dateLabelHeight;
    CGFloat commonLabelOriginX = 60;
    self.statusLable.frame = CGRectMake(commonLabelOriginX, height-defualtHeight-5, width-commonLabelOriginX*2, statusLableHeight);
    
    self.dateLable.frame = CGRectMake(commonLabelOriginX,self.statusLable.frame.size.height+self.statusLable.frame.origin.y, width-commonLabelOriginX*2, dateLabelHeight);
    self.activityIndicatorView.frame = CGRectMake(10, height-(defualtHeight-(defualtHeight-40)/2), 40, 40);
    self.indicateImageView.frame = CGRectMake(20, height-(defualtHeight-(defualtHeight-40)/2), 15, 35);
}

#pragma mark -
- (void)setLoadStatus:(UMLoadStatus)loadStatus
{
 
    if (self.loadStatus == loadStatus) {
        return;
    }
    [super setLoadStatus:loadStatus];
    
    switch (loadStatus) {
        case UMPullingStatus:
        {
            if (self.indicateImageView.superview != self) {
                [self.indicateImageView removeFromSuperview];
                [self addSubview:self.indicateImageView];
            }

            if (self.lastRefreshTime) {
                self.dateLable.text = self.lastRefreshTime;
            }else{
                
                self.dateLable.text = [self nowDateString];
            }
            self.lastRefreshTime = [self nowDateString];
        }
            break;
        case UMPreLoadStatus:
        {
            [self setRotation:-2 animated:YES];

        }
            break;
        case UMLoadingStatus:
        {

            [self.indicateImageView removeFromSuperview];
            self.indicateImageView.transform = CGAffineTransformIdentity;
            [self.activityIndicatorView startAnimating];
            [UIView animateWithDuration:0.25 animations:^{
                // 增加滚动区域
                CGFloat top = self.scrollViewOriginalInset.top + self.beginPullHeight;
                UIEdgeInsets contentInsets = self.scrollView.contentInset;
//                self.scrollView.mj_insetT = top;
                contentInsets.top = top;
                self.scrollView.contentInset = contentInsets;
                
//                // 设置滚动位置
                CGPoint contentOffset = self.scrollView.contentOffset;
                contentOffset.y = -top;
                self.scrollView.contentOffset = contentOffset;
                
            } completion:^(BOOL finished) {
                if (self.loadingBlock) {
                    self.loadingBlock();
                }else{
                    [self endLoading];
                }
            }];
        }
            break;
        case UMNomalStatus:
        {
            [self resetSubViewWhenLoadFinsh];
            if (self.indicateImageView.superview != self) {
                [self.indicateImageView removeFromSuperview];
                [self addSubview:self.indicateImageView];
            }
        }
            break;
            case UMNoMoredStatus:
        {
            [self resetSubViewWhenLoadFinsh];
            [self.indicateImageView removeFromSuperview];
        }
            break;
        default:
            break;
    }
}

- (void)resetSubViewWhenLoadFinsh
{
    [UIView animateWithDuration:0.4 animations:^{
        UIEdgeInsets edgeInset = self.scrollView.contentInset;
        edgeInset.top = self.scrollViewOriginalInset.top;
        self.scrollView.contentInset = edgeInset;
    } completion:^(BOOL finished) {
        self.pullingPercent = 0.0;
    }];
    [self.activityIndicatorView stopAnimating];
    self.indicateImageView.transform = CGAffineTransformIdentity;
}

@end



@interface UMComFootView ()

@end

@implementation UMComFootView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.hidden = YES;
        UIImage *downImage = UMComImageWithImageName(@"grayArrow1");
        self.indicateImageView.image = [self image:downImage rotation:UIImageOrientationDown];;
        self.noticeForLoadStatusBlock = ^(UMLoadStatus loadStatus){
            switch (loadStatus) {
                case UMNomalStatus:
                    return @"加载完成";
                    break;
                case UMPullingStatus:
                    return @"上拉可以加载更多";
                    break;
                case UMPreLoadStatus:
                    return @"松手即可加载更多";
                    break;
                case UMLoadingStatus:
                    return @"正在加载";
                    break;
                case UMNoMoredStatus:
                    return @"已经是最后一页数据了";
                    break;
                default:
                    break;
            }
        };
    }
    return self;
}

- (void)resetSubViews
{
    [super resetSubViews];
    CGRect frame = self.frame;
    frame.origin.y = self.scrollViewOriginalInset.bottom + self.scrollView.contentSize.height;
    self.frame = frame;
    [self.dateLable removeFromSuperview];;
    self.statusLable.frame = CGRectMake(60, 0, self.frame.size.width-120, self.frame.size.height);
    self.activityIndicatorView.frame = CGRectMake(10, (self.frame.size.height - 40)/2, 40, 40);
    self.indicateImageView.frame= CGRectMake(20,(self.frame.size.height - 35)/2, 15, 35);
}

- (void)scrollViewDidChangeOffset:(NSDictionary *)change
{
    if (self.scrollView.contentInset.top + self.scrollView.contentSize.height > self.scrollView.frame.size.height) {
        if (self.hidden) {
            self.hidden = NO;
        }
    }else if(self.hidden == NO){
        self.hidden = YES;
        return;
    }
    if (self.scrollView.contentOffset.y <= 0) {
        return;
    }
    if (self.loadStatus == UMLoadingStatus) {
        return;
    }
    if (self.loadStatus == UMNoMoredStatus) {
        return;
    }
    if (self.scrollView.isDragging) {
        if ( self.frame.origin.y == 0) return;
        //上拉加载
        if ([self isBeginScrollBottom:self.scrollView] && ![self isScrollToBottom:self.scrollView] && self.loadStatus != UMLoadingStatus) {
            if (self.loadStatus == UMNomalStatus) {
                self.loadStatus = UMPullingStatus;
            }else if(self.loadStatus == UMPreLoadStatus){
                
                self.loadStatus = UMNomalStatus;
            }
        }else if ([self isScrollToBottom:self.scrollView] && self.loadStatus == UMPullingStatus){
            self.loadStatus = UMPreLoadStatus;
        }
//        else if ([self isBeginScrollBottom:self.scrollView] && self.loadStatus == UMPreLoadStatus){
//            self.indicateImageView.transform = CGAffineTransformIdentity;
//
//        }

    }else{
        if (self.loadStatus == UMPreLoadStatus){
            [self setLoadStatus:UMLoadingStatus];
        }
    }
}
- (BOOL)isBeginScrollBottom:(UIScrollView *)scrollView
{
    if (scrollView.contentOffset.y>0 && (scrollView.contentSize.height <scrollView.contentOffset.y +scrollView.bounds.size.height-scrollView.contentInset.bottom)) {
        return YES;
    }else{
        return NO;
    }
}

- (BOOL)isScrollToBottom:(UIScrollView *)scrollView
{
    if (scrollView.contentOffset.y>0 && (scrollView.contentSize.height< scrollView.contentOffset.y +scrollView.bounds.size.height -scrollView.contentInset.bottom - self.beginPullHeight)) {
        return YES;
    }else{
        return NO;
    }
}


- (void)scrollViewDidChangeContentSize:(NSDictionary *)change
{
    CGRect frame = self.frame;
    frame.origin.y = self.scrollView.contentSize.height;
    self.frame = frame;
}

- (void)setLoadStatus:(UMLoadStatus)loadStatus
{
    if (self.loadStatus == loadStatus) {
        return;
    }
    [super setLoadStatus:loadStatus];
    switch (loadStatus) {
        case UMPullingStatus:
        {
            if (self.indicateImageView.superview != self) {
                [self.indicateImageView removeFromSuperview];
                [self addSubview:self.indicateImageView];
            }
        }
            break;
        case UMPreLoadStatus:
        {
            [self setRotation:2 animated:YES];
        }
            break;
        case UMLoadingStatus:
        {
            [self.indicateImageView removeFromSuperview];
            self.indicateImageView.transform = CGAffineTransformIdentity;
            [self.activityIndicatorView startAnimating];
            [UIView animateWithDuration:0.25 animations:^{
                // 增加滚动区域
                CGFloat bottom = self.scrollViewOriginalInset.bottom + self.beginPullHeight;
                UIEdgeInsets contentInsets = self.scrollView.contentInset;
                //                self.scrollView.mj_insetT = top;
                contentInsets.bottom = bottom;
                self.scrollView.contentInset = contentInsets;
                
//                //                // 设置滚动位置
//                CGPoint contentOffset = self.scrollView.contentOffset;
//                contentOffset.y = -top;
//                self.scrollView.contentOffset = contentOffset;
                
            } completion:^(BOOL finished) {
                
                if (self.loadingBlock) {
                    self.loadingBlock();
                }else{
                    [self endLoading];
                }
            }];
        }
            break;
        case UMNomalStatus:
        {
            [self resetSubViewWhenLoadFinsh];
            if (self.indicateImageView.superview != self) {
                [self addSubview:self.indicateImageView];
            }
        }
            case UMNoMoredStatus:
        {
            [self resetSubViewWhenLoadFinsh];

            [self.indicateImageView removeFromSuperview];
        }
            break;
        default:
            break;
    }
}


- (void)resetSubViewWhenLoadFinsh
{
    self.indicateImageView.transform = CGAffineTransformIdentity;
    [self.activityIndicatorView stopAnimating];
    [UIView animateWithDuration:0.4 animations:^{
        UIEdgeInsets edgeInset = self.scrollView.contentInset;
        edgeInset.bottom = self.scrollViewOriginalInset.bottom;
        self.scrollView.contentInset = edgeInset;
    } completion:^(BOOL finished) {
        self.pullingPercent = 0.0;
    }];
}

@end



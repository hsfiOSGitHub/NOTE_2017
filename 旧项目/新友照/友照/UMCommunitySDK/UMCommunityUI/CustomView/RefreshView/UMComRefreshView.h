//
//  RefreshTableView.h
//  DJXRefresh
//
//  Created by Founderbn on 14-7-18.
//  Copyright (c) 2014年 Umeng 董剑雄. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum{
    UMNomalStatus = 0,//正常状态
    UMPullingStatus = 1,//拉动状态
    UMPreLoadStatus = 2,//达到松手即可加载的状态
    UMLoadingStatus = 3,//正在加载状态
    UMNoMoredStatus = 4,//已是最后一页的状态
} UMLoadStatus;

@class UMComRefreshView;

@interface UMComRefreshView : UIView

@property (nonatomic,retain) UILabel *dateLable;//显示上次刷新时间

@property (nonatomic,retain) UILabel *statusLable;//显示状态信息

@property (nonatomic,retain) UIImageView *indicateImageView;//显示图片箭头图片

@property (nonatomic,retain) UIActivityIndicatorView *activityIndicatorView;//透明指示器

@property (nonatomic,assign) UMLoadStatus  loadStatus;

@property (nonatomic, strong) UIScrollView *scrollView;

@property (nonatomic,assign) CGFloat beginPullHeight;/*达到松手即可刷新的高度 默认为65.0f*/

@property (nonatomic, assign) UIEdgeInsets scrollViewOriginalInset;

@property (nonatomic, assign) CGFloat pullingPercent;

@property (nonatomic, copy) NSString * (^noticeForLoadStatusBlock)(UMLoadStatus loadStatus);

@property (nonatomic, copy) void(^loadingBlock)();

+ (UMComRefreshView *)refreshControllViewWithScrollView:(UIScrollView *)scrollView block:(void(^)())block;

- (NSString *)noticeForLoadStatus:(UMLoadStatus)loadStatus;


- (void)endLoading;
- (void)noMoreData;

- (void)resetSubViews;

- (void)scrollViewDidChangeOffset:(NSDictionary *)change;

- (void)setRotation:(NSInteger)rotation animated:(BOOL)animated;


@end

@interface UMComHeadView : UMComRefreshView

@end

@interface UMComFootView : UMComRefreshView

@property (nonatomic, assign) BOOL haveNextPage;

@end

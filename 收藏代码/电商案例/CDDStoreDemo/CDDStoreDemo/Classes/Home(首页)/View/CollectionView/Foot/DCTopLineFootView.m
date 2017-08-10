//
//  DCTopLineFootView.m
//  CDDMall
//
//  Created by apple on 2017/6/5.
//  Copyright © 2017年 RocketsChen. All rights reserved.
//

#import "DCTopLineFootView.h"

// Controllers

// Models

// Views
#import "DCNumericalScrollView.h"
// Vendors

// Categories

// Others

@interface DCTopLineFootView ()<UIScrollViewDelegate,NoticeViewDelegate>

/* 滚动 */
@property (strong , nonatomic)DCNumericalScrollView *numericalScrollView;
/* 底部 */
@property (strong , nonatomic)UIView *bottomLineView;

@end

@implementation DCTopLineFootView

#pragma mark - Intial
- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        
        [self setUpUI];
        
        [self setUpBase];
        
    }
    return self;
}

- (void)setUpUI
{
    NSArray *titles = @[@"CDDMall首单新人礼~",
                       @"github你值得拥有，欢迎点赞~",
                       @"项目持续更新中~"];
    NSArray *btnts = @[@"新人礼",
                       @"github",
                       @"点赞"];
    //初始化
    _numericalScrollView = [[DCNumericalScrollView alloc]initWithFrame:CGRectMake(0, 0, self.dc_width, self.dc_height) andImage:@"shouye_img_toutiao" andDataTArray:titles WithDataIArray:btnts];
    _numericalScrollView.delegate = self;
    //设置定时器多久循环
    _numericalScrollView.interval = 5;
    [self addSubview:_numericalScrollView];
    //开始循环
    [_numericalScrollView startTimer];
    
    _bottomLineView = [[UIView alloc] init];
    _bottomLineView.backgroundColor = DCBGColor;
    [self addSubview:_bottomLineView];
    _bottomLineView.frame = CGRectMake(0, self.dc_height - 8, ScreenW, 8);
}

- (void)setUpBase
{
    self.backgroundColor = [UIColor whiteColor];
    
}

#pragma mark - Setter Getter Methods

#pragma mark - 滚动条点击事件
- (void)noticeViewSelectNoticeActionAtIndex:(NSInteger)index{
    NSLog(@"点击了第%zd头条滚动条",index);
}

@end

//
//  ViewController.m
//  ProgressLine
//
//  Created by lujh on 2017/6/5.
//  Copyright © 2017年 lujh. All rights reserved.
//

#import "ViewController.h"
#import "ProgressView.h"

@interface ViewController ()<sequenceViewDelegate>
// 标题数组
@property (nonatomic, copy) NSArray *titleArray;
// 内容数组
@property (nonatomic, copy) NSArray *contentArray;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initVar];
    
    // 初始化SubViews
    [self setupSubViews];
}

- (void)initVar{

    self.title = @"物流公司";
    
    self.titleArray = @[@"顺丰物流",@"韵达快递",@"邮政物流",@"菜鸟物流",@"申通快递",@"圆通快递",@"中通快递",@"京东快递",@"德邦物流",@"天天快递"];
    self.contentArray = @[@"大牛之后是大神,大牛之后是大神",@"有一种爱叫放弃,有一种爱叫放弃,有一种爱叫放弃,有一种爱叫放弃,有一种爱叫放弃,有一种爱叫放弃",@"我不知道什么叫累,只知道死扛,我不知道什么叫累,只知道死扛,我不知道什么叫累,只知道死扛,我不知道什么叫累,只知道死扛,我不知道什么叫累,只知道死扛,我不知道什么叫累,只知道死扛",@"苍老师怎么样,苍老师怎么样,苍老师怎么样,苍老师怎么样,苍老师怎么样,苍老师怎么样,苍老师怎么样,苍老师怎么样,苍老师怎么样,苍老师怎么样,苍老师怎么样",@"大牛之后是大神,大牛之后是大神,大牛之后是大神,大牛之后是大神,大牛之后是大神,大牛之后是大神,大牛之后是大神,大牛之后是大神,大牛之后是大神",@"我不知道什么叫累,只知道死扛,我不知道什么叫累,只知道死扛,我不知道什么叫累,只知道死扛,我不知道什么叫累,只知道死扛,我不知道什么叫累,只知道死扛,我不知道什么叫累,只知道死扛",@"大牛之后是大神,大牛之后是大神",@"我不知道什么叫累,只知道死扛,我不知道什么叫累,只知道死扛,我不知道什么叫累,只知道死扛,我不知道什么叫累,只知道死扛,我不知道什么叫累,只知道死扛,我不知道什么叫累,只知道死扛",@"我不知道什么叫累,只知道死扛,我不知道什么叫累,只知道死扛,我不知道什么叫累,只知道死扛,我不知道什么叫累,只知道死扛,我不知道什么叫累,只知道死扛,我不知道什么叫累,只知道死扛",@"有一种爱叫放弃,有一种爱叫放弃,有一种爱叫放弃,有一种爱叫放弃,有一种爱叫放弃,有一种爱叫放弃"];
}

#pragma mark -初始化SubViews

- (void)setupSubViews {

    // UIScrollView
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:scrollView];
    
    // ProgressView
    ProgressView *sequence = [[ProgressView alloc] initWithFrame:self.view.bounds];
    [sequence sequenceWith:self.titleArray contentArr:self.contentArray uiscrollview:scrollView ];
    sequence.delegate = self;
    [scrollView addSubview:sequence];
    
}

#pragma mark -sequenceViewDelegate

- (void)sequenceViewWithSequenceView:(ProgressView *)sequenceView sequenceBtn:(UIButton *)sequenceBtn {
    
    NSLog(@"%ld",sequenceBtn.tag);
}


@end

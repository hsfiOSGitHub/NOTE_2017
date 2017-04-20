//
//  yin_dao_ye_ViewController.m
//  云糖医
//
//  Created by ZX on 16/10/28.
//  Copyright © 2016年 yuntangyi. All rights reserved.
//

//tabBar
#import "tab_ViewController.h"

#import "yin_dao_ye_ViewController.h"

@interface yin_dao_ye_ViewController ()<UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *scr;
@property (weak, nonatomic) IBOutlet UIPageControl *pag;
@property (weak, nonatomic) IBOutlet UILabel *banben;

@end

@implementation yin_dao_ye_ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _scr.delegate=self;
    _scr.pagingEnabled=YES;
    _scr.showsVerticalScrollIndicator = NO;
    _scr.showsHorizontalScrollIndicator = NO;
    _pag.numberOfPages = 4;
    _pag.currentPage = 0;
    [_pag addTarget:self action:@selector(pageTurn) forControlEvents:UIControlEventValueChanged];
    _banben.text=[NSString stringWithFormat:@"立即体验"];
}

-(void)pageTurn
{
    _scr.contentOffset=CGPointMake(KScreenWidth* _pag.currentPage, 0);
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    int index = fabs(scrollView.contentOffset.x) / scrollView.frame.size.width;
    _pag.currentPage = index;
}

- (IBAction)zhuye:(UIButton *)sender {
    tab_ViewController *tab  = [[tab_ViewController alloc] init];
    [[UIApplication sharedApplication].delegate window].rootViewController=tab;
    [[[UIApplication sharedApplication].delegate window] makeKeyAndVisible];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}



@end

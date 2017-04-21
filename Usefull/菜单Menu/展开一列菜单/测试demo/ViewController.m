//
//  ViewController.m
//  测试demo
//
//  Created by mac on 2016/12/3.
//  Copyright © 2016年 mac. All rights reserved.
//

#import "ViewController.h"
#import "GBPopMenuButtonView.h"



#define GBScreenH [UIScreen mainScreen].bounds.size.height
#define GBScreenW [UIScreen mainScreen].bounds.size.width


@interface ViewController ()<GBMenuButtonDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self testScrollMenuView];
    
   
    
}

#pragma mark -- 测试 GBTopScrollMenuView
- (void)testScrollMenuView{
    GBPopMenuButtonView *view = [[GBPopMenuButtonView alloc] initWithItems:@[@"camera",@"draw",@"dropbox",@"gallery"] size:CGSizeMake(50, 50) type:GBMenuButtonTypeLineBottom isMove:YES];
    
    view.frame = CGRectMake(200, 300, 50, 50);
    [self.view addSubview:view];
    view.delegate = self;
    
   
}
-(void)menuButtonSelectedAtIdex:(NSInteger)index{
    NSLog(@"点击了--> %ld",index);
}


@end

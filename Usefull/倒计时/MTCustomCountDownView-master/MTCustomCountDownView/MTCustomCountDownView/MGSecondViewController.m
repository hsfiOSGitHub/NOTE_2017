//
//  MGSecondViewController.m
//  MTCustomCountDownView
//
//  Created by acmeway on 2017/5/18.
//  Copyright © 2017年 acmeway. All rights reserved.
//

#import "MGSecondViewController.h"
#import "MGCustomCountDown.h"
@interface MGSecondViewController ()<MGCustomCountDownDelagete>

@property (nonatomic, strong)MGCustomCountDown *downView;

@end

@implementation MGSecondViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [[UIApplication sharedApplication].keyWindow addSubview:self.downView];
    
    [_downView addTimerForAnimationDownView];
    
    self.view.backgroundColor = [UIColor colorWithRed:0.51f green:0.82f blue:0.27f alpha:1.00f];
    
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"返回"
                                                                             style:UIBarButtonItemStylePlain
                                                                            target:self
                                                                            action:@selector(back)];
    
}

- (void)customCountDown:(MGCustomCountDown *)downView
{
    NSLog(@"执行完成");
}

- (void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (MGCustomCountDown *)downView
{
    if (!_downView) {
        _downView =  [MGCustomCountDown downView];
        _downView.delegate = self;
        _downView.frame = [UIScreen mainScreen].bounds;
        _downView.backgroundColor = [UIColor colorWithRed:0.11f green:0.61f blue:0.81f alpha:1.00f];
    }
    return _downView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

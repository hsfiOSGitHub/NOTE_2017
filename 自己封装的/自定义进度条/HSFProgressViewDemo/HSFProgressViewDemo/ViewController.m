//
//  ViewController.m
//  HSFProgressViewDemo
//
//  Created by JuZhenBaoiMac on 2017/7/12.
//  Copyright © 2017年 JuZhenBaoiMac. All rights reserved.
//

#import "ViewController.h"

#import "HSFProgressView.h"

@interface ViewController ()

@property (nonatomic,strong) HSFProgressView *progressView;

@property (weak, nonatomic) IBOutlet UILabel *progressLabel;
@property (weak, nonatomic) IBOutlet UISlider *slider;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.progressView = [[HSFProgressView alloc]initWithFrame:CGRectMake(10, 100, 200, 100)];
    self.progressView.progressViewHeight = 10;
    self.progressView.minColor = [[UIColor redColor] colorWithAlphaComponent:1.0];
    self.progressView.maxColor = [UIColor lightGrayColor];
    self.progressView.backgroundColor = [UIColor orangeColor];
    self.progressView.center = CGPointMake(self.view.frame.size.width/2, self.progressView.center.y);
    [self.progressView setUp];//在设置完属性后必须setUp
    [self.progressView setCorner];
    [self.view addSubview:self.progressView];
    
    
    /* 添加dot */
    
    UIView *dot1 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 20, 20)];
    [self.progressView addView:dot1 atProgress:0.20];
    
    UIImageView *dot2 = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 30, 30)];
    dot2.image = [UIImage imageNamed:@"fun"];
    [self.progressView addView:dot2 atProgress:0.50];
    
    UILabel *dot3 = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 50, 30)];
    dot3.text = @"hello";
    dot3.textColor = [UIColor blackColor];
    dot3.textAlignment = NSTextAlignmentCenter;
    dot3.font = [UIFont systemFontOfSize:12];
    [self.progressView addView:dot3 atProgress:0.80];
    
    
    
    self.progressView.progress = 0.50;
    self.progressLabel.text = @"0.50";
    self.slider.value = 0.50;
    
}

- (IBAction)sliderACTION:(UISlider *)sender {
    self.progressView.progress = sender.value;
    self.progressLabel.text = [NSString stringWithFormat:@"%.2f",sender.value];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

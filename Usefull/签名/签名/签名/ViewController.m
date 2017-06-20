//
//  ViewController.m
//  签名
//
//  Created by sammy on 2017/6/7.
//  Copyright © 2017年 sammy. All rights reserved.
//

#import "ViewController.h"
#import "MYDrawView.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet MYDrawView *drwaView;
@property (weak, nonatomic) IBOutlet UIImageView *Imv;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    
    
}


#pragma mark________________生成图片
- (IBAction)btnAction:(UIButton *)sender {
    
    UIImage *image = [self imageWithUIView:self.drwaView];
    _Imv.image = image;
    
}

- (IBAction)clearAction:(UIButton *)sender {
    
    [self.drwaView clear];
    
    
}


- (UIImage*) imageWithUIView:(UIView*) view

{
    
    UIGraphicsBeginImageContext(view.bounds.size);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    [view.layer renderInContext:context];
    
    UIImage* tImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return tImage;
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

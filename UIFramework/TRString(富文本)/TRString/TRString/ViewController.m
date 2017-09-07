//
//  ViewController.m
//  TRString
//
//  Created by cry on 2017/7/20.
//  Copyright © 2017年 eGova. All rights reserved.
//

#import "ViewController.h"
#import "TRStringMaker.h"

@interface ViewController ()

@property (nonatomic, strong) UITextView *textView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self setUpTextView];
    
    NSString *str = @"hello";
    NSInteger intV = 10086;
    CGFloat floatV = 3.14;
    NSNull *null = [NSNull null];
    CGRect rect = CGRectMake(0, 0, 10, 10);
    
    
    _textView.attributedText = TRStringMaker
    .string(str).color([UIColor redColor]).fontSize(16)
    .append(floatV).color([UIColor greenColor]).fontSize(22).ln()
    .append(nil).color([UIColor purpleColor]).fontSize(30).ln()
    .append(rect).color([UIColor brownColor]).fontSize(36).ln()
    .append(null).color([UIColor whiteColor]).font(@"GillSans-Light", 42).ln()
    .append(intV).color([UIColor whiteColor]).fontSize(23).ln()
    .append(1.2).color([UIColor whiteColor]).fontSize(50).ln()
    .null(@"-ERROR-")
    .toAttributedString;
}

- (void)setUpTextView{
    
    _textView = [[UITextView alloc] initWithFrame:CGRectMake(0, 22, 375, 600)];
    _textView.textColor = [UIColor whiteColor];
    _textView.backgroundColor = [UIColor colorWithRed:0.1 green:0.1 blue:0.1 alpha:1];
    [self.view addSubview:_textView];
    self.view.backgroundColor = [UIColor colorWithRed:0.1 green:0.1 blue:0.1 alpha:1];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

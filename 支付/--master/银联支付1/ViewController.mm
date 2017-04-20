//
//  ViewController.m
//  银联支付1
//
//  Created by syq on 16/3/13.
//  Copyright © 2016年 lanou.syq. All rights reserved.
//

#import "ViewController.h"
#import "UPPaymentControl.h"
@interface ViewController ()

@end

@implementation ViewController
- (IBAction)upPay:(id)sender {
//   BOOL ifInstallUp = [[UPPaymentControl defaultControl] isPaymentAppInstalled];
//    if (ifInstallUp) {
//        NSLog(@"install the UP");
//    }else{
//        NSLog(@"not install the UP");
//    }
    /**
     *  支付接口
     *
     *  @param tn             订单信息
     *  @param schemeStr      调用支付的app注册在info.plist中的scheme
     *  @param mode           支付环境
     *  @param viewController 启动支付控件的viewController
     *  @return 返回成功失败
     */

    BOOL ifResult = [[UPPaymentControl defaultControl] startPay:@"201603131105018491158" fromScheme:@"shenyingqianghaha" mode:@"00" viewController:self];
    if (ifResult) {
        NSLog(@"吊起银联成功");
    }else{
        NSLog(@"吊起银联失败");
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

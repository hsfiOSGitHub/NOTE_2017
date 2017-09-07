//
//  ViewController.m
//  HWAdAlertView
//
//  Created by Lee on 2017/4/25.
//  Copyright © 2017年 cashpie. All rights reserved.
//

#import "ViewController.h"
#import "HWAdAlretView.h"
#import "HWAdAlterModel.h"
#import "HWAdWebViewController.h"

@interface ViewController ()<HWAdAlertViewDelegate>

@property(nonatomic,strong) NSMutableArray *imgArr;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.imgArr = [self setImgArr];
    
    UIButton * showBtn        = [UIButton buttonWithType:UIButtonTypeCustom];
    showBtn.center = self.view.center;
    showBtn.bounds = CGRectMake(0, 0, 100, 60);
    [showBtn setTitle:@"tap" forState:UIControlStateNormal];
    [showBtn setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    [showBtn addTarget:self action:@selector(showAdAlertView) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:showBtn];
    
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)showAdAlertView{

    [HWAdAlretView showInView:self.view delegate:self adDataArray:self.imgArr];
}

-(NSMutableArray *)setImgArr{
    NSMutableArray *arr = [[NSMutableArray alloc]initWithCapacity:0];
//    for (int i = 1; i<=2; i++) {
        HWAdAlterModel *adModel  = [[HWAdAlterModel alloc]init];
        adModel.imgurl      = [NSString stringWithFormat:@"welcome_1"];
        adModel.linkurl     = @"https://www.apple.cn";
        [arr addObject:adModel];
//    }
    
    return arr;
}

- (void)alertViewClickedIndex:(NSInteger)index{
    HWAdAlterModel * alertModel = self.imgArr[index];
    HWAdWebViewController * webView = [[HWAdWebViewController alloc]init];
    webView.linkUrl = alertModel.linkurl;
    [self presentViewController:webView animated:YES completion:nil];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

//
//  erWeiMaVC.m
//  ZXJiaXiao
//
//  Created by yujian on 16/4/21.
//  Copyright © 2016年 ZX. All rights reserved.
//

#import "erWeiMaVC.h"
#import "UIImage+LXDCreateBarcode.h"

@interface erWeiMaVC ()

@end

@implementation erWeiMaVC
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}
- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.title = @"我的二维码";
    self.view.backgroundColor = [UIColor whiteColor];
    
    //通过电话号生成二维码（phoneNum）
    UIImage *i= [UIImage imageOfQRFromURL:[ZXUD objectForKey:@"phoneNum"]];
//    UIImage *i= [UIImage imageOfQRFromURL:@"https://itunes.apple.com/WebObjects/MZStore.woa/wa/viewSoftware?id=300136119&mt=8"];

    UIImageView *iv = [[UIImageView alloc] initWithImage:i];
    [iv setFrame:CGRectMake((KScreenWidth - 150) * 0.5, (KScreenHeight - 150) * 0.5, 150, 150)];
    [self.view addSubview:iv];
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake((KScreenWidth - 150) * 0.5, (KScreenHeight - 150) * 0.5 + 160, 150, 30)];
    label.text = @"扫上方二维码加好友";
    label.font = [UIFont systemFontOfSize:14];
    label.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:label];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
   
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

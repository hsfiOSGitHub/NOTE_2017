//
//  HSFQRCodeScanningVC.m
//  HSFKitDemo
//
//  Created by JuZhenBaoiMac on 2017/8/10.
//  Copyright © 2017年 JuZhenBaoiMac. All rights reserved.
//

#import "HSFQRCodeScanningVC.h"

#import "HSFQRCodeSuccessVC.h"

@interface HSFQRCodeScanningVC ()

@end

@implementation HSFQRCodeScanningVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // 注册观察者
    [SGQRCodeNotificationCenter addObserver:self selector:@selector(SGQRCodeInformationFromeAibum:) name:SGQRCodeInformationFromeAibum object:nil];
    [SGQRCodeNotificationCenter addObserver:self selector:@selector(SGQRCodeInformationFromeScanning:) name:SGQRCodeInformationFromeScanning object:nil];
    
    
}



- (void)SGQRCodeInformationFromeAibum:(NSNotification *)noti {
    NSString *string = noti.object;
    
    HSFQRCodeSuccessVC *jumpVC = [[HSFQRCodeSuccessVC alloc] init];
    jumpVC.jump_URL = string;
    [self.navigationController pushViewController:jumpVC animated:YES];
}

- (void)SGQRCodeInformationFromeScanning:(NSNotification *)noti {
    SGQRCodeLog(@"noti - - %@", noti);
    NSString *string = noti.object;
    
    if ([string hasPrefix:kRequestHeaderUrl]) {
        
        
        
    } else { // 扫描结果为条形码
        HSFQRCodeSuccessVC *jumpVC = [[HSFQRCodeSuccessVC alloc] init];
        jumpVC.jump_bar_code = string;
        [self.navigationController pushViewController:jumpVC animated:YES];
    }
}

- (void)dealloc {
    SGQRCodeLog(@"QRCodeScanningVC - dealloc");
    [SGQRCodeNotificationCenter removeObserver:self];
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

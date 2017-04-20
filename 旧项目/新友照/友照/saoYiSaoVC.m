//
//  saoYiSaoVC.m
//  云糖医
//
//  Created by yuntangyi on 16/9/12.
//  Copyright © 2016年 yuntangyi. All rights reserved.
//

#import "saoYiSaoVC.h"
#import "ZHScanView.h"

@interface saoYiSaoVC ()

@property (nonatomic, copy) NSString *randStr;
@property(nonatomic,strong) ZHScanView *scanf;

@end

@implementation saoYiSaoVC

-(void)viewWillAppear:(BOOL)animated
{
   
    _scanf = [ZHScanView scanViewWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
    _scanf.promptMessage = @"将二维码放入框内, 即可自动扫描";
    [self.view addSubview:_scanf];
    [_scanf startScaning];

    [_scanf outPutResult:^(NSString *result)
    {
     
    // 二维码扫描成功，返回
     [[NSNotificationCenter defaultCenter] postNotificationName:@"result" object:result];
        
        _randStr = result;
        [self saoYiSaoData];
     }];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"扫描二维码";
}

-(void)viewDidDisappear:(BOOL)animated
{
     [_scanf removeFromSuperview];
}

- (void)saoYiSaoData
{
    if (![ZXUD boolForKey:@"NetDataState"])
    {
        [MBProgressHUD showSuccess:@"网络不好，请稍后重试"];
        [self.navigationController popViewControllerAnimated:YES];
    }
    else
    {
        [[ZXNetDataManager manager] saoYiSaoDataWithRndStrng:[ZXDriveGOHelper getCurrentTimeStamp] andRand_str:_randStr andIdent_code:[ZXUD objectForKey:@"ident_code"] success:^(NSURLSessionDataTask *task, id responseObject)
        {
            NSError *err;
            NSString *receiveStr = [[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
            NSString *jsonString = [receiveStr stringByReplacingOccurrencesOfString:@"\r" withString:@""];
            jsonString = [jsonString stringByReplacingOccurrencesOfString:@"\n" withString:@""];
            jsonString = [jsonString stringByReplacingOccurrencesOfString:@"\t" withString:@""];
            jsonString = [jsonString stringByReplacingOccurrencesOfString:@"\v" withString:@""];
            jsonString = [jsonString stringByReplacingOccurrencesOfString:@"\f" withString:@""];
            jsonString = [jsonString stringByReplacingOccurrencesOfString:@"\b" withString:@""];
            jsonString = [jsonString stringByReplacingOccurrencesOfString:@"\a" withString:@""];
            jsonString = [jsonString stringByReplacingOccurrencesOfString:@"\e" withString:@""];
            NSData * data = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
            NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&err];
            if(err)
            {
                NSLog(@"json解析失败：%@",err);
            }
            [MBProgressHUD hideHUD];
            if([[ZXwangLuoDanLi WangLuoDanLi] resIsTrue:jsonDict andAlertView:self])
            {
                [MBProgressHUD showSuccess:jsonDict[@"msg"]];
                [self.navigationController popViewControllerAnimated:YES];
            }

        } failed:^(NSURLSessionTask *task, NSError *error)
        {
            [MBProgressHUD showSuccess:@"网络不好，请稍后重试"];
            [self.navigationController popViewControllerAnimated:YES];
        }];
    }
}
- (void)didReceiveMemoryWarning
{
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

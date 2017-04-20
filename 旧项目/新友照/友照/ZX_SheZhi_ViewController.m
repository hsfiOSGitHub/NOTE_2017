//
//  ZX_SheZhi_ViewController.m
//  友照
//
//  Created by cleloyang on 2016/12/1.
//  Copyright © 2016年 ZX_XPH. All rights reserved.
//

#import "ZX_SheZhi_ViewController.h"
#import "ZXGuanYuViewController.h"
#import "ZX_YiJianFanKui_ViewController.h"
#import "ZX_FuWuTiaoKuan_ViewController.h"

@interface ZX_SheZhi_ViewController ()

@end

@implementation ZX_SheZhi_ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"系统设置";
    [_yiJianFanKuiBtn addTarget:self action:@selector(yiJianFanKui) forControlEvents:UIControlEventTouchDown];
    [_guanYuWoMenBtn addTarget:self action:@selector(guanYuWoMen) forControlEvents:UIControlEventTouchDown];
    [_fuWuTiaoKuanBtn addTarget:self action:@selector(fuWuTiaoKuan) forControlEvents:UIControlEventTouchDown];
    [_qingChuHuanCunBtn addTarget:self action:@selector(qingChuHuanCun) forControlEvents:UIControlEventTouchDown];
    [_tuiChuZhangHuBtn addTarget:self action:@selector(logout) forControlEvents:UIControlEventTouchDown];
    //获取当前设备中应用的版本号
    NSDictionary *infoDic = [[NSBundle mainBundle] infoDictionary];
    NSString *currentVersion = [infoDic objectForKey:@"CFBundleShortVersionString"];
    _dangQianBanBenLab.text = currentVersion;
    _dangQianBanBenLab.font = [UIFont systemFontOfSize:14];
    [self getHuanCun];
}

//跳转到意见反馈界面
- (void)yiJianFanKui
{
    ZX_YiJianFanKui_ViewController *yiJianFanKuiVC = [[ZX_YiJianFanKui_ViewController alloc]init];
    [self.navigationController pushViewController:yiJianFanKuiVC animated:YES];
}

//跳转到关于我们界面
- (void)guanYuWoMen
{
    ZXGuanYuViewController *vc = [[ZXGuanYuViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

//跳转到服务条款界面
- (void)fuWuTiaoKuan
{
    ZX_FuWuTiaoKuan_ViewController *fuWuTiaoKuanVC = [[ZX_FuWuTiaoKuan_ViewController alloc]init];
    [self.navigationController pushViewController:fuWuTiaoKuanVC animated:YES];
}

//获取缓存数据
- (void)getHuanCun
{
    //获取缓存数据
    CGFloat size = [[SDImageCache sharedImageCache] getSize];
    
    if (size > 0)
    {
        NSString *count = [NSString stringWithFormat:@"%0.2fM" , size / 1024 / 1024 ];
        _huanCunLab.text = count;
    }
    else
    {
        _huanCunLab.text =@"0.0M";
    }
}

//清除缓存
- (void)qingChuHuanCun
{
    float size = [[SDImageCache sharedImageCache] getSize]/1024.0/1024.0;
    NSString *strName;
    NSMutableAttributedString *messageStr;
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"清除缓存" message:strName preferredStyle:UIAlertControllerStyleAlert];
    
    if (size > 0)
    {
        strName = [NSString stringWithFormat:@"确定清除 %.2fMB 缓存吗？",size];
        messageStr = [[NSMutableAttributedString alloc] initWithString:strName];
        [messageStr addAttribute:NSForegroundColorAttributeName value:ZX_LightGray_Color range:NSMakeRange(0, strName.length)];
        [messageStr addAttribute:NSForegroundColorAttributeName value:hongse range:NSMakeRange(5,[NSString stringWithFormat:@"%.2fMB",size].length)];
    }
    else
    {
        strName = @"现在没有要清除的缓存";
        messageStr = [[NSMutableAttributedString alloc] initWithString:strName];
        [messageStr addAttribute:NSForegroundColorAttributeName value:ZX_LightGray_Color range:NSMakeRange(0, strName.length)];
    }
    
    
    [messageStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:15] range:NSMakeRange(0, strName.length)];
    [alert setValue:messageStr forKey:@"attributedMessage"];
    
    NSMutableAttributedString *titleStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"清除缓存"]];
    [titleStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:18] range:NSMakeRange(0, 4)];
    [titleStr addAttribute:NSForegroundColorAttributeName value:ZX_DarkGray_Color range:NSMakeRange(0, 4)];
    [alert setValue:titleStr forKey:@"attributedTitle"];
    
    UIAlertAction *confirm = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action)
                              {
                                  if (size > 0)
                                  {
                                      [[SDImageCache sharedImageCache] clearDisk];
                                      _huanCunLab.text =@"0.0M";
                                  }
                              }];
    [confirm setValue:dao_hang_lan_Color forKey:@"titleTextColor"];
    
    UIAlertAction *cancle = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action)
                             {
                             }];
    [cancle setValue:ZX_LightGray_Color forKey:@"titleTextColor"];
    [alert addAction:confirm];
    [alert addAction:cancle];
    [self presentViewController:alert animated:YES completion:nil];
}

//退出登录
- (void)logout
{
    if (![ZXUD boolForKey:@"IS_LOGIN"])
    {
        [MBProgressHUD showSuccess:@"您当前还没有登录"];
    }
    else
    {
        //用户退出登录操作（需要清除用户信息）
        [[ZXNetDataManager manager] logoutDataWithRndstring:[ZXDriveGOHelper getCurrentTimeStamp] andIdent_code:[ZXUD objectForKey:@"ident_code"] success:^(NSURLSessionDataTask *task, id responseObject)
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
             if([[ZXwangLuoDanLi WangLuoDanLi] resIsTrue:jsonDict andAlertView:self])
             {
                 [ZXUD setBool:NO forKey:@"IS_LOGIN"];
                 [self.navigationController popViewControllerAnimated:YES];
                  [ZXUD setBool:NO forKey:@"xx"];
                 //移除掉用户的数据
                 [ZXUD setObject:@"" forKey:@"username"];
                 [ZXUD setObject:@"" forKey:@"area"];
                 [ZXUD setObject:@"" forKey:@"userRealName"];
                 [ZXUD setObject:@"" forKey:@"T_ID"];
                 [ZXUD setObject:@"" forKey:@"S_ID"];
                 [ZXUD setObject:@"" forKey:@"S_NAME"];
                 [ZXUD setObject:@"" forKey:@"T_NAME"];
                 [ZXUD setObject:@"" forKey:@"usersubject"];
                 [ZXUD setObject:@"" forKey:@"id_card"];
                 [ZXUD setObject:@"" forKey:@"phoneNum"];
                 [ZXUD setObject:@"" forKey:@"userpic"];
                 [ZXUD setBool:@"" forKey:@"sex"];
                 
                 [ZXUD setObject:[NSMutableArray array] forKey:@"xiaoxi"];
                 [ZXUD setObject:[NSMutableArray array] forKey:@"xinxiaoxi"];

                 [ZXUD synchronize];
//                 退出友盟社区
                 [UMComLoginManager userLogout];
                 [MBProgressHUD showSuccess:@"退出成功"];
             }
         } failed:^(NSURLSessionTask *task, NSError *error)
         {
         }];
    }
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

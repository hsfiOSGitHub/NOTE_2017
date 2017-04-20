//
//  ZX_Login_ViewController.m
//  友照
//
//  Created by cleloyang on 2016/11/22.
//  Copyright © 2016年 ZX_XPH. All rights reserved.
//

#import "ZX_Login_ViewController.h"
#import "ZX_ZhuCe_ViewController.h"
#import "ZX_wangJiMiMa_ViewController.h"

#import <UMCommunitySDK/UMComDataRequestManager.h>
#import <UMComFoundation/UMComKit+Color.h>

@interface ZX_Login_ViewController ()<UIAlertViewDelegate>

@property (weak, nonatomic) IBOutlet UITextField *shouJiHaoTF;
@property (weak, nonatomic) IBOutlet UITextField *miMaTF;
@property (weak, nonatomic) IBOutlet UIButton *miMaXianShiBtn;
@property (weak, nonatomic) IBOutlet UIButton *wangJiMiMaBtn;
@property (weak, nonatomic) IBOutlet UIButton *dengLuBtn;

@end

@implementation ZX_Login_ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSFontAttributeName:[UIFont systemFontOfSize:20],NSForegroundColorAttributeName:[UIColor whiteColor]}];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"登录";
    self.navigationController.navigationBar.barTintColor = dao_hang_lan_Color;
    UIBarButtonItem *rightItem  =[[UIBarButtonItem alloc]initWithTitle:@"注册" style:UIBarButtonItemStylePlain target:self action:@selector(turnToZhuCeViewController)];
    rightItem.tintColor=[UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = rightItem;
    _dengLuBtn.layer.cornerRadius = 8;
    _dengLuBtn.layer.masksToBounds = YES;
    [_dengLuBtn addTarget:self action:@selector(turnToLogin) forControlEvents:UIControlEventTouchDown];
    [_wangJiMiMaBtn addTarget:self action:@selector(turnToWangJiMiMaViewController) forControlEvents:UIControlEventTouchDown];
    
    [_shouJiHaoTF addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    _shouJiHaoTF.tag = 100;
    [_miMaTF addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    _miMaTF.tag = 200;
    
    [_miMaXianShiBtn addTarget:self action:@selector(miMaXianShi) forControlEvents:UIControlEventTouchDown];
}

//密码隐藏和显示
- (void)miMaXianShi
{
    _miMaTF.secureTextEntry = !_miMaTF.secureTextEntry;
    if(_miMaTF.secureTextEntry)
    {
        [_miMaXianShiBtn setImage:[UIImage imageNamed:@"不显示密码"] forState:UIControlStateNormal];
    } else {
        [_miMaXianShiBtn setImage:[UIImage imageNamed:@"显示密码"] forState:UIControlStateNormal];
    }
}

//手机号和密码位数的限制
-(void)textFieldDidChange:(UITextField *)textField
{
    if (textField.tag == 100)
    {
        if (textField.text.length > 11)
        {
            textField.text = [textField.text substringWithRange:NSMakeRange(0,11)];
        }
    }
    else if (textField.tag == 200)
    {
        if (textField.text.length > 16)
        {
            textField.text=[textField.text substringWithRange:NSMakeRange(0,16)];
        }
    }
}


//开始登录
- (void)turnToLogin
{
    //判断网络状态
    if ([ZXUD boolForKey:@"NetDataState"])
    {
        //退出键盘
        [[UIApplication sharedApplication].keyWindow endEditing:YES];
        //检验电话号码
        if (_shouJiHaoTF.text.length != 11)
        {
            [MBProgressHUD showSuccess:@"请输入有效的手机号码"];
            return;
        }
        
        if ([_miMaTF.text isEqualToString:@""])
        {
            [MBProgressHUD showSuccess:@"密码不能为空"];
            return;
        }
        if (_miMaTF.text.length < 6 || _miMaTF.text.length > 16 )
        {
            [MBProgressHUD showSuccess:@"密码位数不对，请您重新输入。"];
            return;
        }
        
        [MBProgressHUD showMessage:@"正在登录..."];
        [[ZXNetDataManager manager] loginDataWithPhone:_shouJiHaoTF.text andPassword:[ZXDriveGOHelper getMD5StringWithString:_miMaTF.text] andRndstring:[ZXDriveGOHelper getCurrentTimeStamp] success:^(NSURLSessionDataTask *task, id responseObject)
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
             
             if(err) {
                 
                 NSLog(@"json解析失败：%@",err);
             }
             [MBProgressHUD hideHUD];
             //登录成功
             if([[ZXwangLuoDanLi WangLuoDanLi] resIsTrue:jsonDict andAlertView:self])
             {
                 [ZXUD setBool:YES forKey:@"IS_LOGIN"];
                 [ZXUD setObject:[jsonDict objectForKey:@"ident_code"] forKey:@"ident_code"];
                 [ZXUD setObject:_shouJiHaoTF.text forKey:@"phoneNum"];
                 [ZXUD synchronize];
                 [self chaKanXueYuanXinXiData];
            }
         }failed:^(NSURLSessionTask *task, NSError *error)
         {
             [MBProgressHUD hideHUD];
             [MBProgressHUD showSuccess:@"网络不好，请稍后重试。"];
         }];
    }
    else
    {
        [MBProgressHUD showSuccess:@"网络不好，请稍后重试。"];
    }
}

// 查看学员信息
- (void)chaKanXueYuanXinXiData
{
    [[ZXNetDataManager manager] chaKanXueYuanXinXiDataWithRndstring:[ZXDriveGOHelper getCurrentTimeStamp] andIdent_code:[ZXUD objectForKey:@"ident_code"] success:^(NSURLSessionDataTask *task, id responseObject)
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
             //保存用户的登录状态
             NSDictionary *dict = [jsonDict objectForKey:@"info"][0];
             //程序启动就判断用户的登录状态，保存用户的基本信息
             [ZXUD setObject:dict[@"nickname"] forKey:@"username"];
             [ZXUD setObject:dict[@"area"] forKey:@"area"];
             [ZXUD setObject:dict[@"name"] forKey:@"userRealName"];
             [ZXUD setObject:dict[@"tid"] forKey:@"T_ID"];
             [ZXUD setObject:dict[@"sid"] forKey:@"S_ID"];
             [ZXUD setObject:dict[@"school_name"] forKey:@"S_NAME"];
             [ZXUD setObject:dict[@"teacher_name"] forKey:@"T_NAME"];
             [ZXUD setObject:dict[@"subject"] forKey:@"usersubject"];
             [ZXUD setObject:dict[@"id_card"] forKey:@"id_card"];
             [ZXUD setObject:dict[@"phone"] forKey:@"phoneNum"];
             [ZXUD setObject:dict[@"pic"] forKey:@"userpic"];
             [ZXUD setBool:[dict[@"gender"] boolValue] forKey:@"sex"];
             [ZXUD synchronize];
            
             //友盟社区登录
             UMComLoginUser *userAccount = [[UMComLoginUser alloc] init];
            
             userAccount.userNameType=userNameNoRestrict;
             if ([dict[@"nickname"] length]>0)
             {
                 if ([dict[@"nickname"] isEqualToString:dict[@"phone"]])
                 {
                    userAccount.name=[NSString stringWithFormat:@"%@****%@",[dict[@"phone"] substringWithRange:NSMakeRange(0, 3)],[dict[@"phone"] substringWithRange:NSMakeRange(7, 4)]];
                 }
                 else
                 {
                     userAccount.name = dict[@"nickname"];
                 }
             }
             else
             {
                  userAccount.name=[NSString stringWithFormat:@"%@****%@",[dict[@"phone"] substringWithRange:NSMakeRange(0, 3)],[dict[@"phone"] substringWithRange:NSMakeRange(7, 4)]];
             }
             userAccount.updatedProfile=YES;
             userAccount.usid = [ZXUD objectForKey:@"phoneNum"];
             userAccount.icon_url = dict[@"pic"];
             if ([dict[@"gender"] isEqualToString:@"0"]) {
                 userAccount.gender = [NSNumber numberWithInt:1];//性别，0-女 1-男
             }else {
                 userAccount.gender = [NSNumber numberWithInt:0];//性别，0-女 1-男
             }
             
             [UMComLoginManager requestLoginWithLoginAccount:userAccount requestCompletion:^(NSDictionary *responseObject, NSError *error, dispatch_block_t callbackCompletion) {
                 if (error)
                 {
                 }
                 else
                 {

                 }
             }];
             [MBProgressHUD hideHUD];
             [MBProgressHUD showSuccess:@"登录成功"];
             [self.navigationController popViewControllerAnimated:YES];
         }
         else
         {
             [MBProgressHUD hideHUD];
             [ZXUD setBool:NO forKey:@"IS_LOGIN"];
         }
     }failed:^(NSURLSessionTask *task, NSError *error)
     {
         [MBProgressHUD hideHUD];
     }];
}

//跳转到注册控制器
- (void)turnToZhuCeViewController
{
    self.hidesBottomBarWhenPushed=YES;
    ZX_ZhuCe_ViewController *zhuCeVC =[[ZX_ZhuCe_ViewController alloc] init];
    [self.navigationController  pushViewController:zhuCeVC animated:YES];
}

//跳转到忘记密码控制器
- (void)turnToWangJiMiMaViewController
{
    self.hidesBottomBarWhenPushed = YES;
    ZX_wangJiMiMa_ViewController *wangJiMiMaVC =[[ZX_wangJiMiMa_ViewController alloc] init];
    [self.navigationController  pushViewController:wangJiMiMaVC animated:YES];
}

#pragma mark-UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (self.navigationController)
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
    else
    {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end

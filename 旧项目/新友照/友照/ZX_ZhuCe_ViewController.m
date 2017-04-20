//
//  ZX_ZhuCe_ViewController.m
//  友照
//
//  Created by cleloyang on 2016/11/22.
//  Copyright © 2016年 ZX_XPH. All rights reserved.
//

#import "ZX_ZhuCe_ViewController.h"
#import "ZX_FuWuTiaoKuan_ViewController.h"
#import "zhu_ye_ViewController.h"

@interface ZX_ZhuCe_ViewController ()<UIAlertViewDelegate,UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *shouJiHaoTF;
@property (weak, nonatomic) IBOutlet UITextField *yanZhengMaTF;
@property (weak, nonatomic) IBOutlet UITextField *miMaTF;
@property (weak, nonatomic) IBOutlet UITextField *yaoQingMaTF;
@property (weak, nonatomic) IBOutlet UIButton *yanZhengMaBtn;
@property (weak, nonatomic) IBOutlet UIButton *zhuCeBtn;
@property (weak, nonatomic) IBOutlet UIButton *tiaoKuanBtn;

/**定时器*/
@property (nonatomic ,weak)NSTimer* timer;

/**定时器倒计时*/
@property (nonatomic ,assign) NSInteger timerSecond;
@property (nonatomic ,copy) NSString *shoujihao;

@property (nonatomic) NSString* yanZhengType;

@end

@implementation ZX_ZhuCe_ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"注册";
    self.view.backgroundColor = [UIColor whiteColor];
    self.hidesBottomBarWhenPushed=YES;
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:@"注册就代表同意《智行》相关条款"];
    [str addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:121/255.0 green:212/255.0 blue:251/255.0 alpha:1] range:NSMakeRange(7,4)];
    _tiaoKuanBtn.titleLabel.attributedText = str;
    
    [_yanZhengMaBtn addTarget:self action:@selector(getYanZhengMaData) forControlEvents:UIControlEventTouchDown];
    [_zhuCeBtn addTarget:self action:@selector(zhuCeData) forControlEvents:UIControlEventTouchDown];
    [_tiaoKuanBtn addTarget:self action:@selector(toTiaoKuan) forControlEvents:UIControlEventTouchDown];
    
    [_shouJiHaoTF addTarget:self action:@selector(textFieldDidChange2:) forControlEvents:UIControlEventEditingChanged];
    _shouJiHaoTF.tag = 100;
    [_yanZhengMaTF addTarget:self action:@selector(textFieldDidChange2:) forControlEvents:UIControlEventEditingChanged];
    _yanZhengMaTF.tag = 101;
    [_miMaTF addTarget:self action:@selector(textFieldDidChange2:) forControlEvents:UIControlEventEditingChanged];
    _miMaTF.tag = 102;
    [_yaoQingMaTF addTarget:self action:@selector(textFieldDidChange2:) forControlEvents:UIControlEventEditingChanged];
    _yaoQingMaTF.tag = 103;
    _yanZhengType = @"0";
}

//选择
-(BOOL)checkTelNumber:(NSString *) telNumber
{
    NSString *pattern = @"^1+[345678]+\\d{9}";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern];
    BOOL isMatch = [pred evaluateWithObject:telNumber];
    return isMatch;
}

- (void)getYanZhengMaData
{
    //判断手机号码是否够11位
    if (![self checkTelNumber:_shouJiHaoTF.text])
    {
        [MBProgressHUD showSuccess:@"请输入正确的手机号码"];
        return;
    }
    if ([_shoujihao isEqualToString:self.shouJiHaoTF.text])
    {
        [MBProgressHUD showSuccess:@"手机号已经注册"];
    }
    else
    {
        _yanZhengMaBtn.userInteractionEnabled=NO;
        [[ZXNetDataManager manager] getYanZhengMaDataWithPhone:_shouJiHaoTF.text andType:_yanZhengType andRndstring:[ZXDriveGOHelper getCurrentTimeStamp] success:^(NSURLSessionDataTask *task, id responseObject)
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
             _yanZhengMaBtn.userInteractionEnabled=YES;
             [MBProgressHUD showSuccess:jsonDict[@"msg"]];
             if(![[jsonDict objectForKey:@"msg"] isEqualToString:@"手机号已经注册"])
             {
                 _timerSecond = 60;
                 _timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(telNumberTextChange) userInfo:nil repeats:YES];
             }
             else
             {
                 _shoujihao = _shouJiHaoTF.text;
             }
         }failed:^(NSURLSessionTask *task, NSError *error)
         {
             _yanZhengMaBtn.userInteractionEnabled=YES;
             //获得验证码失败，弹出一个视图，告诉用户请稍后重试
             [MBProgressHUD showSuccess:@"由于网络原因发送验证码失败，请稍后再试"];
             YZLog(@"获得验证码失败%@",error);
             return ;
         }];
    }
}

//获取验证码的按钮的倒计时
-(void)telNumberTextChange
{
    _yanZhengMaBtn.userInteractionEnabled = NO;
    [_yanZhengMaBtn setTitle:[NSString stringWithFormat:@"%ld秒后重试",(long)_timerSecond] forState:UIControlStateNormal];
    _timerSecond --;
    if (_timerSecond ==0)
    {
        [_timer invalidate];
        _yanZhengMaBtn.userInteractionEnabled = YES;
        [_yanZhengMaBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
        _timerSecond = 60;
    }
}

//注册
- (void)zhuCeData
{
    //判断手机号码是否够11位
    if (![self checkTelNumber:_shouJiHaoTF.text])
    {
        [MBProgressHUD showSuccess:@"请输入正确的手机号码"];
        return;
    }
    //判断过程
    if ([_yanZhengMaTF.text isEqualToString:@""])
    {
        [MBProgressHUD showSuccess:@"请输入验证码"];
        return;
    }
    if ([_miMaTF.text isEqualToString:@""])
    {
        [MBProgressHUD showSuccess:@"请输入密码"];
        return;
    }
    if (_miMaTF.text.length < 6 || _miMaTF.text.length > 16)
    {
        [MBProgressHUD showSuccess:@"密码位数必须在6-16位。"];
        return;
    }
    //填写了推荐人的手机号码 但不正确
    if (![_yaoQingMaTF.text isEqualToString:@""] && ![self checkTelNumber:_yaoQingMaTF.text]) {
        [MBProgressHUD showSuccess:@"输入正确的手机号码"];
        return;
    }
    
    //注册操作
    [MBProgressHUD showMessage:@"正在注册..."];
    
    [[ZXNetDataManager manager] zhuCeDataWithPhone:_shouJiHaoTF.text andPassword:[ZXDriveGOHelper getMD5StringWithString:_miMaTF.text] andCode:_yanZhengMaTF.text andRndstring:[ZXDriveGOHelper getCurrentTimeStamp] andSourcePhone:_yaoQingMaTF.text success:^(NSURLSessionDataTask *task, id responseObject)
     {
         //注册成功的归档内容
         //判断注册成功以后才归档
         // 注册成功之后注册环信
         
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
             [MBProgressHUD showSuccess:@"注册成功"];
             [ZXUD setObject:[jsonDict objectForKey:@"ident_code"] forKey:@"ident_code"];
             [ZXUD setObject:[_miMaTF.text MD5Hash] forKey:@"password"];
             [ZXUD setObject:_shouJiHaoTF.text forKey:@"phoneNum"];
             [ZXUD synchronize];
             
             [self loginData];
        }
        else
        {
            [MBProgressHUD showSuccess:jsonDict[@"msg"]];
        }
     }failed:^(NSURLSessionTask *task, NSError *error)
     {
         [MBProgressHUD hideHUD];
     }];
}

//登录
- (void)loginData
{
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
         
         //登录成功
         if([[ZXwangLuoDanLi WangLuoDanLi] resIsTrue:jsonDict andAlertView:self])
         {
             [ZXUD setBool:YES forKey:@"IS_LOGIN"];
             [ZXUD setObject:[jsonDict objectForKey:@"ident_code"] forKey:@"ident_code"];
             [ZXUD synchronize];
             
             [self chaKanXueYuanXinXiData];
         }
         else
         {
             [MBProgressHUD showSuccess:jsonDict[@"msg"]];
         }
     }failed:^(NSURLSessionTask *task, NSError *error)
     {
     }];
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
             if ([dict[@"gender"] isEqualToString:@"0"])
             {
                 userAccount.gender = [NSNumber numberWithInt:1];//性别，0-女 1-男
             }else {
                 userAccount.gender = [NSNumber numberWithInt:0];//性别，0-女 1-男
             }
             
             [UMComLoginManager requestLoginWithLoginAccount:userAccount requestCompletion:^(NSDictionary *responseObject, NSError *error, dispatch_block_t callbackCompletion)
             {
                 if (error)
                 {
                 }
                 else
                 {
                     
                 }
             }];
             
             zhu_ye_ViewController *zhuYeVC = [[zhu_ye_ViewController alloc]init];
             [self.navigationController pushViewController:zhuYeVC animated:YES];
         }
         else
         {
             [ZXUD setBool:NO forKey:@"IS_LOGIN"];
         }
     }failed:^(NSURLSessionTask *task, NSError *error)
     {
         [MBProgressHUD hideHUD];
     }];
}

-(void)textFieldDidChange2:(UITextField *)textField
{
    if (textField.tag == 100 || textField.tag == 103)
    {
        if (textField.text.length > 11)
        {
            textField.text = [textField.text substringWithRange:NSMakeRange(0,11)];
        }
    }
    else if (textField.tag == 101)
    {
        if (textField.text.length > 6)
        {
            textField.text = [textField.text substringWithRange:NSMakeRange(0,6)];
        }
    }
    else if (textField.tag == 102)
    {
        if (textField.text.length > 16)
        {
            textField.text = [textField.text substringWithRange:NSMakeRange(0,16)];
        }
    }
}

// 跳转到服务条款
- (void)toTiaoKuan
{
    ZX_FuWuTiaoKuan_ViewController *fuWuTiaoKuanVC = [[ZX_FuWuTiaoKuan_ViewController alloc] init];
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:fuWuTiaoKuanVC animated:YES];
}

#pragma mark --退出键盘
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [[UIApplication sharedApplication].keyWindow endEditing:YES];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (self.navigationController) {
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        [self dismissViewControllerAnimated:YES completion:nil];
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

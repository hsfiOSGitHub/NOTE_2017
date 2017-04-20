//
//  ZX_wangJiMiMa_ViewController.m
//  友照
//
//  Created by cleloyang on 2016/11/22.
//  Copyright © 2016年 ZX_XPH. All rights reserved.
//

#import "ZX_wangJiMiMa_ViewController.h"

@interface ZX_wangJiMiMa_ViewController ()<UIAlertViewDelegate,UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *shouJiHaoTF;
@property (weak, nonatomic) IBOutlet UITextField *yanZhengMaTF;
@property (weak, nonatomic) IBOutlet UITextField *miMaTF;
@property (weak, nonatomic) IBOutlet UIButton *yanZhengMaBtn;
@property (weak, nonatomic) IBOutlet UIButton *chongZhiMiMaBtn;

/**定时器*/
@property (nonatomic ,weak)NSTimer* timer;

/**定时器倒计时*/
@property (nonatomic ,assign) NSInteger timerSecond;
@property (nonatomic ,copy) NSString *shoujihao;

@property (nonatomic) NSString* yanZhengType;
@end

@implementation ZX_wangJiMiMa_ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"忘记密码";
    self.view.backgroundColor = [UIColor whiteColor];
    [_yanZhengMaBtn addTarget:self action:@selector(getYanZhengMaData) forControlEvents:UIControlEventTouchDown];
    [_chongZhiMiMaBtn addTarget:self action:@selector(chongZhiMiMaData) forControlEvents:UIControlEventTouchDown];
    
    [_shouJiHaoTF addTarget:self action:@selector(textFieldDidChange1:) forControlEvents:UIControlEventEditingChanged];
    _shouJiHaoTF.tag = 100;
    [_yanZhengMaTF addTarget:self action:@selector(textFieldDidChange1:) forControlEvents:UIControlEventEditingChanged];
    _yanZhengMaTF.tag = 101;
    [_miMaTF addTarget:self action:@selector(textFieldDidChange1:) forControlEvents:UIControlEventEditingChanged];
    _miMaTF.tag = 102;
    _yanZhengType = @"1";
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
             [MBProgressHUD showSuccess:@"由于网络原因发送验证码失败，请稍后再试。"];
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

- (void)chongZhiMiMaData
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
    if ([ZXUD objectForKey:@"NetDataState"])
    {
        [[ZXNetDataManager manager] chongZhiMiMaDataWithPhone:_shouJiHaoTF.text andPassword:[ZXDriveGOHelper getMD5StringWithString:_miMaTF.text] andCode:_yanZhengMaTF.text andRndstring:[ZXDriveGOHelper getCurrentTimeStamp] success:^(NSURLSessionDataTask *task, id responseObject)
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
             YZLog(@"手机号：%@",_shouJiHaoTF.text);
             YZLog(@"密码：%@",_miMaTF.text);
             YZLog(@"验证码：%@",_yanZhengMaTF.text);
             YZLog(@"随机字符串：%@",[ZXDriveGOHelper getCurrentTimeStamp]);
             if(err)
             {
                 NSLog(@"json解析失败：%@",err);
             }
             
             if ([[jsonDict objectForKey:@"res"] isEqualToString:@"1001"])
             {
                 [ZXUD setObject:[jsonDict objectForKey:@"ident_code"] forKey:@"ident_code"];
                 [ZXUD setObject:[_miMaTF.text MD5Hash] forKey:@"password"];
                 [ZXUD setObject:_shouJiHaoTF.text forKey:@"phoneNum"];
                 [ZXUD synchronize];
                 [MBProgressHUD showSuccess:@"重置密码成功"];
                 [self.navigationController popViewControllerAnimated:YES];
             }
             else
             {
                 [MBProgressHUD showSuccess:jsonDict[@"msg"]];
             }
         }failed:^(NSURLSessionTask *task, NSError *error)
         {
             [MBProgressHUD showSuccess:@"网络不好，请稍后重试。"];
         }];
    }
    else
    {
        [MBProgressHUD showSuccess:@"网络不好，请稍后重试。"];
    }
}

-(void)textFieldDidChange1:(UITextField *)textField
{
    if (textField.tag == 100)
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
}


@end

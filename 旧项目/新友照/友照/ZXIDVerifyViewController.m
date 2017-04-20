//
//  ZXIDVerifyViewController.m
//  ZXJiaXiao
//
//  Created by ZX on 16/3/15.
//  Copyright © 2016年 ZX. All rights reserved.
//

#import "ZXIDVerifyViewController.h"
#import "ZXNetDataManager+CoachData.h"
//#import "ZXLoginPageViewController.h"
@interface ZXIDVerifyViewController ()<UIAlertViewDelegate>
@property (weak, nonatomic) IBOutlet UITextField *nameLabel;
@property (weak, nonatomic) IBOutlet UITextField *phoneNumLabel;
@property (weak, nonatomic) IBOutlet UITextField *yanZhengMaLabel;
@property (weak, nonatomic) IBOutlet UITextField *IDLabel;
@property (weak, nonatomic) IBOutlet UILabel *tipLabel;
@property (weak, nonatomic) IBOutlet UIButton *idCode;
/**定时器*/
@property (nonatomic ,weak)NSTimer      *  timer;
/**定时器倒计时*/
@property (nonatomic ,assign) NSInteger    residueSecond;

@property (nonatomic) UIAlertView *successAlertView;
@end

@implementation ZXIDVerifyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"身份验证";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"提交" style:UIBarButtonItemStyleDone target:self action:@selector(submitInfo)];
    self.navigationItem.rightBarButtonItem.tintColor = [UIColor whiteColor];
    self.idCode.layer.borderColor = [[UIColor blackColor]CGColor];
    self.idCode.layer.borderWidth = 1;
    self.idCode.layer.cornerRadius = 7;
    self.idCode.layer.masksToBounds = YES;
    self.tipLabel.text = @"请填写正确的手机号码，身份证号码。";
    _nameLabel.text = [ZXUD objectForKey:@"userRealName"];
    _phoneNumLabel.text = [ZXUD objectForKey:@"phoneNum"];
    _IDLabel.text = [ZXUD objectForKey:@"id_card"];
    //创建AlertView
    _successAlertView = [[UIAlertView alloc] initWithTitle:nil message:@"预约已受理" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
    [_phoneNumLabel addTarget:self action:@selector(textFieldDidChange3:) forControlEvents:UIControlEventEditingChanged];
    _phoneNumLabel.tag = 100;
    [_yanZhengMaLabel addTarget:self action:@selector(textFieldDidChange3:) forControlEvents:UIControlEventEditingChanged];
    _yanZhengMaLabel.tag = 101;
    [_IDLabel addTarget:self action:@selector(textFieldDidChange3:) forControlEvents:UIControlEventEditingChanged];
}

- (void) submitInfo
{
    //需要判断文本框是否有空
    if ([_nameLabel.text isEqualToString:@""])
    {
        [MBProgressHUD showSuccess:@"姓名不能为空"];
        return;
    }
    if (_phoneNumLabel.text.length != 11) {
        [MBProgressHUD showSuccess:@"请输入有效的手机号"];
        return;
    }
    if ([_yanZhengMaLabel.text isEqualToString:@""])
    {
        [MBProgressHUD showSuccess:@"验证码不能为空"];
        return;
    }
    if (_IDLabel.text.length != 18)
    {
        [MBProgressHUD showSuccess:@"请输入正确的身份证号"];
        return;
    }
    
    NSString *yanZhengMa = @"[0-9]*";
    NSPredicate *yanZhengMaText = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",yanZhengMa];
    if (![yanZhengMaText evaluateWithObject:_yanZhengMaLabel.text])
    {
        [MBProgressHUD showSuccess:@"验证码输入错误"];
    }
    else
    {
        [self yuYueAction];
    }
}
- (void)yuYueAction
{
    if ([ZXUD boolForKey:@"NetDataState"])
    {
        if (_verifyType == verifyTypeJiaoLian)
        {
            //预约教练
            [[ZXNetDataManager manager] YuYueJiaoLianWithTimeStamp:[ZXDriveGOHelper getCurrentTimeStamp] andIdent_code:[ZXUD objectForKey:@"ident_code"] andTid:_jiaolianID andPhone:_phoneNumLabel.text andName:_nameLabel.text andCode:_yanZhengMaLabel.text andId_card:_IDLabel.text success:^(NSURLSessionDataTask *task, id responseObject)
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
                
                if ([jsonDict[@"res"] isEqualToString:@"1001"])
                {
                    [ZXUD setObject:_jiaolianID forKey:@"T_ID"];
                    [ZXUD setObject:_teacher_pic forKey:@"teacher_pic"];
                    
                    [ZXUD setObject:_teacher_name forKey:@"T_NAME"];
                    [ZXUD synchronize];
                    [_successAlertView show];
                }
                else  if ([jsonDict[@"res"] isEqualToString:@"1002"])
                {
                    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"登录状态已过期, 请重新登录" message:nil preferredStyle:UIAlertControllerStyleAlert];
                    UIAlertAction *anotherAction = [UIAlertAction actionWithTitle:@"登录" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action)
                    {
                        //让用户重新登录
                        [ZXUD setObject:nil forKey:@"ident_code"];
                        ZX_Login_ViewController *VC = [[ZX_Login_ViewController alloc] init];
                        UINavigationController *navi = [[UINavigationController alloc]initWithRootViewController:VC];
                        [self presentViewController:navi animated:YES completion:nil];
                    }];
                    [alert addAction:anotherAction];
                    [self presentViewController:alert animated:YES completion:^{
                    }];
                }
                else if ([jsonDict[@"res"] isEqualToString:@"1005"] || [jsonDict[@"res"] isEqualToString:@"1004"])
                {
                    
                }
                else
                {
                    [MBProgressHUD showError:jsonDict[@"msg"]];
                }
            } failed:^(NSURLSessionTask *task, NSError *error)
            {
            }];
            
        }
        else if (_verifyType == verifyTypeJiaXiao)
        {
            //预约驾校
            [[ZXNetDataManager manager] yuYueJiaXiaoWithRndstring:[ZXDriveGOHelper getCurrentTimeStamp] andIdent_code:[ZXUD objectForKey:@"ident_code"] andSid:_jiaxiaoID andPhone:_phoneNumLabel.text andName:_nameLabel.text andCode:_yanZhengMaLabel.text andId_card:_IDLabel.text success:^(NSURLSessionDataTask *task, id responseObject)
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
                     NSString *msg = [jsonDict objectForKey:@"msg"];
                     if ([msg isEqualToString:@"预约成功"])
                     {
                         [ZXUD setObject:_jiaxiaoID forKey:@"S_ID"];
                         [ZXUD synchronize];
                         [_successAlertView show];
                     }
                 }
             } failed:^(NSURLSessionTask *task, NSError *error)
             {
                 [MBProgressHUD showSuccess:@"网络不好，请稍后重试。"];
             }];
        }
    }
    else
    {
        [MBProgressHUD showSuccess:@"网络不好，请稍后重试。"];
    }
}

//获取手机验证码
- (IBAction)getVerifyNumBtn:(id)sender
{
   [[ZXNetDataManager manager] getYanZhengMaDataWithPhone:_phoneNumLabel.text andType:_yanZhengMaType andRndstring:[ZXDriveGOHelper getCurrentTimeStamp] success:^(NSURLSessionDataTask *task, id responseObject) {
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
       if ([jsonDict[@"res"] isEqualToString:@"1002"]) {
          
       }else if ([jsonDict[@"res"] isEqualToString:@"1005"]) {
           
       }else {
           [MBProgressHUD showError:jsonDict[@"msg"]];
       }
   } failed:^(NSURLSessionTask *task, NSError *error) {
       
   }];
    _residueSecond = 60;
    _timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(telNumberTextChange) userInfo:nil repeats:YES];
}
/**
 *  获取验证码的按钮的倒计时
 */
-(void)telNumberTextChange
{
    _idCode.userInteractionEnabled=NO;
    [_idCode setTitle:[NSString stringWithFormat:@"%ld秒后重试",(long)_residueSecond] forState:UIControlStateNormal];
    _residueSecond --;
    if (_residueSecond ==0)
    {
        [_timer invalidate];
        _idCode.userInteractionEnabled = YES;
        [_idCode setTitle:@"获取验证码" forState:UIControlStateNormal];
        _residueSecond = 60;
    }
}

-(void)textFieldDidChange3:(UITextField *)textField
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
    else
    {
        if (textField.text.length > 18)
        {
            textField.text = [textField.text substringWithRange:NSMakeRange(0,18)];
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [[UIApplication sharedApplication].keyWindow endEditing:YES];
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    [self.navigationController popViewControllerAnimated:YES];
    
}

@end

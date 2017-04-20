//
//  ZX_YiJianFanKui_ViewController.m
//  友照
//
//  Created by cleloyang on 2016/12/2.
//  Copyright © 2016年 ZX_XPH. All rights reserved.
//

#import "ZX_YiJianFanKui_ViewController.h"

@interface ZX_YiJianFanKui_ViewController ()<UITextViewDelegate>
@property(nonatomic,strong)UILabel* lab;
@property (nonatomic) UITextView *userFeedTextView;
@property (nonatomic) UITextField *phoneNumTextFiled;
@property (nonatomic) BOOL isEditing;
@end

@implementation ZX_YiJianFanKui_ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"意见反馈";
    self.view.backgroundColor = ZX_BG_COLOR;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"提交" style:UIBarButtonItemStylePlain target:self action:@selector(submitYiJian)];
    
    UIButton* btn=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight)];
    [btn addTarget:self action:@selector(quxiao) forControlEvents:UIControlEventTouchDown];
    _lab = [[UILabel alloc] initWithFrame:CGRectMake(14, 80, KScreenWidth-24, 21)];
    _lab.text = @"请输入反馈，我们将不断改进。";
    _lab.textColor = ZX_LightGray_Color;
    _lab.userInteractionEnabled = NO;
    [btn addSubview:self.userFeedTextView];
    [btn addSubview:_lab];
    [btn addSubview:self.phoneNumTextFiled];
    [self.view addSubview:btn];
    self.navigationItem.rightBarButtonItem.tintColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
}


//取消第一响应
-(void)quxiao
{
    [self.view endEditing:YES];
}

//懒加载textView
- (UITextView *)userFeedTextView
{
    _userFeedTextView = [[UITextView alloc] initWithFrame:CGRectMake(10, 74, KScreenWidth-20, 240)];
    _userFeedTextView.font = [UIFont systemFontOfSize:16];
    _userFeedTextView.textColor = ZX_DarkGray_Color;
    _userFeedTextView.delegate = self;
    return _userFeedTextView;
}

- (UITextField *)phoneNumTextFiled
{
    _phoneNumTextFiled = [[UITextField alloc] initWithFrame:CGRectMake(10, 330, KScreenWidth - 20, 40)];
    _phoneNumTextFiled.borderStyle = UITextGranularityLine;
    _phoneNumTextFiled.keyboardType = UIKeyboardTypePhonePad;
    _phoneNumTextFiled.placeholder = @"您的手机号(选填)";
    [_phoneNumTextFiled addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    _phoneNumTextFiled.font = [UIFont systemFontOfSize:16];
    _phoneNumTextFiled.backgroundColor = [UIColor whiteColor];
    return _phoneNumTextFiled;
}

-(void)textFieldDidChange:(UITextField *)textField
{
    if (textField.text.length > 11)
    {
        textField.text = [textField.text substringWithRange:NSMakeRange(0,11)];
    }
}

//选择
-(BOOL)checkTelNumber:(NSString *)telNumber
{
    if(telNumber.length==0)
    {
        return YES;
    }
    else
    {
        NSString *pattern = @"^1+[345678]+\\d{9}";
        NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern];
        BOOL isMatch = [pred evaluateWithObject:telNumber];
        return isMatch;
    }
}

-(void)textViewDidBeginEditing:(UITextView *)textView
{
    _lab.hidden = YES;
    _isEditing = YES;
}

-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString*)text
{
    if(textView.text.length == 0)
    {
        if (!_isEditing)
        {
            _lab.hidden = NO;
        }
    }
    else
    {
        _lab.hidden = YES;
        _isEditing = YES;
    }
    if ([text isEqualToString:@"\n"])
    {
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}

//退出键盘
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [[UIApplication sharedApplication].keyWindow endEditing:YES];
    if ([_userFeedTextView.text isEqualToString:@""])
    {
        _lab.hidden = NO;
    }
}

//用户提交的函数
- (void)submitYiJian
{
    NSCharacterSet *set = [NSCharacterSet whitespaceAndNewlineCharacterSet];
    NSString *trimedString = [_userFeedTextView.text stringByTrimmingCharactersInSet:set];
    if ([trimedString length] == 0) {
        [MBProgressHUD showSuccess:@"输入内容不能为空格。"];
        return ;
    }
    if ([_userFeedTextView.text isEqualToString:@" "]||[_userFeedTextView.text isEqualToString:@"请输入反馈，我们将不断改进"])
    {
        [MBProgressHUD showSuccess:@"请您留下点儿意见！"];
        return;
    }
    
    
    if ([_phoneNumTextFiled.text length]>0)
    {
        NSCharacterSet *set2 = [NSCharacterSet whitespaceAndNewlineCharacterSet];
        NSString *trimedString2 = [_phoneNumTextFiled.text stringByTrimmingCharactersInSet:set2];
        if ([trimedString2 length] == 0)
        {
            [MBProgressHUD showSuccess:@"手机号不能为空格。"];
            return ;
        }
        if (![self checkTelNumber:_phoneNumTextFiled.text])
        {
            [MBProgressHUD showSuccess:@"请输入正确的手机号码"];
            return;
        }
    }
    
    [MBProgressHUD showMessage:@"正在提交..."];
    [[ZXNetDataManager manager] yongHuFanKuiWithRndstring:[ZXDriveGOHelper getCurrentTimeStamp] andPhone:_phoneNumTextFiled.text andContent:_userFeedTextView.text success:^(NSURLSessionDataTask *task, id responseObject)
     {
         [MBProgressHUD hideHUD];
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
             [MBProgressHUD showSuccess:@"反馈提交成功"];
             [self.navigationController popViewControllerAnimated:YES];
         }
     } failed:^(NSURLSessionTask *task, NSError *error)
     {
         [MBProgressHUD showSuccess:@"网络不好，请稍后重试。"];
     }];
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

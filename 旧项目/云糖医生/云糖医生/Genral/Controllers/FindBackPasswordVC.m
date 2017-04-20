//
//  FindBackPasswordVC.m
//  yuntangyi
//
//  Created by yuntangyi on 16/9/7.
//  Copyright © 2016年 yuntangyi. All rights reserved.
//

#import "FindBackPasswordVC.h"

#import "TalkBtn.h"
#import "UIView+Shaking.h"
#import "SZBNetDataManager+RegisterAndLoginNetData.h"
#import "RegisterVC.h"

@interface FindBackPasswordVC ()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIButton *myBackBtn;//返回按钮
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *myBackBtnHeightConstraint;//返回按钮高度约束

@property (weak, nonatomic) IBOutlet UIImageView *imgView;//图片
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imgViewHeightConstraint;//图片高度约束

@property (weak, nonatomic) IBOutlet UIView *bgView;//底部UIView
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bgViewBottomConstraint;//底部UIView的底部约束

@property (weak, nonatomic) IBOutlet UILabel *findBackPasswordLabe;//找回密码字样
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *findBackPasswordLabelTopConstraint;//找回密码字样顶部约束


@property (weak, nonatomic) IBOutlet UITextField *phoneNumberTF;//请输入手机号
@property (weak, nonatomic) IBOutlet UITextField *securityCodeTF;//请输入验证码
@property (weak, nonatomic) IBOutlet UITextField *passwordTF1;//请输入密码
@property (weak, nonatomic) IBOutlet UITextField *passwordTF2;//请确认密码

@property (weak, nonatomic) IBOutlet UIButton *getSecurityCodeBtn;//获取验证码按钮
@property (weak, nonatomic) IBOutlet UIButton *findBackPasswordBtn;//找回密码按钮
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *findBackPasswordBtnHeghtConstraint;//找回密码按钮高度约束
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *findBackPasswordBtnTopConstraint;//找回密码按钮顶部约束

@property (weak, nonatomic) IBOutlet TalkBtn *talkBtn1;
@property (weak, nonatomic) IBOutlet TalkBtn *talkBtn2;
@property (weak, nonatomic) IBOutlet TalkBtn *talkBtn3;
@property (weak, nonatomic) IBOutlet TalkBtn *talkBtn4;


@property (weak, nonatomic) IBOutlet UIButton *eyeBtn1;
@property (weak, nonatomic) IBOutlet UIButton *eyeBtn2;


@property (nonatomic,strong) UITextField *currentTF;//当前输入框
@property (nonatomic,strong) NSTimer *timer;//定时器 用于获取验证码倒计时
@property (nonatomic,assign) NSInteger second;//剩余时间
@end

@implementation FindBackPasswordVC
#pragma mark -Touch事件
-(void)addTapGestureToGetBackKeyboard{
    self.view.userInteractionEnabled = YES;
    
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(fingerTapped:)];
    
    [self.view addGestureRecognizer:singleTap];
}
-(void)fingerTapped:(UITapGestureRecognizer *)gestureRecognizer{
    
    [self.view endEditing:YES];
    
}
#pragma mark -返回
- (IBAction)backToLoginVC:(UIButton *)sender {
    [_currentTF resignFirstResponder];
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark -懒加载

#pragma mark -viewDidLoad
- (void)viewDidLoad {
    [super viewDidLoad];
    //添加点击空白处回收键盘
    [self addTapGestureToGetBackKeyboard];
    //配置子视图控件
    [self setUpSubviews];
    //添加键盘弹出回收事件
    [self keyboardAction];
}
//配置子视图控件
-(void)setUpSubviews{
    _phoneNumberTF.text = self.userNumTF_text;
    
    //设置代理
    _phoneNumberTF.delegate = self;
    _securityCodeTF.delegate = self;
    _passwordTF1.delegate = self;
    _passwordTF2.delegate = self;
    
    //配置找回密码按钮
    _findBackPasswordBtn.layer.masksToBounds = YES;
//    _findBackPasswordBtn.layer.borderColor = [UIColor grayColor].CGColor;
//    _findBackPasswordBtn.layer.borderWidth = 1;
    _findBackPasswordBtn.layer.cornerRadius = 5;
    
    //颜色配置
    _findBackPasswordLabe.textColor = KRGB(0, 172, 204, 1);
    [_getSecurityCodeBtn setTitleColor:KRGB(0, 172, 204, 1) forState:UIControlStateNormal];
    [_findBackPasswordBtn setBackgroundColor:KRGB(20, 157, 192, 1)];
}
#pragma mark -监听键盘弹出与回收
-(void)keyboardAction{
    //增加监听，当键盘出现或改变时收出消息
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    //增加监听，当键退出时收出消息
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}
//当键盘出现或改变时调用
- (void)keyboardWillShow:(NSNotification *)aNotification{
    NSDictionary *userInfo = [aNotification userInfo];
    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    CGFloat height = keyboardRect.size.height;
    //动画(往上弹)
    NSNumber *duration = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSNumber *curve = [userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey];
    [UIView animateWithDuration:[duration integerValue] animations:^{
        [UIView setAnimationCurve:[curve integerValue]];
        //将返回按钮隐藏
        _myBackBtnHeightConstraint.constant = 0;
        [_myBackBtn setNeedsLayout];
        [_myBackBtn layoutIfNeeded];
        //bgView往上弹
        _bgViewBottomConstraint.constant = height;
        [_bgView setNeedsLayout];
        _findBackPasswordLabelTopConstraint.constant = 0;
        [_findBackPasswordLabe setNeedsLayout];
        _findBackPasswordBtnTopConstraint.constant = 10;
        _findBackPasswordBtnHeghtConstraint.constant = 40;
        [_findBackPasswordBtn setNeedsLayout];
        //图片缩小
        _imgViewHeightConstraint.constant = 0;
        [_imgView setNeedsLayout];
    }];
    
    
}
//当键退出时调用
- (void)keyboardWillHide:(NSNotification *)aNotification{
    NSDictionary *userInfo = [aNotification userInfo];
    //动画(往下弹)
    NSNumber *duration = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSNumber *curve = [userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey];
    [UIView animateWithDuration:[duration integerValue] animations:^{
        [UIView setAnimationCurve:[curve integerValue]];
        //将返回按钮和注册按钮隐藏
        _myBackBtnHeightConstraint.constant = 44;
        [_myBackBtn setNeedsLayout];
        //bgView往上弹
        _bgViewBottomConstraint.constant = 0;
        [_bgView setNeedsLayout];
        _findBackPasswordLabelTopConstraint.constant = 20;
        [_findBackPasswordLabe setNeedsLayout];
        _findBackPasswordBtnTopConstraint.constant = 30;
        _findBackPasswordBtnHeghtConstraint.constant = 50;
        [_findBackPasswordBtn setNeedsLayout];
        //图片放大
        _imgViewHeightConstraint.constant = 100;
        [_imgView setNeedsLayout];
    }];
}

//获取验证码
- (IBAction)getSecurityCodeAction:(UIButton *)sender {
//    [_currentTF resignFirstResponder];//取消第一响应
    //判断手机号是否输入正确
    if (![self checkTelNumber:_phoneNumberTF.text]) {
        [_talkBtn1 setTitle:@"  请输入正确的手机号  " forState:UIControlStateNormal];
        _talkBtn1.alpha = 1;
        [UIView animateWithDuration:5 animations:^{
            _talkBtn1.alpha = 0;
        }];
        [_phoneNumberTF becomeFirstResponder];
        //抖一抖
        [_phoneNumberTF shakeWithTimes:4 speed:0.05 range:5 shakeDirection:ShakingDirectionVertical];
        return;
    }
    //网络请求 获取验证码
    //12 代表注册
    [[SZBNetDataManager manager] MessagePhone:_phoneNumberTF.text andType:@"14" andRandomStamp:[ToolManager getCurrentTimeStamp] success:^(NSURLSessionDataTask *task, id responseObject) {
        //网络请求成功
        /*
         {"res":"1001","msg":"发送成功"}
         {"res":"1004","msg":"重复请求"}
         {"res":"1005","msg":"缺少必须参数"}
         {"res":"1006","msg":"发送失败"}
         {"res":"1007","msg":"手机号已经注册"}
         {"res":"1008","msg":"该手机号未注册"}
         */
        NSString *resStr = [NSString stringWithFormat:@"%@",[responseObject objectForKey:@"res"]];
        NSString *msgStr = [NSString stringWithFormat:@"%@",[responseObject objectForKey:@"msg"]];
        if ([resStr isEqualToString: @"1001"]) {
            //发送成功
            NSString *message = responseObject[@"msg"];
            [MBProgressHUD showError:message];
            //获取验证码成功
            //1.改变获取验证码状态
            _getSecurityCodeBtn.userInteractionEnabled = NO;
            _second=60;//一分钟
            _timer=[NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(telNumberTextChange) userInfo:nil repeats:YES];
            NSLog(@"%@",msgStr);
        }else if ([resStr isEqualToString: @"1007"]) {
            //手机号已经注册
            UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"温馨提示" message:msgStr preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
            UIAlertAction *goToLogin = [UIAlertAction actionWithTitle:@"去登录" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
                //跳转到登录界面
                [_currentTF resignFirstResponder];//取消第一响应
                [self.navigationController popViewControllerAnimated:YES];
            }];
            [alertC addAction:cancel];
            [alertC addAction:goToLogin];
            [self presentViewController:alertC animated:YES completion:nil];
        }else if ([resStr isEqualToString: @"1005"] || [resStr isEqualToString: @"1004"]) {
            
        }else{
            NSString *message = responseObject[@"msg"];
            [MBProgressHUD showError:message];
        }
    } failed:^(NSURLSessionTask *task, NSError *error) {
        [MBProgressHUD showError:@"获取验证码失败"];
    }];
}
//获取验证码的按钮的倒计时
-(void)telNumberTextChange {
    [_getSecurityCodeBtn setTitle:[NSString stringWithFormat:@"%ld秒后重试",(long)_second] forState:UIControlStateNormal];
    _second --;
    [_getSecurityCodeBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    if (_second ==0) {
        [_timer invalidate];
        _getSecurityCodeBtn.userInteractionEnabled = YES;
        [_getSecurityCodeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
        _second = 60;
        [_getSecurityCodeBtn setTitleColor:KRGB(0, 172, 204, 1) forState:UIControlStateNormal];
    }
}
//是否显示密码
- (IBAction)showPassword:(UIButton *)sender {
    sender.selected = !sender.selected;
    UIImage *showImg = [UIImage imageNamed:@"login_hidePassword"];
    UIImage *noShowImg = [UIImage imageNamed:@"login_showPassword"];
    if (sender.selected) {//点击》不展示
        [sender setImage:noShowImg forState:UIControlStateNormal];
        if (sender == self.eyeBtn1) {
            _passwordTF1.secureTextEntry = NO;
        }else if (sender == self.eyeBtn2) {
            _passwordTF2.secureTextEntry = NO;
        }
    }else {//点击》展示
        [sender setImage:showImg forState:UIControlStateNormal];
        if (sender == self.eyeBtn1) {
            _passwordTF1.secureTextEntry = YES;
        }else if (sender == self.eyeBtn2) {
            _passwordTF2.secureTextEntry = YES;
        }
    }
}

//找回密码
- (IBAction)findBackPassworeAction:(UIButton *)sender {
    //1.判断手机号是否输入正确
    if (![self checkTelNumber:_phoneNumberTF.text]) {
        [_talkBtn1 setTitle:@"  请输入正确的手机号  " forState:UIControlStateNormal];
        _talkBtn1.alpha = 1;
        [UIView animateWithDuration:5 animations:^{
            _talkBtn1.alpha = 0;
        }];
        //抖一抖
        [_phoneNumberTF shakeWithTimes:4 speed:0.05 range:5 shakeDirection:ShakingDirectionVertical];
        return;
    }
    //2.验证码必须是6位
    if ([_securityCodeTF.text length] != 6) {
        [_talkBtn2 setTitle:@"  验证码必须是6位  " forState:UIControlStateNormal];
        _talkBtn2.alpha = 1;
        [UIView animateWithDuration:5 animations:^{
            _talkBtn2.alpha = 0;
        }];
        //抖一抖
        [_securityCodeTF shakeWithTimes:4 speed:0.05 range:5 shakeDirection:ShakingDirectionVertical];
        return;
    }
    //3.判断密码1不能为空
    if ([_passwordTF1.text length] == 0) {
        [_talkBtn3 setTitle:@"  密码不能为空  " forState:UIControlStateNormal];
        _talkBtn3.alpha = 1;
        [UIView animateWithDuration:5 animations:^{
            _talkBtn3.alpha = 0;
        }];
        //抖一抖
        [_passwordTF1 shakeWithTimes:4 speed:0.05 range:5 shakeDirection:ShakingDirectionVertical];
        return;
    }
    //4.判断密码2不能为空
    if ([_passwordTF2.text length] == 0) {
        [_talkBtn4 setTitle:@"  密码不能为空  " forState:UIControlStateNormal];
        _talkBtn4.alpha = 1;
        [UIView animateWithDuration:5 animations:^{
            _talkBtn4.alpha = 0;
        }];
        //抖一抖
        [_passwordTF2 shakeWithTimes:4 speed:0.05 range:5 shakeDirection:ShakingDirectionVertical];
        return;
    }
    //5.判断密码是否一致
    if (![_passwordTF1.text isEqualToString:_passwordTF2.text]) {
        [_talkBtn4 setTitle:@"  密码不一致  " forState:UIControlStateNormal];
        _talkBtn4.alpha = 1;
        [UIView animateWithDuration:5 animations:^{
            _talkBtn4.alpha = 0;
        }];
        //抖一抖
        [_passwordTF2 shakeWithTimes:4 speed:0.05 range:5 shakeDirection:ShakingDirectionVertical];
        return;
    }
    //6.发起网络请求
    [[SZBNetDataManager manager]forgetPasswordPhone:_phoneNumberTF.text andPassWord:_passwordTF1.text andCode:_securityCodeTF.text andRandomStamp:[ToolManager getCurrentTimeStamp] success:^(NSURLSessionDataTask *task, id responseObject) {
        //网络请求成功
        /*
         {"res":"1001","msg":"找回成功"}
         {"res":"1004","msg":"重复请求"}
         {"res":"1005","msg":"缺少必须参数"}
         {"res":"1006","msg":"验证码无效"}
         {"res":"1007","msg":"验证码已经过期"}
         {"res":"1008","msg":"该手机号未注册"}
         */
        NSString *resStr = [NSString stringWithFormat:@"%@",[responseObject objectForKey:@"res"]];
        NSString *msgStr = [NSString stringWithFormat:@"%@",[responseObject objectForKey:@"msg"]];
        if ([resStr isEqualToString: @"1001"]) {
            NSString *message = responseObject[@"msg"];
            [MBProgressHUD showError:message];
            //跳转到登录界面
            [_currentTF resignFirstResponder];//取消第一响应
            [self.navigationController popViewControllerAnimated:YES];
        }else if ([resStr isEqualToString: @"1008"]) {
            //该手机号未注册
            UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"温馨提示" message:msgStr preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
            UIAlertAction *goToRegister = [UIAlertAction actionWithTitle:@"去注册" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
                //跳转到注册界面
                [_currentTF resignFirstResponder];//取消第一响应
                RegisterVC *register_VC = [[RegisterVC alloc]init];
                register_VC.sourcePushVC = @"findBackPasswordVC";
                [self.navigationController pushViewController:register_VC animated:YES];
            }];
            [alertC addAction:cancel];
            [alertC addAction:goToRegister];
            [self presentViewController:alertC animated:YES completion:nil];
        }else if ([resStr isEqualToString: @"1005"] || [resStr isEqualToString: @"1004"]) {
            
        }else{
            NSString *message = responseObject[@"msg"];
            [MBProgressHUD showError:message];
        }
        
    } failed:^(NSURLSessionTask *task, NSError *error) {
        //网络请求失败
        [MBProgressHUD showError:@"网络请求失败"];
    }];
}


//判断手机号是否输入正确
-(BOOL)checkTelNumber:(NSString *) telNumber {
    NSString *pattern = @"^1+[345678]+\\d{9}";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern];
    BOOL isMatch = [pred evaluateWithObject:telNumber];
    return isMatch;
}



#pragma mark -UITextFieldDelegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    return YES;
}
- (void)textFieldDidBeginEditing:(UITextField *)textField{
    _currentTF = textField;
}
- (BOOL)textFieldShouldEndEditing:(UITextField *)textField{
    //判断手机号是否为11位
    if (textField == _phoneNumberTF) {
        if ([_phoneNumberTF.text length] != 11) {
            [_talkBtn1 setTitle:@"  手机号必须是11位  " forState:UIControlStateNormal];
            _talkBtn1.alpha = 1;
            [UIView animateWithDuration:5 animations:^{
                _talkBtn1.alpha = 0;
            }];
            //抖一抖
            [_phoneNumberTF shakeWithTimes:4 speed:0.05 range:5 shakeDirection:ShakingDirectionVertical];
        }
    }
    
    //判断验证码必须是6位
    if (textField == _securityCodeTF) {
        if ([_securityCodeTF.text length] != 6) {
            [_talkBtn2 setTitle:@"  验证码必须是6位  " forState:UIControlStateNormal];
            _talkBtn2.alpha = 1;
            [UIView animateWithDuration:5 animations:^{
                _talkBtn2.alpha = 0;
            }];
            [_securityCodeTF shakeWithTimes:4 speed:0.05 range:5 shakeDirection:ShakingDirectionVertical];
        }
    }
    
    //判断密码不能少于6位
    if (textField == _passwordTF1) {
        if ([_passwordTF1.text length] < 6) {
            if ([_passwordTF1.text length] == 0) {
                [_talkBtn3 setTitle:@"  请先输入密码  " forState:UIControlStateNormal];
                _talkBtn3.alpha = 1;
                [UIView animateWithDuration:5 animations:^{
                    _talkBtn3.alpha = 0;
                }];
                //抖一抖
                [_passwordTF1 shakeWithTimes:4 speed:0.05 range:5 shakeDirection:ShakingDirectionVertical];
            }else{
                [_talkBtn3 setTitle:@"  密码不能小于6位  " forState:UIControlStateNormal];
                _talkBtn3.alpha = 1;
                [UIView animateWithDuration:5 animations:^{
                    _talkBtn3.alpha = 0;
                }];
                //抖一抖
                [_passwordTF1 shakeWithTimes:4 speed:0.05 range:5 shakeDirection:ShakingDirectionVertical];
            }
        }
    }
    
    //判断密码是否一致
    if (textField == _passwordTF2) {
       
        if (![_passwordTF1.text isEqualToString:_passwordTF2.text]) {
            [_talkBtn4 setTitle:@"  密码不一致  " forState:UIControlStateNormal];
            _talkBtn4.alpha = 1;
            [UIView animateWithDuration:5 animations:^{
                _talkBtn4.alpha = 0;
            }];
            //抖一抖
            [_passwordTF2 shakeWithTimes:4 speed:0.05 range:5 shakeDirection:ShakingDirectionVertical];
        }
        
        
    }
    
    return YES;
}
- (void)textFieldDidEndEditing:(UITextField *)textField{
    
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    //判断手机号长度不能大于11位
    if (textField == _phoneNumberTF) {
        if (range.location > 10) {
            [_talkBtn1 setTitle:@"  手机号长度不能大于11位  " forState:UIControlStateNormal];
            _talkBtn1.alpha = 1;
            [UIView animateWithDuration:5 animations:^{
                _talkBtn1.alpha = 0;
            }];
            //抖一抖
            [_phoneNumberTF shakeWithTimes:4 speed:0.05 range:5 shakeDirection:ShakingDirectionVertical];
            return NO;
        }
    }
    
    //判断密码不能大于16位
    if (textField == _passwordTF1) {
        if (range.location > 15) {
            [_talkBtn3 setTitle:@"  密码不能大于16位  " forState:UIControlStateNormal];
            _talkBtn3.alpha = 1;
            [UIView animateWithDuration:5 animations:^{
                _talkBtn3.alpha = 0;
            }];
            //抖一抖
            [_passwordTF1 shakeWithTimes:4 speed:0.05 range:5 shakeDirection:ShakingDirectionVertical];
            return NO;
        }
        //判断密码不能有特殊字符
    }
    //判断验证码必须是6位
    if (textField == _securityCodeTF) {
        if (range.location > 5) {
            [_talkBtn2 setTitle:@"  验证码必须是6位  " forState:UIControlStateNormal];
            _talkBtn2.alpha = 1;
            [UIView animateWithDuration:5 animations:^{
                _talkBtn2.alpha = 0;
            }];
            [_securityCodeTF shakeWithTimes:4 speed:0.05 range:5 shakeDirection:ShakingDirectionVertical];
            return NO;
        }
    }
    
    return YES;
}
- (BOOL)textFieldShouldClear:(UITextField *)textField{
    return YES;
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
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

//
//  RegesterVC.m
//  yuntangyi
//
//  Created by yuntangyi on 16/9/2.
//  Copyright © 2016年 yuntangyi. All rights reserved.
//

#import "RegisterVC.h"

#import "LoginVC.h"
#import "SZBNetDataManager+RegisterAndLoginNetData.h"
#import "ToolManager.h"
#import "TalkBtn.h"
#import "UIView+Shaking.h"
#import "SZBDelegateVC.h"
#import "Register2VC.h"

@interface RegisterVC ()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIButton *myBackBtn;//返回按钮
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *myBackBtnHeightConstraint;//返回按钮高度约束
@property (weak, nonatomic) IBOutlet UIImageView *imgView;//图片
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imgViewHeightConstraint;//图片高度约束
@property (weak, nonatomic) IBOutlet UIView *bgView;//最底部UIView
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bgViewBottomConstraint;//最底部UIView底部约束
@property (weak, nonatomic) IBOutlet UILabel *registerLabel;//注册字样
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *registerLabelTopConstraints;//注册字样顶部约束
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *registerBtnTopConstraint;//注册按钮顶部约束

//>>>>>>>>
@property (weak, nonatomic) IBOutlet UITextField *phoneNumberTF;//手机号
@property (weak, nonatomic) IBOutlet UITextField *securityCodeTF;//验证码
@property (weak, nonatomic) IBOutlet UITextField *passwordTF;//密码

@property (weak, nonatomic) IBOutlet UIButton *getSecurityCodeBtn;//获取验证码按钮
@property (weak, nonatomic) IBOutlet UIButton *showPasswordBtn;//是否显示密码按钮

@property (weak, nonatomic) IBOutlet UIButton *registerBtn;//注册按钮
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *registerBtnHeightConstraint;//注册按钮高度约束
@property (weak, nonatomic) IBOutlet UIButton *acceptDelegateBtn;//接受《云糖医生协议》 按钮
@property (weak, nonatomic) IBOutlet UILabel *SZBAcceptLabel;//我已阅读并接受
@property (weak, nonatomic) IBOutlet UIButton *SZBdelegateBtn;//云糖医生协议详情按钮
@property (weak, nonatomic) IBOutlet UIView *SZBDelegateView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *SZBDelegateViewHeightConstraint;//云糖医生协议高度约束

@property (weak, nonatomic) IBOutlet TalkBtn *talkBtn1;//手机号提示回话框
@property (weak, nonatomic) IBOutlet TalkBtn *talkBtn2;//验证码提示回话框
@property (weak, nonatomic) IBOutlet TalkBtn *talkBtn3;//密码提示回话框

@property (nonatomic,strong) UITextField *currentTF;//当前输入框
@property (nonatomic,strong) NSTimer *timer;//定时器 用于获取验证码倒计时
@property (nonatomic,assign) NSInteger second;//剩余时间
@end

@implementation RegisterVC
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
    if ([self.sourceModeVC isEqualToString:@"GuideVC"]) {
        //返回guideVC
        [self.delegate quitRegisterVCPlayMp4];
        [self dismissViewControllerAnimated:YES completion:nil];
    }else{
        [self .navigationController popToRootViewControllerAnimated:YES];
    }
}
#pragma mark -懒加载

#pragma mark -viewWillAppear
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //隐藏导航栏
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}
#pragma mark -viewDidLoad
- (void)viewDidLoad {
    [super viewDidLoad];
    //返回按钮的图标
    if ([self.sourceModeVC isEqualToString:@"GuideVC"]) {
        [self.myBackBtn setImage:[UIImage imageNamed:@"login_close"] forState:UIControlStateNormal];
    }else{
        [self.myBackBtn setImage:[UIImage imageNamed:@"返回"] forState:UIControlStateNormal];
    }
    
    //配置子视图
    [self setUpSubViews];
    //添加点击空白回收键盘
    [self addTapGestureToGetBackKeyboard];
    //键盘的弹出于回收
    [self keyboardAction];
}
//配置子视图
-(void)setUpSubViews{
    //配置注册按钮
    _registerBtn.layer.masksToBounds = YES;
    _registerBtn.layer.cornerRadius = 5;
//    _registerBtn.layer.borderColor = [UIColor grayColor].CGColor;
//    _registerBtn.layer.borderWidth = 1;
    //设置输入框代理
    _phoneNumberTF.delegate = self;
    _securityCodeTF.delegate = self;
    _passwordTF.delegate = self;
    //配置颜色
    _registerLabel.textColor = KRGB(0, 172, 204, 1);
    [_getSecurityCodeBtn setTitleColor:KRGB(0, 172, 204, 1) forState:UIControlStateNormal];
    [_SZBdelegateBtn setTitleColor:KRGB(0, 172, 204, 1) forState:UIControlStateNormal];
    [_registerBtn setBackgroundColor:KRGB(20, 157, 192, 1)];
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
        //注册按钮
        _registerBtnHeightConstraint.constant = 40;
        [_registerBtn setNeedsLayout];
        //bgView往上弹
        _bgViewBottomConstraint.constant = height;
        [_bgView setNeedsLayout];
        _registerLabelTopConstraints.constant = 0;
        [_registerLabel setNeedsLayout];
        _registerBtnTopConstraint.constant = 10;
        [_registerBtn setNeedsLayout];
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
        //注册按钮
        _registerBtnHeightConstraint.constant = 45;
        [_registerBtn setNeedsLayout];
        //bgView往上弹
        _bgViewBottomConstraint.constant = 0;
        [_bgView setNeedsLayout];
        _registerLabelTopConstraints.constant = 20;
        [_registerLabel setNeedsLayout];
        _registerBtnTopConstraint.constant = 50;
        [_registerBtn setNeedsLayout];
        //图片放大
        _imgViewHeightConstraint.constant = 100;
        [_imgView setNeedsLayout];
    }];
}
//是否显示密码
- (IBAction)showPassword:(UIButton *)sender {
    sender.selected = !sender.selected;
    UIImage *showImg = [UIImage imageNamed:@"login_hidePassword"];
    UIImage *noShowImg = [UIImage imageNamed:@"login_showPassword"];
    if (sender.selected) {//点击》不展示
        [sender setImage:noShowImg forState:UIControlStateNormal];
        _passwordTF.secureTextEntry = NO;
    }else {//点击》展示
        [sender setImage:showImg forState:UIControlStateNormal];
        _passwordTF.secureTextEntry = YES;
    }
}
//获取验证码
- (IBAction)getSecurityCodeAction:(UIButton *)sender {
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
    [[SZBNetDataManager manager] MessagePhone:_phoneNumberTF.text andType:@"12" andRandomStamp:[ToolManager getCurrentTimeStamp] success:^(NSURLSessionDataTask *task, id responseObject) {
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
        //获取验证码失败
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
//注册
- (IBAction)registerAction:(UIButton *)sender {
    //取消第一响应
    [self.currentTF resignFirstResponder];
    //判断手机号是否输入正确
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
    //判断验证码必须是6位
    if ([_securityCodeTF.text length] != 6) {
        [_talkBtn2 setTitle:@"  验证码必须是6位  " forState:UIControlStateNormal];
        _talkBtn2.alpha = 1;
        [UIView animateWithDuration:5 animations:^{
            _talkBtn2.alpha = 0;
        }];
        [_securityCodeTF shakeWithTimes:4 speed:0.05 range:5 shakeDirection:ShakingDirectionVertical];
        return;
    }
    //判断密码不能为空
    if ([_passwordTF.text length] == 0) {
        [_talkBtn3 setTitle:@"  密码不能为空  " forState:UIControlStateNormal];
        _talkBtn3.alpha = 1;
        [UIView animateWithDuration:5 animations:^{
            _talkBtn3.alpha = 0;
        }];
        //抖一抖
        [_passwordTF shakeWithTimes:4 speed:0.05 range:5 shakeDirection:ShakingDirectionVertical];
        return;
    }
    //网络请求
    [[SZBNetDataManager manager] registerPhone:_phoneNumberTF.text andPassword:_passwordTF.text andCode:_securityCodeTF.text andRandomStamp:[ToolManager getCurrentTimeStamp] success:^(NSURLSessionDataTask *task, id responseObject) {
        //网络请求成功
        /*
         {"res":"1001","msg":"注册成功","ident_code":"ea23b4a17738fe808595211e6cd44f7f"}
         {"res":"1004","msg":"重复请求"}
         {"res":"1005","msg":"缺少必须参数"}
         {"res":"1006","msg":"该手机号已注册"}
         {"res":"1007","msg":"验证码有误"}
         {"res":"1008","msg":"验证码已经过期"}
         */
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
        NSString *resStr = [NSString stringWithFormat:@"%@",[jsonDict objectForKey:@"res"]];
        if ([resStr isEqualToString: @"1001"]) {
            //注册成功
            NSString *ident_code = [NSString stringWithFormat:@"%@",[jsonDict objectForKey:@"ident_code"]];
            [ZXUD setObject:ident_code forKey:@"ident_code"];//保存登录状态
            [ZXUD synchronize];
            Register2VC *register2_VC = [[Register2VC alloc]init];
            [self.navigationController pushViewController:register2_VC animated:YES];
            
//            UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"温馨提示" message:msgStr preferredStyle:UIAlertControllerStyleAlert];
//            //跳转到登录界面
//            UIAlertAction *login = [UIAlertAction actionWithTitle:@"去登录" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
//                [self .navigationController popToRootViewControllerAnimated:YES];
//            }];
//            //跳转到填写信息界面
//            UIAlertAction *registerGuider = [UIAlertAction actionWithTitle:@"填写个人信息" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
//                Register2VC *register2_VC = [[Register2VC alloc]init];
//                [self.navigationController pushViewController:register2_VC animated:YES];
//            }];
//            [alertC addAction:login];
//            [alertC addAction:registerGuider];
//            [self presentViewController:alertC animated:YES completion:nil];
            //登录成功，将版本号更新
            NSString *key = (NSString *)kCFBundleVersionKey;
            //新版本号
            NSString *version = [NSBundle mainBundle].infoDictionary[key];
            [ZXUD setObject:version forKey:@"firstLanch"];
            [ZXUD synchronize];
        }else if ([resStr isEqualToString: @"1006"]) {
//            //该手机号已经注册
//            UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"温馨提示" message:msgStr preferredStyle:UIAlertControllerStyleAlert];
//            UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
//            UIAlertAction *goToLogin = [UIAlertAction actionWithTitle:@"去登录" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
//                //跳转到登录界面
//                [_currentTF resignFirstResponder];//取消第一响应
//                [self.navigationController popViewControllerAnimated:YES];
//            }];
//            [alertC addAction:cancel];
//            [alertC addAction:goToLogin];
//            [self presentViewController:alertC animated:YES completion:nil];
            
            NSString *message = jsonDict[@"msg"];
            [MBProgressHUD showError:message];
        }else if ([resStr isEqualToString: @"1005"] || [resStr isEqualToString: @"1004"]) {
            
        }else{
            NSString *message = jsonDict[@"msg"];
            [MBProgressHUD showError:message];
        }
        
    } failed:^(NSURLSessionTask *task, NSError *error) {
        //网络请求失败
        [MBProgressHUD showError:@"网络请求失败"];
    }];
    //注册环信
    
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
            [_phoneNumberTF shakeWithTimes:4 speed:0.05 range:5 shakeDirection:ShakingDirectionVertical];
        }
    }
    //判断密码不能少于6位
    if (textField == _passwordTF) {
        if ([_passwordTF.text length] < 6) {
            [_talkBtn3 setTitle:@"  密码不能小于6位  " forState:UIControlStateNormal];
            _talkBtn3.alpha = 1;
            [UIView animateWithDuration:5 animations:^{
                _talkBtn3.alpha = 0;
            }];
            [_passwordTF shakeWithTimes:4 speed:0.05 range:5 shakeDirection:ShakingDirectionVertical];
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
            [_phoneNumberTF shakeWithTimes:4 speed:0.05 range:5 shakeDirection:ShakingDirectionVertical];
            return NO;
        }
    }
    //判断密码不能大于16位
    if (textField == _passwordTF) {
        if (range.location > 15) {
            [_talkBtn3 setTitle:@"  密码不能大于16位  " forState:UIControlStateNormal];
            _talkBtn3.alpha = 1;
            [UIView animateWithDuration:5 animations:^{
                _talkBtn3.alpha = 0;
            }];
            [_passwordTF shakeWithTimes:4 speed:0.05 range:5 shakeDirection:ShakingDirectionVertical];
            return NO;
        }
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


//云糖医生协议
- (IBAction)acceptSZBDelegate:(UIButton *)sender {
    sender.selected = !sender.selected;
    UIImage *seletedImg = [UIImage imageNamed:@"login_seleted"];
    UIImage *noseletedImg = [UIImage imageNamed:@"login_noseleted"];
    if (sender.selected) {//点击》不展示
        [sender setImage:seletedImg forState:UIControlStateNormal];
        [_registerBtn setBackgroundColor:KRGB(20, 157, 192, 1)];
        _registerBtn.userInteractionEnabled = YES;
    }else {//点击》展示
        [sender setImage:noseletedImg forState:UIControlStateNormal];
        [_registerBtn setBackgroundColor:[UIColor lightGrayColor]];
        _registerBtn.userInteractionEnabled = NO;
    }
}
//查看云糖医生协议详情
- (IBAction)gotoSZBDelegateVC:(UIButton *)sender {
    SZBDelegateVC *SZBDelegate_VC = [[SZBDelegateVC alloc]init];
    [self presentViewController:SZBDelegate_VC animated:YES completion:nil];
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

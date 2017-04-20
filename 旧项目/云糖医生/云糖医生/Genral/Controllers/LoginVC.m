//
//  LoginVC.m
//  yuntangyi
//
//  Created by yuntangyi on 16/9/1.
//  Copyright © 2016年 yuntangyi. All rights reserved.
//

#import "LoginVC.h"

#import "RegisterVC.h"
#import "TalkBtn.h"
#import "UIView+Shaking.h"
#import "SZBNetDataManager+RegisterAndLoginNetData.h"
#import "FindBackPasswordVC.h"
#import "SZBFmdbManager+userInfo.h"
#import "UserInfoModel.h"

#import "UMessage.h"
@interface LoginVC ()<UIScrollViewDelegate,UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UILabel *backFillInfo;

@property (weak, nonatomic) IBOutlet UIImageView *imgView;//图片
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imgViewHeightConstraint;//图片高度约束
@property (weak, nonatomic) IBOutlet UIView *bgView;//最底部UIView
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bgViewBottomConstraint;//最底部UIView的底部约束
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bgViewTopConstraint;//最底部UIView的顶部约束


@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;//底部scrollView
@property (weak, nonatomic) IBOutlet UIButton *passwordLoginBtn;//密码登录
@property (weak, nonatomic) IBOutlet UIButton *noLienceLoginBtn;//免证书登录
//密码登录
@property (weak, nonatomic) IBOutlet UITextField *userNameTF;//用户名
@property (weak, nonatomic) IBOutlet UITextField *passwordTF;//密码
@property (weak, nonatomic) IBOutlet UIButton *showPasswordBtn;//显示密码按钮
@property (weak, nonatomic) IBOutlet UIButton *forgetPasswordBtn;//忘记密码
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *forgetPasswordBtnHeightConstraint;//忘记密码按钮高度约束
//免证书登录
@property (weak, nonatomic) IBOutlet UITextField *phoneNumberTF;//手机号
@property (weak, nonatomic) IBOutlet UITextField *secturityCodeTF;//验证码
@property (weak, nonatomic) IBOutlet UIButton *getSecurityCodeBtn;//获取验证码按钮

//登录／注册／返回
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;//登录
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *loginBtnHeightConstraint;//登录按钮高度约束
@property (weak, nonatomic) IBOutlet UIButton *registerBtn;//注册
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *registerBtnHeightConstraint;//注册按钮高度约束
@property (weak, nonatomic) IBOutlet UIButton *myBackBtn;//返回
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *myBackBtnHeightConstraint;//返回按钮高度约束


@property (weak, nonatomic) IBOutlet UIView *baselineView;//底线
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *baselineViewLeftconstraint;//底线左边约束


@property (weak, nonatomic) IBOutlet TalkBtn *talkBtn1;
@property (weak, nonatomic) IBOutlet TalkBtn *talkBtn2;
@property (weak, nonatomic) IBOutlet TalkBtn *talkBtn3;
@property (weak, nonatomic) IBOutlet TalkBtn *talkBtn4;

@property (weak, nonatomic) IBOutlet UILabel *noticeLabel;//提示温馨提示 免注册登录

@property (nonatomic,strong) NSTimer *timer;//定时器 用于获取验证码倒计时
@property (nonatomic,assign) NSInteger second;//剩余时间
@property (nonatomic,strong) UIButton *currentBtn;//当前登录类型
@property (nonatomic,strong) UITextField *currentTF;//当前获取第一响应的输入框
@property (nonatomic,assign) NSInteger inputWrongPasswordCount;//输入错误密码次数

@property (nonatomic,strong) LoadingView2 *loadingView2;//登录中
@end

@implementation LoginVC

#pragma mark -懒加载
-(LoadingView2 *)loadingView2{
    if (!_loadingView2) {
        _loadingView2 = [[LoadingView2 alloc]initWithFrame:self.view.frame];
    }
    return _loadingView2;
}

#pragma mark -返回
- (IBAction)backAction:(UIButton *)sender {
    //
//    if ([self.sourceModeVC isEqualToString:@"GuideVC"]) {
//        //返回guideVC
//        [self.delegate quitLoginVCPlayMp4Again];
//    }else{
//        
//    }
    [self dismissViewControllerAnimated:YES completion:nil];
    
}
#pragma mark -注册
- (IBAction)registerAction:(UIButton *)sender {
    
    //跳转到注册界面
    RegisterVC *register_VC = [[RegisterVC alloc]init];
    register_VC.sourcePushVC = @"loginVC";
    [self.navigationController pushViewController:register_VC animated:YES];
    
}
#pragma mark -viewWillAppear
-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    //隐藏导航栏
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    //滑动到密码登录
    _currentBtn = _passwordLoginBtn;
    [self.scrollView scrollRectToVisible:CGRectMake(0, 0, self.scrollView.frame.size.width, self.scrollView.frame.size.height) animated:YES];
    //密码输入次数归零
    _inputWrongPasswordCount = 0;
    
}
#pragma mark -viewDidLoad
- (void)viewDidLoad {
    [super viewDidLoad];
    // 是否显示返回按钮
    NSString *skipGuide = [[NSUserDefaults standardUserDefaults]objectForKey:@"skipGuide"];
    if ([skipGuide isEqualToString:@"skipGuide_YES"]) {
        self.myBackBtn.hidden = YES;
        self.backFillInfo.hidden = YES;
    }else if ([skipGuide isEqualToString:@"skipGuide_NO"]) {
        self.myBackBtn.hidden = NO;
        self.backFillInfo.hidden = NO;
    }
    //是否显示注册按钮
    if ([self.sourceModeVC isEqualToString:@"GuideVC"]) {
        self.myBackBtn.hidden = YES;
        self.registerBtn.hidden = NO;
        self.backFillInfo.hidden = YES;
    }
    //是否显示backFillInfo
    if ([self.sourceModeVC isEqualToString:@"Register2VC"]) {
        self.myBackBtn.hidden = NO;
        self.backFillInfo.hidden = NO;
        self.registerBtn.hidden = YES;
    }
    //添加点击空白回收键盘
    [self addTapGestureToGetBackKeyboard];
    //配置scrollView
    [self setUpScrollView];
    //配置输入框
    [self setUpTF];
    //监听键盘弹出与回收
    [self keyboardAction];
}
//添加点击空白回收键盘
-(void)addTapGestureToGetBackKeyboard{
    self.view.userInteractionEnabled = YES;
    
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(fingerTapped:)];
    
    [self.view addGestureRecognizer:singleTap];
}
-(void)fingerTapped:(UITapGestureRecognizer *)gestureRecognizer{
    [self.view endEditing:YES];
}
//配置scrollView
-(void)setUpScrollView{
    self.scrollView.delegate = self;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.pagingEnabled = YES;
    //解决UIView动画无故偏移
    self.automaticallyAdjustsScrollViewInsets = NO;
}
//配置输入框
-(void)setUpTF{
    //设置代理
    _userNameTF.delegate = self;
    _passwordTF.delegate = self;
    _phoneNumberTF.delegate = self;
    _secturityCodeTF.delegate = self;
    
    //配置登录按钮
    _loginBtn.layer.masksToBounds = YES;
    _loginBtn.layer.cornerRadius = 5;
//    _loginBtn.layer.borderWidth = 1;
//    _loginBtn.layer.borderColor = [UIColor grayColor].CGColor;
    
    //颜色配置
    [_registerBtn setTitleColor:KRGB(0, 172, 204, 1) forState:UIControlStateNormal];
    [_passwordLoginBtn setTitleColor:KRGB(0, 172, 204, 1) forState:UIControlStateNormal];
    [_noLienceLoginBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    _baselineView.backgroundColor = KRGB(0, 172, 204, 1);
    [_getSecurityCodeBtn setTitleColor:KRGB(0, 172, 204, 1) forState:UIControlStateNormal];
    
    //是否显示忘记密码按钮
    self.forgetPasswordBtn.hidden = NO;
    //是否显示温馨提示
    self.noticeLabel.hidden = YES;
}
#pragma mark -监听键盘弹出与回收
//监听键盘弹出与回收
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
        //将返回按钮和注册按钮隐藏
        _myBackBtnHeightConstraint.constant = 0;
        [_myBackBtn setNeedsLayout];
        _registerBtnHeightConstraint.constant = 0;
        _registerBtn.alpha = 0;
        [_registerBtn setNeedsLayout];
        _backFillInfo.alpha = 0;
        [_backFillInfo setNeedsLayout];
        //bgView往上弹
        _bgViewBottomConstraint.constant = height;
        _bgViewTopConstraint.constant = 0;
        [_bgView setNeedsLayout];
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
        _registerBtnHeightConstraint.constant = 44;
        _registerBtn.alpha = 1;
        [_registerBtn setNeedsLayout];
        _backFillInfo.alpha = 1;
        [_backFillInfo setNeedsLayout];
        //bgView往上弹
        _bgViewBottomConstraint.constant = 0;
        _bgViewTopConstraint.constant = 20;
        [_bgView setNeedsLayout];
        //图片放大
        _imgViewHeightConstraint.constant = 100;
        [_imgView setNeedsLayout];
    }];
}

//点击不同的登录方式
- (IBAction)chooseLoginMode:(UIButton *)sender {
    _currentBtn = sender;
    switch (sender.tag) {
        case 1000:{//密码登录
            [UIView animateWithDuration:0.3 animations:^{
                //滑动到密码登录
                [self.scrollView scrollRectToVisible:CGRectMake(0, 0, self.scrollView.frame.size.width, self.scrollView.frame.size.height) animated:YES];
            }];
        }
            break;
        case 2000:{//免证书登录
            [UIView animateWithDuration:0.3 animations:^{
                //滑动到免证书登录
                [self.scrollView scrollRectToVisible:CGRectMake(self.scrollView.frame.size.width, 0, self.scrollView.frame.size.width, self.scrollView.frame.size.height) animated:YES];
            }];
        }
        break;
        default:
            break;
    }
}
//是否显示密码
- (IBAction)showPasswordAction:(UIButton *)sender {
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
        [_talkBtn3 setTitle:@"  请输入正确的手机号  " forState:UIControlStateNormal];
        _talkBtn3.alpha = 1;
        [UIView animateWithDuration:5 animations:^{
            _talkBtn3.alpha = 0;
        }];
        //抖一抖
        [_phoneNumberTF shakeWithTimes:4 speed:0.05 range:5 shakeDirection:ShakingDirectionVertical];
        [_phoneNumberTF becomeFirstResponder];
        return;
    }
    
    //网络请求 获取验证码
    //11 代表免注册登录验证码
    [[SZBNetDataManager manager] MessagePhone:_phoneNumberTF.text andType:@"11" andRandomStamp:[ToolManager getCurrentTimeStamp] success:^(NSURLSessionDataTask *task, id responseObject) {
        //网络请求成功
        /*
         {"res":"1001","msg":"发送成功"}
         {"res":"1004","msg":"重复请求"}
         {"res":"1005","msg":"缺少必须参数"}
         {"res":"1006","msg":"发送失败"}
         {"res":"1007","msg":"手机号已经注册"}
         {"res":"1008","msg":"该手机号未注册"}
         */
        
        NSString *resStr = [responseObject objectForKey:@"res"];
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
            UIAlertAction *goToPasswordLogin = [UIAlertAction actionWithTitle:@"去密码登录" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
                //跳转到密码登录界面
                _userNameTF.text = _phoneNumberTF.text;
                [_passwordTF becomeFirstResponder];
                [self.scrollView scrollRectToVisible:CGRectMake(0, 0, self.scrollView.frame.size.width, self.scrollView.frame.size.height) animated:YES];
            }];
            [alertC addAction:cancel];
            [alertC addAction:goToPasswordLogin];
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
//判断手机号是否输入正确
-(BOOL)checkTelNumber:(NSString *) telNumber {
    NSString *pattern = @"^1+[345678]+\\d{9}";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern];
    BOOL isMatch = [pred evaluateWithObject:telNumber];
    return isMatch;
}

//点击登录
- (IBAction)loginAction:(UIButton *)sender {
    [self.currentTF resignFirstResponder];
    NSLog(@"登录中");
    //密码登录
    if (_currentBtn == _passwordLoginBtn) {
        //判断手机号不为空
        if ([_userNameTF.text length] == 0) {
            [_talkBtn1 setTitle:@"  请输入正确的手机号  " forState:UIControlStateNormal];
            _talkBtn1.alpha = 1;
            [UIView animateWithDuration:5 animations:^{
                _talkBtn1.alpha = 0;
            }];
            //抖一抖
            [_userNameTF shakeWithTimes:4 speed:0.05 range:5 shakeDirection:ShakingDirectionVertical];
            return;
        }
        //判断密码不为空
        if ([_passwordTF.text length] == 0) {
            [_talkBtn2 setTitle:@"  密码不能为空  " forState:UIControlStateNormal];
            _talkBtn2.alpha = 1;
            [UIView animateWithDuration:5 animations:^{
                _talkBtn2.alpha = 0;
            }];
            //抖一抖
            [_passwordTF shakeWithTimes:4 speed:0.05 range:5 shakeDirection:ShakingDirectionVertical];
            return;
        }
        
        //登录中动画
        [self.view addSubview:self.loadingView2];
        [[SZBNetDataManager manager]LoginPhone:_userNameTF.text andPassword:_passwordTF.text andRandomStamp:[ToolManager getCurrentTimeStamp] success:^(NSURLSessionDataTask *task, id responseObject) {
            //网络请求成功
            [self.loadingView2 removeFromSuperview];
            
            /*
             {"res":"1001","msg":"登录成","ident_code":"41b30bdbeb1541c39c594c7ee25abeab"}
             {"res":"1004","msg":"重复请求"}
             {"res":"1005","msg":"缺少必须参数"}
             {"res":"1006","msg":"密码输入错误"}
             {"res":"1007","msg":"验证码有误"}
             {"res":"1008","msg":"验证码已经过期"}
             {"res":"1009","msg":"您的账号被禁用"}
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
            NSString *ident_code = [NSString stringWithFormat:@"%@",[jsonDict objectForKey:@"ident_code"]];
            if ([resStr isEqualToString:@"1001"]) {
                //登录成功
                [UMessage setAlias:_userNameTF.text type:@"suizhenbao" response:^(id responseObject, NSError *error) {
                }];
                [ZXUD setObject:jsonDict[@"info"][@"id"] forKey:@"ids"];//医生id;
                [ZXUD setObject:jsonDict[@"info"][@"activity_id"] forKey:@"activity_id"];//项目id;
                [ZXUD setObject:ident_code forKey:@"ident_code"];//保存登录状态
                [ZXUD setObject:_userNameTF.text forKey:@"phone"];//保存用户手机号
                [ZXUD setObject:jsonDict[@"info"][@"name"] forKey:@"name"];//保存用户名
                if ([jsonDict[@"info"][@"pic"] isKindOfClass:[NSString class]]) {
                    [ZXUD setObject:jsonDict[@"info"][@"pic"] forKey:@"pic"];//保存头像
                }
                if ([jsonDict[@"info"][@"is_check"] isEqualToString:@"1"]) {
                     [ZXUD setObject:jsonDict[@"info"][@"check_type"] forKey:@"check_type"];//保存认证类型
                }else {
                     [ZXUD setObject:@"" forKey:@"check_type"];//保存认证类型
                }
                [UMessage setAlias:@"suizhenbao" type:[ZXUD objectForKey:@"phone"] response:^(id responseObject, NSError *error) {
                }];
                //登录环信
                EMError *error2 = [[EMClient sharedClient] loginWithUsername:_userNameTF.text password:@"suizhenbao"];
                if (!error2) {
                    NSLog(@"环信登录成功");
                }
                //将登录成功请求下来的信息保存到数据库 并跳转到主界面
                [self saveLoginDataIntoDBWithInfo:[jsonDict objectForKey:@"info"]];
                
                //登录成功，将版本号更新
                NSString *key = (NSString *)kCFBundleVersionKey;
                //新版本号
                NSString *version = [NSBundle mainBundle].infoDictionary[key];
                [ZXUD setObject:version forKey:@"firstLanch"];
                [ZXUD setObject:@"skipGuide_YES" forKey:@"skipGuide"];
                [ZXUD synchronize];
            }else if ([resStr isEqualToString: @"1005"] || [resStr isEqualToString: @"1004"]) {
                
            }else {
                NSString *message = jsonDict[@"msg"];
                [MBProgressHUD showError:message toView:self.view];
            }
        } failed:^(NSURLSessionTask *task, NSError *error) {
            //网络请求失败
            [self.loadingView2 removeFromSuperview];
            [MBProgressHUD showError:@"网络请求失败"];
        }];
    }
    //免注册登录
    if (_currentBtn == _noLienceLoginBtn) {
        
        //判断手机号不为空
        if ([_phoneNumberTF.text length] == 0) {
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
        if ([_secturityCodeTF.text length] != 6) {
            [_talkBtn4 setTitle:@"  验证码必须是6位  " forState:UIControlStateNormal];
            _talkBtn4.alpha = 1;
            [UIView animateWithDuration:5 animations:^{
                _talkBtn4.alpha = 0;
            }];
            [_secturityCodeTF shakeWithTimes:4 speed:0.05 range:5 shakeDirection:ShakingDirectionVertical];
            return;
        }
        
        //登录中动画
        [self.view addSubview:self.loadingView2];
        
        [[SZBNetDataManager manager]nrloginPhone:_phoneNumberTF.text andCode:_secturityCodeTF.text andRandomStamp:[ToolManager getCurrentTimeStamp] success:^(NSURLSessionDataTask *task, id responseObject) {
            
            [self.loadingView2 removeFromSuperview];//取消登录中
            
            /*
             {"res":"1001","msg":"登录成","ident_code":"41b30bdbeb1541c39c594c7ee25abeab"}
             {"res":"1004","msg":"重复请求"}
             {"res":"1005","msg":"缺少必须参数"}
             {"res":"1006","msg":"密码输入错误"}
             {"res":"1007","msg":"验证码有误"}
             {"res":"1008","msg":"验证码已经过期"}
             {"res":"1009","msg":"您的账号被禁用"}
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
            NSString *msgStr = [NSString stringWithFormat:@"%@",[jsonDict objectForKey:@"msg"]];
            NSString *ident_code = [NSString stringWithFormat:@"%@",[jsonDict objectForKey:@"ident_code"]];
            if ([resStr isEqualToString:@"1001"]) {
                //登录成功
                
                [ZXUD setObject:ident_code forKey:@"ident_code"];//保存登录状态
                [ZXUD setObject:_userNameTF.text forKey:@"phone"];//保存用户手机号
                //登录环信
                EMError *error2 = [[EMClient sharedClient] loginWithUsername:_userNameTF.text password:@"suizhenbao"];
                if (!error2) {
                    NSLog(@"环信登录成功");
                }
                //将登录成功请求下来的信息保存到数据库 并跳转到主界面
                [self saveLoginDataIntoDBWithInfo:[jsonDict objectForKey:@"info"]];
                //登录成功，将版本号更新
                NSString *key = (NSString *)kCFBundleVersionKey;
                //新版本号
                NSString *version = [NSBundle mainBundle].infoDictionary[key];
                [ZXUD setObject:version forKey:@"firstLanch"];
                [ZXUD setObject:@"skipGuide_YES" forKey:@"skipGuide"];
                [ZXUD synchronize];                
                
            }else if ([resStr isEqualToString:@"1006"]) {
                //该手机号已经注册
                UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"温馨提示" message:msgStr preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
//                    [self.loadingView2 removeFromSuperview];//取消登录中
                }];
                UIAlertAction *goToLogin = [UIAlertAction actionWithTitle:@"去登录" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
                    //跳转到密码登录
                    [_currentTF resignFirstResponder];
                    _currentBtn = _passwordLoginBtn;
                    [self.scrollView scrollRectToVisible:CGRectMake(0, 0, self.scrollView.frame.size.width, self.scrollView.frame.size.height) animated:YES];
                }];
                [alertC addAction:cancel];
                [alertC addAction:goToLogin];
                [self presentViewController:alertC animated:YES completion:nil];
            }else if ([resStr isEqualToString: @"1005"] || [resStr isEqualToString: @"1004"]) {
                
            }else{
                NSString *message = jsonDict[@"msg"];
                [MBProgressHUD showError:message];
            }
        } failed:^(NSURLSessionTask *task, NSError *error) {
            //网络请求失败
            [self.loadingView2 removeFromSuperview];
            [MBProgressHUD showError:@"网络请求失败"];
        }];
    }
}
//点击忘记密码
- (IBAction)forgetPasswordAction:(UIButton *)sender {
    FindBackPasswordVC *findBackPassword_VC = [[FindBackPasswordVC alloc]init];
    findBackPassword_VC.userNumTF_text = self.userNameTF.text;
    [self.navigationController pushViewController:findBackPassword_VC animated:YES];
}

//底线的滑动动画
#pragma mark -UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (_scrollView.contentOffset.x < _scrollView.bounds.size.width/2) {
        _currentBtn = _passwordLoginBtn;
        [UIView animateWithDuration:0.3 animations:^{
            _baselineViewLeftconstraint.constant = 0;
            [_baselineView setNeedsLayout];
            [_baselineView layoutIfNeeded];
        }];
        //配置登录方式按钮的标题颜色
        [_passwordLoginBtn setTitleColor:KRGB(0, 172, 204, 1) forState:UIControlStateNormal];
        [_noLienceLoginBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        //是否显示忘记密码按钮
        self.forgetPasswordBtn.hidden = NO;
        //是否显示温馨提示
        self.noticeLabel.hidden = YES;
        
    }else if (_scrollView.contentOffset.x > _scrollView.bounds.size.width/2) {
        _currentBtn = _noLienceLoginBtn;
        [UIView animateWithDuration:0.3 animations:^{
            _baselineViewLeftconstraint.constant = _scrollView.frame.size.width/2;
            [_baselineView setNeedsLayout];
            [_baselineView layoutIfNeeded];
        }];
        //配置登录方式按钮的标题颜色
        [_passwordLoginBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [_noLienceLoginBtn setTitleColor:KRGB(0, 172, 204, 1) forState:UIControlStateNormal];
        
        //是否显示忘记密码按钮
        self.forgetPasswordBtn.hidden = YES;
        //是否显示温馨提示
        self.noticeLabel.hidden = NO;
    }
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
    if (textField == _userNameTF) {
        if ([_userNameTF.text length] != 11) {
            [_talkBtn1 setTitle:@"  手机号必须是11位  " forState:UIControlStateNormal];
            _talkBtn1.alpha = 1;
            [UIView animateWithDuration:5 animations:^{
                _talkBtn1.alpha = 0;
            }];
            [_userNameTF shakeWithTimes:4 speed:0.05 range:5 shakeDirection:ShakingDirectionVertical];
        }
    }
    if (textField == _phoneNumberTF) {
        if ([_phoneNumberTF.text length] != 11) {
            [_talkBtn3 setTitle:@"  手机号必须是11位  " forState:UIControlStateNormal];
            _talkBtn3.alpha = 1;
            [UIView animateWithDuration:5 animations:^{
                _talkBtn3.alpha = 0;
            }];
            [_phoneNumberTF shakeWithTimes:4 speed:0.05 range:5 shakeDirection:ShakingDirectionVertical];
        }
    }
    //判断密码不能少于6位
    if (textField == _passwordTF) {
        //判断密码不能少于6位
        if ([_passwordTF.text length] < 6) {
            [_talkBtn2 setTitle:@"  密码不能小于6位  " forState:UIControlStateNormal];
            _talkBtn2.alpha = 1;
            [UIView animateWithDuration:5 animations:^{
                _talkBtn2.alpha = 0;
            }];
            [_passwordTF shakeWithTimes:4 speed:0.05 range:5 shakeDirection:ShakingDirectionVertical];
        }
        //判断密码不能有特殊字符
    }
    //判断验证码必须是6位
    if (textField == _secturityCodeTF) {
        if ([_secturityCodeTF.text length] != 6) {
            [_talkBtn4 setTitle:@"  验证码必须是6位  " forState:UIControlStateNormal];
            _talkBtn4.alpha = 1;
            [UIView animateWithDuration:5 animations:^{
                _talkBtn4.alpha = 0;
            }];
            [_secturityCodeTF shakeWithTimes:4 speed:0.05 range:5 shakeDirection:ShakingDirectionVertical];
        }
    }
    return YES;
}
- (void)textFieldDidEndEditing:(UITextField *)textField{
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    //判断手机号长度不能大于11位
    if (textField == _userNameTF) {
        if (range.location > 10) {
            [_talkBtn1 setTitle:@"  手机号长度不能大于11位  " forState:UIControlStateNormal];
            _talkBtn1.alpha = 1;
            [UIView animateWithDuration:5 animations:^{
                _talkBtn1.alpha = 0;
            }];
            [_userNameTF shakeWithTimes:4 speed:0.05 range:5 shakeDirection:ShakingDirectionVertical];
            return NO;
        }
    }
    if (textField == _phoneNumberTF) {
        if (range.location > 10) {
            [_talkBtn3 setTitle:@"  手机号长度不能大于11位  " forState:UIControlStateNormal];
            _talkBtn3.alpha = 1;
            [UIView animateWithDuration:5 animations:^{
                _talkBtn3.alpha = 0;
            }];
            [_phoneNumberTF shakeWithTimes:4 speed:0.05 range:5 shakeDirection:ShakingDirectionVertical];
            return NO;
        }
    }
    //判断密码不能大于16位
    if (textField == _passwordTF) {
        if (range.location > 15) {
            [_talkBtn2 setTitle:@"  密码不能大于16位  " forState:UIControlStateNormal];
            _talkBtn2.alpha = 1;
            [UIView animateWithDuration:5 animations:^{
                _talkBtn2.alpha = 0;
            }];
            [_passwordTF shakeWithTimes:4 speed:0.05 range:5 shakeDirection:ShakingDirectionVertical];
            return NO;
        }
    }
    //判断验证码必须是6位
    if (textField == _secturityCodeTF) {
        if (range.location > 5) {
            [_talkBtn4 setTitle:@"  验证码必须是6位  " forState:UIControlStateNormal];
            _talkBtn4.alpha = 1;
            [UIView animateWithDuration:5 animations:^{
                _talkBtn4.alpha = 0;
            }];
            [_secturityCodeTF shakeWithTimes:4 speed:0.05 range:5 shakeDirection:ShakingDirectionVertical];
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



#pragma mark -将登录成功请求下来的数据保存到数据库
-(void)saveLoginDataIntoDBWithInfo:(NSDictionary *)info{
    //将数据保存到本地数据库
    [[SZBFmdbManager sharedManager] saveUserInfoDataIntoDBWithModelArr:@[info]];
    //获取根视图控制器对象
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    MainTabBarController *mainTabBar_C = [mainStoryboard instantiateViewControllerWithIdentifier:@"mainTab"];
    //跳转到主界面
//    NSString *ident_coed = [ZXUD objectForKey:@"ident_coed"];
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    //进入主界面
    keyWindow.rootViewController = mainTabBar_C;
    //取消第一响应
    [self.currentTF resignFirstResponder];
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

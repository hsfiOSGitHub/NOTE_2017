//
//  Register2VC.m
//  yuntangyi
//
//  Created by yuntangyi on 16/9/29.
//  Copyright © 2016年 yuntangyi. All rights reserved.
//

#import "Register2VC.h"

#import "ValueHelper.h"
#import "Register2JobVC.h"
#import "Register2ProvinceVC.h"
#import "Register2DepartmentVC.h"
#import "LoginVC.h"
#import "SZBNetDataManager+PersonalInformation.h"
#import "SZBFmdbManager+userInfo.h"

@interface Register2VC ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *nameTF;//
@property (weak, nonatomic) IBOutlet UIButton *jobBtn;//
@property (weak, nonatomic) IBOutlet UIButton *hospitalBtn;//
@property (weak, nonatomic) IBOutlet UIButton *departmentBtn;//
@property (weak, nonatomic) IBOutlet UIButton *womanBtn;//女 按钮
@property (weak, nonatomic) IBOutlet UIButton *manBtn;//男 按钮
@property (weak, nonatomic) IBOutlet UIButton *registerBtn;//

@property (weak, nonatomic) IBOutlet UILabel *jobLabel;//
@property (weak, nonatomic) IBOutlet UILabel *hospitalLabel;//
@property (weak, nonatomic) IBOutlet UILabel *departmentLabel;//

@property (nonatomic,strong) UIActivityIndicatorView *loadingView;//加载中
@end

@implementation Register2VC
#pragma mark -懒加载

#pragma mark -导航栏设置
-(void)setUpNavi{
    self.navigationController.navigationBar.translucent = NO;
    //返回按钮
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"返回"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStyleDone target:self action:@selector(backAction)];
}
//返回
-(void)backAction{
//    [self.delegate playMp4Again];
//    [self.navigationController popViewControllerAnimated:YES];
//    //将ValueHelper中的数据清除
//    [ValueHelper sharedHelper].registerName = nil;
//    [ValueHelper sharedHelper].registerJob = nil;
//    [ValueHelper sharedHelper].registerHospital = nil;
//    [ValueHelper sharedHelper].registerDepartment = nil;
//    [ValueHelper sharedHelper].registerSex = nil;
    [MBProgressHUD showError:@"请填写资料"];
}

#pragma mark -viewWillAppear
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //显示导航栏
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    //通知栏
//    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
    //
    self.navigationController.navigationBarHidden = NO;
    self.navigationController.navigationBar.barTintColor = KRGB(253, 254, 255, 1);
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSFontAttributeName:[UIFont systemFontOfSize:20],NSForegroundColorAttributeName:KRGB(0, 172, 204, 1)}];
    //赋值
    _nameTF.text = [ValueHelper sharedHelper].registerName;
    _jobLabel.text = [ValueHelper sharedHelper].registerJob[@"title"];
    _hospitalLabel.text = [ValueHelper sharedHelper].registerHospital[@"name"];
    _departmentLabel.text = [ValueHelper sharedHelper].registerDepartment[@"name"];
    
    UIImage *manImg = [UIImage imageNamed:@"man"];
    UIImage *man_hdImg = [UIImage imageNamed:@"man_hd"];
    UIImage *womanImg = [UIImage imageNamed:@"woman"];
    UIImage *woman_hdImg = [UIImage imageNamed:@"woman_hd"];
    if ([[ValueHelper sharedHelper].registerSex isEqualToString:@"0"]) {
        [_manBtn setImage:man_hdImg forState:UIControlStateNormal];
        [_womanBtn setImage:womanImg forState:UIControlStateNormal];
    }else if ([[ValueHelper sharedHelper].registerSex isEqualToString:@"1"]) {
        [_manBtn setImage:manImg forState:UIControlStateNormal];
        [_womanBtn setImage:woman_hdImg forState:UIControlStateNormal];
    }
   
}
#pragma mark -viewDidLoad
- (void)viewDidLoad {
    [super viewDidLoad];
    //标题
    self.navigationItem.title = @"欢迎注册";
    //导航栏设置
    [self setUpNavi];
    //配置nameTF
    self.nameTF.delegate = self;
    //添加点击空白回收键盘
    [self addTapGestureToGetBackKeyboard];
}
#pragma mark -viewWillDisappear
-(void)viewWillDisappear:(BOOL)animated{
    [_nameTF resignFirstResponder];
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
#pragma mark -UITextFieldDelegate
//名字
- (void)textFieldDidEndEditing:(UITextField *)textField{
    [ValueHelper sharedHelper].registerName = textField.text;
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [ValueHelper sharedHelper].registerName = textField.text;
    [textField resignFirstResponder];
    
    return YES;
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if (range.location > 11) {
        return NO;
    }
    return YES;
}

//选择职称
- (IBAction)jobBtnAction:(UIButton *)sender {
    Register2JobVC *job_VC = [[Register2JobVC alloc]init];
    [self.navigationController pushViewController:job_VC animated:YES];
}
//选择医院
- (IBAction)hospitalBtnAction:(UIButton *)sender {
    [ValueHelper sharedHelper].registerGuider = @"registerGuider";
    Register2ProvinceVC *register2Province_VC = [[Register2ProvinceVC alloc]init];
    UINavigationController *navi = [[UINavigationController alloc]initWithRootViewController:register2Province_VC];
    [self presentViewController:navi animated:YES completion:nil];
}
//选择科室
- (IBAction)departmentBtnAction:(UIButton *)sender {
    [ValueHelper sharedHelper].registerGuider = @"registerGuider";
    Register2DepartmentVC *department_VC = [[Register2DepartmentVC alloc]init];
    [self.navigationController pushViewController:department_VC animated:YES];
}
//点击男
- (IBAction)manBtnAction:(UIButton *)sender {
    UIImage *man_hdImg = [UIImage imageNamed:@"man_hd"];
    UIImage *womanImg = [UIImage imageNamed:@"woman"];
    [_manBtn setImage:man_hdImg forState:UIControlStateNormal];
    [_womanBtn setImage:womanImg forState:UIControlStateNormal];
    //存入ValueHelper
    [ValueHelper sharedHelper].registerSex = @"0";
}
//点击女
- (IBAction)womanBtnAction:(UIButton *)sender {
    UIImage *manImg = [UIImage imageNamed:@"man"];
    UIImage *woman_hdImg = [UIImage imageNamed:@"woman_hd"];
    [_manBtn setImage:manImg forState:UIControlStateNormal];
    [_womanBtn setImage:woman_hdImg forState:UIControlStateNormal];
    //存入ValueHelper
    [ValueHelper sharedHelper].registerSex = @"1";
}
//填写资料完毕
- (IBAction)okBtn:(UIButton *)sender {
    [self loadDoctor_update_UrlData];
    //跳转转到登录界面
//    LoginVC *login_VC = [[LoginVC alloc]init];
//    login_VC.sourceModeVC = @"Register2VC";
//    UINavigationController *navi = [[UINavigationController alloc]initWithRootViewController:login_VC];
//    [self presentViewController:navi animated:YES completion:nil];
}

#pragma mark -网络请求数据 （上传到服务器）
-(void)loadDoctor_update_UrlData{
    //加载中动画
    self.loadingView = [[UIActivityIndicatorView alloc]initWithFrame:CGRectMake(0, 0, 60, 60)];
    self.loadingView.center = CGPointMake(KScreenWidth/2, KScreenHeight/2 - 32);
    [self.view addSubview:self.loadingView];
    self.loadingView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
    self.loadingView.backgroundColor = [UIColor darkGrayColor];
    self.loadingView.layer.masksToBounds = YES;
    self.loadingView.layer.cornerRadius = 10;
    [self.loadingView startAnimating];
    
    SZBNetDataManager *manager = [SZBNetDataManager manager];
    [manager doctor_updateWithRandomString:[ToolManager getCurrentTimeStamp]
                             andIdent_code:[ZXUD objectForKey:@"ident_code"]
                                    andHid:[ValueHelper sharedHelper].registerHospital[@"id"]
                                    andDid:[ValueHelper sharedHelper].registerDepartment[@"id"]
                                 andGender:[ValueHelper sharedHelper].registerSex
                                andContent:@""
                                  andDo_at:@""
                                   andName:[ValueHelper sharedHelper].registerName
                                   andTtid:[ValueHelper sharedHelper].registerJob[@"ttid"]
                                   success:^(NSURLSessionDataTask *task, id responseObject) {
                                       
        //网络请求成功
        [self.loadingView removeFromSuperview];
        if ([responseObject[@"res"] isEqualToString:@"1001"]) {
            [MBProgressHUD showSuccess:responseObject[@"msg"]];
//            //跳转转到登录界面
//            LoginVC *login_VC = [[LoginVC alloc]init];
//            login_VC.sourceModeVC = @"Register2VC";
//            UINavigationController *navi = [[UINavigationController alloc]initWithRootViewController:login_VC];
//            [self presentViewController:navi animated:YES completion:nil];
            
            //将登录成功请求下来的信息保存到数据库 并跳转到主界面
            [self saveLoginDataIntoDBWithInfo:[responseObject objectForKey:@"info"]];
            
        }else if ([responseObject[@"res"] isEqualToString:@"1005"]){
            [MBProgressHUD showError:@"基本信息未填写完整"];
        }else if ([responseObject[@"res"] isEqualToString:@"1005"]){
            
        }else {
            [MBProgressHUD showError:responseObject[@"msg"]];
        }
    } failed:^(NSURLSessionTask *task, NSError *error) {
        //网络请求失败
        [self.loadingView removeFromSuperview];
        [MBProgressHUD showError:@"网络错误"];
    }];
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

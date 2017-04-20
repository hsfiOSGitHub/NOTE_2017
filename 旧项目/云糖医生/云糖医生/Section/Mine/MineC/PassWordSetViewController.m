//
//  PassWordSetViewController.m
//  yuntangyi
//
//  Created by yuntangyi on 16/9/26.
//  Copyright © 2016年 yuntangyi. All rights reserved.
//

#import "PassWordSetViewController.h"
#import "SZBNetDataManager+RegisterAndLoginNetData.h"

@interface PassWordSetViewController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *oldPassWordTF;
@property (weak, nonatomic) IBOutlet UITextField *PassWordTF1;
@property (weak, nonatomic) IBOutlet UITextField *PassWordTF2;

@end

@implementation PassWordSetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.oldPassWordTF.delegate = self;
    self.PassWordTF1.delegate = self;
    self.PassWordTF2.delegate = self;
    self.navigationItem.title = @"修改密码";
    self.navigationController.navigationBar.translucent = NO;
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, 44, 44);
    [btn setTitle:@"保存" forState:UIControlStateNormal];
    [btn setTitleColor: KRGB(0, 172, 204, 1.0) forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(saveAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithCustomView:btn];
    [rightItem setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17],NSForegroundColorAttributeName:KRGB(0, 172, 204, 1.0)} forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem = rightItem;
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"返回"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStyleDone target:self action:@selector(goToBack)];
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if (textField == _oldPassWordTF) {
        if (range.location > 15) {
            [MBProgressHUD showError:@"密码位数必须为6-16位"];
            _oldPassWordTF.text = [_oldPassWordTF.text substringToIndex:16];
            return NO;
        }
        return YES;
    }else if(textField == _PassWordTF1){
        if (range.location > 15) {
            [MBProgressHUD showError:@"密码位数必须为6-16位"];
            _PassWordTF1.text = [_PassWordTF1.text substringToIndex:16];
            return NO;
        }
        return YES;
    }else {
        if (range.location > 15) {
           [MBProgressHUD showError:@"密码位数必须为6-16位"];
            _PassWordTF2.text = [_PassWordTF2.text substringToIndex:16];
            return NO;
        }
        return YES;
    }
}
//保存
- (void)saveAction {
    if (self.oldPassWordTF.text.length == 0){
       [MBProgressHUD showSuccess:@"请输入旧密码"];
    }else if (_PassWordTF1.text.length == 0){
        [MBProgressHUD showSuccess:@"请输入新的密码"];
    }else if (_PassWordTF2.text.length == 0){
        
        [MBProgressHUD showSuccess:@"请确认新的密码"];
    }else if (_PassWordTF1.text.length < 6){
        
        [MBProgressHUD showSuccess:@"密码位数小于6位，请您重新输入"];
    }else if (![self.PassWordTF1.text isEqualToString:self.PassWordTF2.text]) {
        
        [MBProgressHUD showSuccess:@"密码不一致, 请重新输入"];
    }else {
      [MBProgressHUD showMessage:@"请稍后" toView:self.view];
      [[SZBNetDataManager manager]updatePasswordIdentCode:[ZXUD objectForKey:@"ident_code"] andOldPassWord:_oldPassWordTF.text andNewPassWord:_PassWordTF1.text andRandomStamp:[ToolManager getCurrentTimeStamp] success:^(NSURLSessionDataTask *task, id responseObject) {
          [MBProgressHUD hideHUDForView:self.view];
          if ([responseObject[@"res"] isEqualToString:@"1002"]) {
              UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"登录状态已过期, 请重新登录" message:nil preferredStyle:UIAlertControllerStyleAlert];
              
              UIAlertAction *anotherAction = [UIAlertAction actionWithTitle:@"登录" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
                  //让用户重新登录
                  [ZXUD setObject:nil forKey:@"ident_code"];
                  LoginVC *VC = [[LoginVC alloc] init];
                  UINavigationController *navi = [[UINavigationController alloc]initWithRootViewController:VC];
                  [self presentViewController:navi animated:YES completion:nil];
              }];
              [alert addAction:anotherAction];
              
              [self presentViewController:alert animated:YES completion:^{
                  
              }];
          }else if ([responseObject[@"res"] isEqualToString:@"1001"]) {
             [MBProgressHUD showError:responseObject[@"msg"]];
              //让用户重新登录
              [ZXUD setObject:nil forKey:@"ident_code"];
              LoginVC *VC = [[LoginVC alloc] init];
              UINavigationController *navi = [[UINavigationController alloc]initWithRootViewController:VC];
              [self presentViewController:navi animated:YES completion:nil];
          }else {
             [MBProgressHUD showError:responseObject[@"msg"]];
          }

      } failed:^(NSURLSessionTask *task, NSError *error) {
          [MBProgressHUD hideHUDForView:self.view];
          [MBProgressHUD showError:@"网络错误"];
      }];
        
    }
}
- (void)goToBack {
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
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

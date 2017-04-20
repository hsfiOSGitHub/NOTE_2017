//
//  ZXOpinionFeedBackVC.h
//
//
//  Created by yuntangyi on 16/9/22.
//  Copyright © 2016年 ZX. All rights reserved.
//

#import "ZXOpinionFeedBackVC.h"
#import "SZBNetDataManager+RegisterAndLoginNetData.h"

@interface ZXOpinionFeedBackVC ()<UITextViewDelegate, UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextView *opinionTextView;
@property (weak, nonatomic) IBOutlet UITextField *phoneTextFiled;
@property (weak, nonatomic) IBOutlet UILabel *placeholderLable;

@property (nonatomic,copy) NSString *res;

@end

@implementation ZXOpinionFeedBackVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"反馈内容";
    self.view.backgroundColor = J_BackLightGray;
    self.navigationController.navigationBar.translucent = NO;
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, 44, 44);
    [btn setTitle:@"提交" forState:UIControlStateNormal];
    [btn setTitleColor: KRGB(0, 172, 204, 1.0) forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(submitInfo) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithCustomView:btn];
    [rightItem setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17],NSForegroundColorAttributeName:KRGB(0, 172, 204, 1.0)} forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem = rightItem;
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"返回"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStyleDone target:self action:@selector(goToBack)];
    [self UISet];
    // Do any additional setup after loading the view from its nib.
}
-(void)UISet{
    self.placeholderLable.text = @"请输入您的意见，我们将为您不断改进~~";
    self.opinionTextView.delegate = self;
    self.phoneTextFiled.delegate = self;
}
//开始编辑
-(void)textViewDidBeginEditing:(UITextView *)textView
{
    //开始编辑时，让占位Label内容为空
    self.placeholderLable.text = @"";
}

//结束编辑
-(void)textViewDidEndEditing:(UITextView *)textView
{
    //结束编辑时，占位Label根据内容判断内容
    if (self.opinionTextView.text.length == 0) {
        self.placeholderLable.text = @"请输入您的意见，我们将为您不断改进~~";
    }else{
        self.placeholderLable.text = @"";
    }
}
//检查电话号码是否正确
-(BOOL)checkTelNumber:(NSString *) telNumber
{
    NSString *pattern = @"^1+[345678]+\\d{9}";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern];
    BOOL isMatch = [pred evaluateWithObject:telNumber];
    return isMatch;
}
//手机号输入框 动态监控
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if (textField == _phoneTextFiled) {
        if (range.location > 10) {
              [MBProgressHUD showError:@"手机号码为11位"];
            _phoneTextFiled.text = [_phoneTextFiled.text substringToIndex:11];
            return NO;
        }
        return YES;
    }else {
        return YES;
    }
}

- (void) goToBack {
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)submitInfo {
    if (_opinionTextView.text.length == 0) {
        [MBProgressHUD showError:@"请您提出宝贵意见"];
    }else if (_phoneTextFiled.text.length != 0){
        if (![self checkTelNumber:_phoneTextFiled.text]) {
            [MBProgressHUD showError:@"请输入正确的手机号码"];
        }else {
            //提交反馈
        [self commitFeed];
            
        }
    }else{
        //提交反馈
        [self commitFeed];
    }
}
- (void)commitFeed {
    [MBProgressHUD showMessage:@"请稍后" toView:self.view];
    [[SZBNetDataManager manager] feedbackRandomStamp:[ToolManager getCurrentTimeStamp] andPhone:_phoneTextFiled.text andContent:_opinionTextView.text andVersion:[ToolManager getVersion] success:^(NSURLSessionDataTask *task, id responseObject) {
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
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                 [self.navigationController popViewControllerAnimated:YES];
            });
        }else {
              [MBProgressHUD showError:responseObject[@"msg"]];
        }
       
    } failed:^(NSURLSessionTask *task, NSError *error) {
        [MBProgressHUD hideHUDForView:self.view];
       [MBProgressHUD showError:@"网络错误"];
    }];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [[UIApplication sharedApplication].keyWindow endEditing:YES];
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

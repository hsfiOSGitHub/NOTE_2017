//
//  UserExperienceVC.m
//  yuntangyi
//
//  Created by yuntangyi on 16/9/23.
//  Copyright © 2016年 yuntangyi. All rights reserved.
//

#import "UserExperienceVC.h"

@interface UserExperienceVC ()<UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UITextView *experienceTextView;//textView
@property (weak, nonatomic) IBOutlet UILabel *placeholder;

@end

@implementation UserExperienceVC

#pragma mark -懒加载
#pragma mark -viewWillAppear
-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSFontAttributeName:[UIFont systemFontOfSize:20],NSForegroundColorAttributeName:KRGB(0, 172, 204, 1.0)}];
}
#pragma mark -配置导航栏
-(void)setUpNavi{
    self.navigationController.navigationBar.translucent = NO;
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"返回"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStyleDone target:self action:@selector(backAction)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStyleDone target:self action:@selector(submitInfo:)];
     self.navigationItem.rightBarButtonItem.tintColor = KRGB(0, 172, 204, 1.0);
     [self UISet];
}

-(void)UISet{
   
    self.experienceTextView.delegate = self;
    if ([self.content isKindOfClass:[NSString class]] && ![self.content isEqualToString:@""]) {
         _experienceTextView.text = self.content;
    }else {
         self.placeholder.text = @"请编辑个人经历";
    }
   
}
//开始编辑
-(void)textViewDidBeginEditing:(UITextView *)textView
{
    //开始编辑时，让占位Label内容为空
    self.placeholder.text = @"";
}
//结束编辑
-(void)textViewDidEndEditing:(UITextView *)textView
{
    //结束编辑时，占位Label根据内容判断内容
    if (self.experienceTextView.text.length == 0) {
        self.placeholder.text = @"请编辑个人经历";
    }else{
        self.placeholder.text = @"";
    }
}
-(void)backAction{
    
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)submitInfo:(UIBarButtonItem *)sender{
    if (_experienceTextView.text.length == 0) {
        [MBProgressHUD showError:@"您还没有编辑经历"];
    }else {
        //传数据
        [[NSNotificationCenter defaultCenter] postNotificationName:UserInfoExperienceNoti object:nil userInfo:@{@"conent":_experienceTextView.text}];
        [self.navigationController popViewControllerAnimated:YES];
    }
   
}
#pragma mark -viewDidLoad
- (void)viewDidLoad {
    [super viewDidLoad];
    //标题
    self.navigationItem.title = @"编辑个人经历";
    //配置导航栏
    [self setUpNavi];
   
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [[UIApplication sharedApplication].keyWindow endEditing:YES];
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

//
//  EditScheduleContentVC.m
//  CalendarDemo
//
//  Created by monkey2016 on 16/12/28.
//  Copyright © 2016年 monkey2016. All rights reserved.
//

#import "EditScheduleContentVC.h"

@interface EditScheduleContentVC ()<UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UITextView *contentTV;
@property (weak, nonatomic) IBOutlet UIButton *saveBtn;
@property (weak, nonatomic) IBOutlet UILabel *placeholder;

//键盘调用时
@property (nonatomic,strong) UIView *keyboardTool;

@end

@implementation EditScheduleContentVC

#pragma mark -懒加载
-(UIView *)keyboardTool{
    if (!_keyboardTool) {
        _keyboardTool = [[UIView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, 40)];
        _keyboardTool.backgroundColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.6];
        UIButton *hiddenBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        hiddenBtn.frame = CGRectMake(KScreenWidth - 50, 0, 40, 40);
        [hiddenBtn setImage:[UIImage imageNamed:@"keyboard_common"] forState:UIControlStateNormal];
        [hiddenBtn addTarget:self action:@selector(hiddenBtnACTION:) forControlEvents:UIControlEventTouchUpInside];
        [_keyboardTool addSubview:hiddenBtn];
    }
    return _keyboardTool;
}
-(void)hiddenBtnACTION:(UIButton *)sender{
    [self.view endEditing:YES];//收回键盘
}
#pragma mark -配置导航栏
-(void)setUpNavi{
    self.automaticallyAdjustsScrollViewInsets = NO;
    //标题
    self.navigationItem.title = @"编辑备注";
    //返回
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"back_common"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStyleDone target:self action:@selector(backAction)];
    
}
//返回
-(void)backAction{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark -viewWillAppear
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.barTintColor = KRGB(52, 168, 238, 1.0);
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSFontAttributeName:[UIFont systemFontOfSize:20],NSForegroundColorAttributeName:[UIColor whiteColor]}];
}
#pragma mark -viewDidLoad
- (void)viewDidLoad {
    [super viewDidLoad];
    //配置导航栏
    [self setUpNavi];
    self.contentTV.delegate = self;
    //初始化内容
    if ([self.contentStr isEqualToString:@""]) {
        self.placeholder.hidden = NO;
    }else{
        self.placeholder.hidden = YES;
    }
    self.contentTV.text = self.contentStr;
    
    self.contentTV.inputAccessoryView = self.keyboardTool;
    //给self.view添加单击手势
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hiddenBtnACTION:)];
    [self.view addGestureRecognizer:singleTap];
}

#pragma mark -UITextViewDelegate
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    if ([textView.text isEqualToString:@""]) {
        self.placeholder.hidden = NO;
    }else{
        self.placeholder.hidden = YES;
    }
    return YES;
}
- (void)textViewDidChange:(UITextView *)textView{
    if ([textView.text isEqualToString:@""]) {
        self.placeholder.hidden = NO;
    }else{
        self.placeholder.hidden = YES;
    }
}
- (void)textViewDidEndEditing:(UITextView *)textView{
    if ([textView.text isEqualToString:@""]) {
        self.placeholder.hidden = NO;
    }else{
        self.placeholder.hidden = YES;
    }
}

//点击保存
- (IBAction)saveBtnACTION:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(endEditContentWith:)]) {
        [self.delegate endEditContentWith:self.contentTV.text];
    }
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark -didReceiveMemoryWarning
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

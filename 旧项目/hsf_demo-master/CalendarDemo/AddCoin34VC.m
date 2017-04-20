//
//  AddCoin34VC.m
//  CalendarDemo
//
//  Created by monkey2016 on 17/1/13.
//  Copyright © 2017年 monkey2016. All rights reserved.
//

#import "AddCoin34VC.h"

@interface AddCoin34VC ()<UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UILabel *zhi;
@property (weak, nonatomic) IBOutlet UIButton *startBtn;
@property (weak, nonatomic) IBOutlet UIButton *endBtn;

@property (weak, nonatomic) IBOutlet UIButton *levelBtn1;
@property (weak, nonatomic) IBOutlet UIButton *levelBtn2;
@property (weak, nonatomic) IBOutlet UIButton *levelBtn3;
@property (weak, nonatomic) IBOutlet UIButton *levelBtn4;
@property (weak, nonatomic) IBOutlet UIButton *levelBtn5;
@property (weak, nonatomic) IBOutlet UITextView *contentTV;
@property (weak, nonatomic) IBOutlet UIButton *OKBtn;

@property (nonatomic,strong) NSString *colorStr;//1,2,3,4,5

@property (nonatomic,strong) DatePicker24HoursView *hour24Picker;

//键盘
@property (nonatomic,strong) UIView *keyboardTool;
@property (nonatomic,strong) UITapGestureRecognizer *endEditingTap;//弹出键盘时点击空白退出键盘

@end

@implementation AddCoin34VC
#pragma mark -懒加载
-(NSString *)colorStr{
    if (!_colorStr) {
        _colorStr = @"1";
    }
    return _colorStr;
}
-(DatePicker24HoursView *)hour24Picker{
    if (!_hour24Picker) {
        _hour24Picker = [[DatePicker24HoursView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    }
    return _hour24Picker;
}
-(UIView *)keyboardTool{
    if (!_keyboardTool) {
        _keyboardTool = [[UIView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, 40)];
        _keyboardTool.backgroundColor = [KRGB(255, 147, 18, 1) colorWithAlphaComponent:1];
        UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        rightBtn.frame = CGRectMake(KScreenWidth - 50, 0, 40, 40);
        [rightBtn setImage:[UIImage imageNamed:@"keyboard_right_common"] forState:UIControlStateNormal];
        [rightBtn addTarget:self action:@selector(rightBtnACTION:) forControlEvents:UIControlEventTouchUpInside];
        [_keyboardTool addSubview:rightBtn];
    }
    return _keyboardTool;
}

#pragma mark -配置导航栏
-(void)setUpNavi{
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.automaticallyAdjustsScrollViewInsets = NO;
    //退出
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[[UIImage imageNamed:@"back_common"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(backAction)];
}
//退出
-(void)backAction{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark -viewWillAppear
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.barTintColor = KRGB(255, 147, 18, 1.0);
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSFontAttributeName:[UIFont systemFontOfSize:20],NSForegroundColorAttributeName:[UIColor whiteColor]}];
    self.navigationItem.title = @"新建事项";
}
#pragma mark -viewDidLoad
- (void)viewDidLoad {
    [super viewDidLoad];
    //配置导航栏
    [self setUpNavi];
    //配置subviews
    [self setUpSubViews];
    //注册通知
    [self registerNotification];
}
//配置subviews
-(void)setUpSubViews{
    //时间
    self.zhi.layer.masksToBounds = YES;
    self.zhi.layer.cornerRadius = 12;
    if ([self.addOrModify isEqualToString:@"add"]) {
        __block NSString *startStr;
        NSString *endStr;
        for (NSString *key in self.timeArr) {
            if ([self.contentDic[key] isEqualToString:@""]) {
                startStr = key;
                break;
            }
        }
        NSArray *arr = [startStr componentsSeparatedByString:@":"];
        if ([arr[1] isEqualToString:@"00"]) {
            endStr = [NSString stringWithFormat:@"%@:30",arr[0]];
        }else{
            NSString *hour = [NSString stringWithFormat:@"%02ld",([arr[0] integerValue]+1)];
            endStr = [NSString stringWithFormat:@"%@:00",hour];
        }
        [self.startBtn setTitle:startStr forState:UIControlStateNormal];
        [self.endBtn setTitle:endStr forState:UIControlStateNormal];
    }else if ([self.addOrModify isEqualToString:@"modify"]) {
        //时间
        NSString *startStr = self.timeArr[self.clickIndex];
        NSString *endStr;
        if (self.clickIndex == self.timeArr.count - 1) {
            endStr = @"00:00";
        }else{
            endStr = self.timeArr[self.clickIndex + 1];
        }
        [self.startBtn setTitle:startStr forState:UIControlStateNormal];
        [self.endBtn setTitle:endStr forState:UIControlStateNormal];
        //颜色
        [self.levelBtn1 setImage:[UIImage imageNamed:@"color_level1_small_34coins"] forState:UIControlStateNormal];
        [self.levelBtn2 setImage:[UIImage imageNamed:@"color_level2_small_34coins"] forState:UIControlStateNormal];
        [self.levelBtn3 setImage:[UIImage imageNamed:@"color_level3_small_34coins"] forState:UIControlStateNormal];
        [self.levelBtn4 setImage:[UIImage imageNamed:@"color_level4_small_34coins"] forState:UIControlStateNormal];
        [self.levelBtn5 setImage:[UIImage imageNamed:@"color_level5_small_34coins"] forState:UIControlStateNormal];
        if ([self.colorDic[startStr] isEqualToString:@"0"]) {
            [self.levelBtn1 setImage:[UIImage imageNamed:@"color_level1_34coins"] forState:UIControlStateNormal];
        }else if ([self.colorDic[startStr] isEqualToString:@"1"]) {
            [self.levelBtn1 setImage:[UIImage imageNamed:@"color_level1_34coins"] forState:UIControlStateNormal];
        }else if ([self.colorDic[startStr] isEqualToString:@"2"]) {
            [self.levelBtn2 setImage:[UIImage imageNamed:@"color_level2_34coins"] forState:UIControlStateNormal];
        }else if ([self.colorDic[startStr] isEqualToString:@"3"]) {
            [self.levelBtn3 setImage:[UIImage imageNamed:@"color_level3_34coins"] forState:UIControlStateNormal];
        }else if ([self.colorDic[startStr] isEqualToString:@"4"]) {
            [self.levelBtn4 setImage:[UIImage imageNamed:@"color_level4_34coins"] forState:UIControlStateNormal];
        }else if ([self.colorDic[startStr] isEqualToString:@"5"]) {
            [self.levelBtn5 setImage:[UIImage imageNamed:@"color_level5_34coins"] forState:UIControlStateNormal];
        }
        //内容
        self.contentTV.text = self.contentDic[startStr];
    }
    

    //类别
    [self.levelBtn1 layoutButtonWithEdgeInsetsStyle:HSFButtonEdgeInsetsStyleTop imageTitleSpace:5];
    [self.levelBtn2 layoutButtonWithEdgeInsetsStyle:HSFButtonEdgeInsetsStyleTop imageTitleSpace:5];
    [self.levelBtn3 layoutButtonWithEdgeInsetsStyle:HSFButtonEdgeInsetsStyleTop imageTitleSpace:5];
    [self.levelBtn4 layoutButtonWithEdgeInsetsStyle:HSFButtonEdgeInsetsStyleTop imageTitleSpace:5];
    [self.levelBtn5 layoutButtonWithEdgeInsetsStyle:HSFButtonEdgeInsetsStyleTop imageTitleSpace:5];
    //事件
    self.contentTV.delegate = self;
    self.contentTV.inputAccessoryView = self.keyboardTool;
    //完成
    self.OKBtn.layer.masksToBounds = YES;
    self.OKBtn.layer.cornerRadius = 10;
}

#pragma mark -点击开始结束时间，弹出24小时时间选择器
- (IBAction)timeBtnACTION:(UIButton *)sender {
    [self.view endEditing:YES];
    [KMyWindow addSubview:self.hour24Picker];
    switch (sender.tag) {
        case 1000:{//开始时间
            self.hour24Picker.dateType = @"开始时间";
            self.hour24Picker.descLabel.text = [NSString stringWithFormat:@"开始时间:%@",self.startBtn.titleLabel.text];
        }
            break;
        case 2000:{//结束时间
            self.hour24Picker.dateType = @"结束时间";
            self.hour24Picker.descLabel.text = [NSString stringWithFormat:@"结束时间:%@",self.endBtn.titleLabel.text];
        }
            break;
            
        default:
            break;
    }
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.hour24Picker show];
    });
    
}

#pragma mark -点击类别按钮
- (IBAction)levelBtnACTION:(UIButton *)sender {
    [self.levelBtn1 setImage:[UIImage imageNamed:@"color_level1_small_34coins"] forState:UIControlStateNormal];
    [self.levelBtn2 setImage:[UIImage imageNamed:@"color_level2_small_34coins"] forState:UIControlStateNormal];
    [self.levelBtn3 setImage:[UIImage imageNamed:@"color_level3_small_34coins"] forState:UIControlStateNormal];
    [self.levelBtn4 setImage:[UIImage imageNamed:@"color_level4_small_34coins"] forState:UIControlStateNormal];
    [self.levelBtn5 setImage:[UIImage imageNamed:@"color_level5_small_34coins"] forState:UIControlStateNormal];
    switch (sender.tag) {
        case 100:{//尽兴娱乐
            [self.levelBtn1 setImage:[UIImage imageNamed:@"color_level1_34coins"] forState:UIControlStateNormal];
            self.colorStr = @"1";
        }
            break;
        case 200:{//休息放松
            [self.levelBtn2 setImage:[UIImage imageNamed:@"color_level2_34coins"] forState:UIControlStateNormal];
            self.colorStr = @"2";
        }
            break;
        case 300:{//高效工作
            [self.levelBtn3 setImage:[UIImage imageNamed:@"color_level3_34coins"] forState:UIControlStateNormal];
            self.colorStr = @"3";
        }
            break;
        case 400:{//强迫工作
            [self.levelBtn4 setImage:[UIImage imageNamed:@"color_level4_34coins"] forState:UIControlStateNormal];
            self.colorStr = @"4";
        }
            break;
        case 500:{//无效工作
            [self.levelBtn5 setImage:[UIImage imageNamed:@"color_level5_34coins"] forState:UIControlStateNormal];
            self.colorStr = @"5";
        }
            break;
            
        default:
            break;
    }
    [self.levelBtn1 layoutButtonWithEdgeInsetsStyle:HSFButtonEdgeInsetsStyleTop imageTitleSpace:5];
    [self.levelBtn2 layoutButtonWithEdgeInsetsStyle:HSFButtonEdgeInsetsStyleTop imageTitleSpace:5];
    [self.levelBtn3 layoutButtonWithEdgeInsetsStyle:HSFButtonEdgeInsetsStyleTop imageTitleSpace:5];
    [self.levelBtn4 layoutButtonWithEdgeInsetsStyle:HSFButtonEdgeInsetsStyleTop imageTitleSpace:5];
    [self.levelBtn5 layoutButtonWithEdgeInsetsStyle:HSFButtonEdgeInsetsStyleTop imageTitleSpace:5];
}
#pragma mark -点击完成按钮
- (IBAction)OKBtnACTION:(UIButton *)sender {
    //检查时间是否正确
    NSArray *startArr = [self.startBtn.titleLabel.text componentsSeparatedByString:@":"];
    NSArray *endArr = [self.endBtn.titleLabel.text componentsSeparatedByString:@":"];
    NSInteger start = [startArr[0] integerValue]*60 + [startArr[1] integerValue];
    NSInteger end = [endArr[0] integerValue]*60 + [endArr[1] integerValue];
    NSInteger deta = end - start;
    if (deta <= 0) {
        [MBProgressHUD showError:@"开始时间必须早于结束时间"];
        return;
    }
    //内容不能为空
    if ([self.contentTV.text isEqualToString:@""]) {
        [MBProgressHUD showError:@"请填写事件内容"];
        return;
    }
    //保存->返回到好时光页面
    NSInteger startIndex =  [self.timeArr indexOfObject:self.startBtn.titleLabel.text];
    NSInteger endIndex =  [self.timeArr indexOfObject:self.endBtn.titleLabel.text];
    for (NSInteger i = startIndex; i < endIndex; i++) {
        if (![self.contentDic[self.timeArr[i]] isEqualToString:@""]) {
            UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"在该时间区间内已有事件，是否覆盖？" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
            UIAlertAction *ok = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    if ((endIndex - startIndex) > 1) {
                        for (NSInteger i = (startIndex + 1); i < endIndex; i++) {
                            [self.timeArr removeObjectAtIndex:i];
                        }
                    }
                    [self.contentDic setObject:self.contentTV.text forKey:self.startBtn.titleLabel.text];
                    [self.colorDic setObject:self.colorStr forKey:self.startBtn.titleLabel.text];
                    if ([self.delegate respondsToSelector:@selector(addSuccessWithTimeArr:andContentDic:andColorDic:)]) {
                        [self.delegate addSuccessWithTimeArr:self.timeArr andContentDic:self.contentDic andColorDic:self.colorDic];
                    }
                    [MBProgressHUD showError:@"修改成功!"];
                });
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [self backAction];
                });
            }];
            [alertC addAction:cancel];
            [alertC addAction:ok];
            [self presentViewController:alertC animated:YES completion:nil];
            return;
        } 
    }
    [self okBtnSuccess];
}
-(void)okBtnSuccess{
    [self.contentDic setObject:self.contentTV.text forKey:self.startBtn.titleLabel.text];
    [self.colorDic setObject:self.colorStr forKey:self.startBtn.titleLabel.text];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if ([self.delegate respondsToSelector:@selector(addSuccessWithTimeArr:andContentDic:andColorDic:)]) {
            [self.delegate addSuccessWithTimeArr:self.timeArr andContentDic:self.contentDic andColorDic:self.colorDic];
        }
        [MBProgressHUD showError:@"添加成功!"];
    });
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self backAction];
    });
}


#pragma mark -注册通知
-(void)registerNotification{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];  
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];  
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardDidShowNotification object:nil];
    //用于开始结束时间点选择
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(kDatePicker24HoursView_Notify:) name:@"kDatePicker24HoursView" object:nil];
}
//移除通知
- (void)removeNotification{  
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];  
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];  
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidShowNotification object:nil];  
} 
//键盘的弹出与回收
- (void)keyboardWillShow:(NSNotification *)note{  
    CGFloat duration = [note.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue]; 
    
    self.endEditingTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(singleTapACtION:)];
    [self.view addGestureRecognizer:self.endEditingTap];
}  
-(void)singleTapACtION:(UITapGestureRecognizer *)singleTap{
    [self.view endEditing:YES];
}
- (void)keyboardDidShow:(NSNotification *)notification{  
    NSValue* aValue = [[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey];  
    CGRect keyboardRect = [aValue CGRectValue];  
    CGRect keyboardFrame = [self.view convertRect:keyboardRect fromView:[[UIApplication sharedApplication] keyWindow]];  
    CGFloat keyboardHeight = keyboardFrame.size.height;  
}  
- (void)keyboardWillHide:(NSNotification *)note{  
    CGFloat duration = [note.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];  
    [self.view removeGestureRecognizer:self.endEditingTap];
}
//用于开始结束时间点选择
-(void)kDatePicker24HoursView_Notify:(NSNotification *)notify{
    NSString *dateType = notify.userInfo[@"dateType"];
    NSString *hour = notify.userInfo[@"hour"];
    if ([dateType isEqualToString:@"开始时间"]) {
        [self.startBtn setTitle:hour forState:UIControlStateNormal];
    }else if ([dateType isEqualToString:@"结束时间"]) {
        [self.endBtn setTitle:hour forState:UIControlStateNormal];
    }
}
//点击rightBtn
-(void)rightBtnACTION:(UIButton *)sender{
    [self.view endEditing:YES];
}

#pragma mark -UITextViewDelegate

- (BOOL)textViewShouldEndEditing:(UITextView *)textView{
    [textView resignFirstResponder];
    return YES;
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

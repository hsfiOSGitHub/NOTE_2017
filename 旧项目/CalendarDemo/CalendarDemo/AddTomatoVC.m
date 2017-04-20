//
//  AddTomatoVC.m
//  CalendarDemo
//
//  Created by monkey2016 on 17/1/9.
//  Copyright © 2017年 monkey2016. All rights reserved.
//

#import "AddTomatoVC.h"

#import "AddTomatoCell.h"
#import "StartTomatoVC.h"//开始🍅

@interface AddTomatoVC ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *nameTF;

@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UIView *timeBgView;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *source;//数据源
//按钮
@property (weak, nonatomic) IBOutlet UIButton *cancelBtn;
@property (weak, nonatomic) IBOutlet UIButton *saveBtn;
@property (weak, nonatomic) IBOutlet UIButton *saveAndStartBtn;

@property (nonatomic,strong) CKCircleView* dialView;//时间进度条
@property (nonatomic,assign) int currentNum;



@property (nonatomic,strong) UITapGestureRecognizer *endEditingTap;//弹出键盘时点击空白退出键盘

@end

static NSString *identifierCell = @"identifierCell";
@implementation AddTomatoVC
#pragma mark -懒加载
//数据源
-(TaskModel *)model{
    if (!_model) {
        _model = [TaskModel modelWithDic:@{}];
    }
    return _model;
}
-(NSMutableArray *)source{
    if (!_source) {
        _source = [NSMutableArray array];
        [_source addObject:@"20分钟"];
        [_source addObject:@"30分钟"];
//        [_source addObject:@"自定义"];
        [_source addObject:@" "];
        [_source addObject:@" "];
        [_source addObject:@" "];
        [_source addObject:@" "];
        [_source addObject:@" "];
        [_source addObject:@" "];
        [_source addObject:@" "];
        [_source addObject:@" "];
        [_source addObject:@" "];
    }
    return _source;
}

#pragma mark -配置导航栏
-(void)setUpNavi{
    self.automaticallyAdjustsScrollViewInsets = NO;
    //返回
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[[UIImage imageNamed:@"back_common"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(backAction)];
}
//返回
-(void)backAction{
    [self dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark -viewWillAppear
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.barTintColor = KRGB(52, 168, 238, 1.0);
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSFontAttributeName:[UIFont systemFontOfSize:20],NSForegroundColorAttributeName:[UIColor whiteColor]}];
    if ([self.addOrEdit isEqualToString:@"add"]) {
        self.navigationItem.title = @"添加任务";
    }else if ([self.addOrEdit isEqualToString:@"edit"]) {
        self.navigationItem.title = @"编辑任务";
    }
    
}
#pragma mark -viewWillDisappear
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    //保存time列表
    NSString *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
    NSString *timePath = [path stringByAppendingPathComponent:@"timePath"];
    [self.source writeToFile:timePath atomically:YES];
}
#pragma mark -viewDidLoad
- (void)viewDidLoad {
    [super viewDidLoad];
    //配置导航栏
    [self setUpNavi];
    //初始化数据源
    NSString *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
    NSString *timePath = [path stringByAppendingPathComponent:@"timePath"];
    self.source = [NSMutableArray arrayWithContentsOfFile:timePath];
    //初始化subViews
    [self initSubviews];
    //配置tableView
    [self setUptableView];
    //注册通知
    [self registerNotification];
}
//初始化subViews
-(void)initSubviews{
    self.view.backgroundColor = KRGB(139, 188, 199, 1.0);
    self.timeLabel.backgroundColor = KRGB(139, 188, 199, 1.0);
    //标题
    self.nameTF.delegate = self;
    //圆角 边框
    self.cancelBtn.layer.masksToBounds = YES;
    self.saveBtn.layer.masksToBounds = YES;
    self.saveAndStartBtn.layer.masksToBounds = YES;
    
    self.cancelBtn.layer.cornerRadius = 10;
    self.saveBtn.layer.cornerRadius = 10;
    self.saveAndStartBtn.layer.cornerRadius = 10;
    
    self.cancelBtn.layer.borderWidth = 1;
    self.saveBtn.layer.borderWidth = 1;
    self.saveAndStartBtn.layer.borderWidth = 1;
    
    self.cancelBtn.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.saveBtn.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.saveAndStartBtn.layer.borderColor = [UIColor lightGrayColor].CGColor;
    
    //时间label
    self.timeLabel.alpha = 0;
    //添加时间进度条
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        //tableView缩进
        self.tableView.contentInset = UIEdgeInsetsMake((self.timeBgView.height - 80), 0, 0, 0);
        [self.tableView setContentOffset:CGPointMake(0, -(self.timeBgView.height - 80))];
        //添加时间进度条
        self.dialView = [[CKCircleView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth - 120, KScreenWidth - 120)];
        self.dialView.center = CGPointMake(self.timeBgView.centerX, self.timeBgView.height/2);
        self.dialView.arcColor = [UIColor whiteColor];
        self.dialView.backColor = [KRGB(235, 235, 235, 1.0) colorWithAlphaComponent:0.6];
        self.dialView.dialColor = [UIColor whiteColor];
        self.dialView.arcRadius = KScreenWidth - 120;
        self.dialView.units = @"分钟";
        self.dialView.minNum = 0;
        self.dialView.maxNum = 60;
        self.dialView.labelColor = [UIColor whiteColor];
        self.dialView.labelFont = [UIFont systemFontOfSize:25.0];
        [self.timeBgView addSubview: self.dialView];
    });
    self.nameTF.text = self.model.title;
    if ([self.model.time length]<=3) {
        self.currentNum = [[self.model.time substringToIndex:1] intValue];
    }else{
        self.currentNum = [[self.model.time substringToIndex:2] intValue];
    }
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        //最大进度条
        double angle = ((double)(self.currentNum - self.dialView.minNum)/(self.dialView.maxNum - self.dialView.minNum)) * 360.0;
        [self.dialView moveCircleToAngle:angle];
    });
}
//配置tableView
-(void)setUptableView{
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    //高度
    self.tableView.estimatedRowHeight = 44;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    //注册cell
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([AddTomatoCell class]) bundle:nil] forCellReuseIdentifier:identifierCell];
        
}
#pragma mark -UITableViewDelegate,UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.source.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    AddTomatoCell *cell = [tableView dequeueReusableCellWithIdentifier:identifierCell forIndexPath:indexPath];
    if (indexPath.row < self.source.count) {
        cell.title.text = self.source[indexPath.row];
    }
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSString *title = self.source[indexPath.row];
    if ([title isEqualToString:@" "]) {
        return;
    }else if ([title isEqualToString:@"自定义"]) {
//        DateSeletor *dateSeletor = [[DateSeletor alloc]initWithFrame:[UIScreen mainScreen].bounds];
//        dateSeletor.title.text = @"自定义提醒时间";
//        dateSeletor.datePicker.datePickerMode = UIDatePickerModeCountDownTimer;
//        dateSeletor.sourceVC = @"EditScheduleVC";
//        [KMyWindow addSubview:dateSeletor];
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.15 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//            [dateSeletor show];
//        });
    }else{
        _currentNum = [[title substringToIndex:2] intValue];
        double angle = ((double)(_currentNum - self.dialView.minNum)/(self.dialView.maxNum - self.dialView.minNum)) * 360.0;
        [self.dialView moveCircleToAngle:angle];
    }
}


//点击保存
- (IBAction)saveBtnACTION:(UIButton *)sender {
    //必填项 ：title time 
    if (!self.model.task_id) {
        NSArray *all = [[HSFFmdbManager sharedManager] readAllTasks];
        self.model.task_id = [NSNumber numberWithInteger:(all.count + 1)];
    }
    self.model.title = self.nameTF.text;
    self.model.time = self.dialView.numberLabel.text;
    self.model.date = [NSDate allDayTimeWithDate:[NSDate date]];
    self.model.isFinished = @"0";
    
    if (!self.model.title || [self.model.title isEqualToString:@""] || !self.model.time || [self.model.time isEqualToString:@""]) {
        [MBProgressHUD showError:@"信息填写不完整！"];
    }else{
        //保存到数据库
        [[HSFFmdbManager sharedManager] insertNewTask:self.model];
        //保存成功，退出
        [MBProgressHUD showError:@"保存成功!"];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"kSaveAddTomato" object:nil];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self backAction];
        });
    }
}
//点击保存并启动
- (IBAction)saveAndStartBtnACtION:(UIButton *)sender {
    //必填项 ：title time 
    if (!self.model.task_id) {
        NSArray *all = [[HSFFmdbManager sharedManager] readAllTasks];
        self.model.task_id = [NSNumber numberWithInteger:(all.count + 1)];
    }
    self.model.title = self.nameTF.text;
    self.model.time = self.dialView.numberLabel.text;
    self.model.date = [NSDate allDayTimeWithDate:[NSDate date]];
    self.model.isFinished = @"0";
    
    if (!self.model.title || [self.model.title isEqualToString:@""] || !self.model.time || [self.model.time isEqualToString:@""]) {
        [MBProgressHUD showError:@"信息填写不完整！"];
    }else{
        //保存到数据库
        [[HSFFmdbManager sharedManager] insertNewTask:self.model];
        //保存成功，退出
        [MBProgressHUD showError:@"保存成功!"];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.7 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [[NSNotificationCenter defaultCenter] postNotificationName:@"kSaveAddTomato" object:nil];
            //开始🍅
            StartTomatoVC *startTomato_VC = [[StartTomatoVC alloc]init];
            startTomato_VC.model = self.model;
            startTomato_VC.sourceVC = @"AddTomatoVC";
            [self.navigationController pushViewController:startTomato_VC animated:YES];
        });
    }
}
//点击取消
- (IBAction)cancelBtnACTION:(UIButton *)sender {
    [self backAction];
}


#pragma mark -UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (scrollView == self.tableView) {
        CGPoint point = scrollView.contentOffset;
        CGFloat height = (self.timeBgView.height - 80)/2;
        CGFloat alpha = MIN(1, (point.y / height) + 1);
        
        if (point.y <= -(self.timeBgView.height - 80)) {
            //将tableView放到最底层
            [self.bgView sendSubviewToBack:self.tableView];
        }else{
            [self.bgView bringSubviewToFront:self.tableView];
        }
        if (point.y >= -(self.timeBgView.height - 80)/2) {
            self.dialView.alpha = (1-alpha);
            self.dialView.userInteractionEnabled = NO;
        }else{
            self.dialView.alpha = 1;
            self.dialView.userInteractionEnabled = YES;
        }
        if (point.y >= -(self.timeBgView.height - 80)/3) {
            self.timeLabel.text = [NSString stringWithFormat:@"00:%02d:00",self.dialView.currentNum];
            self.timeLabel.alpha = alpha;
        }else{
            self.timeLabel.alpha = 0;
        }
        if (point.y>0) {
            self.tableView.backgroundColor = [UIColor whiteColor];
        }else{
            self.tableView.backgroundColor = [UIColor clearColor];
        }
    }
}

#pragma mark -UITextFieldDelegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    return YES;
}
- (void)textFieldDidBeginEditing:(UITextField *)textField{
    [textField becomeFirstResponder];
    
}
- (BOOL)textFieldShouldEndEditing:(UITextField *)textField{
    return YES;
}
- (void)textFieldDidEndEditing:(UITextField *)textField{
   
}
- (void)textFieldDidEndEditing:(UITextField *)textField reason:(UITextFieldDidEndEditingReason)reason NS_AVAILABLE_IOS(10_0){
    
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    return YES;
}
- (BOOL)textFieldShouldClear:(UITextField *)textField{
    return YES;
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];//取消第一响应，回收键盘
    return YES;
}
#pragma mark -键盘
//注册通知
- (void)registerNotification{  
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];  
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];  
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardDidShowNotification object:nil];
    //用于自定义提醒时间
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(chooseAlarm_dateSeletor:) name:@"kDateSeletor_notify_EditScheduleVC" object:nil];
}  
//移除通知
- (void)removeNotification{  
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];  
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];  
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidShowNotification object:nil];  
} 
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
//自定义提醒时间
-(void)chooseAlarm_dateSeletor:(NSNotification *)sender{
    NSDictionary *userInfo = sender.userInfo;
    NSString *alarmStr = userInfo[@"alarmStr"];
//    self.model.alarm = alarmStr;
    [self.tableView reloadData];
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

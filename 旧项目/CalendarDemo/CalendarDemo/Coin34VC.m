//
//  Coin34VC.m
//  CalendarDemo
//
//  Created by monkey2016 on 17/1/11.
//  Copyright © 2017年 monkey2016. All rights reserved.
//

#import "Coin34VC.h"

#import "Coin34Cell1.h"
#import "Coin34Cell2.h"

@interface Coin34VC ()<UITableViewDelegate,UITableViewDataSource,AddCoin34VCDelegate,UITextViewDelegate>
//XIB>>>>>>>>>>
//顶部星期
@property (weak, nonatomic) IBOutlet UIView *timeBgView;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIButton *lastBtn;
@property (weak, nonatomic) IBOutlet UIButton *nextBtn;

//tableView
@property (weak, nonatomic) IBOutlet UIView *tableBgView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

//底部转场按钮
@property (weak, nonatomic) IBOutlet UIButton *todayBtn;
@property (weak, nonatomic) IBOutlet UIButton *weekBtn;
@property (weak, nonatomic) IBOutlet UIButton *monthBtn;
//tableView底部约束
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableViewBottomCons;


//Code>>>>>>>>>
@property (nonatomic,strong) Coin34Cell2 *cell2;

@property (strong, nonatomic) ColorPickerView *colorPickerView;
//数据源
@property (nonatomic,strong) NSMutableArray *timeArr;
@property (nonatomic,strong) NSMutableDictionary *contentDic;
@property (nonatomic,strong) NSMutableDictionary *colorDic;
@property (nonatomic,strong) NSMutableDictionary *summaryDic;

@property (nonatomic,strong) NSDate *currentDate;//今天日期
@property (nonatomic,assign) BOOL isOpen;//取色器是否打开
//键盘
@property (nonatomic,strong) UIView *keyboardTool;
@property (nonatomic,strong) UITapGestureRecognizer *endEditingTap;//弹出键盘时点击空白退出键盘


@end

static NSString *identifier_cell1 = @"identifier_cell1";
static NSString *identifier_cell2 = @"identifier_cell2";
@implementation Coin34VC
#pragma mark -懒加载
-(NSMutableDictionary *)contentDic{
    if (!_contentDic) {
        _contentDic = [NSMutableDictionary dictionary];
        [self.timeArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [_contentDic setObject:@"" forKey:obj];
        }];
    }
    return _contentDic;
}
-(NSMutableDictionary *)colorDic{
    if (!_colorDic) {
        _colorDic = [NSMutableDictionary dictionary];
        [self.timeArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [_colorDic setObject:@"0" forKey:obj];
        }];
    }
    return _colorDic;
}
-(NSMutableDictionary *)summaryDic{
    if (!_summaryDic) {
        _summaryDic = [NSMutableDictionary dictionary];
        [_summaryDic setObject:@"2" forKey:@"feeling"];
        [_summaryDic setObject:@"0.5" forKey:@"sense"];
        [_summaryDic setObject:@"" forKey:@"evaluation"];
    }
    return _summaryDic;
}
-(NSMutableArray *)timeArr{
    if (!_timeArr) {
        _timeArr = [NSMutableArray array];
        [_timeArr addObject:@"07:00"];[_timeArr addObject:@"07:30"];
        [_timeArr addObject:@"08:00"];[_timeArr addObject:@"08:30"];
        [_timeArr addObject:@"09:00"];[_timeArr addObject:@"09:30"];
        [_timeArr addObject:@"10:00"];[_timeArr addObject:@"10:30"];
        [_timeArr addObject:@"11:00"];[_timeArr addObject:@"11:30"];
        [_timeArr addObject:@"12:00"];[_timeArr addObject:@"12:30"];
        [_timeArr addObject:@"13:00"];[_timeArr addObject:@"13:30"];
        [_timeArr addObject:@"14:00"];[_timeArr addObject:@"14:30"];
        [_timeArr addObject:@"15:00"];[_timeArr addObject:@"15:30"];
        [_timeArr addObject:@"16:00"];[_timeArr addObject:@"16:30"];
        [_timeArr addObject:@"17:00"];[_timeArr addObject:@"17:30"];
        [_timeArr addObject:@"18:00"];[_timeArr addObject:@"18:30"];
        [_timeArr addObject:@"19:00"];[_timeArr addObject:@"19:30"];
        [_timeArr addObject:@"20:00"];[_timeArr addObject:@"20:30"];
        [_timeArr addObject:@"21:00"];[_timeArr addObject:@"21:30"];
        [_timeArr addObject:@"22:00"];[_timeArr addObject:@"22:30"];
        [_timeArr addObject:@"23:00"];[_timeArr addObject:@"23:30"];
    }
    return _timeArr;
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
//点击rightBtn
-(void)rightBtnACTION:(UIButton *)sender{
    [self.view endEditing:YES];
}

#pragma mark -配置导航栏
-(void)setUpNavi{
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.automaticallyAdjustsScrollViewInsets = NO;
    //退出
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[[UIImage imageNamed:@"back4_common"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(backAction)];
    //添加
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[[UIImage imageNamed:@"add_34coins"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(addACTION)];
}
//退出
-(void)backAction{
    [self dismissViewControllerAnimated:YES completion:nil];
}
//添加
-(void)addACTION{
    AddCoin34VC *addCoin_VC = [[AddCoin34VC alloc]init];
    addCoin_VC.delegate = self;
    addCoin_VC.addOrModify = @"add";
    addCoin_VC.timeArr = self.timeArr;
    addCoin_VC.contentDic = self.contentDic;
    addCoin_VC.colorDic = self.colorDic;
    [self.navigationController pushViewController:addCoin_VC animated:YES];
}

#pragma mark -viewWillAppear
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.barTintColor = KRGB(255, 147, 18, 1.0);
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSFontAttributeName:[UIFont systemFontOfSize:20],NSForegroundColorAttributeName:[UIColor whiteColor]}];
    self.navigationItem.title = @"记录好时光";
}
#pragma mark -viewWillDisappear
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    //缓存到本地
    NSString *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
    NSString *filePath_time = [path stringByAppendingPathComponent:[NSString stringWithFormat:@"34coins_%@_time",self.timeLabel.text]];
    NSString *filePath_content = [path stringByAppendingPathComponent:[NSString stringWithFormat:@"34coins_%@_content",self.timeLabel.text]];
    NSString *filePath_color = [path stringByAppendingPathComponent:[NSString stringWithFormat:@"34coins_%@_color",self.timeLabel.text]];
    [self.timeArr writeToFile:filePath_time atomically:YES];
    [self.contentDic writeToFile:filePath_content atomically:YES];
    [self.colorDic writeToFile:filePath_color atomically:YES];
}
#pragma mark -viewDidLoad
- (void)viewDidLoad {
    [super viewDidLoad];
    //配置导航栏
    [self setUpNavi];
    //初始化数据
    [self setUpData];
    //配置tableView
    [self setUpTableView];
    //配置取色器
    [self setUpColorImgView];
    //配置底部转场按钮
    [self.todayBtn layoutButtonWithEdgeInsetsStyle:HSFButtonEdgeInsetsStyleLeft imageTitleSpace:5];
    [self.weekBtn layoutButtonWithEdgeInsetsStyle:HSFButtonEdgeInsetsStyleLeft imageTitleSpace:5];
    [self.monthBtn layoutButtonWithEdgeInsetsStyle:HSFButtonEdgeInsetsStyleLeft imageTitleSpace:5];
    //注册通知
    [self registerNotification];
}
//初始化数据
-(void)setUpData{
    //配置日期
    self.currentDate = [NSDate date];
    self.timeLabel.text = [NSDate allDayTimeWithDate:self.currentDate];
    //读数据
    NSString *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
    NSString *filePath_time = [path stringByAppendingPathComponent:[NSString stringWithFormat:@"34coins_%@_time",self.timeLabel.text]];
    NSString *filePath_content = [path stringByAppendingPathComponent:[NSString stringWithFormat:@"34coins_%@_content",self.timeLabel.text]];
    NSString *filePath_color = [path stringByAppendingPathComponent:[NSString stringWithFormat:@"34coins_%@_color",self.timeLabel.text]];
    NSString *filePath_summary = [path stringByAppendingPathComponent:[NSString stringWithFormat:@"34coins_%@_summary",self.timeLabel.text]];
    self.timeArr = [NSMutableArray arrayWithContentsOfFile:filePath_time];
    self.contentDic = [NSMutableDictionary dictionaryWithContentsOfFile:filePath_content];
    self.colorDic = [NSMutableDictionary dictionaryWithContentsOfFile:filePath_color];
    self.summaryDic = [NSMutableDictionary dictionaryWithContentsOfFile:filePath_summary];
}
//配置tableView
-(void)setUpTableView{
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    //高度
    self.tableView.estimatedRowHeight = 44;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    //注册
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([Coin34Cell1 class]) bundle:nil] forCellReuseIdentifier:identifier_cell1];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([Coin34Cell2 class]) bundle:nil] forCellReuseIdentifier:identifier_cell2];
}
//配置取色器
-(void)setUpColorImgView{
    self.colorPickerView = [[ColorPickerView alloc]initWithFrame:CGRectMake(KScreenWidth - 50, 20, 50, 50)];
    [self.tableBgView addSubview:self.colorPickerView];
    
    self.colorPickerView.icon.userInteractionEnabled = YES;
    //点击展开手势
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapACTION:)];
    [self.colorPickerView.icon addGestureRecognizer:tap];
}
//点击展开手势
-(void)tapACTION:(UITapGestureRecognizer *)tap{
    self.isOpen = !self.isOpen;
    if (self.isOpen) {
        [self.colorPickerView open];
    }else{
        [self.colorPickerView close];
    }
}
#pragma mark -UITableViewDelegate,UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return self.timeArr.count;
    }else{
        return 1;
    }
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        Coin34Cell1 *cell1 = [tableView dequeueReusableCellWithIdentifier:identifier_cell1 forIndexPath:indexPath];
        cell1.time.text = self.timeArr[indexPath.row];
        //首行缩进两个字符
        NSString *test  =  self.contentDic[cell1.time.text];
        NSMutableParagraphStyle *paraStyle01 = [[NSMutableParagraphStyle alloc] init];
        paraStyle01.alignment = NSTextAlignmentLeft;  //对齐
        paraStyle01.headIndent = 0.0f;//行首缩进
        //参数：（字体大小17号字乘以2，34f即首行空出两个字符）
        CGFloat emptylen = cell1.content.font.pointSize * 2;
        paraStyle01.firstLineHeadIndent = emptylen;//首行缩进
        paraStyle01.tailIndent = 0.0f;//行尾缩进
        paraStyle01.lineSpacing = 2.0f;//行间距
        NSAttributedString *attrText = [[NSAttributedString alloc] initWithString:test attributes:@{NSParagraphStyleAttributeName:paraStyle01}];
        cell1.content.attributedText = attrText;
        
        //颜色
        NSString *str = self.colorDic[cell1.time.text];
        if ([str isEqualToString:@"0"]) {//未填写
            cell1.content.backgroundColor = [UIColor whiteColor];
        }else if ([str isEqualToString:@"1"]) {//尽兴娱乐
            cell1.content.backgroundColor = KRGB(23, 129, 210, 1);
        }else if ([str isEqualToString:@"2"]) {//休息放松
            cell1.content.backgroundColor = KRGB(123, 177, 21, 1);
        }else if ([str isEqualToString:@"3"]) {//高效工作
            cell1.content.backgroundColor = KRGB(226, 124, 42, 1);
        }else if ([str isEqualToString:@"4"]) {//强迫工作
            cell1.content.backgroundColor = KRGB(204, 0, 10, 1);
        }else if ([str isEqualToString:@"5"]) {//无效工作
            cell1.content.backgroundColor = KRGB(179, 179, 179, 1);
        }
        
        return cell1;
    }else if (indexPath.section == 1) {
        _cell2 = [tableView dequeueReusableCellWithIdentifier:identifier_cell2 forIndexPath:indexPath];
        _cell2.feelingSegC.selectedSegmentIndex = [self.summaryDic[@"feeling"] integerValue];
        _cell2.score = [self.summaryDic[@"sense"] doubleValue];
        _cell2.evaluationTV.text = self.summaryDic[@"evaluation"];
        _cell2.evaluationTV.delegate = self;
        _cell2.evaluationTV.inputAccessoryView = self.keyboardTool;
        //添加事件
        [_cell2.saveBtn addTarget:self action:@selector(saveBtnACTION:) forControlEvents:UIControlEventTouchUpInside];
        
        return _cell2;
    }
    return nil;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0) {
        AddCoin34VC *addCoin_VC = [[AddCoin34VC alloc]init];
        addCoin_VC.delegate = self;
        addCoin_VC.addOrModify = @"modify";
        addCoin_VC.timeArr = self.timeArr;
        addCoin_VC.contentDic = self.contentDic;
        addCoin_VC.colorDic = self.colorDic;
        addCoin_VC.clickIndex = indexPath.row;
        [self.navigationController pushViewController:addCoin_VC animated:YES];
    }
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 0.1;
    }else if (section == 1) {
        return 30;
    }
    return 0.1;
}
#pragma mark -summary
-(void)saveBtnACTION:(UIButton *)sender{
    [self.summaryDic setObject:[NSString stringWithFormat:@"%ld",_cell2.feelingSegC.selectedSegmentIndex] forKey:@"feeling"];
    [self.summaryDic setObject:[NSString stringWithFormat:@"%f",_cell2.changedScore] forKey:@"sense"];
    [self.summaryDic setObject:_cell2.evaluationTV.text forKey:@"evaluation"];
    //缓存到本地
    NSString *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
    NSString *filePath_summary = [path stringByAppendingPathComponent:[NSString stringWithFormat:@"34coins_%@_summary",self.timeLabel.text]];
    [self.summaryDic writeToFile:filePath_summary atomically:YES];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [MBProgressHUD showError:@"保存成功!"];
    });
}
#pragma mark -<UITextViewDelegate>
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
- (void)keyboardDidShow:(NSNotification *)note{  
    CGFloat duration = [note.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    NSValue* aValue = [[note userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey];  
    CGRect keyboardRect = [aValue CGRectValue];  
    CGRect keyboardFrame = [self.view convertRect:keyboardRect fromView:[[UIApplication sharedApplication] keyWindow]];  
    CGFloat keyboardHeight = keyboardFrame.size.height; 
    
    //动画
    [UIView animateWithDuration:duration animations:^{
        self.tableViewBottomCons.constant = keyboardHeight - 50;
    }];
    
}  
- (void)keyboardWillHide:(NSNotification *)note{  
    CGFloat duration = [note.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];  
    [self.view removeGestureRecognizer:self.endEditingTap];
    
    //动画
    [UIView animateWithDuration:duration animations:^{
        self.tableViewBottomCons.constant = 0;
    }];
}



#pragma mark -点击底部跳转按钮
- (IBAction)pushBtnACTION:(UIButton *)sender {
    switch (sender.tag) {
        case 100:{//今天
            
        }
            break;
        case 200:{//周小结
            WeekChartCionVC *week_C = [[WeekChartCionVC alloc]init];
            [self.navigationController pushViewController:week_C animated:NO];
        }
            break;
        case 300:{//月总结
            MonthChartCoinVC *month_VC = [[MonthChartCoinVC alloc]init];
            [self.navigationController pushViewController:month_VC animated:NO];
        }
            break;
            
        default:
            break;
    }
}

#pragma mark -AddCoin34VCDelegate
-(void)addSuccessWithTimeArr:(NSMutableArray *)timeArr andContentDic:(NSMutableDictionary *)contentDic andColorDic:(NSMutableDictionary *)colorDic{
    self.timeArr = timeArr;
    self.contentDic = contentDic; 
    self.colorDic = colorDic;
    //缓存到本地
    NSString *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
    NSString *filePath_time = [path stringByAppendingPathComponent:[NSString stringWithFormat:@"34coins_%@_time",self.timeLabel.text]];
    NSString *filePath_content = [path stringByAppendingPathComponent:[NSString stringWithFormat:@"34coins_%@_content",self.timeLabel.text]];
    NSString *filePath_color = [path stringByAppendingPathComponent:[NSString stringWithFormat:@"34coins_%@_color",self.timeLabel.text]];
    [self.timeArr writeToFile:filePath_time atomically:YES];
    [self.contentDic writeToFile:filePath_content atomically:YES];
    [self.colorDic writeToFile:filePath_color atomically:YES];
    //刷表
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
    });
    
}

#pragma mark -前一天 后一天
- (IBAction)dateBtnACTION:(UIButton *)sender {
    //创建动画
    CATransition *transition = [CATransition animation];
    transition.duration = 0.3;
    transition.type = @"push";
    switch (sender.tag) {
        case 10:{//前一天
            transition.subtype = kCATransitionFromLeft;
            self.currentDate = [NSDate dateWithTimeInterval:-24*60*60 sinceDate:self.currentDate];
            self.timeLabel.text = [NSDate allDayTimeWithDate:self.currentDate];
        }
            break;
        case 20:{//后一天
            transition.subtype = kCATransitionFromRight;
            self.currentDate = [NSDate dateWithTimeInterval:24*60*60 sinceDate:self.currentDate];
            self.timeLabel.text = [NSDate allDayTimeWithDate:self.currentDate];
        }
            break;
            
        default:
            break;
    }
    //更新数据
    NSString *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
    NSString *filePath_time = [path stringByAppendingPathComponent:[NSString stringWithFormat:@"34coins_%@_time",self.timeLabel.text]];
    NSString *filePath_content = [path stringByAppendingPathComponent:[NSString stringWithFormat:@"34coins_%@_content",self.timeLabel.text]];
    NSString *filePath_color = [path stringByAppendingPathComponent:[NSString stringWithFormat:@"34coins_%@_color",self.timeLabel.text]];
    NSString *filePath_summary = [path stringByAppendingPathComponent:[NSString stringWithFormat:@"34coins_%@_summary",self.timeLabel.text]];
    self.timeArr = [NSMutableArray arrayWithContentsOfFile:filePath_time];
    self.contentDic = [NSMutableDictionary dictionaryWithContentsOfFile:filePath_content];
    self.colorDic = [NSMutableDictionary dictionaryWithContentsOfFile:filePath_color];
    self.summaryDic = [NSMutableDictionary dictionaryWithContentsOfFile:filePath_summary];
    [self.tableView reloadData];
    //添加动画
    [self.tableView.layer addAnimation:transition forKey:nil];
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

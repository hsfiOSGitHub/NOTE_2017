//
//  SearchVC.m
//  CalendarDemo
//
//  Created by monkey2016 on 17/1/5.
//  Copyright © 2017年 monkey2016. All rights reserved.
//

#import "SearchVC.h"

#import "ScheduleCell_1.h"
#import "CustomKeyboardInputView.h"//键盘inputView

@interface SearchVC ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

//标题
@property (nonatomic,strong) UIButton *optionBtn;
@property (weak, nonatomic) IBOutlet UIView *maskView;
@property (weak, nonatomic) IBOutlet UIView *optionBgView;
@property (weak, nonatomic) IBOutlet UIButton *option1StateBtn;
@property (weak, nonatomic) IBOutlet UIButton *option2StateBtn;
@property (weak, nonatomic) IBOutlet UIButton *option3StateBtn;
@property (weak, nonatomic) IBOutlet UIButton *option4StateBtn;
//搜索框
@property (weak, nonatomic) IBOutlet UIView *searchBgView;
//按日期搜索
@property (weak, nonatomic) IBOutlet UIView *search_dateView;
@property (weak, nonatomic) IBOutlet UITextField *startTimeTF;
@property (weak, nonatomic) IBOutlet UITextField *endTimeTF;
@property (weak, nonatomic) IBOutlet UIButton *searchBtn_date;
//按紧急程度搜索
@property (weak, nonatomic) IBOutlet UIView *search_emergencyView;
@property (weak, nonatomic) IBOutlet UISegmentedControl *emergencySegC;
//按标签搜索
@property (weak, nonatomic) IBOutlet UIView *search_tagView;
@property (weak, nonatomic) IBOutlet UITextField *tagTF;
@property (weak, nonatomic) IBOutlet UIButton *searchBtn_tag;
//按标题搜索
@property (weak, nonatomic) IBOutlet UIView *search_titleView;
@property (weak, nonatomic) IBOutlet UITextField *titleTF;
@property (weak, nonatomic) IBOutlet UIButton *searchBtn_title;

@property (nonatomic,strong) UITapGestureRecognizer *endEditingTap;//弹出键盘时点击空白退出键盘
//键盘调用时
@property (nonatomic,strong) UIView *keyboardTool;
@property (nonatomic,strong) UIView *keyboardTool2;
@property (nonatomic,strong) CustomKeyboardInputView *keyboardInputView;
@property (nonatomic,strong) UILabel *currentInputTimeLabel;

@property (nonatomic,strong) NSMutableArray *source;//数据源


@end

static NSString *identifierCell_1 = @"identifierCell_1";
@implementation SearchVC
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
-(UIView *)keyboardTool2{
    if (!_keyboardTool2) {
        _keyboardTool2 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, 40)];
        _keyboardTool2.backgroundColor = [[UIColor lightGrayColor] colorWithAlphaComponent:1.0];
        UIButton *hiddenBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        hiddenBtn.frame = CGRectMake(KScreenWidth - 50, 0, 40, 40);
        [hiddenBtn setImage:[UIImage imageNamed:@"keyboard_common"] forState:UIControlStateNormal];
        [hiddenBtn addTarget:self action:@selector(hiddenBtnACTION:) forControlEvents:UIControlEventTouchUpInside];
        [_keyboardTool2 addSubview:hiddenBtn];
        //时间（开始、结束）
        _currentInputTimeLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, KScreenWidth - 60, 40)];
        _currentInputTimeLabel.textColor = [UIColor whiteColor];
        _currentInputTimeLabel.font = [UIFont systemFontOfSize:15];
        [_keyboardTool2 addSubview:_currentInputTimeLabel];
    }
    return _keyboardTool2;
}
-(void)hiddenBtnACTION:(UIButton *)sender{
    [self.view endEditing:YES];
}
-(CustomKeyboardInputView *)keyboardInputView{
    if (!_keyboardInputView) {
        _keyboardInputView = [[CustomKeyboardInputView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, 250)];
    }
    return _keyboardInputView;
}
-(UIButton *)optionBtn{
    if (!_optionBtn) {
        _optionBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _optionBtn.frame = CGRectMake(0, 0, 280, 40);
        _optionBtn.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        _optionBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;        
        [_optionBtn setImage:[UIImage imageNamed:@"down4_common"] forState:UIControlStateNormal];
        [_optionBtn layoutButtonWithEdgeInsetsStyle:HSFButtonEdgeInsetsStyleRight imageTitleSpace:5];
        [_optionBtn addTarget:self action:@selector(optionBtnACTION:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _optionBtn;
}
-(NSMutableArray *)source{
    if (!_source) {
        _source = [NSMutableArray array];
    }
    return _source;
}

#pragma mark -点击标题
-(void)optionBtnACTION:(UIButton *)sender{
    sender.selected = !sender.selected;
    if (sender.selected) {
        [self.optionBtn setImage:[UIImage imageNamed:@"up4_common"] forState:UIControlStateNormal];
        self.maskView.hidden = NO;
        [UIView animateWithDuration:0.5 animations:^{
            self.optionBgView.frame = CGRectMake(0, 64, self.optionBgView.width, self.optionBgView.height);
        }];
    }else{
        [self.optionBtn setImage:[UIImage imageNamed:@"down4_common"] forState:UIControlStateNormal];
        [UIView animateWithDuration:0.5 animations:^{
            self.optionBgView.frame = CGRectMake(0, -210, self.optionBgView.width, self.optionBgView.height);
        }];
        self.maskView.hidden = YES;
    }
}
//点击标题选项
- (IBAction)optionChoosedBtnACTION:(UIButton *)sender {
    //先将原来的数据全部移除
    [self.source removeAllObjects];
    [self.tableView reloadData];

    switch (sender.tag) {
        case 100:{//按标题搜索
            [self.option1StateBtn setImage:[UIImage imageNamed:@"seleted_edit_tag"] forState:UIControlStateNormal];
            [self.option2StateBtn setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
            [self.option3StateBtn setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
            [self.option4StateBtn setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
            [self.optionBtn setTitle:@"按标题搜索" forState:UIControlStateNormal];
            [self.searchBgView bringSubviewToFront:self.search_titleView];
        }
            break;
        case 200:{//按标签搜索
            [self.option1StateBtn setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
            [self.option2StateBtn setImage:[UIImage imageNamed:@"seleted_edit_tag"] forState:UIControlStateNormal];
            [self.option3StateBtn setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
            [self.option4StateBtn setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
            [self.optionBtn setTitle:@"按标签搜索" forState:UIControlStateNormal];
            [self.searchBgView bringSubviewToFront:self.search_tagView];
        }
            break;
        case 300:{//按日期搜索
            [self.option1StateBtn setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
            [self.option2StateBtn setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
            [self.option3StateBtn setImage:[UIImage imageNamed:@"seleted_edit_tag"] forState:UIControlStateNormal];
            [self.option4StateBtn setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
            [self.optionBtn setTitle:@"按日期搜索" forState:UIControlStateNormal];
            [self.searchBgView bringSubviewToFront:self.search_dateView];
        }
            break;
        case 400:{//按重要／紧急程度搜索
            [self.option1StateBtn setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
            [self.option2StateBtn setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
            [self.option3StateBtn setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
            [self.option4StateBtn setImage:[UIImage imageNamed:@"seleted_edit_tag"] forState:UIControlStateNormal];
            [self.optionBtn setTitle:@"按重要／紧急程度搜索" forState:UIControlStateNormal];
            [self.searchBgView bringSubviewToFront:self.search_emergencyView];
            //默认自动搜索A
            NSArray *resultArr = [[HSFFmdbManager sharedManager] readScheduleModelWhereEmergencyLike:@"重要／紧急"];
            self.source = [NSMutableArray arrayWithArray:resultArr];
            if (self.source.count == 0) {
                [MBProgressHUD showError:@"搜索结果为空!"];
            }else{
                //刷表
                [self.tableView reloadData];
            }
        }
            break;
            
        default:
            break;
    }
    [_optionBtn layoutButtonWithEdgeInsetsStyle:HSFButtonEdgeInsetsStyleRight imageTitleSpace:5];
    self.optionBtn.selected = !self.optionBtn.selected;
    [self.optionBtn setImage:[UIImage imageNamed:@"down4_common"] forState:UIControlStateNormal];
    [UIView animateWithDuration:0.5 animations:^{
        self.optionBgView.frame = CGRectMake(0, -210, self.optionBgView.width, self.optionBgView.height);
    }];
    self.maskView.hidden = YES;
}
//点击搜索按钮
- (IBAction)searchBtnACTION:(UIButton *)sender {
    switch (sender.tag) {
        case 1000:{//按标题搜索
            if ([self.titleTF.text isEqualToString:@""]) {
                [MBProgressHUD showError:@"搜索的标题为空"];
                return;
            }
            //读取数据库数据 －模糊查询
            NSArray *resultArr = [[HSFFmdbManager sharedManager] readScheduleModelWhereTitleNameLike:self.titleTF.text];
            self.source = [NSMutableArray arrayWithArray:resultArr];
            
        }
            break;
        case 2000:{//按标签搜索
            if ([self.tagTF.text isEqualToString:@""]) {
                [MBProgressHUD showError:@"搜索的标签为空"];
                return;
            }
            //读取数据库数据 －模糊查询
            NSArray *resultArr = [[HSFFmdbManager sharedManager] readScheduleModelWhereTagLike:self.tagTF.text];
            self.source = [NSMutableArray arrayWithArray:resultArr];
        }
            break;
        case 3000:{//按日期搜索
            if ([self.startTimeTF.text isEqualToString:@""]) {
                [MBProgressHUD showError:@"请输入开始时间"];
                return;
            }
            //判断－结束时间大于开始时间
            NSDate *startDate = [NSDate dateWithString:self.startTimeTF.text];
            NSDate *endDate = [NSDate dateWithString:self.endTimeTF.text];
            NSTimeInterval start = [startDate timeIntervalSince1970];
            NSTimeInterval end = [endDate timeIntervalSince1970];
            NSTimeInterval deta = end - start;
            if (deta < 0) {
                [MBProgressHUD showError:@"开始时间必须早于结束时间"];
                return;
            }
            //读取数据库数据 －精准查询
            NSArray *resultArr = [[HSFFmdbManager sharedManager] readScheduleModelWhereStartDate:self.startTimeTF.text andEndDate:self.endTimeTF.text];
            self.source = [NSMutableArray arrayWithArray:resultArr];
        }
            break;
            
        default:
            break;
    }
    if (self.source.count == 0) {
        [MBProgressHUD showError:@"搜索结果为空!"];
    }else{
        //刷表
        [self.tableView reloadData];
    }
    [self.view endEditing:YES];
}
//按紧急程度搜索
- (IBAction)emergencySegCACTION:(UISegmentedControl *)sender {
    switch (sender.selectedSegmentIndex) {
        case 0:{//A
            NSArray *resultArr = [[HSFFmdbManager sharedManager] readScheduleModelWhereEmergencyLike:@"重要／紧急"];
            self.source = [NSMutableArray arrayWithArray:resultArr];
        }
            break;
        case 1:{//B
            NSArray *resultArr = [[HSFFmdbManager sharedManager] readScheduleModelWhereEmergencyLike:@"重要／不紧急"];
            self.source = [NSMutableArray arrayWithArray:resultArr];
        }
            break;
        case 2:{//C
            NSArray *resultArr = [[HSFFmdbManager sharedManager] readScheduleModelWhereEmergencyLike:@"不重要／紧急"];
            self.source = [NSMutableArray arrayWithArray:resultArr];
        }
            break;
        case 3:{//D
            NSArray *resultArr = [[HSFFmdbManager sharedManager] readScheduleModelWhereEmergencyLike:@"不重要／不紧急"];
            self.source = [NSMutableArray arrayWithArray:resultArr];
        }
            break;
            
        default:
            break;
    }
    if (self.source.count == 0) {
        [MBProgressHUD showError:@"搜索结果为空!"];
    }else{
        //刷表
        [self.tableView reloadData];
    }
    [self.view endEditing:YES];
}


#pragma mark -配置导航栏
-(void)setUpNavi{
    self.automaticallyAdjustsScrollViewInsets = NO;
    //返回
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[[UIImage imageNamed:@"back_common"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(backAction)];
    //标题
    self.navigationItem.titleView = self.optionBtn;
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
#pragma mark -viewWillDisappear
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    //保存搜索方式
    [HSF_UD setObject:self.optionBtn.titleLabel.text forKey:@"searchType"];
}
#pragma mark -viewDidLoad
- (void)viewDidLoad {
    [super viewDidLoad];
    //配置导航栏
    [self setUpNavi];
    //配置tableView
    [self setUpTableView];
    //配置搜索框
    [self setUpSearch];
    //初始化搜索方式
    [self initSearchType];
    //注册通知
    [self registerNotification];
}
//配置tableView
-(void)setUpTableView{
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    //cell高度
    self.tableView.estimatedRowHeight = 44;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    //注册cell
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([ScheduleCell_1 class]) bundle:nil] forCellReuseIdentifier:identifierCell_1];
}
//配置搜索框
-(void)setUpSearch{
    //按标题搜索
    self.titleTF.delegate = self;
    self.titleTF.inputAccessoryView = self.keyboardTool;
    //按标签搜索
    self.tagTF.delegate = self;
    self.tagTF.inputAccessoryView = self.keyboardTool;
    //按日期搜索
    self.startTimeTF.delegate = self;
    self.endTimeTF.delegate = self;
    self.startTimeTF.inputAccessoryView = self.keyboardTool2;
    self.endTimeTF.inputAccessoryView = self.keyboardTool2;
    self.startTimeTF.inputView = self.keyboardInputView;
    self.endTimeTF.inputView = self.keyboardInputView;
    //按重要／紧急程度搜索
}
//初始化搜索方式
-(void)initSearchType{
    NSString *searchType = [HSF_UD objectForKey:@"searchType"];
    if (!searchType || [searchType isEqualToString:@""] || [searchType isEqualToString:@"按标题搜索"]) {
        [self.option1StateBtn setImage:[UIImage imageNamed:@"seleted_edit_tag"] forState:UIControlStateNormal];
        [self.option2StateBtn setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
        [self.option3StateBtn setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
        [self.option4StateBtn setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
        [self.optionBtn setTitle:@"按标题搜索" forState:UIControlStateNormal];
        [self.searchBgView bringSubviewToFront:self.search_titleView];
    }else if (!searchType || [searchType isEqualToString:@"按标签搜索"]) {
        [self.option1StateBtn setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
        [self.option2StateBtn setImage:[UIImage imageNamed:@"seleted_edit_tag"] forState:UIControlStateNormal];
        [self.option3StateBtn setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
        [self.option4StateBtn setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
        [self.optionBtn setTitle:@"按标签搜索" forState:UIControlStateNormal];
        [self.searchBgView bringSubviewToFront:self.search_tagView];
    }else if (!searchType || [searchType isEqualToString:@"按日期搜索"]) {
        [self.option1StateBtn setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
        [self.option2StateBtn setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
        [self.option3StateBtn setImage:[UIImage imageNamed:@"seleted_edit_tag"] forState:UIControlStateNormal];
        [self.option4StateBtn setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
        [self.optionBtn setTitle:@"按日期搜索" forState:UIControlStateNormal];
        [self.searchBgView bringSubviewToFront:self.search_dateView];
    }else if (!searchType || [searchType isEqualToString:@"按重要／紧急程度搜索"]) {
        [self.option1StateBtn setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
        [self.option2StateBtn setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
        [self.option3StateBtn setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
        [self.option4StateBtn setImage:[UIImage imageNamed:@"seleted_edit_tag"] forState:UIControlStateNormal];
        [self.optionBtn setTitle:@"按重要／紧急程度搜索" forState:UIControlStateNormal];
        [self.searchBgView bringSubviewToFront:self.search_emergencyView];
        //默认自动搜索A
        NSArray *resultArr = [[HSFFmdbManager sharedManager] readScheduleModelWhereEmergencyLike:@"重要／紧急"];
        self.source = [NSMutableArray arrayWithArray:resultArr];
        if (self.source.count == 0) {
            [MBProgressHUD showError:@"搜索结果为空!"];
        }else{
            //刷表
            [self.tableView reloadData];
        }
    }
    [self.optionBtn layoutButtonWithEdgeInsetsStyle:HSFButtonEdgeInsetsStyleRight imageTitleSpace:5];
}
#pragma mark -UITableViewDelegate,UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.source.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ScheduleCell_1 *cell = [tableView dequeueReusableCellWithIdentifier:identifierCell_1 forIndexPath:indexPath];
    ScheduleModel *model = self.source[indexPath.row];
    //紧急情况
    if ([model.emergency isEqualToString:@"重要／紧急"]) {
        cell.emergency.image = [UIImage imageNamed:@"A"];
    }else if ([model.emergency isEqualToString:@"重要／不紧急"]) {
        cell.emergency.image = [UIImage imageNamed:@"B"];
    }else if ([model.emergency isEqualToString:@"不重要／紧急"]) {
        cell.emergency.image = [UIImage imageNamed:@"C"];
    }else if ([model.emergency isEqualToString:@"不重要／不紧急"]) {
        cell.emergency.image = [UIImage imageNamed:@"D"];
    }
    //标题
    cell.titleName.text = model.name;
    //时间
    NSString *start_time = model.start_time;
    NSString *end_time = model.end_time;
    if ([start_time isEqualToString:end_time]) {//全天事件
        cell.time.text = [NSString stringWithFormat:@"%@全天",[start_time substringWithRange:NSMakeRange(5, 5)]];
    }else{
        cell.time.text = [NSString stringWithFormat:@"%@-%@",[start_time substringWithRange:NSMakeRange(5, 11)],[end_time substringWithRange:NSMakeRange(5, 11)]];
    }   
    //标签
    if ([model.tags isEqualToString:@"点击添加标签"]) {
        cell.tag1.text = @"";
        cell.tag2.text = @"";
        cell.tag3.text = @"";
        cell.tag1.hidden = YES;
        cell.tag2.hidden = YES;
        cell.tag3.hidden = YES;
    }else{
        NSArray *tagsArr = [model.tags componentsSeparatedByString:@"、 "];
        if (tagsArr.count == 1) {
            cell.tag1.text = [NSString stringWithFormat:@"  %@  ",tagsArr[0]];
            cell.tag1.hidden = NO;
            cell.tag2.hidden = YES;
            cell.tag3.hidden = YES;
        }else if (tagsArr.count == 2) {
            cell.tag1.text = [NSString stringWithFormat:@"  %@  ",tagsArr[0]];
            cell.tag2.text = [NSString stringWithFormat:@"  %@  ",tagsArr[1]];
            cell.tag1.hidden = NO;
            cell.tag2.hidden = NO;
            cell.tag3.hidden = YES;
        }else if (tagsArr.count >= 3) {
            cell.tag1.text = [NSString stringWithFormat:@"  %@  ",tagsArr[0]];
            cell.tag2.text = [NSString stringWithFormat:@"  %@  ",tagsArr[1]];
            cell.tag3.text = [NSString stringWithFormat:@"  %@  ",tagsArr[2]];
            cell.tag1.hidden = NO;
            cell.tag2.hidden = NO;
            cell.tag3.hidden = NO;
        }
    }
    //备注
    cell.content.text = model.content;
    //图片
    NSMutableArray *picArr = [NSMutableArray array];
    NSString *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
    NSString *picArrPath = [path stringByAppendingPathComponent:[NSString stringWithFormat:@"%@",model.schedule_id]];
    NSArray *imageDataArr = [NSMutableArray arrayWithContentsOfFile:picArrPath];
    [imageDataArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UIImage *image = [UIImage imageWithData:obj];
        [picArr addObject:image];
    }];
    if (picArr.count == 0) {
        cell.pic1.hidden = NO;
        cell.pic2.hidden = YES;
        cell.pic3.hidden = YES;
    }else if (picArr.count == 1) {
        cell.pic1.image = picArr[0];
        cell.pic1.hidden = NO;
        cell.pic2.hidden = YES;
        cell.pic3.hidden = YES;
    }else if (picArr.count == 2) {
        cell.pic1.image = picArr[0];
        cell.pic2.image = picArr[1];
        cell.pic1.hidden = NO;
        cell.pic2.hidden = NO;
        cell.pic3.hidden = YES;
    }else if (picArr.count >= 3) {
        cell.pic1.image = picArr[0];
        cell.pic2.image = picArr[1];
        cell.pic3.image = picArr[2];
        cell.pic1.hidden = NO;
        cell.pic2.hidden = NO;
        cell.pic3.hidden = NO;
    }
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 1) {
        EditScheduleVC *editSchedule_VC = [[EditScheduleVC alloc]init];
        editSchedule_VC.pushOrMode = @"push";
        editSchedule_VC.model = self.source[indexPath.row];
        [self.navigationController pushViewController:editSchedule_VC animated:YES];
    }
}
#pragma mark -UITextFieldDelegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    return YES;
}
- (void)textFieldDidBeginEditing:(UITextField *)textField{
    [textField becomeFirstResponder];
    //赋值时间（开始、结束）
    NSString *dateStr = [NSDate starEndTimeWithDate:[NSDate date]];
    if ([self.startTimeTF isFirstResponder]) {
        _currentInputTimeLabel.text = [NSString stringWithFormat:@"开始时间：%@",dateStr];
    }else if ([self.endTimeTF isFirstResponder]) {
        _currentInputTimeLabel.text = [NSString stringWithFormat:@"结束时间：%@",dateStr];
    }
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
    //模拟点击搜索按钮(标题、标签)
    if (textField == self.titleTF) {
        [self searchBtnACTION:self.searchBtn_title];
    }else if (textField == self.tagTF) {
        [self searchBtnACTION:self.searchBtn_tag];
    }
    return YES;
}
#pragma mark -键盘
//注册通知
- (void)registerNotification{  
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];  
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];  
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardDidShowNotification object:nil];
    //用于日期时间选择的回调
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getYouChoosedCurrentDate:) name:@"kCustomKeyboardInputView" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardOkBtnDate:) name:@"kKeyboardOkBtn" object:nil];
    
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
//键盘选择器更改时间
-(void)getYouChoosedCurrentDate:(NSNotification *)sender{
    NSDictionary *userInfo = sender.userInfo;
    NSDate *date = userInfo[@"youChoosedDate"];
    NSString *dateStr = [NSDate starEndTimeWithDate:date];
    //赋值时间（开始、结束）
    if ([self.startTimeTF isFirstResponder]) {
        _currentInputTimeLabel.text = [NSString stringWithFormat:@"开始时间：%@",dateStr];
    }else if ([self.endTimeTF isFirstResponder]) {
        _currentInputTimeLabel.text = [NSString stringWithFormat:@"结束时间：%@",dateStr];
    }
}
//点击键盘的确认按钮
-(void)keyboardOkBtnDate:(NSNotification *)sender{
    NSDictionary *userInfo = sender.userInfo;
    NSDate *date = userInfo[@"okBtnDate"];
    NSString *dateStr = [NSDate starEndTimeWithDate:date];
    //赋值时间（开始、结束）
    if ([self.startTimeTF isFirstResponder]) {
        self.startTimeTF.text = dateStr;
    }else if ([self.endTimeTF isFirstResponder]) {
        self.endTimeTF.text = dateStr;
    }
    //刷表
    [self.tableView reloadData];
    [self.view endEditing:YES];
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

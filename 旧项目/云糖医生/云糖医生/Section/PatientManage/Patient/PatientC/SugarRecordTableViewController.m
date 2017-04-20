//
//  SugarRecordTableViewController.m
//  yuntangyi
//
//  Created by yuntangyi on 16/9/14.
//  Copyright © 2016年 yuntangyi. All rights reserved.
//

#import "SugarRecordTableViewController.h"
#import "UUDatePicker.h"
#import "SportsTableViewCell.h"
#import "SZBNetDataManager+PatientManageNetData.h"


@interface SugarRecordTableViewController ()<UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate>
@property (nonatomic, strong)UISegmentedControl *segmented;
@property (nonatomic, strong)UIView *animationView;//滑动动画
@property(nonatomic,strong)NSString* str;//传入接口的关键词
@property (nonatomic, strong)NSMutableArray *buttonArray;
@property (nonatomic, strong)UIView *BackGrayView;
@property (nonatomic)NSInteger flag2;//判断是饮食还是运动胰岛素口服药

@property (nonatomic, strong) NSMutableArray *dataSource;//数据源
@property (nonatomic, strong) NSMutableArray *arr;//每组返回的数
@property (strong, nonatomic) UITableView *currentTableView;
@property (nonatomic)int medication;//用来标记 , 加载完一次之后不在网络请求
@property (nonatomic)int meal;
@property (nonatomic)int sports;
@property (nonatomic)int insulin;

@property (nonatomic,strong) NSMutableArray *source;//数据源数组
@property (nonatomic,assign) NSInteger index;
@property (nonatomic, strong)KongPlaceHolderView *placeholdView1;//数据为空的占位图
@property (nonatomic, strong)KongPlaceHolderView *placeholdView2;//数据为空的占位图
@property (nonatomic, strong)KongPlaceHolderView *placeholdView3;//数据为空的占位图
@property (nonatomic, strong)KongPlaceHolderView *placeholdView4;//数据为空的占位图

@end

@implementation SugarRecordTableViewController
-(NSMutableArray *)source{
    if (!_source) {
        _source = [NSMutableArray array];
        NSMutableArray *arr = [NSMutableArray array];
        for (int i = 0; i < 4; i++) {
            [_source addObject:arr];
        }
    }
    return _source;
}
- (NSMutableArray *)dataSource {
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}
-(UIView *)animationView {
    if (!_animationView) {
        self.animationView = [[UIView alloc]initWithFrame:CGRectMake(KScreenWidth / 4 *self.flag2, 62, KScreenWidth / 4, 3)];
        self.animationView.backgroundColor = KRGB(0, 172, 204, 1.0);
    }
    return _animationView;
}
- (UIView *)BackGrayView {
    if (!_BackGrayView) {
        _BackGrayView = [[UIView alloc]initWithFrame:self.view.bounds];
        _BackGrayView.alpha = 0.5;
        _BackGrayView.backgroundColor = [UIColor grayColor];
    }
    return _BackGrayView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"返回"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStyleDone target:self action:@selector(goToBack)];
    _startDateTF.delegate = self;
    _endStartTF.delegate = self;
    self.flag2 = [[ZXUD objectForKey:@"flag2"] integerValue];
    //添加滑动条
    [self.backV addSubview:self.animationView];
    
    //给四个按钮加点击事件并给tag值
    [self prefectBtnThings];
    //日期选择
    [self timehandle];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    //添加回收键盘手势
    UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
    [self.view addGestureRecognizer:gestureRecognizer];
    //设置默认开始与结束日期
    NSDate *currentDate = [NSDate date];
    NSDate *newDate = [currentDate dateByAddingTimeInterval: - 60 * 60 * 24 * 6];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"YYYY-MM-dd"];
    NSString *dateString = [dateFormatter stringFromDate:currentDate];
    NSString *NewdateString = [dateFormatter stringFromDate:newDate];
    self.startDateTF.text = NewdateString;
    self.endStartTF.text = dateString;
    [self creatScrollView];
  
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.scrollView.contentOffset = CGPointMake(KScreenWidth * self.flag2, 0);
}
//配置scrollview属性
-(void)creatScrollView{
    self.scrollView.tag = 888;
    self.scrollView.delegate = self;
    self.tableView1.delegate = self;
    self.tableView1.dataSource = self;
    self.tableView2.delegate = self;
    self.tableView2.dataSource = self;
    self.tableView3.delegate = self;
    self.tableView3.dataSource = self;
    self.tableView4.delegate = self;
    self.tableView4.dataSource = self;
    //注册cell
    [self.tableView1 registerNib:[UINib nibWithNibName:@"SportsTableViewCell" bundle:nil] forCellReuseIdentifier:@"SportsTableViewCellID"];
    [self.tableView2 registerNib:[UINib nibWithNibName:@"SportsTableViewCell" bundle:nil] forCellReuseIdentifier:@"SportsTableViewCellID"];
    [self.tableView3 registerNib:[UINib nibWithNibName:@"SportsTableViewCell" bundle:nil] forCellReuseIdentifier:@"SportsTableViewCellID"];
    [self.tableView4 registerNib:[UINib nibWithNibName:@"SportsTableViewCell" bundle:nil] forCellReuseIdentifier:@"SportsTableViewCellID"];

    //添加下拉刷新
    self.tableView1.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
         self.index = 0;
        [self netDataChange:self.index];
        }];
    //添加下拉刷新
    self.tableView2.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        self.index = 1;
        [self netDataChange:self.index];
    }];
    //添加下拉刷新
    self.tableView3.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        self.index = 2;
        [self netDataChange:self.index];
    }];
    //添加下拉刷新
    self.tableView4.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        self.index = 3;
        [self netDataChange:self.index];
    }];
   
    [self netDataChange:self.flag2];
    
}
//scrollView 滑动
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    if (scrollView.tag == 888) {
        for (UIButton *btn in _buttonArray)
        {
            [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        }
        UIButton *btn = [self.view viewWithTag:100 + self.scrollView.contentOffset.x / scrollView.frame.size.width];
        [btn setTitleColor: KRGB(0, 172, 204, 1.0) forState:UIControlStateNormal];
        [self LocalDataChange:self.scrollView.contentOffset.x / scrollView.frame.size.width];
        [self animationMove:self.scrollView.contentOffset.x / scrollView.frame.size.width];
    }
}
- (void)hideKeyboard {
    [self.view endEditing:YES];
}
-(void)timehandle{
    UIView *backgroundview1 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, 216)];
    UIView *backgroundview2 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, 216)];
    UUDatePicker *datePicker = [[UUDatePicker alloc]initWithframe:CGRectMake(0, 0, KScreenWidth, 216 *3/4) PickerStyle:UUDateStyle_YearMonthDay didSelected:^(NSString *year, NSString *month, NSString *day, NSString *hour, NSString *minute, NSString *weekDay) {
        _startDateTF.text = [NSString stringWithFormat:@"%@-%@-%@",year,month,day];
    }];
    [backgroundview1 addSubview:datePicker];
    UUDatePicker *datePicker2 = [[UUDatePicker alloc]initWithframe:CGRectMake(0, 0, KScreenWidth, 216 *3/4) PickerStyle:UUDateStyle_YearMonthDay didSelected:^(NSString *year, NSString *month, NSString *day, NSString *hour, NSString *minute, NSString *weekDay) {
        //   NSLog(@"选择日期");
        _endStartTF.text = [NSString stringWithFormat:@"%@-%@-%@",year,month,day];
    }];
    [backgroundview2 addSubview:datePicker2];
    UIView *V = [[UIView alloc]initWithFrame:CGRectMake(0, 216 *3/4, KScreenWidth, 216/4)];
    V.backgroundColor = [UIColor lightGrayColor];
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 1, KScreenWidth, 216/4-2);
    [btn setTitle:@"确认" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btn.backgroundColor = KRGB(0, 172, 204, 1.0);
    [V addSubview:btn];
    [btn addTarget:self action:@selector(hideKeyboard) forControlEvents:UIControlEventTouchUpInside];
    UIView *VV = [[UIView alloc]initWithFrame:CGRectMake(0, 216 *3/4, KScreenWidth, 216/4)];
    VV.backgroundColor = [UIColor lightGrayColor];
    UIButton *btn1 = [UIButton buttonWithType:UIButtonTypeCustom];
    btn1.frame = CGRectMake(0, 1, KScreenWidth, 216/4-2);
    [btn1 setTitle:@"确认" forState:UIControlStateNormal];
    [btn1 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btn1.backgroundColor = KRGB(0, 172, 204, 1.0);
    [VV addSubview:btn1];
    [btn1 addTarget:self action:@selector(hideKeyboard) forControlEvents:UIControlEventTouchUpInside];
    [backgroundview2 addSubview:VV];
    [backgroundview1 addSubview:V];
    _startDateTF.inputView = backgroundview1;
    _endStartTF.inputView = backgroundview2;
}
- (void)prefectBtnThings {
    self.yinshiBtn.tag = 100;
    self.sportBtn.tag = 101;
    self.yidaosuBtn.tag = 102;
    self.koufuyaoBtn.tag = 103;
    _buttonArray = [NSMutableArray array];
    [_buttonArray addObject:self.yinshiBtn];
    [_buttonArray addObject:self.sportBtn];
    [_buttonArray addObject:self.yidaosuBtn];
    [_buttonArray addObject:self.koufuyaoBtn];
    for (UIButton *btn in _buttonArray)
    {
        [btn addTarget:self action:@selector(functionBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        if (btn.tag - 100 == self.flag2) {
            [btn setTitleColor:KRGB(0, 172, 204, 1.0) forState:UIControlStateNormal];
        }
    }
}
//点击切换
- (void)functionBtnClick:(UIButton *)btn {
    NSInteger X = btn.tag - 100;
    for (UIButton *btn in _buttonArray){
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    }
    [btn setTitleColor: KRGB(0, 172, 204, 1.0) forState:UIControlStateNormal];
    [self animationMove:X];
    [self LocalDataChange:X];
    self.scrollView.contentOffset = CGPointMake(self.scrollView.bounds.size.width * X, 0);
}
//动画条移动
- (void)animationMove:(NSInteger)X {
    [UIView animateWithDuration:0.2 animations:^{
        self.animationView.frame = CGRectMake((KScreenWidth / 4) * X , 62,  KScreenWidth / 4, 3);
    }];
}
//点击或者滑的时候
-(void)LocalDataChange:(NSInteger)num {
    //停掉上一次的刷新
    [self.currentTableView.mj_header endRefreshing];
    self.index = num;
    switch (num) {
        case 0:{
            self.currentTableView = self.tableView1;
            self.str = @"get_patient_meal";
            if (self.meal == 1) {
                return;
            }
            self.meal = 1;
        }
            break;
        case 1:{
            self.currentTableView = self.tableView2;
            self.str = @"get_patient_movement";
            if (self.sports == 1) {
                return;
            }
            self.sports = 1;
        }
            break;
        case 2:{
            self.currentTableView = self.tableView3;
            self.str = @"get_patient_insulin";
            if (self.insulin == 1) {
                return;
           }
            self.insulin = 1;
        }
            break;
        default:
            self.currentTableView = self.tableView4;
            self.str = @"get_patient_medication";
            if (self.medication == 1) {
               return;
          }
            self.medication = 1;
            
        break;
    }
    [self getPatientDataSource:self.index];
}
//下拉刷新的时候, 去请求数据
-(void)netDataChange:(NSInteger)num {
  
    self.index = num;
    switch (num) {
        case 0:{
            self.currentTableView = self.tableView1;
            self.str = @"get_patient_meal";
            self.meal = 1;
        }
            break;
        case 1:{
            self.currentTableView = self.tableView2;
            self.str = @"get_patient_movement";
            self.sports = 1;
        }
            break;
        case 2:{
            self.currentTableView = self.tableView3;
            self.str = @"get_patient_insulin";
            self.insulin = 1;
        }
            break;
        default:
            self.currentTableView = self.tableView4;
            self.str = @"get_patient_medication";
            self.medication = 1;
            break;
    }
    [self getPatientDataSource:self.index];
}
//获取网络数据
- (void)getPatientDataSource:(NSInteger)index {
    
     __weak typeof(self) MYSelf = self;
    [[SZBNetDataManager manager]StatisticsM:self.str andRandomString:[ToolManager getCurrentTimeStamp] andCode:[ZXUD objectForKey:@"ident_code"] andPatient_id:[ZXUD objectForKey:@"patient_id"] andStartDate:_startDateTF.text andEndDate:_endStartTF.text success:^(NSURLSessionDataTask *task, id responseObject) {
        if ([responseObject[@"res"] isEqualToString:@"1001"]) {
            NSMutableArray *tmp = [NSMutableArray array];
            if ([responseObject[@"list"] isKindOfClass:[NSArray class]]) {
                
                for (NSDictionary *dic in responseObject[@"list"]) {
                    [tmp addObject:dic];
                }
            }
            [self.source replaceObjectAtIndex:index withObject:tmp];
            switch (self.index) {
                case 0:
                    if ([self.source[0] count] == 0) {
                        //加载的数据为空
                        _placeholdView1 = [[KongPlaceHolderView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, self.scrollView.frame.size.height)];
                        _placeholdView1.label.text = @"没有记录";
                        [self.tableView1 addSubview:_placeholdView1];
                    }else {
                        [_placeholdView1 removeFromSuperview];
                    }
                    break;
                case 1:
                    if ([self.source[1] count] == 0) {
                        
                        //加载的数据为空
                        _placeholdView2 = [[KongPlaceHolderView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, self.scrollView.frame.size.height)];
                        _placeholdView2.label.text = @"没有记录";
                        [self.tableView2 addSubview:_placeholdView2];
                    }else {
                        [_placeholdView2 removeFromSuperview];
                    }
                    break;
                case 2:
                   if ([self.source[2] count] == 0) {
                        //加载的数据为空
                        _placeholdView3 = [[KongPlaceHolderView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, self.scrollView.frame.size.height)];
                        _placeholdView3.label.text = @"没有记录";
                        [self.tableView3 addSubview:_placeholdView3];
                    }else {
                        [_placeholdView3 removeFromSuperview];
                    }

                    break;
                case 3:
                    if ([self.source[3] count] == 0) {
                        //加载的数据为空
                        _placeholdView4 = [[KongPlaceHolderView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, self.scrollView.frame.size.height)];
                        _placeholdView4.label.text = @"没有记录";
                        [self.tableView4 addSubview:_placeholdView4];
                    }else {
                        [_placeholdView4 removeFromSuperview];
                    }

                    break;
                    
                default:
                    break;
            }
            [MYSelf.currentTableView reloadData];
           
        }else  if ([responseObject[@"res"] isEqualToString:@"1002"]) {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"登录状态已过期, 请重新登录" message:nil preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *anotherAction = [UIAlertAction actionWithTitle:@"登录" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
                //让用户重新登录
                [ZXUD setObject:nil forKey:@"ident_code"];
                LoginVC *VC = [[LoginVC alloc] init];
                UINavigationController *navi = [[UINavigationController alloc]initWithRootViewController:VC];
                [self presentViewController:navi animated:YES completion:nil];
            }];
            [alert addAction:anotherAction];
            [MYSelf presentViewController:alert animated:YES completion:^{
                
            }];
        }else if ([responseObject[@"res"] isEqualToString:@"1005"] || [responseObject[@"res"] isEqualToString:@"1004"]) {
            
        }else {
            [MBProgressHUD showError:responseObject[@"msg"]];
            
        }
        [MYSelf.currentTableView.mj_header endRefreshing];
    } failed:^(NSURLSessionTask *task, NSError *error) {
       [MYSelf.currentTableView.mj_header endRefreshing];
       [MBProgressHUD showError:@"网络错误"];
    }];
}
- (void)goToBack {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
   return [self.source[self.index] count];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSDictionary *Dic = self.source[self.index][section];
    if ([self.str isEqualToString:@"get_patient_movement"]) {
//        运动
        _arr = Dic[@"movement_list"];
        return _arr.count;
    }else if ([self.str isEqualToString:@"get_patient_insulin"]) {
//        胰岛素
        _arr = Dic[@"medication_list"];
        return _arr.count;
    }else if ([self.str isEqualToString:@"get_patient_medication"]) {
//        口服药
        _arr = Dic[@"medication_list"];
        return _arr.count;
    }else {
//        饮食
       _arr = Dic[@"meal_list"];
        return _arr.count;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    SportsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SportsTableViewCellID" forIndexPath:indexPath];
    NSDictionary *Dic = self.source[self.index][indexPath.section];
    if ([self.str isEqualToString:@"get_patient_movement"]) {
         _arr = Dic[@"movement_list"];
        //运动
        NSDictionary *dic = Dic[@"movement_list"][indexPath.row];
        if ([dic[@"movement"] isKindOfClass:[NSString class]]) {
             cell.styleLable.text = dic[@"movement"];
        }else {
             cell.styleLable.text = @"运动";
        }
        cell.timeLable.text = [NSString stringWithFormat:@"%@开始", [dic[@"addtime"] substringFromIndex:11]];
        cell.detailLable.text = [NSString stringWithFormat:@"%@分钟", dic[@"time"]];
        cell.styleLable.adjustsFontSizeToFitWidth = YES;
        cell.detailLable.adjustsFontSizeToFitWidth = YES;
    }else if ([self.str isEqualToString:@"get_patient_insulin"]) {
         _arr = Dic[@"medication_list"];
        //胰岛素
        cell.styleLable.adjustsFontSizeToFitWidth = YES;
        cell.detailLable.adjustsFontSizeToFitWidth = YES;
        NSDictionary *dic = Dic[@"medication_list"][indexPath.row];
      
        if ([dic[@"medication2"] isKindOfClass:[NSString class]] && ![dic[@"medication2"] isEqualToString:@""]) {
               cell.styleLable.text = [NSString stringWithFormat:@"%@", dic[@"medication2"]];
        }
        else if([dic[@"medication1"] isKindOfClass:[NSString class]] && ![dic[@"medication1"] isEqualToString:@""]) {
               cell.styleLable.text = [NSString stringWithFormat:@"%@",dic[@"medication1"]];
        }
    
        cell.timeLable.text = [dic[@"addtime"] substringFromIndex:11];
        if ([dic[@"num"] isKindOfClass:[NSString class]]) {
            cell.detailLable.text = [NSString stringWithFormat:@"%@U", dic[@"num"]];
        }
    }else if ([self.str isEqualToString:@"get_patient_medication"]) {
        _arr = Dic[@"medication_list"];
        //口服药
        cell.styleLable.adjustsFontSizeToFitWidth = YES;
        cell.detailLable.adjustsFontSizeToFitWidth = YES;
        NSDictionary *dic = Dic[@"medication_list"][indexPath.row];
        if ([dic[@"medication2"] isKindOfClass:[NSString class]] && ![dic[@"medication2"] isEqualToString:@""]) {
            cell.styleLable.text = [NSString stringWithFormat:@"%@", dic[@"medication2"]];
        }
        else if([dic[@"medication1"] isKindOfClass:[NSString class]] && ![dic[@"medication1"] isEqualToString:@""]) {
            cell.styleLable.text = [NSString stringWithFormat:@"%@",dic[@"medication1"]];
        }
        cell.timeLable.text = [dic[@"addtime"] substringFromIndex:11];
        if ([dic[@"num"] isKindOfClass:[NSString class]]) {
            if ([dic[@"medication1"] containsString:@"胶囊"]) {
                 cell.detailLable.text = [NSString stringWithFormat:@"%d粒", [dic[@"num"] integerValue]];
            }else {
                 cell.detailLable.text = [NSString stringWithFormat:@"%d片", [dic[@"num"] integerValue]];
            }
        }
    }else {
         _arr = Dic[@"meal_list"];
        //饮食
        NSDictionary *dic = Dic[@"meal_list"][indexPath.row];
        cell.styleLable.text = [dic[@"mealtimes"] substringFromIndex:11];
        cell.styleLable.adjustsFontSizeToFitWidth = YES;
        cell.detailLable.adjustsFontSizeToFitWidth = YES;
//        int num = 0;
//        for (NSDictionary *dict in dic[@"food_list"]) {
//          num += [dict[@"food_weight"] integerValue];
//        }
        cell.timeLable.text = [NSString stringWithFormat:@"%@大卡",dic[@"calorie"]];
        cell.detailLable.text = dic[@"time_point"];
    }
    if (indexPath.section == [self.source[self.index] count] - 1) {
        if (indexPath.row == _arr.count - 1) {
            cell.xianV.backgroundColor = KRGB(0, 172, 204, 1.0);
        }else {
             cell.xianV.backgroundColor = KRGB(238, 238, 238, 1.0);
        }
    }else {
        cell.xianV.backgroundColor = KRGB(238, 238, 238, 1.0);
    }
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 80;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 60;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.1;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = [[UIView alloc]init];
    view.backgroundColor = [UIColor whiteColor];
    UIImageView *imageV = [[UIImageView alloc]initWithFrame:CGRectMake(25, 0, 30, 59)];
    imageV.image = [UIImage imageNamed:@"时间"];
    [imageV setContentMode:UIViewContentModeScaleAspectFit];
    
    [view addSubview:imageV];
    UILabel *timeLable = [[UILabel alloc]initWithFrame:CGRectMake(65, 0, KScreenWidth - 55, 59)];
    timeLable.textColor = [UIColor darkGrayColor];
   NSDictionary *Dic = self.source[self.index][section];
   timeLable.text = Dic[@"date"];
    [view addSubview:timeLable];
    UIView *xianV = [[UIView alloc]initWithFrame:CGRectMake(40, 59, KScreenWidth - 40, 1)];
    xianV.backgroundColor =  J_BackLightGray;
    [view addSubview:xianV];
    return view;
}

//设置时间键盘显示事件
- (void)keyboardWillShow:(NSNotification *)notification {
    if (self.startDateTF.editing) {
        self.leftImageV.image = [UIImage imageNamed:@"展开"];
    }
    if (_endStartTF.editing) {
        self.rightImageV.image = [UIImage imageNamed:@"展开"];
    }
    [self.view addSubview: self.BackGrayView];
    self.currentTableView.scrollEnabled = NO;
}

//设置时间键盘消失事件
- (void) keyboardWillHide:(NSNotification *)notify {
    self.leftImageV.image = [UIImage imageNamed:@"下一步-拷贝"];
    self.rightImageV.image = [UIImage imageNamed:@"下一步-拷贝"];
    [self.BackGrayView removeFromSuperview];
    self.currentTableView.scrollEnabled = YES;
}
-(void)textFieldDidEndEditing:(UITextField *)textField
{
    NSComparisonResult result = [_endStartTF.text compare:_startDateTF.text];
    if (result == -1) {
        [MBProgressHUD showError:@"日期选择有误" toView:self.view];
        return;
    }
    [self getPatientDataSource:self.index];
    
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

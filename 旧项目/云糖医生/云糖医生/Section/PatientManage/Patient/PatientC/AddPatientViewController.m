//
//  AddPatientViewController.m
//  yuntangyi
//
//  Created by yuntangyi on 16/9/13.
//  Copyright © 2016年 yuntangyi. All rights reserved.
//

#import "AddPatientViewController.h"
#import "WeiChatSweepTableViewCell.h"
#import "SearchBarHeader.h"
#import "SZBNetDataManager+PatientManageNetData.h"
#import "PatientListTableViewCell.h"

@interface AddPatientViewController ()<UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableV;
@property (nonatomic, strong)UIView *animationView;//滑动动画
@property(nonatomic,strong)NSString* str;//传入接口的关键词
@property (nonatomic) NSInteger numOfPage;//滑动标记第几页
@property (nonatomic, strong)NSMutableArray *buttonArray;
@property (nonatomic, strong)NSMutableArray *dataSource;
@property (nonatomic, strong)UITextField *SearchPhoneTF;//搜索框的手机号
@property (nonatomic, strong) NetworkLoadFailureView *loadFailureView;
@property (nonatomic, strong) NSDictionary *dic;//添加患者对应的数据
@property (nonatomic)int flag;//判断是添加调用搜索接口还是搜索按钮的调用
@property (nonatomic,strong)NSString *phoneStr;//手机号
@end

@implementation AddPatientViewController
# pragma mark 懒加载
-(NetworkLoadFailureView *)loadFailureView{
    if (!_loadFailureView) {
        _loadFailureView = [[NetworkLoadFailureView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    }
    return _loadFailureView;
}
-(UIView *)animationView {
    if (!_animationView) {
        self.animationView = [[UIView alloc]initWithFrame:CGRectMake(0, 56, KScreenWidth / 2, 5)];
        self.animationView.backgroundColor = KRGB(0, 172, 204, 1.0);;
    }
    return _animationView;
}

-(NSMutableArray *)dataSource {
    if (!_dataSource) {
        self.dataSource = [[NSMutableArray alloc]initWithCapacity:1];
    }
    return _dataSource;
}
//初始化方法
-(instancetype)init{
    if (self = [super init]) {
        self.hidesBottomBarWhenPushed = YES;
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.str = @"0";
    self.flag = 0;
    self.navigationItem.title = @"添加患者";
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"返回"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStyleDone target:self action:@selector(goToBack)];
    
    self.tableV.delegate = self;
    self.tableV.dataSource = self;
   
    //在tableview添加手势，模拟
    UISwipeGestureRecognizer *leftSwipGes = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(rightSwipEvent:)];
    leftSwipGes.direction = UISwipeGestureRecognizerDirectionRight;
    [_tableV addGestureRecognizer:leftSwipGes];
    
    UISwipeGestureRecognizer *rightSwipGes = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(leftSwipEvent:)];
    leftSwipGes.direction = UISwipeGestureRecognizerDirectionLeft;
    [_tableV addGestureRecognizer:rightSwipGes];
    //添加滑动条
    [self.backV addSubview:self.animationView];
    //注册cell
    [self.tableV registerNib:[UINib nibWithNibName:@"WeiChatSweepTableViewCell" bundle:nil] forCellReuseIdentifier:@"WeiChatSweepTableViewCellID"];
     [self.tableV registerNib:[UINib nibWithNibName:@"PatientListTableViewCell" bundle:nil] forCellReuseIdentifier:@"PatientListTableViewCellID"];
    //注册搜索区头
    [self.tableV registerNib:[UINib nibWithNibName:NSStringFromClass([SearchBarHeader class]) bundle:nil] forHeaderFooterViewReuseIdentifier:@"SearchBarHeader"];
    //给两个按钮加点击事件并给tag值
    [self prefectBtnThings];
    // Do any additional setup after loading the view from its nib.
    //添加回收键盘手势
    UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
    [self.view addGestureRecognizer:gestureRecognizer];
}
- (void)hideKeyboard {
    [self.view endEditing:YES];
   
}

- (void)goToBack {
    //发通知
    [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadData"  object:nil userInfo:nil];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)prefectBtnThings {
    self.phoneBtn.tag = 100;
    self.weiChatBtn.tag = 101;
    _buttonArray = [NSMutableArray array];
    [_buttonArray addObject:self.phoneBtn];
    [_buttonArray addObject:self.weiChatBtn];
    for (UIButton *btn in _buttonArray)
    {
        [btn addTarget:self action:@selector(functionBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
}
//点击切换
- (void)functionBtnClick:(UIButton *)btn {
    NSInteger X = btn.tag - 100;
    for (UIButton *btn in _buttonArray)
    {
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    }
    [btn setTitleColor:KRGB(0, 172, 204, 1.0) forState:UIControlStateNormal];
    [self animationMove:X];
    [self netDataChange:X];
}
//左轻扫切换
- (void)leftSwipEvent:(UISwipeGestureRecognizer *)swip {
    if( --_numOfPage < 0) {
        _numOfPage = 0;
    }
    for (UIButton *btn in _buttonArray)
    {
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    }
    UIButton *btn = [self.view viewWithTag:100 + _numOfPage];
    [btn setTitleColor:KRGB(0, 172, 204, 1.0) forState:UIControlStateNormal];
    [self animationMove:_numOfPage];
    [self netDataChange:_numOfPage];
}
//右轻扫切换
- (void)rightSwipEvent:(UISwipeGestureRecognizer *)swip {
    if( ++_numOfPage > 1) {
        _numOfPage = 1;
    }
    for (UIButton *btn in _buttonArray)
    {
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    }
    UIButton *btn = [self.view viewWithTag:100 + _numOfPage];
    [btn setTitleColor:KRGB(0, 172, 204, 1.0) forState:UIControlStateNormal];
    
    [self animationMove:_numOfPage];
    [self netDataChange:_numOfPage];
}
//动画条移动
- (void)animationMove:(NSInteger)X {
    [UIView animateWithDuration:0.2 animations:^{
        self.animationView.frame = CGRectMake((KScreenWidth / 2) * X , CGRectGetMaxY(self.backV.frame) - 69,  KScreenWidth / 2, 5);
    }];
    if (X == 1) {
         [self.view endEditing:YES];
    }
}
//切换关键词 , 去请求数据
-(void)netDataChange:(NSInteger)num {
    switch (num) {
        case 0:{
            self.str = @"0";
        }
            break;
        case 1:{
            self.str = @"1";
        }
            break;
        default:
            break;
    }
    [self.tableV reloadData];
}
#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if ([self.str isEqualToString:@"0"]) {
        return self.dataSource.count;
    }
    return 1;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
   
    switch ([self.str intValue]) {
        case 0:{
            PatientListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PatientListTableViewCellID" forIndexPath:indexPath];
            NSDictionary *dic = self.dataSource[indexPath.row];
            cell.addPatientBtn.hidden = NO;
            cell.addPatientBtn.layer.cornerRadius = 5;
            cell.addPatientBtn.layer.masksToBounds = YES;
            cell.showType.hidden = YES;
            cell.ziliao.hidden = YES;
            cell.smallimageV.hidden = YES;
          
            if ([dic[@"status"] integerValue] == 0) {
                [cell.addPatientBtn setTitle:@"添加" forState:UIControlStateNormal];
                 cell.addPatientBtn.backgroundColor = KRGB(0, 172, 204, 1.0);
                cell.addPatientBtn.userInteractionEnabled = YES;
            }else {
                [cell.addPatientBtn setTitle:@"已添加" forState:UIControlStateNormal];
                cell.addPatientBtn.backgroundColor = [UIColor lightGrayColor];
                cell.addPatientBtn.userInteractionEnabled = NO;
            }
            [cell.headImageV sd_setImageWithURL:[NSURL URLWithString:dic[@"pic"]] placeholderImage:[UIImage imageNamed:@"默认患者头像"]];
            cell.nameLable.text = dic[@"name"];
            if ([dic[@"gender"] isEqualToString:@"1"]) {
                cell.genderLable.text = @"女";
            }else {
                cell.genderLable.text = @"男";
            }
            cell.ageLable.text = dic[@"age"];
            cell.sickType.text = dic[@"diabetes"];
            [cell.addPatientBtn addTarget:self action:@selector(addPatientAction:) forControlEvents:UIControlEventTouchUpInside];
            cell.addPatientBtn.tag = 100 + indexPath.row;
            return cell;
        }
            break;
            
        default:
        {
            
            WeiChatSweepTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"WeiChatSweepTableViewCellID" forIndexPath:indexPath];

            NSString *str;
            if ( [[ZXUD objectForKey:@"activity_id"] isKindOfClass:[NSString class]] && ! [[ZXUD objectForKey:@"activity_id"] isEqualToString:@""]) {
                str = [ZXUD objectForKey:@"activity_id"];
            }else {
                str = @"0";
            }
            cell.erWeiCodeImageV.image = [UIImage imageOfQRFromURL:[NSString stringWithFormat:@"%@,%@", [ZXUD objectForKey:@"ids"], @"0"]];
            
            return cell;
        }
            break;
    }
    // Configure the cell...
    
    
    
}
//添加患者
- (void)addPatientAction:(UIButton *)btn {
    _dic = self.dataSource[btn.tag - 100];
    [self addPatient];
}
- (void)addPatient {
   
    [[SZBNetDataManager manager]patientAddRandomString:[ToolManager getCurrentTimeStamp] andCode:[ZXUD objectForKey:@"ident_code"] andPatient_id:_dic[@"id"] andActivity_id:0 success:^(NSURLSessionDataTask *task, id responseObject) {
        [self.loadFailureView removeFromSuperview];
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
             self.flag = 1;
             [self SearchAction];
        }else if ([responseObject[@"res"] isEqualToString:@"1005"] || [responseObject[@"res"] isEqualToString:@"1004"]) {
        }else {
            [MBProgressHUD showError:responseObject[@"msg"]];
        }
    } failed:^(NSURLSessionTask *task, NSError *error) {
        [self.view addSubview:self.loadFailureView];
        [self.loadFailureView.loadAgainBtn addTarget:self action:@selector(addPatient) forControlEvents:UIControlEventTouchUpInside];
    }];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.str isEqualToString:@"0"]) {
        return 100;
    }
    return 180 + (KScreenWidth - 80);
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if ([self.str isEqualToString:@"0"]) {
        return 60;
    }
    return 0.1;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    SearchBarHeader *header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"SearchBarHeader"];
    self.SearchPhoneTF = header.SearchTF;
    self.SearchPhoneTF.placeholder = @"请输入患者手机号";
    self.SearchPhoneTF.delegate = self;
    [header.SearchBtn addTarget:self action:@selector(SearchAction) forControlEvents:UIControlEventTouchUpInside];
    return header;
}

//手机号输入框 动态监控
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if (textField == _SearchPhoneTF) {
        if (range.location > 10) {
           [MBProgressHUD showError:@"手机号码为11位"];
            _SearchPhoneTF.text = [_SearchPhoneTF.text substringToIndex:11];
            return NO;
        }
        return YES;
    }else {
        return YES;
    }
}
//按手机号搜索
- (void)SearchAction{
    if (self.flag == 0) {
        if (_SearchPhoneTF.text.length == 0 ) {
            [MBProgressHUD showError:@"请输入手机号"];
            return;
        }else {
            self.phoneStr = self.SearchPhoneTF.text;
            [MBProgressHUD showMessage:@"正在搜索" toView:self.view];
        }
    }
    self.flag = 0;
    [self.view endEditing:YES];
    [[SZBNetDataManager manager]SearchPhoneRandomString:[ToolManager getCurrentTimeStamp] andCode:[ZXUD objectForKey:@"ident_code"] andPhone:self.phoneStr success:^(NSURLSessionDataTask *task, id responseObject) {
        [MBProgressHUD hideHUDForView:self.view];
            [self.loadFailureView removeFromSuperview];
            if ([responseObject[@"res"] isEqualToString:@"1001"]) {
                [self.dataSource removeAllObjects];
                NSArray *arr = responseObject[@"list"];
                if ([arr isKindOfClass:[NSArray class]] && arr.count > 0) {
                    for (NSDictionary *dic in responseObject[@"list"]) {
                        [self.dataSource addObject:dic];
                    }
                    [self.tableV reloadData];
                }
                if (self.dataSource.count == 0) {
                    [MBProgressHUD showError:@"没有搜索结果"];
                }
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
                [self presentViewController:alert animated:YES completion:^{
                    
                }];
            }else if ([responseObject[@"res"] isEqualToString:@"1005"]) {
                [MBProgressHUD showError:@"请输入搜索的内容" toView:self.view];
            }else if ([responseObject[@"res"] isEqualToString:@"1004"]) {
                
            }else {
                [MBProgressHUD showError:responseObject[@"msg"]];
            }
            
            
        } failed:^(NSURLSessionTask *task, NSError *error) {
//            [self.view addSubview:self.loadFailureView];
//            [self.loadFailureView.loadAgainBtn addTarget:self action:@selector(SearchAction) forControlEvents:UIControlEventTouchUpInside];
            [MBProgressHUD hideHUDForView:self.view];
            [MBProgressHUD showError:@"网络错误"];
        }];

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated {
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSFontAttributeName:[UIFont systemFontOfSize:20],NSForegroundColorAttributeName:KRGB(0, 172, 204, 1.0)}];
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

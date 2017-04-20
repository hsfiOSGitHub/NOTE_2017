//
//  SchedulingSetTableViewController.m
//  yuntangyi
//
//  Created by yuntangyi on 16/9/6.
//  Copyright © 2016年 yuntangyi. All rights reserved.
//

#import "SchedulingSetTableViewController.h"
#import "ZXNumberOfDaysTableViewCell.h"
#import "ZXDaySetDetailTableViewCell.h"
#import "ZXDaySetDetailTableViewCell1.h"
#import "OrderedNumTableViewCell.h"
#import "SZBNetDataManager+Worksheet.h"
#import "LoginVC.h"
@interface SchedulingSetTableViewController ()<UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource>
@property(nonatomic, strong)UILabel *daylable;//显示天数的
@property (nonatomic)int am;//上午是否休息
@property (nonatomic)int pm;//下午是否休息

//@property (nonatomic, strong)UILabel *AmQuanNum;//上午预约人数lable
//@property (nonatomic, strong)UILabel *PmQuanNum;//下午预约人数lable
@property (nonatomic, strong)NSString *pointStr;//设置上下午的拼接串
@property (nonatomic, strong) UIView *BackGrayView;//编辑时加的背景蒙版
@property (nonatomic, strong) UITextField *currentTF;//变量TF
@property (nonatomic)int DayNum;//天数
@end

@implementation SchedulingSetTableViewController
#pragma mark - 懒加载
- (UIView *)BackGrayView {
    if (!_BackGrayView) {
        _BackGrayView = [[UIView alloc]initWithFrame:self.tableView.bounds];
        _BackGrayView.alpha = 0.5;
        _BackGrayView.backgroundColor = [UIColor grayColor];
    }
    return _BackGrayView;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"排班设置";
    self.navigationController.navigationBar.translucent = YES;
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"返回"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStyleDone target:self action:@selector(goToBack)];
   
    //获取当天日期
    NSDate *date = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
     [formatter setDateFormat:@"YYYY-MM-dd"];
    self.start_date = [formatter stringFromDate:date];
    //默认设置一天(即结束日期等于当前日期)
    self.DayNum = 1;
    self.end_date = self.start_date;
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style: UITableViewStyleGrouped];
    self.tableView.backgroundColor = J_BackLightGray;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    [self.tableView registerNib:[UINib nibWithNibName:@"ZXNumberOfDaysTableViewCell" bundle:nil] forCellReuseIdentifier:@"ZXNumberOfDaysTableViewCellID"];
    [self.tableView registerNib:[UINib nibWithNibName:@"ZXDaySetDetailTableViewCell" bundle:nil] forCellReuseIdentifier:@"ZXDaySetDetailTableViewCellID"];
    [self.tableView registerNib:[UINib nibWithNibName:@"ZXDaySetDetailTableViewCell1" bundle:nil] forCellReuseIdentifier:@"ZXDaySetDetailTableViewCellID1"];
    [self.tableView registerNib:[UINib nibWithNibName:@"OrderedNumTableViewCell" bundle:nil] forCellReuseIdentifier:@"OrderedNumTableViewCellID"];
    // 添加回收键盘手势
    UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
    [self.tableView addGestureRecognizer:gestureRecognizer];
    //设置时间的键盘事件
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    //创建右边提交按钮
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, 44, 44);
    [btn setTitle:@"确定" forState:UIControlStateNormal];
    [btn setTitleColor: KRGB(0, 172, 204, 1.0) forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(handleRightBtn:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithCustomView:btn];
    [rightItem setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17],NSForegroundColorAttributeName:KRGB(0, 172, 204, 1.0)} forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem = rightItem;
    //标记上下午是否休息
    self.am = 1;
    self.pm = 1;
}
- (void)goToBack {
   
    [self.navigationController popViewControllerAnimated:YES];
}
//确定排班按钮
- (void)handleRightBtn:(UIBarButtonItem *)item{
    if (self.am == 1 && self.pm == 0 ) {
        self.pointStr = @"am";
    }else if (self.am == 0 && self.pm == 1) {
          self.pointStr = @"pm";
    }else if (self.am && self.pm) {
        self.pointStr = @"am,pm";
    }else {
        [MBProgressHUD showError:@"请选择上午或下午"];
        return;
    }
    //设置排班
    [self SetScheduling];
}

- (void)SetScheduling {
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"YYYY-MM-dd"];
    NSDate *endDate = [formatter dateFromString:self.end_date];
    NSTimeInterval seconds = [endDate timeIntervalSinceNow];
    if (seconds / 60 /60 / 24 > 30) {
        [MBProgressHUD showError:@"最多只能设置最近30天"];
        return;
    }
    [MBProgressHUD showMessage:@"正在提交数据" toView:self.view];
    [[SZBNetDataManager manager] worksheetSetWithRandomStamp:[ToolManager getCurrentTimeStamp] andIdentCode:[ZXUD objectForKey:@"ident_code"] andStartDate:self.start_date andEndDate:self.end_date andAmStartTime:self.start_time1 andAmEndTime:self.end_time1 andAmnum:self.amNum andPmStartTime:self.start_time2 andPmEndTime:self.end_time2 andPmnum:self.pmNum andPoint:self.pointStr success:^(NSURLSessionDataTask *task, id responseObject) {
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
            [self.navigationController popViewControllerAnimated:YES];
            [MBProgressHUD showError:responseObject[@"msg"]];
        }else if ([responseObject[@"res"] isEqualToString:@"1005"] || [responseObject[@"res"] isEqualToString:@"1004"]) {
            
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

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 1 || section == 2) {
        return 3;
    }else {
        return 1;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 3) {
        return 100;
    }else {
        return 50;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1 || indexPath.section == 2) {
        
        if (indexPath.row == 0) {
            ZXDaySetDetailTableViewCell *cell1 = [tableView dequeueReusableCellWithIdentifier:@"ZXDaySetDetailTableViewCellID" forIndexPath:indexPath];
            UIView *sapdView = [[UIView alloc] initWithFrame:CGRectMake(20, 0, KScreenWidth - 40, 1)];
            sapdView.backgroundColor = J_BackLightGray;
            [cell1.contentView addSubview:sapdView];
//            cell1.SetTextField.borderStyle=UITextBorderStyleNone;
//            cell1.SetTextField.textAlignment=NSTextAlignmentCenter;
            cell1.SetLable.text = @"开始时间";
            if (indexPath.section == 1) {
                cell1.SetTextField.text = @"09:00";
                self.start_time1 = @"09:00";
                cell1.datePicker.onetime  = [self.start_time1 stringByReplacingOccurrencesOfString:@":" withString:@""];
            }else {
                cell1.SetTextField.text = @"14:00";
                self.start_time2 =  @"14:00";
                cell1.datePicker.onetime  = [self.start_time2 stringByReplacingOccurrencesOfString:@":" withString:@""];
            }
            cell1.tag = 10004 * indexPath.section;
            cell1.SetTextField.tag = 10002 * indexPath.section;
            cell1.SetTextField.delegate = self;
            cell1.selectionStyle = UITableViewCellSelectionStyleNone;
       //确定按钮
            [cell1.btn addTarget:self action:@selector(hideKeyboard) forControlEvents:UIControlEventTouchUpInside];
            
            return cell1;
        }else if (indexPath.row == 1){
            ZXDaySetDetailTableViewCell *cell1 = [tableView dequeueReusableCellWithIdentifier:@"ZXDaySetDetailTableViewCellID" forIndexPath:indexPath];
            UIView *sapdView = [[UIView alloc] initWithFrame:CGRectMake(20, 0, KScreenWidth - 40, 1)];
            sapdView.backgroundColor = J_BackLightGray;
            [cell1.contentView addSubview:sapdView];
//            cell1.SetTextField.borderStyle=UITextBorderStyleNone;
//            cell1.SetTextField.textAlignment=NSTextAlignmentCenter;
            cell1.SetLable.text = @"结束时间";
            if (indexPath.section == 1) {
                cell1.SetTextField.text = @"11:30";
                self.end_time1 = @"11:30";
                cell1.datePicker.onetime  = [self.end_time1 stringByReplacingOccurrencesOfString:@":" withString:@""];
            }else {
                cell1.SetTextField.text = @"17:30";
                self.end_time2 = @"17:30";
                cell1.datePicker.onetime  = [self.end_time2 stringByReplacingOccurrencesOfString:@":" withString:@""];
            }
            cell1.tag = 10005 * indexPath.section;
            cell1.SetTextField.tag = 10003 * indexPath.section;
            cell1.SetTextField.delegate = self;
            cell1.selectionStyle = UITableViewCellSelectionStyleNone;
            //确定按钮
            [cell1.btn addTarget:self action:@selector(hideKeyboard) forControlEvents:UIControlEventTouchUpInside];
            return cell1;
        }else {
             OrderedNumTableViewCell *Cell = [tableView dequeueReusableCellWithIdentifier:@"OrderedNumTableViewCellID" forIndexPath:indexPath];
            UIView *sapdView = [[UIView alloc] initWithFrame:CGRectMake(20, 0, KScreenWidth - 40, 1)];
            sapdView.backgroundColor = J_BackLightGray;
            [Cell.contentView addSubview:sapdView];
            if (indexPath.section == 1) {
                self.amNum = @"10";
                Cell.orderNumTF.text = @"10";
                Cell.orderNumTF.tag = 777;
            }else {
                self.pmNum = @"14";
                Cell.orderNumTF.text = @"14";
                Cell.orderNumTF.tag = 888;
            }
            Cell.tag = 10006 * indexPath.section;
            Cell.orderNumTF.delegate = self;
            return Cell;
        }
    }else {
        if (indexPath.section == 0 && indexPath.row == 0) {
            ZXDaySetDetailTableViewCell1 *cell2 = [tableView dequeueReusableCellWithIdentifier:@"ZXDaySetDetailTableViewCellID1" forIndexPath:indexPath];
            UIView *sapdView = [[UIView alloc] initWithFrame:CGRectMake(20, 0, KScreenWidth - 40, 1)];
            sapdView.backgroundColor = J_BackLightGray;
            [cell2.contentView addSubview:sapdView];
            
            cell2.SetLable.text = @"请设置日期";
            cell2.SetTextField.text = self.start_date;
            cell2.SetTextField.tag = 10001;
            cell2.SetTextField.delegate = self;
            cell2.selectionStyle = UITableViewCellSelectionStyleNone;
            cell2.datePicker.onetime  = [self.end_time1 stringByReplacingOccurrencesOfString:@":" withString:@""];
            [cell2.btn addTarget:self action:@selector(hideKeyboard) forControlEvents:UIControlEventTouchUpInside];
            return cell2;
        }else {
            ZXNumberOfDaysTableViewCell *cell4 = [tableView dequeueReusableCellWithIdentifier:@"ZXNumberOfDaysTableViewCellID" forIndexPath:indexPath];
            UIView *sapdView = [[UIView alloc] initWithFrame:CGRectMake(20, 0, KScreenWidth - 40, 1)];
            sapdView.backgroundColor = J_BackLightGray;
            [cell4.contentView addSubview:sapdView];
            cell4.selectionStyle = UITableViewCellSelectionStyleNone;
            [cell4.Slider addTarget:self action:@selector(handleSlider:) forControlEvents:UIControlEventValueChanged];
            self.daylable = cell4.dayNum;
            return cell4;
        }
    }
}
//回收键盘
- (void)hideKeyboard {
    [self.tableView endEditing:YES];
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 10;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *footerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, 10)];
    footerView.backgroundColor = J_BackLightGray;
    return footerView;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 40;
}
//上午是否休息
-(void)haha:(UIButton*)btn
{
    if([btn.titleLabel.text isEqualToString:@"工作"])
    {
        [btn setTitle:@"休息" forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        UITextField *filed1 = [self.tableView viewWithTag:10002];
        UITextField *filed2 = [self.tableView viewWithTag:10003];
        UITextField *filed3 = [self.tableView viewWithTag:777];
        ZXDaySetDetailTableViewCell *cell1 = [self.tableView viewWithTag:10004];
        ZXDaySetDetailTableViewCell *cell2 = [self.tableView viewWithTag:10005];
        OrderedNumTableViewCell *cell3 = [self.tableView viewWithTag:10006];
        cell1.contentView.backgroundColor = [UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1];
        cell2.contentView.backgroundColor = [UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1];
        cell3.contentView.backgroundColor = [UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1];
        filed1.userInteractionEnabled = NO;
        filed2.userInteractionEnabled = NO;
        filed3.userInteractionEnabled = NO;
        self.am = 0;
    }
    else
    {
        [btn setTitle:@"工作" forState:UIControlStateNormal];
         [btn setTitleColor:KRGB(0, 172, 204, 1.0) forState:UIControlStateNormal];
        UITextField *filed1 = [self.tableView viewWithTag:10002];
        UITextField *filed2 = [self.tableView viewWithTag:10003];
        UITextField *filed3 = [self.tableView viewWithTag:777];
        ZXDaySetDetailTableViewCell *cell1 = [self.tableView viewWithTag:10004];
        ZXDaySetDetailTableViewCell *cell2 = [self.tableView viewWithTag:10005];
        OrderedNumTableViewCell *cell3 = [self.tableView viewWithTag:10006];
        cell1.contentView.backgroundColor = [UIColor whiteColor];
        cell2.contentView.backgroundColor = [UIColor whiteColor];
        cell3.contentView.backgroundColor = [UIColor whiteColor];
        filed1.userInteractionEnabled = YES;
        filed2.userInteractionEnabled = YES;
        filed3.userInteractionEnabled = YES;
        self.am = 1;
    }
}
//下午是否休息
-(void)haha1:(UIButton*)btn1
{
    if([btn1.titleLabel.text isEqualToString:@"工作"])
    {
        [btn1 setTitle:@"休息" forState:UIControlStateNormal];
        [btn1 setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        UITextField *filed1 = [self.tableView viewWithTag:20004];
        UITextField *filed2 = [self.tableView viewWithTag:20006];
        UITextField *filed3 = [self.tableView viewWithTag:888];
        
        ZXDaySetDetailTableViewCell *cell1 = [self.tableView viewWithTag:20008];
        ZXDaySetDetailTableViewCell *cell2 = [self.tableView viewWithTag:20010];
        OrderedNumTableViewCell *cell3 = [self.tableView viewWithTag:20012];
        cell1.contentView.backgroundColor = [UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1];
        cell2.contentView.backgroundColor = [UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1];
        cell3.contentView.backgroundColor = [UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1];
        filed1.userInteractionEnabled = NO;
        filed2.userInteractionEnabled = NO;
        filed3.userInteractionEnabled = NO;
        self.pm = 0;
    }
    else
    {
        [btn1 setTitle:@"工作" forState:UIControlStateNormal];
         [btn1 setTitleColor:KRGB(0, 172, 204, 1.0) forState:UIControlStateNormal];
        UITextField *filed1 = [self.tableView viewWithTag:20004];
        UITextField *filed2 = [self.tableView viewWithTag:20006];
        UITextField *filed3 = [self.tableView viewWithTag:888];
        ZXDaySetDetailTableViewCell *cell1 = [self.tableView viewWithTag:20008];
        ZXDaySetDetailTableViewCell *cell2 = [self.tableView viewWithTag:20010];
         OrderedNumTableViewCell *cell3 = [self.tableView viewWithTag:20012];
        cell1.contentView.backgroundColor = [UIColor whiteColor];
        cell2.contentView.backgroundColor = [UIColor whiteColor];
        cell3.contentView.backgroundColor = [UIColor whiteColor];
        filed1.userInteractionEnabled = YES;
        filed2.userInteractionEnabled = YES;
        filed3.userInteractionEnabled = YES;
        self.pm = 1;
    }
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *uiv=[[UIView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, 40)];
    uiv.backgroundColor=[UIColor whiteColor];
    UILabel *headerView = [[UILabel alloc]initWithFrame:CGRectMake(20, 0, KScreenWidth - 100, 40)];
    headerView.backgroundColor = [UIColor whiteColor];
//    headerView.textColor = [UIColor lightGrayColor];
    [uiv addSubview:headerView];
    switch (section) {
        case 0:
            headerView.text = @"设置排班日期";
            break;
        case 1:
        {
            headerView.text = @"设置上午排班安排";
            UIButton* btn=[[UIButton alloc] initWithFrame:CGRectMake(KScreenWidth - 80, 0, 80, 40)];
            
            [btn addTarget:self action:@selector(haha:) forControlEvents:UIControlEventTouchDown];
            [btn setTitle:@"工作" forState:UIControlStateNormal];
            [btn setTitleColor:KRGB(0, 172, 204, 1.0) forState:UIControlStateNormal];
            [uiv addSubview:btn];
        }
            break;
        case 2:
        {
            headerView.text = @"设置下午排班安排";
            UIButton* btn=[[UIButton alloc] initWithFrame:CGRectMake(KScreenWidth - 80, 0, 80, 40)];
            
            [btn addTarget:self action:@selector(haha1:) forControlEvents:UIControlEventTouchDown];
            [btn setTitle:@"工作" forState:UIControlStateNormal];
            [btn setTitleColor:KRGB(0, 172, 204, 1.0) forState:UIControlStateNormal];
            [uiv addSubview:btn];
        }
            break;
        case 3:
           headerView.text = @"设置发布天数";
            break;
        default:
            break;
    }
    return uiv;
}
//设置时间键盘显示事件
- (void)keyboardWillShow:(NSNotification *)notification {
    [self.tableView addSubview: self.BackGrayView];
    self.tableView.scrollEnabled = NO;
    UITextField *filed = [self.tableView viewWithTag:888];
    if (_currentTF == filed) {
        NSIndexPath *scrollIndexPath = [NSIndexPath indexPathForRow:2  inSection:2];
        [self.tableView scrollToRowAtIndexPath:scrollIndexPath
                           atScrollPosition:UITableViewScrollPositionTop animated:YES];
                NSDictionary *userInfo = [notification userInfo];
                NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
                CGRect keyboardRect = [aValue CGRectValue];
                CGFloat height = keyboardRect.size.height;
                //动画(往上弹)
                NSNumber *duration = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
                NSNumber *curve = [userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey];
                [UIView animateWithDuration:[duration integerValue] animations:^{
                    [UIView setAnimationCurve:[curve integerValue]];
                    self.tableView.frame = CGRectMake(0, -height + 150 , self.view.frame.size.width, self.view.frame.size.height);
                    [self.tableView setNeedsLayout];
            }];

    }
}

//设置时间键盘消失事件
- (void)keyboardWillHide:(NSNotification *)notify {
    [self.BackGrayView removeFromSuperview];
    self.tableView.scrollEnabled = YES;
    UITextField *filed = [self.tableView viewWithTag:888];
    if (_currentTF == filed) {
    NSDictionary *userInfo = [notify userInfo];
    //动画(往下弹)
    NSNumber *duration = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSNumber *curve = [userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey];
    [UIView animateWithDuration:[duration integerValue] animations:^{
        [UIView setAnimationCurve:[curve integerValue]];
        self.tableView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
        [self.tableView setNeedsLayout];
    }];
   }
}
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    _currentTF = textField;
    return YES;
}
-(void)textFieldDidEndEditing:(UITextField *)textField
{
    NSInteger Tag = textField.tag;
    
    switch (Tag) {
        case 10001:
            self.start_date = textField.text;
            [self getEndDate];
            break;
        case 10002:
            self.start_time1 = textField.text;
         
            break;
        case 10003:
            self.end_time1 = textField.text;
            
            break;
        case 20004:
            self.start_time2 = textField.text;
            
            break;
        case 20006:
            self.end_time2 = textField.text;
            
            break;
        case 777:
          
//            NSLog(@"%ld", (long)[textField.text integerValue]);
            if ([textField.text integerValue] > 32762) {
                [MBProgressHUD showError:@"人数设置过多"];
                  textField.text = self.amNum;
            }else {
                  self.amNum = textField.text;
            }
            break;
        case 888:
           
            if ([textField.text integerValue] > 65535) {
                [MBProgressHUD showError:@"人数设置过多"];
                 textField.text = self.pmNum;
            }else {
                 self.pmNum = textField.text;
            }
            break;
        default:
            break;
    }
    //根据时间计算
    //上午的预约人数
//    NSInteger Ammiao = [self calculate:self.end_time1] - [self calculate:self.start_time1];
//    if (Ammiao > 0) {
//        NSInteger AquanNum = Ammiao / 60 /15;
//        self.amNum = [NSString stringWithFormat:@"%ld", (long)AquanNum];
//        self.AmQuanNum.text = [NSString stringWithFormat:@"可预约人数为%ld人", (long)AquanNum];
//    }else {
//        self.amNum = 0;
//        self.AmQuanNum.text = @"可预约人数为0人";
//    }
    
    //下午的预约人数
//    NSInteger Pmmiao = [self calculate:self.end_time2] - [self calculate:self.start_time2];
//    if (Pmmiao > 0) {
//        NSInteger PquanNum = Pmmiao / 60 /15;
//        self.pmNum = [NSString stringWithFormat:@"%ld", (long)PquanNum];
//        self.PmQuanNum.text = [NSString stringWithFormat:@"可预约人数为%ld人", (long)PquanNum];
//    }else {
//        self.pmNum = 0;
//        self.PmQuanNum.text = @"可预约人数为0人";
//    }
    
    
}
//转换成秒
- (NSInteger)calculate:(NSString *)timeStr {
    NSArray *array = [timeStr componentsSeparatedByString:@":"]; //从字符A中分隔成2个元素的数组
    NSString *HH = array[0];
    NSString *MM= array[1];
    NSInteger h = [HH integerValue];
    NSInteger m = [MM integerValue];
    NSInteger miao = h*3600 + m*60;
    return miao;
}
//滑竿天数事件
- (void)handleSlider:(UISlider *)slider{
    self.daylable.text = [NSString stringWithFormat:@"%02.0f天", slider.value];
    self.daylable.textColor = KRGB(0, 172, 204, 1.0);
    self.DayNum = [self.daylable.text intValue];
    //计算结束日期
    [self getEndDate];
}
- (void)getEndDate {
    NSDateFormatter *dateFormatter = [NSDateFormatter new];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *myDate = [dateFormatter dateFromString:self.start_date];
    NSDate *newDate = [myDate dateByAddingTimeInterval:60 * 60 * 24 * (self.DayNum - 1)];
    self.end_date = [dateFormatter stringFromDate:newDate];
}
-(void)viewWillAppear:(BOOL)animated {
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSFontAttributeName:[UIFont systemFontOfSize:20],NSForegroundColorAttributeName:KRGB(0, 172, 204, 1.0)}];
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

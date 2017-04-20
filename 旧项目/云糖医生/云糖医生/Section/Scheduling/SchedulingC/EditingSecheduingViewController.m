//
//  EditingSecheduingViewController.m
//  云糖医生
//
//  Created by yuntangyi on 16/11/18.
//  Copyright © 2016年 yuntangyi. All rights reserved.
//

#import "EditingSecheduingViewController.h"
#import "ZXDaySetDetailTableViewCell.h"
#import "DateTableViewCell.h"
#import "OrderedNumTableViewCell.h"
#import "FooterView.h"
#import "SZBNetDataManager+Worksheet.h"
#import "LoginVC.h"
@interface EditingSecheduingViewController ()<UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic)int am;//上午是否休息
@property (nonatomic)int pm;//下午是否休息
@property (nonatomic, strong)NSString *pointStr;//设置上下午的拼接串
@property (nonatomic, strong) UIView *BackGrayView;//编辑时加的背景蒙版
@property (nonatomic, strong) UITextField *currentTF;//变量TF
@property (nonatomic)CGSize size;//提示文字的大小
@end

@implementation EditingSecheduingViewController
#pragma mark - 懒加载
- (UIView *)BackGrayView {
    if (!_BackGrayView) {
        _BackGrayView = [[UIView alloc]initWithFrame:self.tableView.bounds];
        _BackGrayView.alpha = 0.5;
        _BackGrayView.backgroundColor = [UIColor grayColor];
    }
    return _BackGrayView;
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
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
     self.navigationItem.title = @"排班设置";
     self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"返回"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStyleDone target:self action:@selector(goToBack)];
    [self.tableView registerNib:[UINib nibWithNibName:@"ZXDaySetDetailTableViewCell" bundle:nil] forCellReuseIdentifier:@"ZXDaySetDetailTableViewCellID"];
    [self.tableView registerNib:[UINib nibWithNibName:@"DateTableViewCell" bundle:nil] forCellReuseIdentifier:@"DateTableViewCellID"];
     [self.tableView registerNib:[UINib nibWithNibName:@"OrderedNumTableViewCell" bundle:nil] forCellReuseIdentifier:@"OrderedNumTableViewCellID"];
    // 添加回收键盘手势
    UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
    [self.tableView addGestureRecognizer:gestureRecognizer];
    //设置时间的键盘事件
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    //标记上下午是否休息
    if ([self.amNum isEqualToString:@"0"]) {
        self.am = 0;
    }else {
        self.am = 1;
    }
    if ([self.pmNum isEqualToString:@"0"]) {
        self.pm = 0;
    }else {
        self.pm = 1;
    }
    //高度
    //计算最大高度
    NSMutableDictionary *attrs = [NSMutableDictionary dictionary];
    attrs[NSFontAttributeName] = [UIFont systemFontOfSize:14];
    NSString *str = @"提示:如果需要删除今天的排班, 将上下午选为休息, 并点击确认即可.";
    self.size =  [str boundingRectWithSize:CGSizeMake( KScreenWidth - 30,MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        FooterView *FootV = [[FooterView alloc]initWithFrame:CGRectMake(0, 0, 0, self.size.height + 76)];
        [FootV.changeBtn addTarget:self action:@selector(changeBtn:) forControlEvents:UIControlEventTouchUpInside];
        self.tableView.tableFooterView = FootV;
    });
}
//修改排班按钮
- (void)changeBtn:(UIButton *)btn{
    if (self.am == 1 && self.pm == 0 ) {
        self.pointStr = @"am";
        if ([self.amNum isEqualToString:@"0"]) {
            [MBProgressHUD showError:@"请填写上午可预约人数"];
        }else {
            //修改排班
            [self ChangeScheduling];
        }
       
    }else if (self.am == 0 && self.pm == 1) {
        self.pointStr = @"pm";
        if ([self.pmNum isEqualToString:@"0"]) {
            [MBProgressHUD showError:@"请填写下午可预约人数"];
        }else {
            //修改排班
            [self ChangeScheduling];
        }
    }else if (self.am && self.pm) {
        self.pointStr = @"am,pm";
        if ([self.amNum isEqualToString:@"0"]) {
            [MBProgressHUD showError:@"请填写上午可预约人数"];
        }else  if ([self.pmNum isEqualToString:@"0"]) {
            [MBProgressHUD showError:@"请填写下午可预约人数"];
        }else {
            //修改排班
            [self ChangeScheduling];
        }
    }else {
        //删除排班传的空串
        [self delScheduling];
    }
}
//删除排班
- (void)delScheduling {
    [MBProgressHUD showMessage:@"正在提交数据" toView:self.view];
    [[SZBNetDataManager manager] worksheet_delWithRandomStamp:[ToolManager getCurrentTimeStamp] andIdentCode:[ZXUD objectForKey:@"ident_code"] andDwp_id:self.dwp_id success:^(NSURLSessionDataTask *task, id responseObject) {
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
        }else if ([responseObject[@"res"] isEqualToString:@"1005"] || [responseObject[@"res"] isEqualToString:@"1004"]) {
            
        }else {
            [MBProgressHUD showError:responseObject[@"msg"]];
        }
    } failed:^(NSURLSessionTask *task, NSError *error) {
        [MBProgressHUD hideHUDForView:self.view];
        [MBProgressHUD showError:@"网络错误"];
    }];
}
//修改排班
- (void)ChangeScheduling{
    [MBProgressHUD showMessage:@"正在提交数据" toView:self.view];
    [[SZBNetDataManager manager] worksheet_updateWithRandomStamp:[ToolManager getCurrentTimeStamp] andIdentCode:[ZXUD objectForKey:@"ident_code"] andAmStartTime:self.start_time1 andAmEndTime:self.end_time1 andAmnum:self.amNum andPmStartTime:self.start_time2 andPmEndTime:self.end_time2 andPmnum:self.pmNum andPoint:self.pointStr andID:self.dwp_id success:^(NSURLSessionDataTask *task, id responseObject) {
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
        }else if ([responseObject[@"res"] isEqualToString:@"1005"] || [responseObject[@"res"] isEqualToString:@"1004"]) {
            
        }else {
            [MBProgressHUD showError:responseObject[@"msg"]];
        }
    } failed:^(NSURLSessionTask *task, NSError *error) {
        [MBProgressHUD hideHUDForView:self.view];
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
#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 1 || section == 2) {
        return 3;
    }else {
        return 1;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1 || indexPath.section == 2) {
        
        if (indexPath.row == 0) {
            ZXDaySetDetailTableViewCell *cell1 = [tableView dequeueReusableCellWithIdentifier:@"ZXDaySetDetailTableViewCellID" forIndexPath:indexPath];
            UIView *sapdView = [[UIView alloc] initWithFrame:CGRectMake(20, 0, KScreenWidth - 40, 1)];
            sapdView.backgroundColor = J_BackLightGray;
            [cell1.contentView addSubview:sapdView];
            cell1.SetLable.text = @"开始时间";
//          cell1.SetTextField.borderStyle=UITextBorderStyleNone;
//          cell1.SetTextField.textAlignment=NSTextAlignmentCenter;
            if (indexPath.section == 1)
            {
               
                if(self.start_time1)
                {
                    cell1.SetTextField.text = self.start_time1;
                    self.start_time1 = self.start_time1;
                    cell1.datePicker.onetime  = [self.start_time1 stringByReplacingOccurrencesOfString:@":" withString:@""];
                }
                else
                {
                    cell1.SetTextField.text = @"09:00";
                    self.start_time1 = @"09:00";
                    cell1.datePicker.onetime  = [self.start_time1 stringByReplacingOccurrencesOfString:@":" withString:@""];
                }
            }
            else
            {
                if(self.start_time2)
                {
                    cell1.SetTextField.text = self.start_time2;
                    self.start_time2 =  self.start_time2;
                    cell1.datePicker.onetime  = [self.start_time2 stringByReplacingOccurrencesOfString:@":" withString:@""];
                }
                else
                {
                    cell1.SetTextField.text = @"14:00";
                    self.start_time2 =  @"14:00";
                    cell1.datePicker.onetime  = [self.start_time2 stringByReplacingOccurrencesOfString:@":" withString:@""];
                }
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
            cell1.SetLable.text = @"结束时间";
//            cell1.SetTextField.borderStyle=UITextBorderStyleNone;
//            cell1.SetTextField.textAlignment=NSTextAlignmentCenter;
            if (indexPath.section == 1)
            {
                if(self.end_time1)
                {
                    cell1.SetTextField.text = self.end_time1;
                    self.end_time1 = self.end_time1;
                    cell1.datePicker.onetime  = [self.end_time1 stringByReplacingOccurrencesOfString:@":" withString:@""];
                }
                else
                {
                    cell1.SetTextField.text = @"11:30";
                    self.end_time1 =  @"11:30";
                    cell1.datePicker.onetime  = [self.end_time1 stringByReplacingOccurrencesOfString:@":" withString:@""];
                }
            }
            else
            {
                if(self.end_time2)
                {
                    cell1.SetTextField.text = self.end_time2;
                    self.end_time2 = self.end_time2;
                    cell1.datePicker.onetime  = [self.end_time2 stringByReplacingOccurrencesOfString:@":" withString:@""];

                }
                else
                {
                    cell1.SetTextField.text = @"17:30";
                    self.end_time2 =  @"17:30";
                    cell1.datePicker.onetime  = [self.end_time2 stringByReplacingOccurrencesOfString:@":" withString:@""];
                }
            }
            cell1.tag = 10005 * indexPath.section;
            cell1.SetTextField.tag = 10003 * indexPath.section;
            cell1.SetTextField.delegate = self;
            cell1.selectionStyle = UITableViewCellSelectionStyleNone;
            //确定按钮
            [cell1.btn addTarget:self action:@selector(hideKeyboard) forControlEvents:UIControlEventTouchUpInside];
            return cell1;
        }
        else
        {
            OrderedNumTableViewCell *Cell = [tableView dequeueReusableCellWithIdentifier:@"OrderedNumTableViewCellID" forIndexPath:indexPath];
            UIView *sapdView = [[UIView alloc] initWithFrame:CGRectMake(20, 0, KScreenWidth - 40, 1)];
            sapdView.backgroundColor = J_BackLightGray;
            [Cell.contentView addSubview:sapdView];
            if (indexPath.section == 1) {
                self.amNum = self.amNum;
                Cell.orderNumTF.text = self.amNum;
                Cell.orderNumTF.tag = 777;
            }else {
                self.pmNum = self.pmNum;
                Cell.orderNumTF.text = self.pmNum;
                Cell.orderNumTF.tag = 888;
            }
            Cell.tag = 10006 * indexPath.section;
            Cell.orderNumTF.delegate = self;
            return Cell;
        }
    }else {
         DateTableViewCell *Cell = [tableView dequeueReusableCellWithIdentifier:@"DateTableViewCellID" forIndexPath:indexPath];
        Cell.dateLable.text = self.Date;
        return Cell;
    }
}
//回收键盘
- (void)hideKeyboard {
    [self.tableView endEditing:YES];
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == 2) {
        return 1;
    }
    return 10;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    
    UIView *footerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, 10)];
    footerView.backgroundColor = J_BackLightGray;
    return footerView;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 0.1;
    }
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
    [uiv addSubview:headerView];
    switch (section) {
        case 0:
            return nil;
            break;
        case 1:
        {
            headerView.text = @"设置上午排班安排";
            UIButton* btn=[[UIButton alloc] initWithFrame:CGRectMake(KScreenWidth - 80, 0, 80, 40)];
            
            [btn addTarget:self action:@selector(haha:) forControlEvents:UIControlEventTouchDown];
//            [btn setTitle:@"工作" forState:UIControlStateNormal];
            [btn setTitleColor:KRGB(0, 172, 204, 1.0) forState:UIControlStateNormal];
            [uiv addSubview:btn];
            if(self.am == 0)
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
            }

        }
            break;
        case 2:
        {
            headerView.text = @"设置下午排班安排";
            UIButton* btn=[[UIButton alloc] initWithFrame:CGRectMake(KScreenWidth - 80, 0, 80, 40)];
            
            [btn addTarget:self action:@selector(haha1:) forControlEvents:UIControlEventTouchDown];
//            [btn setTitle:@"工作" forState:UIControlStateNormal];
            [btn setTitleColor:KRGB(0, 172, 204, 1.0) forState:UIControlStateNormal];
            [uiv addSubview:btn];
            if(self.pm == 0)
            {
                [btn setTitle:@"休息" forState:UIControlStateNormal];
                [btn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
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
            }
            else
            {
                [btn setTitle:@"工作" forState:UIControlStateNormal];
                [btn setTitleColor:KRGB(0, 172, 204, 1.0) forState:UIControlStateNormal];
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
            }

        }
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
    if (_currentTF == filed)
    {
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
            self.tableView.frame = CGRectMake(0, - height + self.size.height + 76, self.view.frame.size.width, self.view.frame.size.height);
            [self.tableView setNeedsLayout];
        }];
    }
}
//设置时间键盘消失事件
- (void)keyboardWillHide:(NSNotification *)notify {
    [self.BackGrayView removeFromSuperview];
    self.tableView.scrollEnabled = YES;
    UITextField *filed = [self.tableView viewWithTag:888];
    if (_currentTF == filed)
    {
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
    
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
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

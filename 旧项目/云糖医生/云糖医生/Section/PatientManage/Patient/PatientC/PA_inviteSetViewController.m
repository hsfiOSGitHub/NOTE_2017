//
//  PA_inviteSetViewController.m
//  yuntangyi
//
//  Created by yuntangyi on 16/8/29.
//  Copyright © 2016年 yuntangyi. All rights reserved.
//

#import "PA_inviteSetViewController.h"
#import "SZBNetDataManager+Worksheet.h"
#import "SZBNetDataManager+PatientManageNetData.h"

@interface PA_inviteSetViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong)NSMutableArray  *allDateArray;//存所有已经设置过排班的日期
@property (nonatomic, strong)NSMutableDictionary  *alldataSourceDic;//另存所有日期信息
//判断上下午是否可约
@property (nonatomic)BOOL isAm;
@property (nonatomic)BOOL isPm;
@property (nonatomic, strong)NSString *time_point;//要传去接口的上下午时间点
@property (nonatomic, strong)LoadingView *loadingView;
@property (nonatomic, strong) NetworkLoadFailureView *loadFailureView;//重新加载占位图

@end

@implementation PA_inviteSetViewController
#pragma mark -懒加载
-(NetworkLoadFailureView *)loadFailureView{
    if (!_loadFailureView) {
        _loadFailureView = [[NetworkLoadFailureView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    }
    return _loadFailureView;
}
- (NSMutableArray *)classNumArray {
    if (!_classNumArray) {
        _classNumArray = [NSMutableArray array];
    }
    return _classNumArray;
}
-(NSMutableArray *)allDateArray {
    if (!_allDateArray) {
        _allDateArray = [NSMutableArray array];
    }
    return _allDateArray;
}
- (NSMutableDictionary *)alldataSourceDic {
    if (!_alldataSourceDic) {
        _alldataSourceDic = [NSMutableDictionary dictionary];
    }
    return _alldataSourceDic;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"邀请诊治";
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"返回"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStyleDone target:self action:@selector(goToBack)];
    self.SetTableView.dataSource = self;
    self.SetTableView.delegate = self;
    //加载动画
      _loadingView = [[LoadingView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight)];
    //邀请诊治
    [self.inviteBtn addTarget:self action:@selector(completeAction:) forControlEvents:UIControlEventTouchUpInside];
    //注册cell
    [self.SetTableView registerNib:[UINib nibWithNibName:@"amAndPmTableViewCell" bundle:nil] forCellReuseIdentifier:@"amAndPmTableViewCellID"];
    [self.SetTableView registerNib:[UINib nibWithNibName:@"PACalendarTableViewCell" bundle:nil] forCellReuseIdentifier:@"PACalendarTableViewCellID"];
    [self.SetTableView registerNib:[UINib nibWithNibName:@"RemarksTableViewCell" bundle:nil] forCellReuseIdentifier:@"RemarksTableViewCellID"];
    //获取当天日期
    self.selectDate = [ToolManager getCurrentDate];
    //添加刷新头与加载尾
    self.SetTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        //只有下拉刷新的事件被触发,就应该重新请求数据.
        //获取日历日程
        [self getInviteSheetData];
    }];
    [self.view addSubview:_loadingView];
    //获取日历日程
    [self getInviteSheetData];
   
  
   
    // Do any additional setup after loading the view from its nib.
}
- (void)goToBack {
    [self.navigationController popViewControllerAnimated:YES];
}
//获取日历日程
- (void)getInviteSheetData {
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSMutableSet *set = [NSMutableSet setWithSet:manager.responseSerializer.acceptableContentTypes];
    [set addObject:@"text/html"];
    manager.responseSerializer.acceptableContentTypes = set;
//    NSLog(@"%@", [NSString stringWithFormat:SWorksheet_Url, [ToolManager getCurrentTimeStamp],[ZXUD objectForKey:@"ident_code"] ]);
    [manager GET:[NSString stringWithFormat:SWorksheet_Url, [ToolManager getCurrentTimeStamp],[ZXUD objectForKey:@"ident_code"]] parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [_loadingView dismiss];
        [self.SetTableView.mj_header endRefreshing];
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
            [self.classNumArray removeAllObjects]
            ;
            [self.allDateArray removeAllObjects];
            [self.alldataSourceDic removeAllObjects];
            for (NSDictionary *dic in responseObject[@"resault"]) {
                [self.classNumArray addObject:dic];
                [self.allDateArray addObject:dic[@"day"]];
                [self.alldataSourceDic setObject:dic forKey:dic[@"day"]];
            }
            //判断上下午是否空闲
            [self getIsBusyOrFree];
        }else if ([responseObject[@"res"] isEqualToString:@"1005"] || [responseObject[@"res"] isEqualToString:@"1004"]) {
            
        }else {
            [MBProgressHUD showError:responseObject[@"msg"]];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [_loadingView dismiss];
        [self.view addSubview:self.loadFailureView];
        [self.loadFailureView.loadAgainBtn addTarget:self action:@selector(getInviteSheetData) forControlEvents:UIControlEventTouchUpInside];
    }];
}
//判断上下午是否空闲
- (void)getIsBusyOrFree {
    self.time_point = nil;
    if ([self.allDateArray containsObject:self.selectDate]) {
        NSDictionary *dic = self.alldataSourceDic[self.selectDate];
       if ([dic[@"amstatus"] isEqualToString:@"1"] && [dic[@"pmstatus"] isEqualToString:@"1"]) {
            self.isAm = YES;
            self.isPm = YES;
        }else if ([dic[@"amstatus"] isEqualToString:@"1"] && [dic[@"pmstatus"] isEqualToString:@"0"]) {
            self.isAm = YES;
            self.isPm = NO;
        }else if ([dic[@"amstatus"] isEqualToString:@"0"] && [dic[@"pmstatus"] isEqualToString:@"1"]) {
            self.isAm = NO;
            self.isPm = YES;
        }else {
            self.isAm = NO;
            self.isPm = NO;
        }
    }else {
        self.isAm = NO;
        self.isPm = NO;
    }
    [self.SetTableView reloadData];
}
//完成设置按钮
- (void)completeAction:(UIButton *)sender {
   
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:[NSString stringWithFormat:@"确定邀请%@到医院复诊吗",self.name] preferredStyle:UIAlertControllerStyleAlert];
    //修改message
    NSMutableAttributedString *alertControllerMessageStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"确定邀请%@到医院复诊吗",self.name]];
    [alertControllerMessageStr addAttribute:NSForegroundColorAttributeName value:KRGB(0, 172, 204, 1.0) range:NSMakeRange(4, self.name.length)];
    if ([alert valueForKey:@"message"]) {
        [alert setValue:alertControllerMessageStr forKey:@"attributedMessage"];
    }
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
        
    }];
    UIAlertAction *anotherAction = [UIAlertAction actionWithTitle:@"邀请" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        if (self.time_point == nil) {
            [MBProgressHUD showError:@"请选择诊病时间"];
            return ;
        }
        //调接口去邀请
         [MBProgressHUD showMessage:@"请稍后" toView:self.view];
        [[SZBNetDataManager manager] patientInvitePatientIds:self.patient_id andRandomString:[ToolManager getCurrentTimeStamp] andCode:[ZXUD objectForKey:@"ident_code"] andDate:self.selectDate andTime_point:self.time_point success:^(NSURLSessionDataTask *task, id responseObject) {
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
    }];
    [alert addAction:cancelAction];
    [alert addAction:anotherAction];
    [self presentViewController:alert animated:YES completion:^{
       
    }];
}
#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        PACalendarTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PACalendarTableViewCellID" forIndexPath:indexPath];
        cell.dataArray = self.classNumArray;
        cell.ZXP = self;
        [cell xinrilishuaxin];
        return cell;
    }else  {
        amAndPmTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"amAndPmTableViewCellID" forIndexPath:indexPath];
        if (self.isAm) {
             [cell.amBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
             [cell.amBtn setBackgroundColor:[UIColor whiteColor]];
            cell.amBtn.layer.borderWidth = 1.0;
            cell.amBtn.userInteractionEnabled = YES;
            cell.amBtn.tag = 333;
            [cell.amBtn addTarget:self action:@selector(selectBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        }else {
            [cell.amBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [cell.amBtn setBackgroundColor:KRGB(204, 204, 204, 1.0)];
            cell.amBtn.layer.borderWidth = 0;
            cell.amBtn.userInteractionEnabled = NO;
        }
        if (_isPm) {
            [cell.pmBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [cell.pmBtn setBackgroundColor:[UIColor whiteColor]];
            cell.pmBtn.layer.borderWidth = 1.0;
            cell.pmBtn.tag = 444;
            cell.pmBtn.userInteractionEnabled = YES;
            [cell.pmBtn addTarget:self action:@selector(selectBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        }else {
            [cell.pmBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [cell.pmBtn setBackgroundColor:KRGB(204, 204, 204, 1.0)];
            cell.pmBtn.layer.borderWidth = 0;
            cell.pmBtn.userInteractionEnabled = NO;
        }
        return cell;

    }

}
//上下午按钮点击事件
- (void)selectBtnAction:(UIButton *)btn {
    switch (btn.tag) {
        case 333: {
            self.time_point = @"am";
            [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [btn setBackgroundColor:KRGB(0, 172, 204, 1.0)];
            if (self.isPm) {
                UIButton *btn1 = [self.SetTableView viewWithTag:444];
                [btn1 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                [btn1 setBackgroundColor:[UIColor whiteColor]];
            }
        }
            break;
        case 444:
        {
            self.time_point = @"pm";
            [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [btn setBackgroundColor:KRGB(0, 172, 204, 1.0)];
            if (self.isAm) {
                UIButton *btn1 = [self.SetTableView viewWithTag:333];
                [btn1 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                [btn1 setBackgroundColor:[UIColor whiteColor]];
            }
         }
            break;
        default:
            break;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 340;
    }else {
        return 90;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 1) {
        return 40;
    }
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 10;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 1) {
        UIView *view = [[UIView alloc]init];
        view.backgroundColor = [UIColor whiteColor];
        UILabel *lab = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, KScreenWidth - 30, 40)];
        lab.text = @"选择邀请诊病时间";
        [view addSubview:lab];
        return view;
    }
    return nil;
}
- (void)viewWillAppear:(BOOL)animated {
    [ZXUD setObject:@"invite" forKey:@"rili"];
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

//
//  SechedulingVC.m
//  yuntangyi
//
//  Created by yuntangyi on 16/8/26.
//  Copyright © 2016年 yuntangyi. All rights reserved.
//

#import "SechedulingVC.h"
#import "LoginVC.h"
#import "SZBNetDataManager+Worksheet.h"
#import "SZBNetDataManager+RegisterAndLoginNetData.h"

#import "HeaderView.h"
#import "SystemNewsVC.h"
#import "EditingSecheduingViewController.h"
@interface SechedulingVC ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong)NSMutableArray *amDataSource;//每天上午排班数据(为下面的列表)
@property (nonatomic, strong)NSMutableArray *pmDataSource;//每天下午排班数据(为下面的列表)
@property (nonatomic,strong) UIButton *systemMessageBtn;//系统消息按钮
@property (nonatomic,strong) UILabel *numLabel;//系统消息个数
@property (nonatomic) BOOL closeAm;
@property (nonatomic) BOOL closePm;
@property (nonatomic) BOOL enen;
@property (nonatomic, strong)NSDictionary *dic;//数据源字典
@end

@implementation SechedulingVC
# pragma mark 懒加载
-(UITableView *)tableV {
    if (!_tableV) {
        self.tableV = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
        self.tableV.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.tableV.delegate = self;
        self.tableV.dataSource = self;
    }
    return _tableV;
}
- (NSMutableArray *)classNumArray {
    if (!_classNumArray) {
        _classNumArray = [NSMutableArray array];
    }
    return _classNumArray;
}
- (NSMutableArray *)amDataSource {
    if (!_amDataSource) {
        _amDataSource = [NSMutableArray array];
    }
    return _amDataSource;
}
-(NSMutableArray *)pmDataSource {
    if (!_pmDataSource) {
        _pmDataSource = [NSMutableArray array];
    }
    return _pmDataSource;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"排班";
    [self.view addSubview:self.tableV];
    //添加系统消息
    [self addSystemNewsBtn];
    //注册cell
    [self.tableV registerNib:[UINib nibWithNibName:@"SeCalendarTableViewCell" bundle:nil] forCellReuseIdentifier:@"SeCalendarTableViewCellID"];
    [self.tableV registerNib:[UINib nibWithNibName:@"OrderPatientTableViewCell" bundle:nil] forCellReuseIdentifier:@"OrderPatientTableViewCellID"];
    [self.tableV registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    //获取当前日期
    _selectDate = [ToolManager getCurrentDate];
  
   
    //添加刷新头与加载尾
    self.tableV.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        //只有下拉刷新的事件被触发,就应该重新请求数据.
        //获取预约日程
        [self getSheetData];
    }];
    //获取预约日程
    [self getSheetData];
  
}
#pragma mark  -添加系统消息
-(void)addSystemNewsBtn{
    //添加系统消息
    _systemMessageBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 44, 44)];
    [_systemMessageBtn addTarget:self action:@selector(systemNews) forControlEvents:UIControlEventTouchUpInside];
    [_systemMessageBtn   setImage:[UIImage imageNamed:@"系统消息"] forState:UIControlStateNormal];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithCustomView:_systemMessageBtn];
    self.navigationItem.rightBarButtonItem = rightItem;
}
-(void)systemNews{
    if (![_numLabel.text isEqualToString:@"0"] && _numLabel.text != NULL ) {
        SystemNewsVC *systemNews_VC = [[SystemNewsVC alloc]init];
        UINavigationController *navi = [[UINavigationController alloc]initWithRootViewController:systemNews_VC];
        [self presentViewController:navi animated:YES completion:nil];

    }else {
        [MBProgressHUD showError:@"当前没有消息"];
    }
}
//获取预约日程
- (void)getSheetData {
    //判断网络状态，网络不可用时直接显示网络状态
    if ([[ZXUD objectForKey:@"NetDataState"] isEqualToString:@"0"]) {
        
        [self.tableV.mj_header endRefreshing];
       
        [MBProgressHUD showError:@"请检查您的网络"];
        return;
    }
    [_classNumArray removeAllObjects];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSMutableSet *set = [NSMutableSet setWithSet:manager.responseSerializer.acceptableContentTypes];
    [set addObject:@"text/html"];
    NSLog(@"%@", [NSString stringWithFormat:SWorksheet_Url, [ToolManager getCurrentTimeStamp],[ZXUD objectForKey:@"ident_code"]]);
    manager.responseSerializer.acceptableContentTypes = set;
    [manager GET:[NSString stringWithFormat:SWorksheet_Url, [ToolManager getCurrentTimeStamp],[ZXUD objectForKey:@"ident_code"]] parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        [self.tableV.mj_header endRefreshing];
        if ([responseObject[@"res"] isEqualToString:@"1002"])
        {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"登录状态已过期, 请重新登录" message:nil preferredStyle:UIAlertControllerStyleAlert];
        
            UIAlertAction *anotherAction = [UIAlertAction actionWithTitle:@"登录" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
                //让用户重新登录
                [ZXUD setObject:nil forKey:@"ident_code"];
                LoginVC *VC = [[LoginVC alloc] init];
                UINavigationController *navi = [[UINavigationController alloc]initWithRootViewController:VC];
                [self presentViewController:navi animated:YES completion:nil];                }];
                [alert addAction:anotherAction];
            
                [self presentViewController:alert animated:YES completion:^{
            }];
        }else if ([responseObject[@"res"] isEqualToString:@"1001"]) {
            for (NSDictionary *dic in responseObject[@"resault"]) {
                [self.classNumArray addObject:dic];
            }
            //请求排班信息
            [self getTheSchedulingSheet];
            
        }else if ([responseObject[@"res"] isEqualToString:@"1005"] || [responseObject[@"res"] isEqualToString:@"1004"]) {
            
        }else {
             [MBProgressHUD showError:responseObject[@"msg"]];
     }
  } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self.tableV.mj_header endRefreshing];
//        [MBProgressHUD showError:@"网络错误"];
    }];
}
#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (_amDataSource.count > 0 && _pmDataSource.count > 0) {
        return 4;
    }else if (_amDataSource.count > 0 || _pmDataSource.count > 0) {
        return 3;
    }
    else  {
        if ( _dic[@"id"]) {
            return 2;
        }
        return 1;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    }else if (section == 1) {
        return 0;
    }else if (section == 2) {
        if (_amDataSource.count) {
            if (!self.closeAm) {
                return 0;
            }
            return _amDataSource.count;
        }else {
            if (!self.closePm) {
                return 0;
            }
            return _pmDataSource.count;
        }
    }else {
        if (!self.closePm) {
            return 0;
        }
        return _pmDataSource.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0)
    {
        SeCalendarTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SeCalendarTableViewCellID" forIndexPath:indexPath];
        cell.dataArray = self.classNumArray;
        cell.ZXS = self;
        [cell xinrilishuaxin];
        return cell;
    }
    else
    {
        if (indexPath.section == 2)
        {
            if ([_amDataSource isKindOfClass:[NSArray class]] && _amDataSource.count > 0) {
                OrderPatientTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"OrderPatientTableViewCellID" forIndexPath:indexPath];
                NSDictionary *dic = self.amDataSource[indexPath.row];
                if (![dic[@"name"] isEqualToString:@""]) {
                    cell.nameLable.text = dic[@"name"];
                }else {
                    cell.nameLable.text = @"--";
                }
                cell.phoneLable.text = dic[@"phone"];
                if ([dic[@"gender"] isEqualToString:@"0"]) {
                    cell.genderLable.text = @"男";
                }else {
                    cell.genderLable.text = @"女";
                }
                if ([dic[@"age"] isKindOfClass:[NSNumber class]]) {
                    cell.ageLable.text = [NSString stringWithFormat:@"%@岁", dic[@"age"]];
                }else {
                    cell.ageLable.text = @"未知岁";
                }
                cell.numLable.backgroundColor = [UIColor colorWithRed:0.875 green:0.482 blue:0.118 alpha:1.000];
                cell.numLable.text = [NSString stringWithFormat:@"%d", indexPath.row + 1];
                return cell;
            }else {
                OrderPatientTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"OrderPatientTableViewCellID" forIndexPath:indexPath];
                NSDictionary *dic = self.pmDataSource[indexPath.row];
                if (![dic[@"name"] isEqualToString:@""]) {
                    cell.nameLable.text = dic[@"name"];
                }else {
                    cell.nameLable.text = @"--";
                }
                cell.phoneLable.text = dic[@"phone"];
                if ([dic[@"gender"] isEqualToString:@"0"]) {
                    cell.genderLable.text = @"男";
                }else {
                    cell.genderLable.text = @"女";
                }
                if ([dic[@"age"] isKindOfClass:[NSNumber class]]) {
                    cell.ageLable.text = [NSString stringWithFormat:@"%@岁", dic[@"age"]];
                }else {
                    cell.ageLable.text = @"未知岁";
                }
                cell.numLable.backgroundColor = [UIColor colorWithRed:0.153 green:0.753 blue:0.576 alpha:1.000];
                cell.numLable.text = [NSString stringWithFormat:@"%d", indexPath.row + 1];
                return cell;

            }
        }else {
           
              OrderPatientTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"OrderPatientTableViewCellID" forIndexPath:indexPath];
                NSDictionary *dic = self.pmDataSource[indexPath.row];
                if (![dic[@"name"] isEqualToString:@""]) {
                    cell.nameLable.text = dic[@"name"];
                }else {
                    cell.nameLable.text = @"--";
                }
                cell.phoneLable.text = dic[@"phone"];
                if ([dic[@"gender"] isEqualToString:@"0"]) {
                    cell.genderLable.text = @"男";
                }else {
                    cell.genderLable.text = @"女";
                }
                if ([dic[@"age"] isKindOfClass:[NSNumber class]]) {
                    cell.ageLable.text = [NSString stringWithFormat:@"%@岁", dic[@"age"]];
                }else {
                    cell.ageLable.text = @"未知岁";
                }
                cell.numLable.backgroundColor = [UIColor colorWithRed:0.153 green:0.753 blue:0.576 alpha:1.000];
                cell.numLable.text = [NSString stringWithFormat:@"%d", indexPath.row + 1];
                return cell;
        }
    }
}
//请求排班信息
-(void)getTheSchedulingSheet
{
    [self.tableV reloadData];
    [MBProgressHUD showMessage:@"正在加载信息" toView:self.view];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSMutableSet *set = [NSMutableSet setWithSet:manager.responseSerializer.acceptableContentTypes];
    [set addObject:@"text/html"];
    manager.responseSerializer.acceptableContentTypes = set;
    NSLog(@"%@",[NSString stringWithFormat:SWorksheetList_Url, [ToolManager getCurrentTimeStamp],[ZXUD objectForKey:@"ident_code"], self.selectDate, nil ]);
    [manager GET:[NSString stringWithFormat:SWorksheetList_Url, [ToolManager getCurrentTimeStamp],[ZXUD objectForKey:@"ident_code"], self.selectDate, nil ] parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
    {
        _enen=YES;
        [MBProgressHUD hideHUDForView:self.view];
        [self.amDataSource removeAllObjects];
        [self.pmDataSource removeAllObjects];
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
            NSArray *Arr = responseObject[@"list"];
            _dic = Arr.firstObject;
            NSArray *amArr = _dic[@"amdata"];
            NSArray *pmArr = _dic[@"pmdata"];
            for (NSDictionary *sdic in amArr) {
                [self.amDataSource addObject:sdic];
            }
            for (NSDictionary *sdic in pmArr) {
                [self.pmDataSource addObject:sdic];
            }
            [self.tableV reloadData];
           
        }else if ([responseObject[@"res"] isEqualToString:@"1005"] || [responseObject[@"res"] isEqualToString:@"1004"]) {
            
        }else {
           [MBProgressHUD showError:responseObject[@"msg"]];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [MBProgressHUD hideHUDForView:self.view];
        [MBProgressHUD showError:@"网络错误"];
    }];

}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 370;
    }
        return 60;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section > 0) {
         return 40;
    }
    return 0.1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == 1) {
        return 1;
    }
    return 10;
}
//上下午点击事件
- (void)gesAction:(UITapGestureRecognizer *)tap {
    if (tap.view.tag == 111) {
         self.closeAm = !self.closeAm;
    }else {
         self.closePm = !self.closePm;
    }
    [self.tableV reloadData];
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    HeaderView *header = [[HeaderView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, 40)];
    UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(gesAction:)];
    [header addGestureRecognizer:gestureRecognizer];
    if (section == 0) {
        return 0;
    }else if (section == 1) {
        UIView *view = [[UIView alloc]init];
        view.backgroundColor = [UIColor whiteColor];
        UILabel *lable = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, KScreenWidth - 100, 40)];
        lable.text = [NSString stringWithFormat:@"日期:%@", self.selectDate];
        lable.textColor = [UIColor redColor];
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame =  CGRectMake(KScreenWidth - 65, 0, 50, 40);
        [btn setTitle:@"编辑" forState:UIControlStateNormal];
        [btn setTitleColor:KRGB(0, 172, 204, 1.0) forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(editing:) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:btn];
        [view addSubview:lable];
        return view;
    }
    else if (section == 2) {
        if (_amDataSource.count > 0) {
            header.tag = 111;
            header.lable.text = @"上午预约人数";
            header.numLable.text = [NSString stringWithFormat:@"%ld", (unsigned long)self.amDataSource.count];
            header.numLable.textColor = [UIColor colorWithRed:0.875 green:0.482 blue:0.118 alpha:1.000];
            if (!self.closeAm) {
               header.imageV.image = [UIImage imageNamed:@"下一步-拷贝"];
            }else {
                header.imageV.image = [UIImage imageNamed:@"展开"];
            }
           
        }else {
            if (_pmDataSource.count > 0) {
                header.tag = 222;
                header.lable.text = @"下午预约人数";
                header.numLable.textColor = [UIColor colorWithRed:0.153 green:0.753 blue:0.576 alpha:1.000];
                header.numLable.text = [NSString stringWithFormat:@"%ld", (unsigned long)self.pmDataSource.count];
                if (!self.closePm) {
                    header.imageV.image = [UIImage imageNamed:@"下一步-拷贝"];
                }else {
                    header.imageV.image = [UIImage imageNamed:@"展开"];
                }
            }
        }
         return header;
    }else {
        header.tag = 222;
        header.lable.text = @"下午预约人数";
        header.numLable.textColor = [UIColor colorWithRed:0.153 green:0.753 blue:0.576 alpha:1.000];
        header.numLable.text = [NSString stringWithFormat:@"%ld", (unsigned long)self.pmDataSource.count];
        if (!self.closePm) {
            header.imageV.image = [UIImage imageNamed:@"下一步-拷贝"];
        }else {
            header.imageV.image = [UIImage imageNamed:@"展开"];
        }
         return header;
    }
}
//编辑界面
- (void)editing:(UIButton *)btn{
    EditingSecheduingViewController *VC = [[EditingSecheduingViewController alloc]init];
    VC.Date = self.selectDate;
    VC.start_time1 = _dic[@"am_start_time"];
    VC.end_time1 = _dic[@"am_end_time"];
    VC.amNum = _dic[@"amnum"];
    VC.start_time2 = _dic[@"pm_start_time"];
    VC.end_time2 = _dic[@"pm_end_time"];
    VC.pmNum = _dic[@"pmnum"];
    VC.dwp_id = _dic[@"id"];
    [self.navigationController pushViewController:VC animated:YES];
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    PatientDetailViewController *PaDetail = [[PatientDetailViewController alloc]init];
    if (indexPath.section == 2) {
        NSDictionary *dic = [NSDictionary dictionary];
        if (_amDataSource.count) {
            dic = _amDataSource[indexPath.row];
        }else {
            dic = _pmDataSource[indexPath.row];
        }
        PaDetail.patient_id = dic[@"patient_id"];
        PaDetail.phone = dic[@"phone"];
        [self.navigationController pushViewController:PaDetail animated:YES];
    }else if (indexPath.section == 3) {
        NSDictionary *dic = _pmDataSource[indexPath.row];
        PaDetail.patient_id = dic[@"patient_id"];
        PaDetail.phone = dic[@"phone"];
        [self.navigationController pushViewController:PaDetail animated:YES];
    }
}
#pragma mark -viewWillAppear
- (void)viewWillAppear:(BOOL)animated
{
    [ZXUD setObject:@"sheet" forKey:@"rili"];
    self.navigationController.navigationBar.barTintColor = KRGB(0, 172, 204, 1.0);
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSFontAttributeName:[UIFont systemFontOfSize:20],NSForegroundColorAttributeName:[UIColor whiteColor]}];
    //添加系统消息个数
    [self getSystemMessageNum];
    //请求排班数量
    if (_enen)
    {
        [self getSheetData];
    }
}
#pragma mark -viewWillDisappear
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

//获取消息数量
- (void)getSystemMessageNum {
    [[SZBNetDataManager manager] remindNumRandomString:[ToolManager getCurrentTimeStamp] andCode:[ZXUD objectForKey:@"ident_code"] success:^(NSURLSessionDataTask *task, id responseObject) {
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
            [_numLabel removeFromSuperview];
            _numLabel = [[UILabel alloc]initWithFrame:CGRectMake(44 - 15, 15/3, 16, 16)];
            [_numLabel setFont:[UIFont systemFontOfSize:10]];
            _numLabel.textColor = [UIColor whiteColor];
            _numLabel.textAlignment = NSTextAlignmentCenter;
            _numLabel.layer.cornerRadius = 8;
            _numLabel.layer.masksToBounds = YES;
            _numLabel.backgroundColor = [UIColor redColor];
            _numLabel.text = responseObject[@"num"];
            if (![_numLabel.text isEqualToString:@"0"] && _numLabel.text != NULL ) {
                [self.systemMessageBtn addSubview:_numLabel];
            }
        }else if ([responseObject[@"res"] isEqualToString:@"1005"] || [responseObject[@"res"] isEqualToString:@"1004"]) {
            
        }else {
            [MBProgressHUD showError:responseObject[@"msg"]];
        }
        
    } failed:^(NSURLSessionTask *task, NSError *error) {
        
    }];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end

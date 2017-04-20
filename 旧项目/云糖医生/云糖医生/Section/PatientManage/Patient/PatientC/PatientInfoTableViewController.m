//
//  PatientInfoTableViewController.m
//  yuntangyi
//
//  Created by yuntangyi on 16/9/27.
//  Copyright © 2016年 yuntangyi. All rights reserved.
//

#import "PatientInfoTableViewController.h"
#import "PersonalDataTableViewCell.h"
#import "SZBNetDataManager+PatientManageNetData.h"

@interface PatientInfoTableViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (strong, nonatomic) UITableView *tableView;
@property (nonatomic, strong)NSDictionary *dicSouce;//数据源
@property (nonatomic, strong)LoadingView *loadingView;
@property (nonatomic, strong) NetworkLoadFailureView *loadFailureView;//重新加载占位图
@end

@implementation PatientInfoTableViewController
-(NetworkLoadFailureView *)loadFailureView{
    if (!_loadFailureView) {
        _loadFailureView = [[NetworkLoadFailureView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    }
    return _loadFailureView;
}
- (NSDictionary *)dicSouce {
    if (!_dicSouce) {
        _dicSouce = [NSDictionary dictionary];
    }
    return _dicSouce;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"健康资料";
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.tableView registerNib:[UINib nibWithNibName:@"PersonalDataTableViewCell" bundle:nil] forCellReuseIdentifier:@"PersonalDataTableViewCellID"];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"返回"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStyleDone target:self action:@selector(goToBack)];
    _loadingView = [[LoadingView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight)];

    //获取患者数据
    [self.view addSubview:_loadingView];
    [self getPatientNetData];
}
- (void)getPatientNetData{
    [[SZBNetDataManager manager]getPatientRandomString:[ToolManager getCurrentTimeStamp] andCode:[ZXUD objectForKey:@"ident_code"] andPatient_id:self.patient_id success:^(NSURLSessionDataTask *task, id responseObject) {
         [_loadingView dismiss];
        [self.loadFailureView removeFromSuperview];
        if ([responseObject[@"res"] isEqualToString:@"1001"]) {
            _dicSouce = responseObject[@"patient"];
            [self.tableView reloadData];
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
        }else if ([responseObject[@"res"] isEqualToString:@"1005"] || [responseObject[@"res"] isEqualToString:@"1004"]) {
            
        }else {
           [MBProgressHUD showError:responseObject[@"msg"]];

        }

    } failed:^(NSURLSessionTask *task, NSError *error) {
        [_loadingView dismiss];
        [self.view addSubview:self.loadFailureView];
        [self.loadFailureView.loadAgainBtn addTarget:self action:@selector(getPatientNetData) forControlEvents:UIControlEventTouchUpInside];

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
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 10;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PersonalDataTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PersonalDataTableViewCellID" forIndexPath:indexPath];
    cell.detailImgView.hidden = YES;
    NSArray *arr = @[@"姓名",@"性别", @"出生日期", @"身高",@"体重", @"糖尿病类型", @"体力活动", @"确诊年份(病史)", @"并发症", @"治疗方式"];
    NSArray *imageArr = @[@"姓名",@"性别", @"出生年份", @"身高",@"体重", @"类型", @"体力活动", @"确诊年份", @"并发症", @"治疗方式"];
    cell.name.text = arr[indexPath.row];
    cell.imageV.image = [UIImage imageNamed:imageArr[indexPath.row]];
    //名字
    if (indexPath.row == 0)
    {
        if (![_dicSouce[@"name"] isEqualToString:@""])
        {
            cell.selectLable.text = _dicSouce[@"name"];
            cell.selectLable.textColor = [UIColor darkGrayColor];
        }
        else
        {
            cell.selectLable.text = @"未填写";
            cell.selectLable.textColor = [UIColor orangeColor];
        }
    }
    //性别
    else if (indexPath.row == 1)
    {
    
        if (![_dicSouce[@"gender"] isEqualToString:@""])
        {
            if ([_dicSouce[@"gender"] isEqualToString:@"0"])
            {
                cell.selectLable.text = @"男";
            }
            else
            {
                cell.selectLable.text = @"女";
            }
            cell.selectLable.textColor = [UIColor darkGrayColor];
        }
        else
        {
            cell.selectLable.text = @"未填写";
            cell.selectLable.textColor = [UIColor orangeColor];
        }
        
    }
    //出生日期
    else if (indexPath.row == 2)
    {
      
        if (![_dicSouce[@"birth"] isEqualToString:@""])
        {
            cell.selectLable.text = _dicSouce[@"birth"];
            cell.selectLable.textColor = [UIColor darkGrayColor];
        }
        else
        {
            cell.selectLable.text = @"未填写";
            cell.selectLable.textColor = [UIColor orangeColor];
        }
    }
    //身高
    else if (indexPath.row == 3)
    {
      
        if (![_dicSouce[@"height"] isEqualToString:@""])
        {
            cell.selectLable.text = [NSString stringWithFormat:@"%@cm", _dicSouce[@"height"]];
            cell.selectLable.textColor = [UIColor darkGrayColor];
        }
        else
        {
            cell.selectLable.text = @"未填写";
            cell.selectLable.textColor = [UIColor orangeColor];
        }
    }
    //体重
    else if (indexPath.row == 4)
    {
     
        if (![_dicSouce[@"weight"] isEqualToString:@""])
        {
            cell.selectLable.text = [NSString stringWithFormat:@"%@kg", _dicSouce[@"weight"]];
            cell.selectLable.textColor = [UIColor darkGrayColor];
        }
        else
        {
            cell.selectLable.text = @"未填写";
            cell.selectLable.textColor = [UIColor orangeColor];
        }
    }
    //糖尿病类型
    else if (indexPath.row == 5)
    {
        
        if (![_dicSouce[@"diabetes_type"] isEqualToString:@""])
        {
            cell.selectLable.text = _dicSouce[@"diabetes_type"];
            cell.selectLable.textColor = [UIColor darkGrayColor];
        }
        else
        {
            cell.selectLable.text = @"未填写";
            cell.selectLable.textColor = [UIColor orangeColor];
        }
    }
    //体力活动
    else if (indexPath.row == 6)
    {

        if (![_dicSouce[@"activity"] isEqualToString:@""])
        {
            cell.selectLable.text = _dicSouce[@"activity"];
            cell.selectLable.textColor = [UIColor darkGrayColor];
        }
        else
        {
            cell.selectLable.text = @"未填写";
            cell.selectLable.textColor = [UIColor orangeColor];
        }
    }
    //病史
    else if (indexPath.row == 7)
    {
   
        if (![_dicSouce[@"diagnose_year"] isEqualToString:@""])
        {
            cell.selectLable.text = [NSString stringWithFormat:@"%@年", _dicSouce[@"diagnose_year"]];
            cell.selectLable.textColor = [UIColor darkGrayColor];
        }
        else
        {
            cell.selectLable.text = @"未填写";
            cell.selectLable.textColor = [UIColor orangeColor];
        }
    }
    //并发症
    else if (indexPath.row == 8)
    {
      
        if (![_dicSouce[@"complication"] isEqualToString:@""])
        {
            cell.selectLable.text = _dicSouce[@"complication"];
            cell.selectLable.textColor = [UIColor darkGrayColor];
        }
        else
        {
            cell.selectLable.text = @"未填写";
            cell.selectLable.textColor = [UIColor orangeColor];
        }
    }
    //治疗方式
    else
    {
        if (![_dicSouce[@"treatment"] isEqualToString:@""])
        {
            cell.selectLable.text = _dicSouce[@"treatment"];
            cell.selectLable.textColor = [UIColor darkGrayColor];
        }
        else
        {
            cell.selectLable.text = @"未填写";
            cell.selectLable.textColor = [UIColor orangeColor];
        }
    }
    
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
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

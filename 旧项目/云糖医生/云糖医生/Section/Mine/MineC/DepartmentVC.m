//
//  DepartmentVC.m
//  yuntangyi
//
//  Created by yuntangyi on 16/10/9.
//  Copyright © 2016年 yuntangyi. All rights reserved.
//

#import "DepartmentVC.h"

#import "SZBNetDataManager+department.h"

@interface DepartmentVC ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,strong) NSArray *source;//数据源
@property (nonatomic, strong)LoadingView *loadingView;
@property (nonatomic, strong) NetworkLoadFailureView *loadFailureView;//重新加载占位图
@end

static NSString *idnetifierCell = @"idnetifierCell";
@implementation DepartmentVC

#pragma mark -懒加载
-(NSArray *)source{
    if (!_source) {
        _source = [NSArray array];
    }
    return _source;
}
-(NetworkLoadFailureView *)loadFailureView{
    if (!_loadFailureView) {
        _loadFailureView = [[NetworkLoadFailureView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    }
    return _loadFailureView;
}
#pragma mark -网络请求
-(void)loadSHospital_department_UrlData{
    [self.view addSubview:_loadingView];
    SZBNetDataManager *manager = [SZBNetDataManager manager];
    [manager hospital_departmentRandomString:[ToolManager getCurrentTimeStamp] success:^(NSURLSessionDataTask *task, id responseObject) {
        [self.loadFailureView removeFromSuperview];
        [_loadingView dismiss];
        NSString *resStr = responseObject[@"res"];
        if ([resStr isEqualToString:@"1001"]) {
            NSArray *resault = responseObject[@"resault"];
            //给数据源赋值
            self.source = resault;
            //刷新表
            [self.tableView reloadData];
        }else if ([responseObject[@"res"] isEqualToString:@"1002"]) {
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
            NSString *message = responseObject[@"msg"];
            [MBProgressHUD showError:message];
        }
    } failed:^(NSURLSessionTask *task, NSError *error) {
        //网络请求失败
        [_loadingView dismiss];
        [self.view addSubview:self.loadFailureView];
        [self.loadFailureView.loadAgainBtn addTarget:self action:@selector(loadSHospital_department_UrlData) forControlEvents:UIControlEventTouchUpInside];
    }];
}
#pragma mark -配置导航栏
-(void)setUpNavi{
     self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"返回"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStyleDone target:self action:@selector(backAction)];
  
}
-(void)backAction{
    [self dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark -viewWillAppear
-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSFontAttributeName:[UIFont systemFontOfSize:20],NSForegroundColorAttributeName:KRGB(0, 172, 204, 1.0)}];
}
#pragma mark -viewDidLoad
- (void)viewDidLoad {
    [super viewDidLoad];
    //标题
    self.navigationItem.title = @"选择科室";
    //加载动画
    _loadingView = [[LoadingView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight)];
    //配置子视图
    [self setUpSubviews];
    //配置导航栏
    [self setUpNavi];
    //加载数据
    [self loadSHospital_department_UrlData];
}
//配置子视图
-(void)setUpSubviews{
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.rowHeight = 50;
    //注册cell
    [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([NormalBaseCell class]) bundle:nil] forCellReuseIdentifier:idnetifierCell];
}

#pragma mark -UITableViewDataSource,UITableViewDelegate
//组数
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
//行数
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.source count];
}
//行内容
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NormalBaseCell *cell = [tableView dequeueReusableCellWithIdentifier:idnetifierCell forIndexPath:indexPath];
    //获取到对应的字典
    NSDictionary *dict = self.source[indexPath.row];
    cell.title.text = dict[@"name"];
    return cell;
}
//点击cell
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *result = self.source[indexPath.row];
    //发通知
    [[NSNotificationCenter defaultCenter] postNotificationName:UserInfoDepartmentNoti  object:nil userInfo:result];
    [self dismissViewControllerAnimated:YES completion:nil];
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

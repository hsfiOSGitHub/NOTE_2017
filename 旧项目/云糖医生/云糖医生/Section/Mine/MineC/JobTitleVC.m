//
//  JobTitleVC.m
//  yuntangyi
//
//  Created by yuntangyi on 16/10/12.
//  Copyright © 2016年 yuntangyi. All rights reserved.
//

#import "JobTitleVC.h"
#import "SZBNetDataManager+department.h"
@interface JobTitleVC ()
@property (nonatomic,strong) NSMutableArray *dateSource;//数据源
@property (nonatomic, strong)LoadingView *loadingView;
@property (nonatomic, strong) NetworkLoadFailureView *loadFailureView;//重新加载占位图
@end

static NSString *idnetifierCell = @"idnetifierCell";
@implementation JobTitleVC
-(NSMutableArray *)dateSource{
    if (!_dateSource) {
        _dateSource = [NSMutableArray array];
    }
    return _dateSource;
}
-(NetworkLoadFailureView *)loadFailureView{
    if (!_loadFailureView) {
        _loadFailureView = [[NetworkLoadFailureView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    }
    return _loadFailureView;
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
    self.navigationItem.title = @"选择职称";
    //加载动画
    _loadingView = [[LoadingView alloc]initWithFrame:CGRectMake(0, - 64, KScreenWidth, KScreenHeight)];
    //配置子视图
    [self setUpSubviews];
    //配置导航栏
    [self setUpNavi];
    //加载数据
    [self getDoctorType];
}
//配置子视图
-(void)setUpSubviews{
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.rowHeight = 50;
    //注册cell
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([NormalBaseCell class]) bundle:nil] forCellReuseIdentifier:idnetifierCell];
    
}
- (void)getDoctorType {
    [self.view addSubview:_loadingView];
    [[SZBNetDataManager manager] get_doctor_typeRandomString:[ToolManager getCurrentTimeStamp] success:^(NSURLSessionDataTask *task, id responseObject) {
        [self.loadFailureView removeFromSuperview];
        [_loadingView dismiss];
        NSString *resStr = responseObject[@"res"];
        if ([resStr isEqualToString:@"1001"]) {
            NSArray *resault = responseObject[@"resault"];
            //给数据源赋值
            for (NSDictionary *dic in resault) {
                [self.dateSource addObject:dic];
            }
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
        [self.loadFailureView.loadAgainBtn addTarget:self action:@selector(getDoctorType) forControlEvents:UIControlEventTouchUpInside];
    }];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -UITableViewDataSource,UITableViewDelegate
//组数
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
//行数
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.dateSource count];
}
//行内容
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NormalBaseCell *cell = [tableView dequeueReusableCellWithIdentifier:idnetifierCell forIndexPath:indexPath];
    //获取到对应的字典
    NSDictionary *dict = self.dateSource[indexPath.row];
    cell.title.text = dict[@"title"];
    return cell;
}
//点击cell
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *result = self.dateSource[indexPath.row];
    //发通知
    [[NSNotificationCenter defaultCenter] postNotificationName:JobView_ok_noti object:nil userInfo:result];
    [self dismissViewControllerAnimated:YES completion:nil];
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
#pragma mark - Table view delegate

// In a xib-based application, navigation from a table can be handled in -tableView:didSelectRowAtIndexPath:
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here, for example:
    // Create the next view controller.
    <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:<#@"Nib name"#> bundle:nil];
    
    // Pass the selected object to the new view controller.
    
    // Push the view controller.
    [self.navigationController pushViewController:detailViewController animated:YES];
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

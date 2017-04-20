//
//  Register2ProvinceVC.m
//  yuntangyi
//
//  Created by yuntangyi on 16/10/13.
//  Copyright © 2016年 yuntangyi. All rights reserved.
//

#import "Register2ProvinceVC.h"

#import "SZBFmdbManager.h"
#import "FMDB.h"
#import "Register2CityVC.h"

@interface Register2ProvinceVC ()<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,strong) NSArray *source;//数据源
@end

static NSString *idnetifierCell = @"idnetifierCell";
@implementation Register2ProvinceVC
#pragma mark -懒加载
-(NSArray *)source{
    if (!_source) {
        SZBFmdbManager *manager = [SZBFmdbManager sharedManager];
        //创建并打开数据库
        FMDatabase *db = [manager getDBWithDBName:@"hospital.db"];
        //查询hospital.db文件中province表中name字段的数据
        NSDictionary *keyTypes = @{@"name":@"text",@"id":@"integer"};
        NSString *tableName = @"province";
        NSInteger limitNum = -1;
        //执行查询
        _source = [manager DataBase:db selectKeyTypes:keyTypes fromTable:tableName limitNum:limitNum];
    }
    return _source;
}
#pragma mark -配置导航栏
-(void)setUpNavi{
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(cancelChoose)];
    [rightItem setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15],NSForegroundColorAttributeName:KRGB(0, 172, 204, 1.0)} forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem = rightItem;
}
-(void)cancelChoose{
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
    self.navigationItem.title = @"选择医院所在地区";
    //配置子视图
    [self setUpSubviews];
    //配置导航栏
    [self setUpNavi];
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
    Register2CityVC *city_VC = [[Register2CityVC alloc]init];
    //获取到对应的字典
    NSDictionary *dict = self.source[indexPath.row];
    city_VC.province_id = dict[@"id"];
    city_VC.provinceName = dict[@"name"];
    //跳转到城市页面
    [self.navigationController pushViewController:city_VC animated:YES];
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

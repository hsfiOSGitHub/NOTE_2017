//
//  ProvinceVC.m
//  yuntangyi
//
//  Created by yuntangyi on 16/9/21.
//  Copyright © 2016年 yuntangyi. All rights reserved.
//

#import "ProvinceVC.h"

#import "SZBFmdbManager.h"
#import "FMDB.h"
#import "CityVC.h"

@interface ProvinceVC ()<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,strong) NSArray *source;//数据源
@end

static NSString *idnetifierCell = @"idnetifierCell";
@implementation ProvinceVC
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
        //去掉"其它"这个省目录
//        NSMutableArray *arr = [NSMutableArray array];
//        for (NSDictionary *dic in _source) {
//            [arr addObject:dic];
//        }
//        [arr removeObjectAtIndex:0];
//        _source = arr;
    }
    return _source;
}
#pragma mark -配置导航栏
-(void)setUpNavi{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, 44, 44);
    [btn setTitle:@"取消" forState:UIControlStateNormal];
    [btn setTitleColor: KRGB(0, 172, 204, 1.0) forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(cancelChoose) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithCustomView:btn];
    [rightItem setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17],NSForegroundColorAttributeName:KRGB(0, 172, 204, 1.0)} forState:UIControlStateNormal];
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
    CityVC *city_VC = [[CityVC alloc]init];
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

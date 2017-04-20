//
//  MyCollectViewController.m
//  yuntangyi
//
//  Created by yuntangyi on 16/8/30.
//  Copyright © 2016年 yuntangyi. All rights reserved.
//

#import "MyCollectViewController.h"
#import "MyCollectTableViewCell.h"
#import "SZBNetDataManager+MyCollectNetData.h"
#import "KnCellType2VC.h"
#import "NSString+TimeString.h"
#import "ValueHelper.h"

@interface MyCollectViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *ListTableView;

@property (nonatomic, strong)NSMutableArray *dataSource;//数据源
@property (nonatomic, strong)LoadingView *loadingView;//加载动画
@property (nonatomic)NSInteger page;
@property (nonatomic, strong)KongPlaceHolderView *placeholdView;
@property (nonatomic, strong) NetworkLoadFailureView *loadFailureView;//重新加载占位图

@property (nonatomic,strong) UILabel *alertLabel;
@end

@implementation MyCollectViewController
#pragma mark - 懒加载
-(void)dismissAlertLabel{
    self.alertLabel.center = CGPointMake(self.view.center.x, KScreenHeight + 20);
}
-(UILabel *)alertLabel{
    if (!_alertLabel) {
        _alertLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, KScreenHeight, 150, 40)];
        _alertLabel.center = CGPointMake(self.view.center.x, KScreenHeight + 20);
        _alertLabel.layer.masksToBounds = YES;
        _alertLabel.layer.cornerRadius = 5;
        _alertLabel.textColor = [UIColor whiteColor];
        _alertLabel.backgroundColor = [UIColor darkGrayColor];
        _alertLabel.font = [UIFont systemFontOfSize:15];
        _alertLabel.textAlignment = NSTextAlignmentCenter;
        [self.view addSubview:_alertLabel];
    }
    return _alertLabel;
}
-(NetworkLoadFailureView *)loadFailureView{
    if (!_loadFailureView) {
        _loadFailureView = [[NetworkLoadFailureView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    }
    return _loadFailureView;
}
- (NSMutableArray *)dataSource {
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"我的收藏";
    self.navigationController.navigationBar.translucent = YES;
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"返回"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStyleDone target:self action:@selector(goToBack)];
    self.ListTableView.delegate = self;
    self.ListTableView.dataSource = self;
   
     //注册cell
    [self.ListTableView registerNib:[UINib nibWithNibName:@"MyCollectTableViewCell" bundle:nil] forCellReuseIdentifier:@"MyCollectTableViewCellID"];
    //加载动画
    _loadingView = [[LoadingView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight)];
    _loadingView.center = CGPointMake(KScreenWidth/2, KScreenHeight/2);
    [self.view addSubview:_loadingView];
    //加载的数据为空
    _placeholdView = [[KongPlaceHolderView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight)];
    _placeholdView.center = CGPointMake(KScreenWidth/2, KScreenHeight/2);
    self.page = 0;
    //添加刷新头与加载尾
    self.ListTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        //只有下拉刷新的事件被触发,就应该重新请求数据.
        //发起网络请求
        self.page = 0;
        [self getMy_collect_newsNetData];
    }];
    self.ListTableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        self.page += 1;
        [self getMy_collect_newsNetData];
    }];
}
- (void)goToBack {
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)getMy_collect_newsNetData {
    [[SZBNetDataManager manager] myCollectNewsRandomString:[ToolManager getCurrentTimeStamp] andCode:[ZXUD objectForKey:@"ident_code"] andPage:self.page success:^(NSURLSessionDataTask *task, id responseObject) {
        [self.loadFailureView removeFromSuperview];
        [self.placeholdView removeFromSuperview];
        [_loadingView dismiss];
        [self.ListTableView.mj_header endRefreshing];
        [self.ListTableView.mj_footer endRefreshing];
        if ([responseObject[@"res"] isEqualToString:@"1001"]) {
            if (self.page == 0) {
                [self.dataSource removeAllObjects];
            }
            if ([responseObject[@"newslist"] isKindOfClass:[NSArray class]]) {
                for (NSDictionary *dic in responseObject[@"newslist"]) {
                    [self.dataSource addObject:dic];
                }
            }
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                if (self.dataSource.count == 0) {
                    _placeholdView.label.text = @"您还没有收藏的内容";
                    [self.view addSubview:_placeholdView];
                }
                [self.ListTableView reloadData];
            });
           
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
            [MBProgressHUD showError:responseObject[@"msg"]];
        }

    } failed:^(NSURLSessionTask *task, NSError *error) {
        [_loadingView dismiss];
        [self.ListTableView.mj_footer endRefreshing];
        [self.ListTableView.mj_header endRefreshing];
        if (self.dataSource.count == 0)  {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.loadFailureView removeFromSuperview];
                [self.view addSubview:self.loadFailureView];
                [self.loadFailureView.loadAgainBtn addTarget:self action:@selector(getMy_collect_newsNetData) forControlEvents:UIControlEventTouchUpInside];
            });
        }else{
            [MBProgressHUD showError:@"网络请求失败！"];
        }
    }];
}
#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.dataSource.count;
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MyCollectTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MyCollectTableViewCellID" forIndexPath:indexPath];
    NSDictionary *dic = self.dataSource[indexPath.row];
    cell.contentLable.text = dic[@"title"];
    [cell.imageV sd_setImageWithURL:[NSURL URLWithString:dic[@"pic"]] placeholderImage:[UIImage imageNamed:@"placeholder"]];
    cell.collectNum.text = dic[@"collect_num"];
    cell.timeLable.text = [NSString returnUploadTime:dic[@"addtime"]];
    cell.LookNumLable.text = dic[@"click"];
    
    return cell;
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 120;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    KnCellType2VC *VC = [[KnCellType2VC alloc]init];
    NSDictionary *dic = self.dataSource[indexPath.row];
    VC.BT=dic[@"title"];
    VC.NR=dic[@"content"];
    VC.TPurl=dic[@"pic"];
    VC.url = dic[@"url"];
    VC.newsID = dic[@"id"];
    VC.ispraise = dic[@"ispraise"];
    VC.iscollect = @"1";
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:VC animated:YES];
    
    [ValueHelper sharedHelper].updateKn = YES;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSFontAttributeName:[UIFont systemFontOfSize:20],NSForegroundColorAttributeName:KRGB(0, 172, 204, 1.0)}];
     self.page = 0;
     [self getMy_collect_newsNetData];
    
    if ([ValueHelper sharedHelper].updateCollect) {
        [self.ListTableView reloadData];
        [ValueHelper sharedHelper].updateCollect = NO;
    }
}
//-(void)viewWillDisappear:(BOOL)animated{
//    self.navigationController.navigationBar.translucent = NO;
//}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

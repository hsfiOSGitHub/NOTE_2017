//
//  ProjectViewController.m
//  yuntangyi
//
//  Created by yuntangyi on 16/9/2.
//  Copyright © 2016年 yuntangyi. All rights reserved.
//

#import "ProjectViewController.h"

#import "PrCell.h"
#import "PrBaseVC2.h"
#import "SystemNewsVC.h"
#import "SZBNetDataManager+ProjectNetData.h"
#import "PrActivityListModel.h"
#import "SZBFmdbManager+project.h"
#import "SZBNetDataManager+RegisterAndLoginNetData.h"

#import "Project2VC.h"

@interface ProjectViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong)UITableView *tableView;
@property (nonatomic,strong) NSString *page;//页数
@property (nonatomic,strong) NSMutableArray *source;//数据源

@property (nonatomic,strong) UIButton *systemMessageBtn;//系统消息按钮
@property (nonatomic,strong) UILabel *numLabel;//系统消息个数

@property (nonatomic,strong) LoadingView *loadingView;//加载中动画
@property (nonatomic,strong) NetworkLoadFailureView *loadFailureView;//加载失败图片
@property (nonatomic, strong)KongPlaceHolderView *placeholdView;//数据为空图片
//用于防止频繁加载
@property (nonatomic,assign) BOOL loadNew;
@property (nonatomic,assign) BOOL loadMore;

@property (nonatomic,strong) NSString *oldPage;

@property (nonatomic,strong) UILabel *alertLabel;

@end

static NSString *identifierCell = @"identifierCell";
@implementation ProjectViewController
#pragma mark -懒加载
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
-(NSMutableArray *)source{
    if (!_source) {
        _source = [NSMutableArray array];
    }
    return _source;
}
-(NSString *)page{
    if (!_page) {
        _page = @"0";
    }
    return _page;
}
#pragma mark -网络请求
-(void)loadActivity_list_UrlDataWithPage:(NSString *)page{
    //判断网络状态，网络不可用时直接显示网络状态
    if ([[ZXUD objectForKey:@"NetDataState"] isEqualToString:@"0"]) {
        //用于防止频繁刷新
        self.loadNew = NO;
        self.loadMore = NO;
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        //加载失败的话page不增加
        self.page = self.oldPage;
        //移除空数据图片
        [_placeholdView removeFromSuperview];
        //停止加载中动画
        [self.loadingView dismiss];
        [MBProgressHUD showError:@"请检查您的网络"];
    }else{
        _loadFailureView.userInteractionEnabled = NO;
        [_loadFailureView.loadAgainBtn setBackgroundColor:[UIColor lightGrayColor]];
        [_loadFailureView.loadAgainBtn setTitleColor:KRGB(0, 172, 204, 1) forState:UIControlStateNormal];
        [_loadFailureView.loadAgainBtn setTitle:@"努力加载中.." forState:UIControlStateNormal];
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        NSMutableSet *set = [NSMutableSet setWithSet:manager.responseSerializer.acceptableContentTypes];
        [set addObject:@"text/html"];
        NSLog(@"%@", [NSString stringWithFormat:SActivity_list_Url, [ToolManager getCurrentTimeStamp] , [ZXUD objectForKey:@"ident_code"], page]);
        manager.responseSerializer.acceptableContentTypes = set;
        [manager GET:[NSString stringWithFormat:SActivity_list_Url, [ToolManager getCurrentTimeStamp], [ZXUD objectForKey:@"ident_code"], page] parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            //网络请求成功
            self.loadNew = NO;
            self.loadMore = NO;
            if ([responseObject[@"res"] isEqualToString:@"1001"]) {
                //数据转模型
                NSArray *list = responseObject[@"list"];
                if (list != nil && [list isKindOfClass:[NSArray class]] && list.count > 0) {
                    [_placeholdView removeFromSuperview];//移除空数据图片
                    //数据转模型
                    NSMutableArray *temp = [NSMutableArray array];
                    for (NSDictionary *dict in list) {
                        PrActivityListModel *activityListModel = [PrActivityListModel modelWithDict:dict];
                        [temp addObject:activityListModel];
                    }
                    if ([page isEqualToString:@"0"]) {
                        self.page = @"0";
                        [self.source removeAllObjects];
                    }
                    [self.source addObjectsFromArray:temp];
                }else{
                    NSInteger newPage = [page integerValue];
                    newPage--;
                    self.page = [NSString stringWithFormat:@"%d",newPage];;
                    //重置－－不可以加载数据了
                    self.loadMore = YES;
                }
                //添加空数据图片
                if (self.source.count == 0) {
                    _placeholdView.label.text = @"您还没有项目";
                    [self.tableView addSubview:_placeholdView];
                }
            }else if ([responseObject[@"res"] isEqualToString:@"1007"]) {
                [MBProgressHUD showError:responseObject[@"msg"]];
            }else if ([responseObject[@"res"] isEqualToString: @"1005"] || [responseObject[@"res"] isEqualToString: @"1004"]) {
                
            }else if ([responseObject[@"res"] isEqualToString:@"100666"]) {
                _placeholdView.label.text = @"您还没有认证成功，无法查看该内容";
                [self.tableView addSubview:_placeholdView];
            }else {
                [MBProgressHUD showError:responseObject[@"msg"]];
            }
            [_tableView.mj_header endRefreshing];
            [_tableView.mj_footer endRefreshing];
            [self.loadingView dismiss];//加载动画停止
            [self.loadFailureView removeFromSuperview];//移除加载失败图片
            [self.tableView reloadData];//刷新UI
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            //网络加载失败
            self.loadNew = NO;
            self.loadMore = NO;
            [_tableView.mj_header endRefreshing];
            [_tableView.mj_footer endRefreshing];
            [self.loadingView dismiss];//加载动画停止
            //加载失败的话page不增加
            if ([page integerValue] > 0) {
                NSInteger newPage = [page integerValue];
                newPage--;
                self.page = [NSString stringWithFormat:@"%d",newPage];
            }
            //加载失败图片
            if (self.source.count == 0) {
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [self.loadFailureView removeFromSuperview];
                    self.loadFailureView = [[NetworkLoadFailureView alloc]initWithFrame:self.view.bounds];
                    [self.view addSubview:self.loadFailureView];
                    [self.loadFailureView.loadAgainBtn addTarget:self action:@selector(loadAgain) forControlEvents:UIControlEventTouchUpInside];
                });
            }else{
                [MBProgressHUD showError:@"网络请求失败！"];
            }
        }];
    }
}
-(void)loadAgain{
    [self loadActivity_list_UrlDataWithPage:self.page];
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

#pragma mark -viewWillAppear
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.barTintColor = KRGB(0, 172, 204, 1.0);
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSFontAttributeName:[UIFont systemFontOfSize:20],NSForegroundColorAttributeName:[UIColor whiteColor]}];
    //系统消息个数
    [self getSystemMessageNum];
}
#pragma mark -
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}
#pragma mark -viewDidLoad
- (void)viewDidLoad {
    [super viewDidLoad];
    //标题
    self.navigationItem.title = @"项目";
    //添加系统消息按钮
    [self addSystemNewsBtn];
    //配置tableView
    [self setUpTableView];
    //网络加载图片（加载中  加载失败  空数据）
    _loadingView = [[LoadingView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight)];
    _loadingView.center = CGPointMake(KScreenWidth/2, KScreenHeight/2);
    _loadFailureView = [[NetworkLoadFailureView alloc]initWithFrame:self.tableView.bounds];
    _placeholdView = [[KongPlaceHolderView alloc]initWithFrame:self.tableView.bounds];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        //判断网络状态，网络不可用时直接显示网络状态
        if ([ZXUD boolForKey:@"NetDataState"]) {
            //加载数据
            [self.view addSubview:self.loadingView];//网络加载动画
            [self loadActivity_list_UrlDataWithPage:self.page];
        }else{
            [self.loadFailureView removeFromSuperview];
            self.loadFailureView = [[NetworkLoadFailureView alloc]initWithFrame:self.view.bounds];
            [self.view addSubview:self.loadFailureView];
            [self.loadFailureView.loadAgainBtn addTarget:self action:@selector(loadAgain) forControlEvents:UIControlEventTouchUpInside];
        }
    });
    
    
    
}
//配置tableView
-(void)setUpTableView{
    //创建并添加
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 49) style:UITableViewStyleGrouped];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
//    _tableView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_tableView];
    //设置代理数据源
    _tableView.delegate = self;
    _tableView.dataSource = self;
    //注册cell
    [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([PrCell class]) bundle:nil] forCellReuseIdentifier:identifierCell];
    //高度
    _tableView.rowHeight = KScreenWidth/3;
    //下啦刷新
    _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        if (!self.loadNew) {
            self.loadNew = YES;
            self.oldPage = @"0";
            self.page = 0;
            //重新网络请求一次
            [self loadActivity_list_UrlDataWithPage:@"0"];
        }else{
            [_tableView.mj_header endRefreshing];
        }
    }];
    //上拉加载
    _tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        if (!self.loadMore) {
            self.loadMore = YES;
            self.oldPage = self.page;
            NSInteger page = [self.page integerValue];
            page++;
            NSString *newPage = [NSString stringWithFormat:@"%d",page];
            self.page = newPage;
            [self loadActivity_list_UrlDataWithPage:self.page];
        }else{
            [_tableView.mj_footer endRefreshing];
            self.alertLabel.text = @"没有更多项目了";
            [UIView animateWithDuration:0.1 animations:^{
                [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
                self.alertLabel.center = CGPointMake(self.view.center.x, KScreenHeight - 80);
            } completion:^(BOOL finished) {
                [self performSelector:@selector(dismissAlertLabel) withObject:nil afterDelay:1];
                
            }];
        }
        
    }];
}

#pragma mark -UITableViewDataSource
//组数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self.source count];
}
//行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}
//行内容
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PrCell *cell = [tableView dequeueReusableCellWithIdentifier:identifierCell forIndexPath:indexPath];
    //获取到对应的model
    PrActivityListModel *activityListModel = self.source[indexPath.section];
    cell.activityListModel = activityListModel;
    return cell;
}
//点击cell
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];// 取消选中
//    PrBaseVC2 *base_VC = [[PrBaseVC2 alloc]init];
//    PrActivityListModel *activityListModel = self.source[indexPath.section];
//    base_VC.activity_id = activityListModel.activity_id;
//    base_VC.url = activityListModel.activity_url;
//    [self.navigationController pushViewController:base_VC animated:YES];
    
    Project2VC *project2_VC = [[Project2VC alloc]init];
    PrActivityListModel *activityListModel = self.source[indexPath.section];
    project2_VC.activity_id = activityListModel.activity_id;
    project2_VC.url = activityListModel.activity_url;
    [self.navigationController pushViewController:project2_VC animated:YES];
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 5;
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
        }else if ([responseObject[@"res"] isEqualToString: @"1005"] || [responseObject[@"res"] isEqualToString: @"1004"]) {
            
        }else {
            NSString *message = responseObject[@"msg"];
            [MBProgressHUD showError:message];
        }
    } failed:^(NSURLSessionTask *task, NSError *error) {
        
    }];
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

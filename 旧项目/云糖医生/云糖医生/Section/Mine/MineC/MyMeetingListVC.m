//
//  MyMeetingListVC.m
//  yuntangyi
//
//  Created by yuntangyi on 16/9/18.
//  Copyright © 2016年 yuntangyi. All rights reserved.
//

#import "MyMeetingListVC.h"

#import "KnCellType1.h"
#import "SZBNetDataManager+PersonalInformation.h"
#import "MiMyMeetingListModel.h"
#import "KnSignUpDetailVC.h"

@interface MyMeetingListVC ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *source;//数据源
@property (nonatomic,strong) LoadingView *loadingView;//加载中动画
@property (nonatomic,strong) NetworkLoadFailureView *loadFailureView;//加载失败图片
@property (nonatomic, strong)KongPlaceHolderView *placeholdView;//数据为空图片
@property (nonatomic,strong) NSString *page;
//用于防止频繁请求数据
@property (nonatomic,assign) BOOL loadNew_meeting;
@property (nonatomic,assign) BOOL loadMore_meeting;

@property (nonatomic,strong) NSString *oldPage_meeting;


@property (nonatomic,strong) UILabel *alertLabel;
@end

static NSString *identifierCell = @"identifierCell";
@implementation MyMeetingListVC
//初始化方法
-(instancetype)init{
    if (self = [super init]) {
        self.hidesBottomBarWhenPushed = YES;
    }
    return self;
}
#pragma mark -懒加载
-(void)dismissAlertLabel{
    self.alertLabel.center = CGPointMake(self.view.center.x, KScreenHeight + 20);
}
-(UILabel *)alertLabel{
    if (!_alertLabel) {
        _alertLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, KScreenHeight, 250, 40)];
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
-(NSString *)page{
    if (!_page) {
        _page = @"0";
    }
    return _page;
}
-(NSMutableArray *)source{
    if (!_source) {
        _source = [NSMutableArray array];
    }
    return _source;
}
#pragma mark -网络请求
-(void)loadMy_meeting_list_UrlData{
    //判断网络状态，网络不可用时直接显示网络状态
    if ([[ZXUD objectForKey:@"NetDataState"] isEqualToString:@"0"]) {
        //用于防止频繁刷新
        self.loadNew_meeting = NO;
        self.loadMore_meeting = NO;
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        //加载失败的话page不增加
        self.page = self.oldPage_meeting;
        //移除空数据图片
        [_placeholdView removeFromSuperview];
        //停止加载中动画
        [self.loadingView dismiss];
        
        [MBProgressHUD showError:@"请检查您的网络"];
    }else{
        SZBNetDataManager *manager = [SZBNetDataManager manager];
        [manager my_meeting_listWithRandomString:[ToolManager getCurrentTimeStamp] AndIdent_code:[ZXUD objectForKey:@"ident_code"] AndPage:self.page success:^(NSURLSessionDataTask *task, id responseObject) {
            self.loadNew_meeting = NO;
            self.loadMore_meeting = NO;
            //网络请求成功
            if ([responseObject[@"res"] isEqualToString:@"1001"]) {
                [_placeholdView removeFromSuperview];//移除空数据图片
                NSArray *list = responseObject[@"list"];
                if (list != nil && [list isKindOfClass:[NSArray class]] && list.count > 0) {
                    //数据转模型
                    NSMutableArray *temp = [NSMutableArray array];
                    for (NSDictionary *dict in list) {
                        MiMyMeetingListModel *myMeetingListModel = [MiMyMeetingListModel modelWithDict:dict];
                        [temp addObject:myMeetingListModel];
                    }
                    if ([self.page isEqualToString:@"0"]) {
                        self.page = @"0";
                        [self.source removeAllObjects];//清空数据源
                        self.source = temp;
                    }else{
                        [self.source addObjectsFromArray:temp];
                    }
                }else{
                    NSInteger page = [self.page integerValue];
                    page--;
                    self.page = [NSString stringWithFormat:@"%d",page];
                    self.loadMore_meeting = YES;
                }
                if (self.source.count == 0) {//添加空数据图片
                    _placeholdView.label.text = @"您还没有已经报名的会议";
                    [self.view addSubview:_placeholdView];
                }
                
            }else if ([responseObject[@"res"] isEqualToString:@"100666"]) {
                [MBProgressHUD showError:responseObject[@"msg"]];
                _placeholdView.label.text = @"您还没有认证成功，无法查看该内容";
                [self.view addSubview:_placeholdView];
            }else if ([responseObject[@"res"] isEqualToString: @"1005"] || [responseObject[@"res"] isEqualToString: @"1004"]) {
                
            }else{
                [MBProgressHUD showError:responseObject[@"msg"]];
            }
            [self.loadingView dismiss];//加载动画停止
            [self.loadFailureView removeFromSuperview];//移除加载失败图片
            [self.tableView reloadData];//刷新UI
            
            [self.tableView.mj_footer endRefreshing];
            [self.tableView.mj_header endRefreshing];
        } failed:^(NSURLSessionTask *task, NSError *error) {
            //网络加载失败
            //加载失败的话page不增加
            if ([self.page integerValue] > 0) {
                NSInteger newPage = [self.page integerValue];
                newPage--;
                self.page = [NSString stringWithFormat:@"%d",newPage];
            }
            //移除空数据图片
            [_placeholdView removeFromSuperview];
            
            //加载动画停止
            self.loadNew_meeting = NO;
            self.loadMore_meeting = NO;
            [self.tableView.mj_footer endRefreshing];
            [self.tableView.mj_header endRefreshing];
            [self.loadingView dismiss];
            
            //加载失败图片
            if (self.source.count == 0) {
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [self.loadFailureView removeFromSuperview];
                    [self.view addSubview:self.loadFailureView];
                    [self.loadFailureView.loadAgainBtn addTarget:self action:@selector(loadMy_meeting_list_UrlData) forControlEvents:UIControlEventTouchUpInside];
                });
            }else{
                [MBProgressHUD showError:@"网络请求失败！"];
            }
            
        }];
    }
}
-(void)dismissAlertC{
    [self dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark -配置导航栏
-(void)setUpNavi{
    //返回
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc]initWithImage:[[UIImage imageNamed:@"返回"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(backAction)];
    self.navigationItem.leftBarButtonItem = leftItem;
    
}
-(void)backAction{
    [self.navigationController popViewControllerAnimated:YES];
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
    self.navigationItem.title = @"我报名的会议";
    //配置导航栏
    [self setUpNavi];
    //配置tableView
    [self setUpTableView];
    
    //网络加载图片（加载中  加载失败  空数据）
    _loadingView = [[LoadingView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight)];
    _loadingView.center = CGPointMake(KScreenWidth/2, KScreenHeight/2);
    _loadFailureView = [[NetworkLoadFailureView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight)];
    _loadFailureView.center = CGPointMake(KScreenWidth/2, KScreenHeight/2);
    _placeholdView = [[KongPlaceHolderView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight)];
    _placeholdView.center = CGPointMake(KScreenWidth/2, KScreenHeight/2);
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        //判断网络状态，网络不可用时直接显示网络状态
        if ([ZXUD boolForKey:@"NetDataState"]) {
            //加载数据
            [self.view addSubview:self.loadingView];
            [self loadMy_meeting_list_UrlData];
        }else{
            [self.loadFailureView removeFromSuperview];
            [self.view addSubview:self.loadFailureView];
            [self.loadFailureView.loadAgainBtn addTarget:self action:@selector(loadMy_meeting_list_UrlData) forControlEvents:UIControlEventTouchUpInside];
        }
    });
    
    
}
//配置tableView
-(void)setUpTableView{
    //设置数据源代理
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    //注册cell
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([KnCellType1 class]) bundle:nil] forCellReuseIdentifier:identifierCell];
    //高度
    self.tableView.estimatedRowHeight = 44;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    //下啦刷新tableView1
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        if (!self.loadNew_meeting) {
            self.loadNew_meeting = YES;
            self.oldPage_meeting = @"0";
            self.page = @"0";
            [self loadMy_meeting_list_UrlData];
        }else{
            [self.tableView.mj_header endRefreshing];
        }
    }];
    //上拉加载tableView1
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        if (!self.loadMore_meeting) {
            self.loadMore_meeting = YES;
            self.oldPage_meeting = self.page;
            NSInteger page = [self.page integerValue];
            page++;
            self.page = [NSString stringWithFormat:@"%d",page];
            [self loadMy_meeting_list_UrlData];
        }else{
            [self.tableView.mj_footer endRefreshing];
            self.alertLabel.text = @"没有更多已报名的会议了";
            [UIView animateWithDuration:0.1 animations:^{
                [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
                self.alertLabel.center = CGPointMake(self.view.center.x, KScreenHeight - 80);
            } completion:^(BOOL finished) {
                [self performSelector:@selector(dismissAlertLabel) withObject:nil afterDelay:1];
                
            }];
        }
    }];
}


#pragma mark -UITableViewDelegate,UITableViewDataSource
//组数
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return [self.source count];
}
//行数
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
//行内容
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    KnCellType1 *cell = [tableView dequeueReusableCellWithIdentifier:identifierCell forIndexPath:indexPath];
    cell.myMeetingListModel = self.source[indexPath.section];
    return cell;
}
//点击cell
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    KnSignUpDetailVC *signUpDetail_VC = [[KnSignUpDetailVC alloc]init];
    signUpDetail_VC.sourcePushVC = @"MyMeetingListVC";
    MiMyMeetingListModel *model = self.source[indexPath.section];
    signUpDetail_VC.mid = model.ID;
    signUpDetail_VC.doType = model.dotype;
    [self.navigationController pushViewController:signUpDetail_VC animated:YES];
}
//header高
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 0.1;
    }
    return 5;
}
//footer高
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 5;
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

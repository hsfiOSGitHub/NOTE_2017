//
//  PrPatientList.m
//  yuntangyi
//
//  Created by yuntangyi on 16/9/6.
//  Copyright © 2016年 yuntangyi. All rights reserved.
//

#import "PrPatientListVC.h"

#import "PrPatientListCell.h"
#import "SZBNetDataManager+ProjectNetData.h"
#import "PrActivityPatientModel.h"

@interface PrPatientListVC ()<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UIButton *okBtn;//确认按钮
@property (weak, nonatomic) IBOutlet UITableView *tableView;//
@property (nonatomic,strong) NSArray *source;//数据源
@property (nonatomic,strong) NSMutableArray *seletedArr;//是否选择的数据源
@property (nonatomic,strong) NSMutableArray *noseletedArr;//未选择的数据源
@property (nonatomic,copy) NSMutableString *patient_id_str;//患者ID拼接字符串

@property (nonatomic,strong) LoadingView *loadingView;//加载中动画
@property (nonatomic,strong) NetworkLoadFailureView *loadFailureView;//加载失败图片
@property (nonatomic, strong)KongPlaceHolderView *placeholdView;//数据为空图片
@property (nonatomic,strong) UIActivityIndicatorView *sendingView;//发送动画

@end

static NSString *identifierPatientListCell = @"identifierPatientListCell";
@implementation PrPatientListVC
#pragma mark -网络请求
//获取列表
-(void)loadActivity_patient_UrlData{
    SZBNetDataManager *manager = [SZBNetDataManager manager];
    [manager activity_patientWithActivity_id:self.activity_id AndRndstring:[ToolManager getCurrentTimeStamp] AndIdent_code:[ZXUD objectForKey:@"ident_code"] success:^(NSURLSessionDataTask *task, id responseObject) {
        //网络请求成功
        if ([responseObject[@"res"] isEqualToString:@"1001"]) {
            NSArray *resault = responseObject[@"resault"];
            if ([resault isKindOfClass:[NSArray class]] && resault.count > 0 && resault != nil) {
                [_placeholdView removeFromSuperview];//移除空数据图片
                //数据转模型
                NSMutableArray *temp = [NSMutableArray array];
                for (NSDictionary *dict in resault) {
                    PrActivityPatientModel *activityPatientModel = [PrActivityPatientModel modelWithDict:dict];
                    [temp addObject:activityPatientModel];
                }
                self.source = temp;
                //初始化seletedArr
                for (int i = 0; i < [self.source count]; i++) {
                    [self.seletedArr addObject:@0];
                }
            }
            if (self.source.count == 0) {//添加空数据图片
                _placeholdView.label.text = @"您还没有患者好友";
                [self.tableView addSubview:_placeholdView];
            }
        }else{
            NSString *message = responseObject[@"msg"];
            [MBProgressHUD showError:message];
        }
        [_tableView.mj_header endRefreshing];
        [self.loadingView dismiss];//加载动画停止
        [self.loadFailureView removeFromSuperview];//移除加载失败图片
        [self.tableView reloadData];//刷新UI
        NSLog(@"%@",responseObject);
        
    } failed:^(NSURLSessionTask *task, NSError *error) {
        //网络加载失败
        [self.loadingView dismiss];//加载动画停止
        [self.view addSubview:self.loadFailureView];//加载失败图片
        [self.loadFailureView.loadAgainBtn addTarget:self action:@selector(loadActivity_patient_UrlData) forControlEvents:UIControlEventTouchUpInside];
    }];
}

#pragma mark -懒加载
-(NSMutableArray *)seletedArr{
    if (!_seletedArr) {
        _seletedArr = [NSMutableArray array];
    }
    return _seletedArr;
}
-(NSMutableArray *)noseletedArr{
    if (!_noseletedArr) {
        _noseletedArr = [NSMutableArray array];
    }
    return _noseletedArr;
}
-(NSMutableString *)patient_id_str{
    if (!_patient_id_str) {
        _patient_id_str = [NSMutableString string];
    }
    return _patient_id_str;
}
#pragma mark -配置导航栏
-(void)setUpNavi{
    self.navigationController.navigationBar.translucent = NO;
    //返回
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"返回"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStyleDone target:self action:@selector(backAction)];
    //全选
    UIButton *seleteAllBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    seleteAllBtn.frame = CGRectMake(0, 0, 44, 44);
    [seleteAllBtn setTitle:@"全选" forState:UIControlStateNormal];
    seleteAllBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [seleteAllBtn setTitleColor:KRGB(0, 172, 204, 1) forState:UIControlStateNormal];
    [seleteAllBtn addTarget:self action:@selector(seleteAllAction:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithCustomView:seleteAllBtn];
    self.navigationItem.rightBarButtonItem = rightItem;
}
//返回
-(void)backAction {
    [self dismissViewControllerAnimated:YES completion:nil];
}
//全选
-(void)seleteAllAction:(UIButton *)sender {
    sender.selected = !sender.selected;
    if (sender.selected) {//点击》全选
        [sender setTitle:@"取消" forState:UIControlStateNormal];
        self.noseletedArr = nil;
        [self.seletedArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj integerValue] == 0) {
                [self.noseletedArr addObject:[NSString stringWithFormat:@"%lu",(unsigned long)idx]];
                [self.seletedArr replaceObjectAtIndex:idx withObject:@1];
            }
        }];
    }else{//点击》取消全选
        [sender setTitle:@"全选" forState:UIControlStateNormal];
        [self.noseletedArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSUInteger index = [obj integerValue];
            [self.seletedArr replaceObjectAtIndex:index withObject:@0];
        }];
    }
    [self.tableView reloadData];
}
#pragma mark -viewWillAppear
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.barTintColor = KRGB(253, 254, 255, 1);
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSFontAttributeName:[UIFont systemFontOfSize:20],NSForegroundColorAttributeName:KRGB(0, 172, 204, 1)}];
}
#pragma mark -viewDidLoad
- (void)viewDidLoad {
    [super viewDidLoad];
    //解决无故偏移的问题
    self.automaticallyAdjustsScrollViewInsets = NO;
    //配置导航栏
    [self setUpNavi];
    //标题
    self.title = @"分享给...";
    //配置确认按钮
    [self setUpOkBtn];
    //配置tableView
    [self setUpTableView];
    //初始化seletedArr
    for (int i = 0; i < [self.source count]; i++) {
        [self.seletedArr addObject:@0];
    }
    //网络加载图片（加载中  加载失败  空数据）
    _loadingView = [[LoadingView alloc]initWithFrame:self.tableView.bounds];
    _loadFailureView = [[NetworkLoadFailureView alloc]initWithFrame:self.tableView.bounds];
    _placeholdView = [[KongPlaceHolderView alloc]initWithFrame:self.tableView.bounds];
    
    //网络加载动画
    [self.tableView addSubview:self.loadingView];
    //加载数据
    [self loadActivity_patient_UrlData];
}
//配置确认按钮
-(void)setUpOkBtn{
    [_okBtn setBackgroundColor:KRGB(0, 172, 204, 1)];
    [_okBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
}
//配置tableView
-(void)setUpTableView{
    //设置数据源代理
    _tableView.dataSource = self;
    _tableView.delegate = self;
    //注册dell
    [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([PrPatientListCell class]) bundle:nil] forCellReuseIdentifier:identifierPatientListCell];
    //高度
    _tableView.estimatedRowHeight = 44;
    _tableView.rowHeight = UITableViewAutomaticDimension;
    //下啦刷新tableView1
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self loadActivity_patient_UrlData];
    }];
    //上拉加载tableView1
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [MBProgressHUD showError:@"没有更多患者好友了"];
        [_tableView.mj_footer endRefreshing];
    }];
}
//点击确认按钮
- (IBAction)okBtnEvent:(UIButton *)sender {
    //先判断是否已经选择
    BOOL hasSelete = [self.seletedArr containsObject:@1];
    if (hasSelete) {
        //遍历seletedArr获取到对应的patient_id
        //将patient_id拼接
        [self.seletedArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj isEqual:@1]) {
                PrActivityPatientModel *activityPatientModel = self.source[idx];
                NSString *patient_id = activityPatientModel.patient_id;
                [self.patient_id_str appendString:[NSString stringWithFormat:@",%@",patient_id]];
            }
        }];
        [self.patient_id_str replaceCharactersInRange:NSMakeRange(0, 1) withString:@""];
        //发送请求
        [self sendNetworkWithActivity_id:self.activity_id];
        //大白转起来
        _sendingView = [[UIActivityIndicatorView alloc]initWithFrame:CGRectMake(0, 0, 50, 50)];
        _sendingView.center = self.view.center;
        _sendingView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
        [self.view addSubview:_sendingView];
        [_sendingView startAnimating];
        
    }else{
        UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"提示" message:@"请选择要发送的好友" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *ok = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleCancel handler:nil];
        [alertC addAction:ok];
        [self presentViewController:alertC animated:YES completion:nil];
    }
}
//发送
-(void)sendNetworkWithActivity_id:(NSString *)activity_id{
    SZBNetDataManager *manager = [SZBNetDataManager manager];
    [manager activity_inviteWithActivity_id:activity_id AndRndstring:[ToolManager getCurrentTimeStamp] AndIdent_code:[ZXUD objectForKey:@"ident_code"] AndPatient_id:self.patient_id_str success:^(NSURLSessionDataTask *task, id responseObject) {
        [_sendingView stopAnimating];//大白停止旋转
        //停止上拉加载更多
        [self.tableView.mj_footer endRefreshing];
        //网络请求成功
        if ([responseObject[@"res"] isEqualToString:@"1001"]) {
            NSString *message = responseObject[@"msg"];
            [MBProgressHUD showError:message];
        }else{
            NSString *message = responseObject[@"msg"];
            [MBProgressHUD showError:message];
        }
        [self.tableView.mj_header endRefreshing];
    } failed:^(NSURLSessionTask *task, NSError *error) {
        [_sendingView stopAnimating];//大白停止旋转
        //网络请求失败
        NSLog(@"%@",error);
    }];
}


#pragma mark -UITableViewDelegate,UITableViewDataSource
//组数
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
//行数
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.source count];
//    return 20;
}
//行内容
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    PrPatientListCell *cell = [tableView dequeueReusableCellWithIdentifier:identifierPatientListCell];
    [cell.seletedBtn setTag:indexPath.row + 100];
    [cell.seletedBtn addTarget:self action:@selector(seletedBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    if ([self.seletedArr count]) {
        cell.isSeleted = [self.seletedArr[indexPath.row] integerValue];
    }
    //配置cell内容
    cell.activityPatientModel = self.source[indexPath.row];
    return cell;
}
//点击选择
-(void)seletedBtnAction:(UIButton *)sender {
    NSUInteger index = sender.tag - 100;
    if ([self.seletedArr[index] integerValue]) {//取消
        [self.seletedArr replaceObjectAtIndex:index withObject:@0];
    }else{//选择
        [self.seletedArr replaceObjectAtIndex:index withObject:@1];
    }
    //刷新单个cell
//    NSIndexPath *currentIndexPath = [NSIndexPath indexPathForRow:index inSection:0];
//    [_tableView reloadRowsAtIndexPaths:@[currentIndexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    [self.tableView reloadData];
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

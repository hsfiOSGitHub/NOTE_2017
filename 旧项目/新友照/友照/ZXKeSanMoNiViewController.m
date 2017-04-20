//
//  ZXKeSanMoNiViewController.m
//  ZXJiaXiao
//
//  Created by yujian on 16/5/12.
//  Copyright © 2016年 ZX. All rights reserved.
//

#import "ZXKeSanMoNiViewController.h"
#import "ZXKeSanMoNiTableViewCell.h"
#import "ZXKeSanMiNiSortView.h"
#import "ZXCarDetailControllerVC.h"

@interface ZXKeSanMoNiViewController ()<UITableViewDelegate,UITableViewDataSource>


//数据源
@property (nonatomic, strong) NSMutableArray *dataSource;
//dataSource的替身
@property (nonatomic, strong) NSMutableArray *TiShenDataSource;
//all Arr
@property (nonatomic, strong) NSMutableArray *allTypeArr;
//皮卡 Arr
@property (nonatomic, strong) NSMutableArray *piKaType;
//轿车 Arr
@property (nonatomic, strong) NSMutableArray *jiaoCheType;
@property (nonatomic ) UITableView * KeSanMoNiTableView;
@property (nonatomic ) UIButton * allCarBtn;
@property (nonatomic ) UIButton * orderBtn;
@property (nonatomic) ZXKeSanMiNiSortView *sortView;
@property (nonatomic, copy) NSString *sortType;
@property (nonatomic, copy) NSString *ctype;
@property (nonatomic, copy) NSString *order;
//车辆的id
@property (nonatomic, copy) NSString *cid;
@property (nonatomic) BOOL isRefresh;
@property (nonatomic, strong) ZXKongKaQuanView *KongKaQuanView;

@end

@implementation ZXKeSanMoNiViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithRed:241/255.0f green:241/255.0f blue:241/255.0f alpha:1];
    self.title = @"科三模拟";
    [self creatBtn];
    [self KeSanMoNiTableView];
    [self.view addSubview:_KeSanMoNiTableView];
    //适配
    
    self.piKaType = [NSMutableArray array];
    self.jiaoCheType = [NSMutableArray array];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    //注册cell
    [self.KeSanMoNiTableView registerNib:[UINib nibWithNibName:@"ZXKeSanMoNiTableViewCell" bundle:Nil] forCellReuseIdentifier:@"cellID"];
    _order = @"0";
    _ctype = @"0";
    [self getNetData];
}

//懒加载空卡券视图
-(ZXKongKaQuanView *)KongKaQuanView
{
    if (!_KongKaQuanView)
    {
        _KongKaQuanView = [[ZXKongKaQuanView alloc]initWithFrame:CGRectMake(0, 52, KScreenWidth, KScreenHeight-52)];
        _KongKaQuanView.label.text = @"您所选的车辆暂时没有哦";
    }
    return _KongKaQuanView;
}

//创建按钮
-(void)creatBtn
{
    _allCarBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, (KScreenWidth-1) / 2, 50)];
    [_allCarBtn setTitle:@"所有车辆" forState:UIControlStateNormal];
    _allCarBtn.backgroundColor = [UIColor whiteColor];
    [_allCarBtn setImage:[UIImage imageNamed:@"收起"] forState:UIControlStateNormal];
    _allCarBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [_allCarBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
   
    [_allCarBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 50)];
    [_allCarBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, -_allCarBtn.bounds.size.width - 10)];
  
    [_allCarBtn addTarget:self action:@selector(sortAll:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_allCarBtn];
    
    _orderBtn  = [[UIButton alloc] initWithFrame:CGRectMake((KScreenWidth-1) / 2 + 1, 0, (KScreenWidth-1) / 2, 50)];
    [_orderBtn setImage:[UIImage imageNamed:@"收起"] forState:UIControlStateNormal];
    [_orderBtn setTitle:@"默认排序" forState:UIControlStateNormal];
    _orderBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [_orderBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 50)];
    [_orderBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, -_allCarBtn.bounds.size.width - 10)];
    [_orderBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    _orderBtn.backgroundColor = [UIColor whiteColor];
    [_orderBtn addTarget:self action:@selector(sortDefault:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_orderBtn];
}

//请求网络数据
-(void)getNetData
{
    if (!_isRefresh)
    {
        //小车动画
        _animationView=[[ZXAnimationView alloc]initWithFrame:CGRectMake(0, 52, KScreenWidth, KScreenHeight-52)];
        [self.view addSubview:_animationView];
    }
    
    [[ZXNetDataManager manager] KeSanMoNiWithTimeStamp:[ZXDriveGOHelper getCurrentTimeStamp] andClassify:_ctype andOrder:_order success:^(NSURLSessionDataTask *task, id responseObject)
     {
        NSError *err;
        NSString *receiveStr = [[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSString *jsonString = [receiveStr stringByReplacingOccurrencesOfString:@"\r" withString:@""];
        jsonString = [jsonString stringByReplacingOccurrencesOfString:@"\n" withString:@""];
        jsonString = [jsonString stringByReplacingOccurrencesOfString:@"\t" withString:@""];
        jsonString = [jsonString stringByReplacingOccurrencesOfString:@"\v" withString:@""];
        jsonString = [jsonString stringByReplacingOccurrencesOfString:@"\f" withString:@""];
        jsonString = [jsonString stringByReplacingOccurrencesOfString:@"\b" withString:@""];
        jsonString = [jsonString stringByReplacingOccurrencesOfString:@"\a" withString:@""];
        jsonString = [jsonString stringByReplacingOccurrencesOfString:@"\e" withString:@""];
        NSData * data = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&err];
        if(err) {
            NSLog(@"json解析失败：%@",err);
        }
         [_KongKaQuanView removeFromSuperview];
         
        if([[ZXwangLuoDanLi WangLuoDanLi] resIsTrue:jsonDict andAlertView:self])
        {
            if([jsonDict[@"carlist"] isKindOfClass:[NSArray class]])
            {
                if (!_TiShenDataSource)
                {
                    _TiShenDataSource =[NSMutableArray arrayWithArray:jsonDict[@"carlist"]];
                }
                else
                {
                    _TiShenDataSource = jsonDict[@"carlist"];
                }
                
                [self.KeSanMoNiTableView reloadData];
            }
        }
         
         dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
             [_animationView removeFromSuperview];
         });
         
    }failed:^(NSURLSessionTask *task, NSError *error)
    {
        [_animationView removeFromSuperview];
        [MBProgressHUD showSuccess:@"网络不好，请稍后重试。"];
    }];
}


//排序按钮事件
- (void)sortDefault:(UIButton *)btn {
    /*
     ZXKeSanMoNiSortTypeAll = 0,
     ZXKeSanMoNiSortTypeDefault,
     */
    if (self.sortView.sortType == ZXKeSanMoNiSortTypeDefault)
    {
        self.sortView.sortType = ZXKeSanMoNiSortTypeNone;
        [btn setImage:[UIImage imageNamed:@"收起"] forState:UIControlStateNormal];
        [self.sortView removeFromSuperview];
    }
    else
    {
        [btn setImage:[UIImage imageNamed:@"展开"] forState:UIControlStateNormal];
        [self.view addSubview:self.sortView];
        self.sortView.sortType = ZXKeSanMoNiSortTypeDefault;
    }
}

- (void)sortAll:(UIButton *)btn
{
    
    if (self.sortView.sortType == ZXKeSanMoNiSortTypeAll)
    {
        self.sortView.sortType = ZXKeSanMoNiSortTypeNone;
        [btn setImage:[UIImage imageNamed:@"收起"] forState:UIControlStateNormal];
        [self.sortView removeFromSuperview];
    }
    else
    {
        [self.view addSubview:self.sortView];
        [btn setImage:[UIImage imageNamed:@"展开"] forState:UIControlStateNormal];
        self.sortView.sortType = ZXKeSanMoNiSortTypeAll;
    }
}

- (ZXKeSanMiNiSortView *)sortView
{
    if (_sortView == nil)
    {
        _sortView = [[ZXKeSanMiNiSortView alloc] initWithFrame:CGRectMake(0, 52, KScreenWidth, KScreenHeight - 51) andSortType:0 ];
        _sortView.backgroundColor=[UIColor whiteColor];
        __weak __typeof(self) weakSelf = self ;
        _sortView.SelectedTypeAll = ^(NSString *sortType,ZXKeSanMoNiSortType type)
        {
            if (type == 1)
            {
                [weakSelf.allCarBtn setTitle:sortType forState:UIControlStateNormal];
            }
            else if (type == 2)
            {
                [weakSelf.orderBtn setTitle:sortType forState:UIControlStateNormal];
            }
            [weakSelf fenlei:weakSelf.allCarBtn.currentTitle andstrt:weakSelf.orderBtn.currentTitle];
            _sortType = sortType;
            weakSelf.sortView.sortType = ZXKeSanMoNiSortTypeNone;
            [weakSelf.allCarBtn setImage:[UIImage imageNamed:@"收起"] forState:UIControlStateNormal];
            [weakSelf.orderBtn setImage:[UIImage imageNamed:@"收起"] forState:UIControlStateNormal];
        };
    }
    return _sortView;
}

//各种分类排序
-(void)fenlei:(NSString*)stro andstrt:(NSString*)strt
{
    //先判断dataSource是否有值
        //然后分类 [@"所有车辆",@"皮卡",@"轿车"]、[@"默认排序",@"好评优先",@"价格最优"]
        if ([stro isEqualToString:@"所有车辆"] && [strt isEqualToString:@"默认排序"]) {
            //先移除数据
            [_dataSource removeAllObjects];
            _ctype = @"0";
            
        }else if([stro isEqualToString:@"所有车辆"] && [strt isEqualToString:@"好评优先"]){
            [_dataSource removeAllObjects];
            _ctype = @"0";
            _order = @"score";
        }else if([stro isEqualToString:@"所有车辆"] && [strt isEqualToString:@"价格最优"]){
            [_dataSource removeAllObjects];
            _ctype = @"0";
            _order = @"price";
            
        }else if([stro isEqualToString:@"皮卡"] && [strt isEqualToString:@"默认排序"]){
            [_dataSource removeAllObjects];
            _ctype = @"2";
            
        }else if([stro isEqualToString:@"皮卡"] && [strt isEqualToString:@"好评优先"]){
            [_dataSource removeAllObjects];
            _ctype = @"2";
            _order = @"score";
        }else if([stro isEqualToString:@"皮卡"] && [strt isEqualToString:@"价格最优"]){
            [_dataSource removeAllObjects];
            _ctype = @"2";
            _order = @"price";
        }else if([stro isEqualToString:@"轿车"] && [strt isEqualToString:@"默认排序"]){
            [_dataSource removeAllObjects];
            _ctype = @"1";
            
        }else if([stro isEqualToString:@"轿车"] && [strt isEqualToString:@"好评优先"]){
            [_dataSource removeAllObjects];
            _ctype = @"1";
            _order = @"score";
        }else if([stro isEqualToString:@"轿车"] && [strt isEqualToString:@"价格最优"]){
            [_dataSource removeAllObjects];
            _ctype = @"1";
            _order = @"price";
        }
        //请求数据
        [self getNetData];
}

//创建tableView
- (UITableView *)KeSanMoNiTableView
{
    if (_KeSanMoNiTableView == nil)
    {
        _KeSanMoNiTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 52, KScreenWidth, KScreenHeight - 75) style:UITableViewStylePlain];
        _KeSanMoNiTableView.dataSource = self;
        _KeSanMoNiTableView.delegate = self;
        _KeSanMoNiTableView.showsVerticalScrollIndicator = NO;
        //分隔线
        _KeSanMoNiTableView.separatorStyle = UITableViewCellSelectionStyleNone;
        //添加下拉刷新视图
        _KeSanMoNiTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            _isRefresh = YES;
            [self.dataSource removeAllObjects];
            [self getNetData];
            [self.KeSanMoNiTableView reloadData];
            [self.KeSanMoNiTableView.mj_header endRefreshing];
        }];
        
        _KeSanMoNiTableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            _isRefresh = YES;
            [self.dataSource removeAllObjects];
            [self getNetData];
            [self.KeSanMoNiTableView reloadData];
            [self.KeSanMoNiTableView.mj_footer endRefreshing];
        }];
    }
    return _KeSanMoNiTableView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (_TiShenDataSource && _TiShenDataSource.count == 0)
    {
        [self KongKaQuanView];
        [self.view insertSubview:_KongKaQuanView belowSubview:_animationView];
    }
    return _TiShenDataSource.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    ZXKeSanMoNiTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellID" forIndexPath:indexPath];
    //配置cell
    [cell setKeSanMoNiCellWith:_TiShenDataSource[indexPath.row]];
    UILabel *fenGeLabel = [[UILabel alloc ]initWithFrame:CGRectMake(0, cell.frame.size.height - 1, KScreenWidth, 1)];
    fenGeLabel.backgroundColor = [UIColor colorWithRed:241/255.0f green:241/255.0f blue:241/255.0f alpha:1];
    [cell.contentView addSubview:fenGeLabel];
    cell.selectionStyle = NO;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 124;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ZXCarDetailControllerVC *CarVC = [[ZXCarDetailControllerVC alloc]init];
    //将车辆id传到详情界面
     CarVC.kid = _TiShenDataSource[indexPath.row][@"id"];
    [self.navigationController pushViewController:CarVC animated:YES];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}



@end

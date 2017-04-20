//
//  CoachViewController.m
//  友照
//
//  Created by chaoyang on 16/11/22.
//  Copyright © 2016年 ZX_XPH. All rights reserved.
//

#import "CoachViewController.h"
#import "CoachListTableViewCell.h"
#import "ZXNetDataManager+CoachData.h"
#import "SearchCoachVC.h"
#import "ZXCoachDetailVC.h"
#import "ZX_Login_ViewController.h"

@interface CoachViewController ()<UIScrollViewDelegate, UITableViewDelegate , UITableViewDataSource>
@property (nonatomic, strong)NSMutableArray *buttonArray;
@property (nonatomic, strong) NSMutableArray *dataSource1;//数据源
@property (nonatomic, strong) NSMutableArray *dataSource2;//数据源
@property (nonatomic, strong) NSMutableArray *dataSource3;//数据源
@property (nonatomic, strong) NSMutableArray *dataSource4;//数据源
@property (nonatomic, strong) NSString *sort;//排序关键字
@property (nonatomic)int coach1;//用来标记 , 加载完一次之后不再网络请求
@property (nonatomic)int coach2;
@property (nonatomic)int coach3;
@property (nonatomic)int coach4;
@property (nonatomic) int page1;
@property (nonatomic) int page2;
@property (nonatomic) int page3;
@property (nonatomic) int page4;

@end

@implementation CoachViewController

- (NSMutableArray *)dataSource1
{
    if (!_dataSource1)
    {
        _dataSource1 = [NSMutableArray array];
    }
    return _dataSource1;
}
- (NSMutableArray *)dataSource2
{
    if (!_dataSource2)
    {
        _dataSource2 = [NSMutableArray array];
    }
    return _dataSource2;
}
- (NSMutableArray *)dataSource3
{
    if (!_dataSource3)
    {
        _dataSource3 = [NSMutableArray array];
    }
    return _dataSource3;
}
- (NSMutableArray *)dataSource4
{
    if (!_dataSource4)
    {
        _dataSource4 = [NSMutableArray array];
    }
    return _dataSource4;
}
//初始化方法
-(instancetype)init
{
    if (self = [super init])
    {
        self.hidesBottomBarWhenPushed = YES;
    }
    return self;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    //添加搜索功能
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSearch target:self action:@selector(searchCoach)];
    self.navigationItem.title = self.CoachType;
    //设置按钮的颜色以及点击事件
    [self prefectBtnThings];
    [self creatScrollView];
    
    [self getCoachListData1];
    //上拉加载 下拉刷新
    [self addRefreshLoadNew];
    [self addRefreshLoadMore];
}
//下拉刷新，
-(void)addRefreshLoadNew
{
    //通过率高
    self.tableView1.mj_header = [HSFRefreshGifHeader headerWithRefreshingBlock:^{
            self.page1 = 0;
            [self getCoachListData1];
    }];
    //评价最好
    self.tableView2.mj_header = [HSFRefreshGifHeader headerWithRefreshingBlock:^{
        self.page2 = 0;
        [self getCoachListData2];
    }];
    //教龄最长
    self.tableView3.mj_header = [HSFRefreshGifHeader headerWithRefreshingBlock:^{
        self.page3 = 0;
        [self getCoachListData3];

    }];
    //拿证最快
    self.tableView4.mj_header = [HSFRefreshGifHeader headerWithRefreshingBlock:^{
        self.page4 = 0;
        [self getCoachListData4];

    }];
}
//上拉加载更多
-(void)addRefreshLoadMore
{
    self.tableView1.mj_footer = [HSFRefreshAutoGifFooter footerWithRefreshingBlock:^{
        self.page1++;
        [self getCoachListData1];
    }];
    self.tableView2.mj_footer = [HSFRefreshAutoGifFooter footerWithRefreshingBlock:^{
        self.page2++;
        [self getCoachListData2];
    }];
    self.tableView3.mj_footer = [HSFRefreshAutoGifFooter footerWithRefreshingBlock:^{
        self.page3++;
        [self getCoachListData3];
    }];
    self.tableView4.mj_footer = [HSFRefreshAutoGifFooter footerWithRefreshingBlock:^{
        self.page3++;
        [self getCoachListData3];
    }];
}
//搜索教练
- (void)searchCoach
{
    SearchCoachVC *seachVC = [[SearchCoachVC alloc] init];
    seachVC.subject = self.subject;
    [self.navigationController pushViewController:seachVC animated:YES];
}

//设置按钮的颜色以及点击事件
- (void)prefectBtnThings
{
    self.passingRateBtn.tag = 100;
    self.estimateBtn.tag = 101;
    self.ageBtn.tag = 102;
    self.quickerBtn.tag = 103;
   _buttonArray = [NSMutableArray array];
    [_buttonArray addObject:self.passingRateBtn];
    [_buttonArray addObject:self.estimateBtn];
    [_buttonArray addObject:self.ageBtn];
    [_buttonArray addObject:self.quickerBtn];
    [self.passingRateBtn setTitleColor:dao_hang_lan_Color forState:UIControlStateNormal];
    for (UIButton *btn in _buttonArray)
    {
        [btn addTarget:self action:@selector(functionBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
}
//配置scrollview属性
-(void)creatScrollView
{
    self.ScrollView.tag = 888;
    self.ScrollView.delegate = self;
    self.tableView1.delegate = self;
    self.tableView1.dataSource = self;
    self.tableView2.delegate = self;
    self.tableView2.dataSource = self;
    self.tableView3.delegate = self;
    self.tableView3.dataSource = self;
    self.tableView4.delegate = self;
    self.tableView4.dataSource = self;
    _tableView1.showsVerticalScrollIndicator = NO;
    _tableView2.showsVerticalScrollIndicator = NO;
    _tableView3.showsVerticalScrollIndicator = NO;
    _tableView4.showsVerticalScrollIndicator = NO;
    [self.tableView1 registerNib:[UINib nibWithNibName:@"CoachListTableViewCell" bundle:nil] forCellReuseIdentifier:@"CoachListTableViewCellID"];
    [self.tableView2 registerNib:[UINib nibWithNibName:@"CoachListTableViewCell" bundle:nil] forCellReuseIdentifier:@"CoachListTableViewCellID"];
    [self.tableView3 registerNib:[UINib nibWithNibName:@"CoachListTableViewCell" bundle:nil] forCellReuseIdentifier:@"CoachListTableViewCellID"];
    [self.tableView4 registerNib:[UINib nibWithNibName:@"CoachListTableViewCell" bundle:nil] forCellReuseIdentifier:@"CoachListTableViewCellID"];
}
//点击切换
- (void)functionBtnClick:(UIButton *)btn
{
    [_animationView removeFromSuperview];
    NSInteger X = btn.tag - 100;
    for (UIButton *btn in _buttonArray)
    {
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    }
    [btn setTitleColor:dao_hang_lan_Color forState:UIControlStateNormal];
    self.ScrollView.contentOffset = CGPointMake(self.ScrollView.bounds.size.width * X, 0);
    [self animationMove:X];
    [self netDataChange:X];
    
}
//动画条移动
- (void)animationMove:(NSInteger)X
{
    [UIView animateWithDuration:0.2 animations:^{
        _animationView1.frame = CGRectMake((KScreenWidth / 4) * X, 53,  KScreenWidth / 4, 2);
    }];
}
//scrollView 滑动
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [_animationView removeFromSuperview];
    if (scrollView.tag == 888)
    {
        for (UIButton *btn in _buttonArray)
        {
            [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        }
        UIButton *btn = [self.view viewWithTag:100 + self.ScrollView.contentOffset.x / scrollView.frame.size.width];
        [btn setTitleColor: dao_hang_lan_Color forState:UIControlStateNormal];
       
        [self animationMove:self.ScrollView.contentOffset.x / scrollView.frame.size.width];
        [self netDataChange:self.ScrollView.contentOffset.x / scrollView.frame.size.width];
    }
}

//下拉刷新的时候, 去请求数据
-(void)netDataChange:(NSInteger)num
{
    switch (num)
    {
        case 0:
        {
//            if (self.coach1 == 1)
//            {
//                return;
//            }
//            [self getCoachListData1];
//            self.coach1 = 1;
        }
            break;
        case 1:
        {
            if (self.coach2 == 1)
            {
                return;
            }
            [self getCoachListData2];
            self.coach2 = 1;
        }
            break;
        case 2:
        {
            if (self.coach3 == 1)
            {
                return;
            }
            [self getCoachListData3];
            self.coach3 = 1;
        }
            break;
        default:
            if (self.coach4 == 1)
            {
                return;
            }
            [self getCoachListData4];
            self.coach4 = 1;
            break;
    }
}

- (void)getCoachListData1
{
    if (_dataSource1 == nil)
    {
        _animationView=[[ZXAnimationView alloc]initWithFrame:CGRectMake(0, 120, KScreenWidth, KScreenHeight-120)];
        [self.view addSubview:_animationView];
    }
     __weak typeof(self) MYSelf = self;
    [[ZXNetDataManager manager]JiaoLianListWithTimeStamp:[ZXDriveGOHelper getCurrentTimeStamp] andSubject:self.subject andPage:[NSString stringWithFormat:@"%d", self.page1] andSort:@"avg_rate" andName:@"" andSid:_sid andCity:_cityName success:^(NSURLSessionDataTask *task, id responseObject)
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
        if(err)
        {
            NSLog(@"json解析失败：%@",err);
        }
        //停止刷新
        [self.tableView1.mj_header endRefreshing];
        [self.tableView1.mj_footer endRefreshing];
        if ([jsonDict[@"res"] isEqualToString:@"1001"])
        {
            if ([jsonDict[@"teacher_list"] isKindOfClass:[NSArray class]])
            {
                //判断刷新第一页时先将数据源置空
                if (self.page1 == 0)
                {
                    [self.dataSource1 removeAllObjects];
                }
                for (NSDictionary *dic in jsonDict[@"teacher_list"])
                {
                    [self.dataSource1 addObject:dic];
                }
            }
          
            [MYSelf.tableView1 reloadData];
        }
        else  if ([jsonDict[@"res"] isEqualToString:@"1002"])
        {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"登录状态已过期, 请重新登录" message:nil preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *anotherAction = [UIAlertAction actionWithTitle:@"登录" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
                //让用户重新登录
                [ZXUD setObject:nil forKey:@"ident_code"];
                ZX_Login_ViewController *VC = [[ZX_Login_ViewController alloc] init];
                UINavigationController *navi = [[UINavigationController alloc]initWithRootViewController:VC];
                [self presentViewController:navi animated:YES completion:nil];
            }];
            [alert addAction:anotherAction];
            [MYSelf presentViewController:alert animated:YES completion:^{
                
            }];
        }
        else if ([jsonDict[@"res"] isEqualToString:@"1005"] || [jsonDict[@"res"] isEqualToString:@"1004"])
        {
            
        }
        else
        {
            [MBProgressHUD showError:jsonDict[@"msg"]];
        }
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [_animationView removeFromSuperview];
        });
        
    } failed:^(NSURLSessionTask *task, NSError *error)
    {
        [_animationView removeFromSuperview];
        [MBProgressHUD showError:@"网络错误"];
    }];
}
- (void)getCoachListData2
{
    if (_dataSource2.count == 0)
    {
        _animationView=[[ZXAnimationView alloc]initWithFrame:CGRectMake(0, 120, KScreenWidth, KScreenHeight-120)];
        [self.view addSubview:_animationView];
    }
    __weak typeof(self) MYSelf = self;
    [[ZXNetDataManager manager]JiaoLianListWithTimeStamp:[ZXDriveGOHelper getCurrentTimeStamp] andSubject:self.subject andPage:[NSString stringWithFormat:@"%d", self.page2] andSort:@"score" andName:@"" andSid:_sid andCity:_cityName success:^(NSURLSessionDataTask *task, id responseObject)
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
         if(err)
         {
             NSLog(@"json解析失败：%@",err);
         }
         //停止刷新
         [self.tableView2.mj_header endRefreshing];
         [self.tableView2.mj_footer endRefreshing];
         if ([jsonDict[@"res"] isEqualToString:@"1001"])
         {
             if ([jsonDict[@"teacher_list"] isKindOfClass:[NSArray class]])
             {
                 //判断刷新第一页时先将数据源置空
                 if (self.page2 == 0)
                 {
                     [self.dataSource2 removeAllObjects];
                 }
                 for (NSDictionary *dic in jsonDict[@"teacher_list"])
                 {
                     [self.dataSource2 addObject:dic];
                 }
             }
             
             [MYSelf.tableView2 reloadData];
             
         }
         else  if ([jsonDict[@"res"] isEqualToString:@"1002"])
         {
             UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"登录状态已过期, 请重新登录" message:nil preferredStyle:UIAlertControllerStyleAlert];
             
             UIAlertAction *anotherAction = [UIAlertAction actionWithTitle:@"登录" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action)
             {
                 //让用户重新登录
                 [ZXUD setObject:nil forKey:@"ident_code"];
                 ZX_Login_ViewController *VC = [[ZX_Login_ViewController alloc] init];
                 UINavigationController *navi = [[UINavigationController alloc]initWithRootViewController:VC];
                 [self presentViewController:navi animated:YES completion:nil];
             }];
             [alert addAction:anotherAction];
             [MYSelf presentViewController:alert animated:YES completion:^{
                 
             }];
         }
         else if ([jsonDict[@"res"] isEqualToString:@"1005"] || [jsonDict[@"res"] isEqualToString:@"1004"])
         {
             
         }
         else
         {
             [MBProgressHUD showError:jsonDict[@"msg"]];
         }
         
         dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
             [_animationView removeFromSuperview];
         });
         
     } failed:^(NSURLSessionTask *task, NSError *error)
    {
        [_animationView removeFromSuperview];
         [MBProgressHUD showError:@"网络错误"];
     }];
}

- (void)getCoachListData3
{
    if (_dataSource3.count == 0)
    {
        _animationView=[[ZXAnimationView alloc]initWithFrame:CGRectMake(0, 120, KScreenWidth, KScreenHeight-120)];
        [self.view addSubview:_animationView];
    }
    __weak typeof(self) MYSelf = self;
    [[ZXNetDataManager manager]JiaoLianListWithTimeStamp:[ZXDriveGOHelper getCurrentTimeStamp] andSubject:self.subject andPage:[NSString stringWithFormat:@"%d", self.page3] andSort:@"teach_age" andName:@"" andSid:_sid andCity:_cityName success:^(NSURLSessionDataTask *task, id responseObject)
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
         if(err)
         {
             NSLog(@"json解析失败：%@",err);
         }
         //停止刷新
         [self.tableView3.mj_header endRefreshing];
         [self.tableView3.mj_footer endRefreshing];
         if ([jsonDict[@"res"] isEqualToString:@"1001"])
         {
             if ([jsonDict[@"teacher_list"] isKindOfClass:[NSArray class]])
             {
                 //判断刷新第一页时先将数据源置空
                 if (self.page3 == 0)
                 {
                     [self.dataSource3 removeAllObjects];
                 }
                 for (NSDictionary *dic in jsonDict[@"teacher_list"])
                 {
                     [self.dataSource3 addObject:dic];
                 }
             }
             
             [MYSelf.tableView3 reloadData];
             
         }
         else  if ([jsonDict[@"res"] isEqualToString:@"1002"])
         {
             UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"登录状态已过期, 请重新登录" message:nil preferredStyle:UIAlertControllerStyleAlert];
             
             UIAlertAction *anotherAction = [UIAlertAction actionWithTitle:@"登录" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action)
             {
                 //让用户重新登录
                 [ZXUD setObject:nil forKey:@"ident_code"];
                 ZX_Login_ViewController *VC = [[ZX_Login_ViewController alloc] init];
                 UINavigationController *navi = [[UINavigationController alloc]initWithRootViewController:VC];
                 [self presentViewController:navi animated:YES completion:nil];
             }];
             [alert addAction:anotherAction];
             [MYSelf presentViewController:alert animated:YES completion:^{
                 
             }];
         }
         else if ([jsonDict[@"res"] isEqualToString:@"1005"] || [jsonDict[@"res"] isEqualToString:@"1004"])
         {
             
         }
         else
         {
             [MBProgressHUD showError:jsonDict[@"msg"]];
         }
         
         dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
             [_animationView removeFromSuperview];
         });
         
     } failed:^(NSURLSessionTask *task, NSError *error)
     {
         [_animationView removeFromSuperview];
         [MBProgressHUD showError:@"网络错误"];
     }];
}

- (void)getCoachListData4
{
    if (_dataSource4.count == 0)
    {
        _animationView=[[ZXAnimationView alloc]initWithFrame:CGRectMake(0, 120, KScreenWidth, KScreenHeight-120)];
        [self.view addSubview:_animationView];
    }
    __weak typeof(self) MYSelf = self;
    [[ZXNetDataManager manager]JiaoLianListWithTimeStamp:[ZXDriveGOHelper getCurrentTimeStamp] andSubject:self.subject andPage:[NSString stringWithFormat:@"%d", self.page4] andSort:@"avg_days" andName:@"" andSid:_sid andCity:_cityName success:^(NSURLSessionDataTask *task, id responseObject)
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
         if(err)
         {
             NSLog(@"json解析失败：%@",err);
         }
         //停止刷新
         [self.tableView4.mj_header endRefreshing];
         [self.tableView4.mj_footer endRefreshing];
         if ([jsonDict[@"res"] isEqualToString:@"1001"])
         {
             if ([jsonDict[@"teacher_list"] isKindOfClass:[NSArray class]])
             {
                 //判断刷新第一页时先将数据源置空
                 if (self.page4 == 0)
                 {
                     [self.dataSource4 removeAllObjects];
                 }
                 for (NSDictionary *dic in jsonDict[@"teacher_list"])
                 {
                     [self.dataSource4 addObject:dic];
                 }
             }
             
             [MYSelf.tableView4 reloadData];
             
         }
         else  if ([jsonDict[@"res"] isEqualToString:@"1002"])
         {
             UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"登录状态已过期, 请重新登录" message:nil preferredStyle:UIAlertControllerStyleAlert];
             
             UIAlertAction *anotherAction = [UIAlertAction actionWithTitle:@"登录" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action)
             {
                 //让用户重新登录
                 [ZXUD setObject:nil forKey:@"ident_code"];
                 ZX_Login_ViewController *VC = [[ZX_Login_ViewController alloc] init];
                 UINavigationController *navi = [[UINavigationController alloc]initWithRootViewController:VC];
                 [self presentViewController:navi animated:YES completion:nil];
             }];
             [alert addAction:anotherAction];
             [MYSelf presentViewController:alert animated:YES completion:^{
                 
             }];
         }
         else if ([jsonDict[@"res"] isEqualToString:@"1005"] || [jsonDict[@"res"] isEqualToString:@"1004"])
         {
             
         }
         else
         {
             [MBProgressHUD showError:jsonDict[@"msg"]];
         }
         
         dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
             [_animationView removeFromSuperview];
         });
         
     } failed:^(NSURLSessionTask *task, NSError *error)
    {
        [_animationView removeFromSuperview];
        [MBProgressHUD showError:@"网络错误"];
     }];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == self.tableView1)
    {
        return self.dataSource1.count;
    }
    else if (tableView == self.tableView2)
    {
        return self.dataSource2.count;
    }
    else if (tableView == self.tableView3)
    {
        return self.dataSource3.count;
    }
    else
    {
        return self.dataSource4.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CoachListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CoachListTableViewCellID" forIndexPath:indexPath];
    cell.imageV.layer.cornerRadius = 35;
    cell.imageV.layer.masksToBounds = YES;
    cell.imageV.layer.borderColor = [KRGB(109, 156, 183, 1) CGColor];
    cell.imageV.layer.borderWidth = 1;
    if (tableView == self.tableView1)
    {
        NSDictionary *Dic = self.dataSource1[indexPath.row];
         [cell setModel:Dic];
    }
    else if (tableView == self.tableView2)
    {
        NSDictionary *Dic = self.dataSource2[indexPath.row];
         [cell setModel:Dic];
    }
    else if (tableView == self.tableView3)
    {
        NSDictionary *Dic = self.dataSource3[indexPath.row];
         [cell setModel:Dic];
    }
    else
    {
        NSDictionary *Dic = self.dataSource4[indexPath.row];
         [cell setModel:Dic];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ZXCoachDetailVC *coachVC = [[ZXCoachDetailVC alloc]init];
    if ([_sid isEqualToString:[ZXUD objectForKey:@"S_ID"]])
    {
        coachVC.benxiao=YES;
    }
    else
    {
        coachVC.benxiao=NO;
    }
    
    if ([_subject isEqualToString:@"3"])
    {
        coachVC.kesan=YES;
    }
    else
    {
        coachVC.kesan=NO;
    }
    if (tableView == self.tableView1)
    {
        NSDictionary *Dic = self.dataSource1[indexPath.row];
        if ([Dic[@"school_name"] isEqualToString:[ZXUD objectForKey:@"S_NAME"]])
        {
            coachVC.benxiao=YES;
        }
        else
        {
            coachVC.benxiao=NO;
        }
        coachVC.tid = Dic[@"id"];
        coachVC.name = Dic[@"name"];
    }
    else if (tableView == self.tableView2)
    {
        NSDictionary *Dic = self.dataSource2[indexPath.row];
        coachVC.tid = Dic[@"id"];
        coachVC.name = Dic[@"name"];
        if ([Dic[@"school_name"] isEqualToString:[ZXUD objectForKey:@"S_NAME"]])
        {
            coachVC.benxiao=YES;
        }
        else
        {
            coachVC.benxiao=NO;
        }
    }
    else if (tableView == self.tableView3)
    {
        NSDictionary *Dic = self.dataSource3[indexPath.row];
        coachVC.tid = Dic[@"id"];
        coachVC.name = Dic[@"name"];
        if ([Dic[@"school_name"] isEqualToString:[ZXUD objectForKey:@"S_NAME"]])
        {
            coachVC.benxiao=YES;
        }
        else
        {
            coachVC.benxiao=NO;
        }
    }
    else
    {
        NSDictionary *Dic = self.dataSource4[indexPath.row];
        coachVC.tid = Dic[@"id"];
        coachVC.name = Dic[@"name"];
        if ([Dic[@"school_name"] isEqualToString:[ZXUD objectForKey:@"S_NAME"]])
        {
            coachVC.benxiao=YES;
        }
        else
        {
            coachVC.benxiao=NO;
        }
    }
    [self.navigationController pushViewController:coachVC animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


@end

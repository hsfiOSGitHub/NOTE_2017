//
//  ZX_MyClass_ViewController.m
//  友照
//
//  Created by cleloyang on 2016/12/1.
//  Copyright © 2016年 ZX_XPH. All rights reserved.
//

#import "ZX_MyClass_ViewController.h"
#import "ZXFunctionBtnsView.h"
#import "ZXTableViewCell.h"
#import "ZXKongKaQuanView.h"
#import "ZXEvaluateOrderListVC.h"

@interface ZX_MyClass_ViewController ()<UITableViewDataSource, UITableViewDelegate>

@property(nonatomic, strong) UITableView *myClassTabV;
@property(nonatomic, strong) NSMutableArray *myClassArr;
@property (nonatomic) ZXFunctionBtnsView *btnsView;
@property (nonatomic ,assign) NSInteger page;
@property(nonatomic)BOOL isRefresh;//判断是否加载动画
@property(nonatomic,strong)NSString* type;
@property (nonatomic, assign) NSInteger numOfPage;
@property(nonatomic)BOOL isYuYueJiLu;
@property(nonatomic,strong) NSDictionary *model;
@property (nonatomic ,assign) NSInteger btnTag;
@property (nonatomic, strong) ZXKongKaQuanView *KongKaQuanView;

@end

@implementation ZX_MyClass_ViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (!_isYuYueJiLu)
    {
        _page = 0;
        _numOfPage = 0;
        _type = @"book";
        [self getMyClassData];
    }
    else
    {
        _page = 0;
        _numOfPage = 0;
        _type = @"study";
        [self getMyClassData];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"我的课程";
    [self createFunctionBtns];
    [self creatMyClassTabV];

}

//懒加载空卡券视图
-(ZXKongKaQuanView *)KongKaQuanView
{
    if (!_KongKaQuanView)
    {
        _KongKaQuanView = [[ZXKongKaQuanView alloc]initWithFrame:_myClassTabV.frame];
        _KongKaQuanView.label.text = @"暂无课程记录";
    }
    return _KongKaQuanView;
}

- (void)createFunctionBtns
{
    NSArray *functionNames = @[@"预约记录",@"学习记录",@"取消记录"];
    _btnsView = [[ZXFunctionBtnsView alloc] initWithButtonNames:functionNames andStartPoint:CGPointMake(0, 64) andSpace:1 andBtnHeight:ZXFUNCTION_BTN_HEIGHT andXiaHuaXiaImage:[UIImage imageNamed:@"btn_denglu"]];
    for (UIButton *btn in _btnsView.buttonArray)
    {
        [btn addTarget:self action:@selector(functionBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    [_btnsView btnsPasteSuperView:self.view];
    _btnsView.cutHeight = ZXFUNCTION_SPAD_CUT_HEIGHT;
}

- (void)creatMyClassTabV
{
    if (_myClassTabV == nil)
    {
        _myClassTabV = [[UITableView alloc] initWithFrame:CGRectMake(0, KTableView_Y, KScreenWidth, KScreenHeight - KTableView_Y)];
        _myClassTabV.delegate = self;
        _myClassTabV.dataSource = self;
        [self.view addSubview:_myClassTabV];
        _myClassTabV.separatorStyle = UITableViewCellSeparatorStyleNone;
        _myClassTabV.showsVerticalScrollIndicator = NO;
        [_myClassTabV registerNib:[UINib nibWithNibName:@"ZXTableViewCell" bundle:nil] forCellReuseIdentifier:@"cellID"];
        //添加下拉刷新视图
        _myClassTabV.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            _page = 0;
            [_myClassArr removeAllObjects];
            _isRefresh = YES;
            [self getMyClassData];
        }];
        //
        _myClassTabV.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            _page++;
            _isRefresh = YES;
            [self getMyClassData];
        }];
        //在tableview添加手势
        UISwipeGestureRecognizer *leftSwipGes = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(rightSwipEvent:)];
        leftSwipGes.direction = UISwipeGestureRecognizerDirectionRight;
        [_myClassTabV addGestureRecognizer:leftSwipGes];
        
        UISwipeGestureRecognizer *rightSwipGes = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(leftSwipEvent:)];
        leftSwipGes.direction = UISwipeGestureRecognizerDirectionLeft;
        [_myClassTabV addGestureRecognizer:rightSwipGes];
        [self.view addSubview:_myClassTabV];
    }
}

//切换按钮点击事件
- (void)functionBtnClick:(UIButton *)btn
{
    _page = 0;
    [_animationView removeFromSuperview];
    //配置数据源
    [_btnsView buttonSelected:btn.tag - 1000];
    _numOfPage = btn.tag;
    [_myClassArr removeAllObjects];
    switch (btn.tag)
    {
        case 1000:
        {
            //预约记录
            _type = @"book";
        }
            break;
        case 1001:
        {
            //学习记录
            _type = @"study";
            _isYuYueJiLu = NO;
        }
            break;
        default:
        {
            //取消预约
            _type = @"cancel";
        }
            break;
    }
    [self getMyClassData];
}

- (void)leftSwipEvent:(UISwipeGestureRecognizer *)swip
{
    [_animationView removeFromSuperview];
    if( --_numOfPage < 0)
    {
        _numOfPage = 0;
    }
    [_btnsView buttonSelected:_numOfPage];
    [self slideGetData];
}
- (void)rightSwipEvent:(UISwipeGestureRecognizer *)swip
{
    [_animationView removeFromSuperview];
    if( ++_numOfPage > 2)
    {
        _numOfPage = 2;
    }
    [_btnsView buttonSelected:_numOfPage];
    [self slideGetData];
}
//滑动切换页面时的数据刷新
- (void)slideGetData
{
    _page = 0;
    [_myClassArr removeAllObjects];
    if (_numOfPage == 0)
    {
        _type = @"book";
    }
    else if (_numOfPage == 1)
    {
        _type = @"study";
        _isYuYueJiLu = NO;
    }
    else if (_numOfPage == 2)
    {
        _type = @"cancel";
    }
    [self getMyClassData];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (_myClassArr && _myClassArr.count == 0)
    {
        [self KongKaQuanView];
        [self.view insertSubview:_KongKaQuanView belowSubview:_animationView];
    }
    else
    {
        return _myClassArr.count;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 72;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ZXTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellID" forIndexPath:indexPath];
    UIView *spadView = [[UIView alloc] initWithFrame:CGRectMake(0, cell.bounds.size.height - 1, KScreenWidth, 1)];
    spadView.backgroundColor = ZX_BG_COLOR;
    [cell.contentView addSubview:spadView];
    //配置cell
    _model = _myClassArr[indexPath.row];
    [cell setCellWith:_model andDataType:_type];
    if ([_type isEqualToString:@"book"])
    {
        cell.buttonInfo.userInteractionEnabled=YES;
        [cell.buttonInfo setTitle:@"取消预约" forState:UIControlStateNormal];
        [cell.buttonInfo setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [cell.buttonInfo setBackgroundColor:[UIColor colorWithRed:108/255.0 green:169/255.0 blue:255/255.0 alpha:1]];
        cell.buttonInfo.layer.cornerRadius = 8;
        [cell.buttonInfo removeTarget:self action:@selector(goToDelete:) forControlEvents:UIControlEventTouchDown];
        [cell.buttonInfo addTarget:self action:@selector(goToCancel:) forControlEvents:UIControlEventTouchDown];
        cell.buttonInfo.tag = [_model[@"id"] integerValue];
    }
    else if ([_type isEqualToString:@"study"])
    {
        [cell.buttonInfo setTitle:@"" forState:UIControlStateNormal];
        [cell.buttonInfo setBackgroundColor:[UIColor clearColor]];
         cell.buttonInfo.userInteractionEnabled=NO;
//        cell.buttonInfo.userInteractionEnabled=YES;
//        [cell.buttonInfo setTitle:@"去评分" forState:UIControlStateNormal];
//        [cell.buttonInfo setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//        [cell.buttonInfo setBackgroundColor:[UIColor orangeColor]];
//        cell.buttonInfo.layer.cornerRadius = 8;
//        [cell.buttonInfo removeTarget:self action:@selector(goToCancel:) forControlEvents:UIControlEventTouchDown];
//        [cell.buttonInfo removeTarget:self action:@selector(goToDelete:) forControlEvents:UIControlEventTouchDown];
//        [cell.buttonInfo addTarget:self action:@selector(goToPingFen:) forControlEvents:UIControlEventTouchDown];
//        cell.buttonInfo.tag = indexPath.row;
//        [cell setUpButtonState:_model];
    }
    else
    {
        cell.buttonInfo.userInteractionEnabled=YES;
        
        [cell.buttonInfo setTitle:@"删除" forState:UIControlStateNormal];
        [cell.buttonInfo setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [cell.buttonInfo setBackgroundColor:[UIColor colorWithRed:108/255.0 green:169/255.0 blue:255/255.0 alpha:1]];
        cell.buttonInfo.layer.cornerRadius = 8;
        [cell.buttonInfo removeTarget:self action:@selector(goToCancel:) forControlEvents:UIControlEventTouchDown];
        [cell.buttonInfo addTarget:self action:@selector(goToDelete:) forControlEvents:UIControlEventTouchDown];
        cell.buttonInfo.tag = [_model[@"id"] integerValue];
    }
    cell.selectionStyle = NO;
    return cell;
}


//点击取消预约
- (void)goToCancel:(UIButton *)btn
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"您确定要取消预约吗" message:nil preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *alertAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action)
    {
        _btnTag = btn.tag;
        _isRefresh = YES;
        [self cancelMyClassData];
    }];
    
    UIAlertAction *anotherAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action)
    {
    }];
    [alert addAction:alertAction];
    [alert addAction:anotherAction];
    [self presentViewController:alert animated:YES completion:^{
    }];
}

//点击删除
- (void)goToDelete:(UIButton *)btn
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"您确定要删除吗" message:nil preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *alertAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action)
    {
        _btnTag = btn.tag;
        _isRefresh = YES;
        [self deleteMyClassData];
    }];
    
    UIAlertAction *anotherAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action)
    {
    }];
    [alert addAction:alertAction];
    [alert addAction:anotherAction];
    [self presentViewController:alert animated:YES completion:^{
    }];
}

//获取我的课程数据
- (void)getMyClassData
{
    if (!_isRefresh)
    {
        _animationView=[[ZXAnimationView alloc]initWithFrame:CGRectMake(0, 115, KScreenWidth, KScreenHeight-115)];
        [self.view addSubview:_animationView];
    }
    
    _myClassTabV.scrollEnabled = NO; //设置tableview 不能滚动
    
    [[ZXNetDataManager manager] MyClassDataWithRndString:[ZXDriveGOHelper getCurrentTimeStamp] andIdent_code:[ZXUD objectForKey:@"ident_code"] andType:_type andPage:[NSString stringWithFormat:@"%ld",(long)_page] success:^(NSURLSessionDataTask *task, id responseObject)
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
         if([[ZXwangLuoDanLi WangLuoDanLi] resIsTrue:jsonDict andAlertView:self])
         {
             if ([jsonDict[@"list"] isKindOfClass:[NSArray class]])
             {
                 [_KongKaQuanView removeFromSuperview];
                 
                 if (!_myClassArr)
                 {
                     _myClassArr = [NSMutableArray arrayWithArray:jsonDict[@"list"]];
                 }
                 else
                 {
                     [_myClassArr addObjectsFromArray:jsonDict[@"list"]];
                 }
             }
             
             _myClassTabV.scrollEnabled =YES;
             [_myClassTabV reloadData];
             _isRefresh = NO;
         }
         
        [_animationView removeFromSuperview];
        [_myClassTabV.mj_header endRefreshing];
        [_myClassTabV.mj_footer endRefreshing];
         
     } failed:^(NSURLSessionTask *task, NSError *error)
    {
        [_animationView removeFromSuperview];
         _myClassTabV.scrollEnabled =YES;
         [_myClassTabV.mj_header endRefreshing];
         [_myClassTabV.mj_footer endRefreshing];
     }];
}

//取消预约课程
- (void)cancelMyClassData
{
    [[ZXNetDataManager manager] cancelMyClassDataWithRndstring:[ZXDriveGOHelper getCurrentTimeStamp] andIdent_code:[ZXUD objectForKey:@"ident_code"] andBcid:[NSString stringWithFormat:@"%ld",(long)_btnTag] success:^(NSURLSessionDataTask *task, id responseObject)
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
        
        [MBProgressHUD showSuccess:jsonDict[@"msg"]];
        //刷新数据
        [_myClassArr removeAllObjects];
        [self getMyClassData];
        
    } failed:^(NSURLSessionTask *task, NSError *error)
    {
        [MBProgressHUD showSuccess:@"网络不好，请稍后重试。"];
        
    }];
}

//删除我的课程
- (void)deleteMyClassData
{
    [[ZXNetDataManager manager] deleteMyClassDataWithRndstring:[ZXDriveGOHelper getCurrentTimeStamp] andIdent_code:[ZXUD objectForKey:@"ident_code"] andBcid:[NSString stringWithFormat:@"%ld",(long)_btnTag] success:^(NSURLSessionDataTask *task, id responseObject)
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
        [MBProgressHUD showSuccess:jsonDict[@"msg"]];
        
        //刷新数据
        [_myClassArr removeAllObjects];
        [self getMyClassData];
        
    } failed:^(NSURLSessionTask *task, NSError *error)
     {
        [MBProgressHUD showSuccess:@"网络不好，请稍后重试。"];
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

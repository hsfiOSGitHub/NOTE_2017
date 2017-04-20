//
//  ZX_DingDanDetail_ViewController.m
//  友照
//
//  Created by cleloyang on 2016/11/28.
//  Copyright © 2016年 ZX_XPH. All rights reserved.
//

#import "ZX_DingDanDetail_ViewController.h"
#import "ZX_ke_er_ka_juan_ding_dan_xiang_qing_TableViewCell.h"
#import "ZX_YuYueMoNi_ViewController.h"
#import "ZX_GouMaiMoNiKa_ViewController.h"
#import "UIImage+LXDCreateBarcode.h"
#import "ZX_OrderList_ViewController.h"

@interface ZX_DingDanDetail_ViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic)UITableView *dingDanDetailTabV;
@property(nonatomic,strong)UILabel* lab1;
@property(nonatomic,strong)UILabel* lab2;
@property (nonatomic,strong) NSDictionary *orderListDic;
//二维码
@property (nonatomic, strong) UIImageView *erWeiMaImage;

@end

@implementation ZX_DingDanDetail_ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"fanhui"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStyleDone target:self action:@selector(goToBack)];
    self.title=@"订单详情";
    //创建tabView
    [self creatDingDanDetailTabV];
    //获取订单数据
    [self getDingDanDetailData];
}

- (void)goToBack
{
    for (UIViewController* VC in self.navigationController.viewControllers)
    {
        if ([VC isKindOfClass:[ZX_GouMaiMoNiKa_ViewController class]])
        {
            [self.navigationController popToViewController:VC animated:YES];
        }
        else if ([VC isKindOfClass:[ZX_OrderList_ViewController class]])
        {
            [self.navigationController popToViewController:VC animated:YES];
        }
    }
}

//创建订单详情tableview
- (void)creatDingDanDetailTabV
{
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.view.backgroundColor = [UIColor whiteColor];
    UIImageView* imagevie = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 45, 45)];
    imagevie.image = [UIImage imageNamed:@"买模拟卡"];
    [self.view addSubview:imagevie];
    _lab1 = [[UILabel alloc]initWithFrame:CGRectMake(65, 10, KScreenWidth-75, 21)];
    _lab1.textColor = ZX_DarkGray_Color;
    [self.view addSubview:_lab1];
    _lab2 = [[UILabel alloc]initWithFrame:CGRectMake(65, 35, KScreenWidth-75, 21)];
    _lab2.textColor = ZX_DarkGray_Color;
    [self.view addSubview:_lab2];
    _dingDanDetailTabV = [[UITableView alloc] initWithFrame:CGRectMake(0, 65, KScreenWidth, KScreenHeight-350)];
    [self.view addSubview:_dingDanDetailTabV];
    _dingDanDetailTabV.delegate = self;
    _dingDanDetailTabV.dataSource = self;
    _dingDanDetailTabV.showsVerticalScrollIndicator = NO;
    _erWeiMaImage = [[UIImageView alloc]initWithFrame:CGRectMake(KScreenWidth/2-75, KScreenHeight-275, 150, 150)];
    [self.view addSubview:_erWeiMaImage];
    
    if (!_isUse)
    {
        _btn=[[UIButton alloc]initWithFrame:CGRectMake(0, KScreenHeight-110, KScreenWidth, 50)];
        [_btn setTitle:@"去排队" forState:UIControlStateNormal];
        [_btn setTitleColor:[UIColor whiteColor] forState:0];
        [_btn addTarget:self action:@selector(goPaiDui) forControlEvents:UIControlEventTouchDown];
        _btn.backgroundColor = dao_hang_lan_Color;
        [self.view addSubview:_btn];
    }
    
    //注册cell
    [_dingDanDetailTabV registerNib:[UINib nibWithNibName:@"ZX_ke_er_ka_juan_ding_dan_xiang_qing_TableViewCell" bundle:nil] forCellReuseIdentifier:@"ZXTableViewCell4"];
}

//返回的组数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

//返回的行数
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([_orderListDic[@"coupons"] isKindOfClass:[NSArray class]])
    {
        return ((NSArray*)_orderListDic[@"coupons"]).count;
    }
    else
    {
        return 0;
    }
}

//返回的行高
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}

//每行的内容
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    ZX_ke_er_ka_juan_ding_dan_xiang_qing_TableViewCell *cell = [_dingDanDetailTabV dequeueReusableCellWithIdentifier:@"ZXTableViewCell4" forIndexPath:indexPath];
    //订单的券码号
    cell.mingcheng.text = [NSString stringWithFormat:@"模拟卡号: %@",_orderListDic[@"coupons"][indexPath.row][@"code"]] ;
    cell.kajuan.textColor = [UIColor redColor];
    //订单状态，是否使用
    if ([_orderListDic[@"coupons"][indexPath.row][@"status"] isEqualToString:@"0"])
    {
        cell.kajuan.text = @"未使用";
        cell.kajuan.textColor = ZX_DarkGray_Color;
    }
    else
    {
        cell.kajuan.text = @"已使用";
    }
    return cell;
}

//cell的点击事件
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    _erWeiMaImage.image = [UIImage imageOfQRFromURL:_orderListDic[@"coupons"][indexPath.row][@"code"]];
}

//跳转到预约模拟选择考场
- (void)goPaiDui
{
    ZX_YuYueMoNi_ViewController *yuYueMoNiVC = [[ZX_YuYueMoNi_ViewController alloc]init];
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:yuYueMoNiVC animated:YES];
}

//获取订单详情数据
- (void)getDingDanDetailData
{
    //小车动画
    _animationView=[[ZXAnimationView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight)];
    [self.view addSubview:_animationView];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [_animationView removeFromSuperview];
    });
    
    [[ZXNetDataManager manager] dingDanDetailWithRndstring:[ZXDriveGOHelper getCurrentTimeStamp] andIdent_code:[ZXUD objectForKey:@"ident_code"] andOrder_id:_orderId success:^(NSURLSessionDataTask *task, id responseObject)
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
             _orderListDic = jsonDict[@"orderlist"];
             _lab1.text = _orderListDic[@"goods_name"];
             _lab2.text = [NSString stringWithFormat:@"购买日期：%@",[_orderListDic[@"order_time"] substringToIndex:10]];
             [_dingDanDetailTabV reloadData];
             _erWeiMaImage.image = [UIImage imageOfQRFromURL:_orderListDic[@"coupons"][0][@"code"]];
         }
     }failed:^(NSURLSessionTask *task, NSError *error)
     {
         [MBProgressHUD showSuccess:@"网络不好，请稍后重试。"];
     }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}



@end

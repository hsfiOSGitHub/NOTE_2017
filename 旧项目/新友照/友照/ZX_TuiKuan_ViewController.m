//
//  ZX_TuiKuan_ViewController.m
//  友照
//
//  Created by cleloyang on 2016/12/8.
//  Copyright © 2016年 ZX_XPH. All rights reserved.
//

#import "ZX_TuiKuan_ViewController.h"
#import "TuiKuanCell1.h"
#import "TuiKuanCell2.h"
#import "TuiKuanCell3.h"
#import "TuiKuanCell4.h"
#import "ZX_OrderList_ViewController.h"

@interface ZX_TuiKuan_ViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic, strong) UITableView *tuiKuanTabV;
@property(nonatomic, strong) UIButton *tuiKuanBtn;
@property (nonatomic,copy) NSString *reason;
@property(nonatomic, strong) UIButton *btn1;
@property(nonatomic, strong) UIButton *btn2;
@property(nonatomic, strong) UIButton *btn3;
@end

@implementation ZX_TuiKuan_ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"申请退款";
    [self creatTuiKuanTabV];
    
    [self creatTuiKuanBtn];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"fanhui"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStyleDone target:self action:@selector(goToBack)];
}

- (void)goToBack
{
    for (UIViewController* VC in self.navigationController.viewControllers)
    {
        if ([VC isKindOfClass:[ZX_OrderList_ViewController class]])
        {
            [self.navigationController popToViewController:VC animated:YES];
        }
    }
}

//创建退款tableView
- (void)creatTuiKuanTabV
{
    _tuiKuanTabV = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight - 50)];
    [self.view addSubview:_tuiKuanTabV];
    _tuiKuanTabV.delegate = self;
    _tuiKuanTabV.dataSource = self;
    _tuiKuanTabV.showsVerticalScrollIndicator = NO;
    _tuiKuanTabV.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_tuiKuanTabV registerNib:[UINib nibWithNibName:@"TuiKuanCell1" bundle:nil] forCellReuseIdentifier:@"cellID1"];
    [_tuiKuanTabV registerNib:[UINib nibWithNibName:@"TuiKuanCell2" bundle:nil] forCellReuseIdentifier:@"cellID2"];
    [_tuiKuanTabV registerNib:[UINib nibWithNibName:@"TuiKuanCell3" bundle:nil] forCellReuseIdentifier:@"cellID3"];
    [_tuiKuanTabV registerNib:[UINib nibWithNibName:@"TuiKuanCell4" bundle:nil] forCellReuseIdentifier:@"cellID4"];
}

//创建退款的button
- (void)creatTuiKuanBtn
{
    _tuiKuanBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, KScreenHeight - 50, KScreenWidth, 50)];
    [self.view addSubview:_tuiKuanBtn];
    [_tuiKuanBtn setTitle:@"申请退款" forState:UIControlStateNormal];
    [_tuiKuanBtn setBackgroundColor:[UIColor orangeColor]];
    [_tuiKuanBtn addTarget:self action:@selector(tuiKuanClick) forControlEvents:UIControlEventTouchDown];
}

//退款按钮点击事件
- (void)tuiKuanClick
{
    if (![_reason isKindOfClass:[NSString class]])
    {
        [MBProgressHUD showSuccess:@"您还没有选择退款原因哦"];
    }
    else
    {
        [self getTuiKuanData];
    }
}

//返回组数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 4;
}

//每组的返回行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

//根据不同的section返回不同的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        return 120;
    }
    else if (indexPath.section == 1)
    {
        return 120;
    }
    else if (indexPath.section == 2)
    {
        return 120;
    }
    else
    {
        return 240;
    }
}

//返回cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath

{
    if (indexPath.section == 0 )
    {
        TuiKuanCell1 * cell = [tableView dequeueReusableCellWithIdentifier:@"cellID1"];
        cell.selectionStyle = NO;
        //订单号
        cell.dingDanHaoLabel.text = [NSString stringWithFormat:@"%@",_orderNum];
        return cell;
    }
    else if(indexPath.section == 1)
    {
        TuiKuanCell2 * cell = [tableView dequeueReusableCellWithIdentifier:@"cellID2"];
        cell.selectionStyle = NO;
        //退款金额
        cell.tuiKuanLabel.text = [NSString stringWithFormat:@"¥ %@ 元",_Price];
        return cell;
        
    }
    else if (indexPath.section == 2)
    {
        TuiKuanCell3 * cell = [tableView dequeueReusableCellWithIdentifier:@"cellID3"];
        cell.selectionStyle = NO;
        return cell;
    }
    else
    {
        TuiKuanCell4 * cell = [tableView dequeueReusableCellWithIdentifier:@"cellID4"];
        
        cell.selectionStyle = NO;
        _btn1 = cell.Btn1;
        _btn2 = cell.Btn2;
        _btn3 = cell.Btn3;
        [cell.Btn1 addTarget:self action:@selector(reasonBtnClick:) forControlEvents:UIControlEventTouchDown];
        [cell.Btn2 addTarget:self action:@selector(reasonBtnClick:) forControlEvents:UIControlEventTouchDown];
        [cell.Btn3 addTarget:self action:@selector(reasonBtnClick:) forControlEvents:UIControlEventTouchDown];
//        if (![_reason isKindOfClass:[NSString class]])
//        {
//            _reason = @"时间调整不开";
//        }
//        else
//        {
//            _reason = cell.reason;
//        }
        return cell;
    }
}
- (NSString *)reasonBtnClick:(UIButton *)btn
{
    if (btn == _btn1)
    {
        _reason = @"预约不上";
        [_btn1 setBackgroundImage:[UIImage imageNamed:@"对"] forState:UIControlStateNormal];
        [_btn2 setBackgroundImage:[UIImage imageNamed:@" "] forState:UIControlStateNormal];
        [_btn3 setBackgroundImage:[UIImage imageNamed:@" "] forState:UIControlStateNormal];
    }
    else if (btn == _btn2)
    {
        _reason = @"买多了/买错了";
        [_btn2 setBackgroundImage:[UIImage imageNamed:@"对"] forState:UIControlStateNormal];
        [_btn3 setBackgroundImage:[UIImage imageNamed:@" "] forState:UIControlStateNormal];
        [_btn1 setBackgroundImage:[UIImage imageNamed:@" "] forState:UIControlStateNormal];
    }
    else
    {
        _reason = @"计划有变没有时间消费";
        [_btn3 setBackgroundImage:[UIImage imageNamed:@"对"] forState:UIControlStateNormal];
        [_btn1 setBackgroundImage:[UIImage imageNamed:@" "] forState:UIControlStateNormal];
        [_btn2 setBackgroundImage:[UIImage imageNamed:@" "] forState:UIControlStateNormal];
    }
    return _reason;
}

- (void)getTuiKuanData
{
    [[ZXNetDataManager manager] tuiKuanDataWithRndstring:[ZXDriveGOHelper getCurrentTimeStamp] andIdent_code:[ZXUD objectForKey:@"ident_code"] andOrder_id:_order_id andReason:_reason success:^(NSURLSessionDataTask *task, id responseObject)
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
             YZLog(@"json解析失败：%@",err);
         }
         
         if([[ZXwangLuoDanLi WangLuoDanLi] resIsTrue:jsonDict andAlertView:self])
         {
             [MBProgressHUD showSuccess:@"已提交审核"];
             //pop回控制器
             for (UIViewController *VC in self.navigationController.viewControllers)
             {
                 if ([VC isKindOfClass:[ZX_OrderList_ViewController class]])
                 {
                     [self.navigationController popToViewController:VC animated:YES];
                 }
             }
         }
     }failed:^(NSURLSessionTask *task, NSError *error)
     {
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

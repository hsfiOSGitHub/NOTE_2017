//
//  ZX_WoDeKaQuan_ViewController.m
//  友照
//
//  Created by cleloyang on 2016/11/25.
//  Copyright © 2016年 ZX_XPH. All rights reserved.
//

#import "ZX_WoDeKaQuan_ViewController.h"
#import "WoDeKaQuanCell1.h"
#import "WoDeKaQuanCell2.h"
#import "ZX_KeErPaiDuiDetail_ViewController.h"


@interface ZX_WoDeKaQuan_ViewController ()<UITableViewDataSource, UITableViewDelegate>
//我的卡券tableView
@property (nonatomic) UITableView * WoDeKaQuanTabV;
//排队按钮
@property (nonatomic) UIButton * PaiDuiBtn;
@property (nonatomic) UIButton *paiDuiBtn;
//接收卡券的数组
@property (nonatomic, strong) NSMutableArray *woDeKaQuanArr;
//记录选了几张卡劵
@property(nonatomic,strong) NSMutableArray *selectKaQuanArr;
@property(nonatomic, copy) NSString *kaQuanShu;

@property (strong, nonatomic) UIImageView *tuPian;
@end

@implementation ZX_WoDeKaQuan_ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"我的卡券";
    [self creatWoDeKaQuanTabV];
    [self creatPaiDuiBtn];
    [self getWoDeKaQuanData];
    _selectKaQuanArr = [NSMutableArray array];
    _woDeKaQuanArr = [NSMutableArray array];
}

//创建我的卡券tableView
- (void)creatWoDeKaQuanTabV
{
    _WoDeKaQuanTabV = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight-60)];
    _WoDeKaQuanTabV.delegate = self;
    _WoDeKaQuanTabV.dataSource = self;
    _WoDeKaQuanTabV.separatorStyle = UITableViewCellSeparatorStyleNone;
    _WoDeKaQuanTabV.showsVerticalScrollIndicator = NO;
    _WoDeKaQuanTabV.backgroundColor = ZX_BG_COLOR;
    //下拉刷新数据
//    _WoDeKaQuanTabV.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
//        [self shuaxinsuoyoushuju];
//        [_kajuan removeAllObjects];
//    }];
    [self.view addSubview:_WoDeKaQuanTabV];
    
    [_WoDeKaQuanTabV registerNib:[UINib nibWithNibName:@"WoDeKaQuanCell1" bundle:nil] forCellReuseIdentifier:@"WoDeKaQuanCell1"];
    [_WoDeKaQuanTabV registerNib:[UINib nibWithNibName:@"WoDeKaQuanCell2" bundle:nil] forCellReuseIdentifier:@"WoDeKaQuanCell2"];
}

//创建立即排队的按钮
- (void)creatPaiDuiBtn
{
    _paiDuiBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, KScreenHeight - 60, KScreenWidth, 60)];
    [self.view addSubview:_paiDuiBtn];
    [_paiDuiBtn setTitle:@"立即排队" forState:UIControlStateNormal];
    [_paiDuiBtn addTarget:self action:@selector(goToPaiDui) forControlEvents:UIControlEventTouchDown];
    //橘色的RGB的值
    [_paiDuiBtn setBackgroundColor:[UIColor orangeColor]];
}

//返回的组数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

//每组的返回行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _woDeKaQuanArr.count+1;
}

//根据不同的section返回不同的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row==0)
    {
        return 49;
    }
    else
    {
        return 150;
    }
}

//返回cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row != 0 )
    {
        //第二种情况
        WoDeKaQuanCell2 *cell = [tableView dequeueReusableCellWithIdentifier:@"WoDeKaQuanCell2"];
        if ([_woDeKaQuanArr isKindOfClass:[NSArray class]])
        {
            cell.selectionStyle = NO;
            cell.btn.tag = indexPath.row;
            _tuPian = cell.tuPian;
            cell.kaoChang.text = _woDeKaQuanArr[indexPath.row-1][@"ername"];
            cell.riQi.text = _woDeKaQuanArr[indexPath.row-1][@"lasttime"];
            cell.haoMa.text = [NSString stringWithFormat:@"卡号: %@ %@ %@ %@",[ _woDeKaQuanArr[indexPath.row-1][@"code"] substringWithRange:NSMakeRange(0, 4)],[ _woDeKaQuanArr[indexPath.row-1][@"code"] substringWithRange:NSMakeRange(4, 4)],[ _woDeKaQuanArr[indexPath.row-1][@"code"] substringWithRange:NSMakeRange(8, 4)],[_woDeKaQuanArr[indexPath.row-1][@"code"] substringWithRange:NSMakeRange(12, [_woDeKaQuanArr[indexPath.row-1][@"code"] length]-12)]];
            //上左下右
            [cell.btn setImageEdgeInsets:UIEdgeInsetsMake(-71.5,KScreenWidth-95,0 ,0)];
            [cell.btn addTarget:self action:@selector(kaQuanDuoXuan:) forControlEvents:UIControlEventTouchDown];
        }
        [cell.btn setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
        if(_selectKaQuanArr.count > 0)
        {
            for (int i = 0; i < _selectKaQuanArr.count; i ++)
            {
                if ([_selectKaQuanArr[i][@"code"] isEqualToString:_woDeKaQuanArr[indexPath.row-1][@"code"]])
                {
                    [cell.btn setImage:[UIImage imageNamed:@"选中"] forState:UIControlStateNormal];
                }
            }
        }
        return cell;
    }
    else
    {
        WoDeKaQuanCell1 * cell = [tableView dequeueReusableCellWithIdentifier:@"WoDeKaQuanCell1"];
        cell.selectionStyle = NO;
        UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(0, cell.frame.size.height - 2, KScreenWidth, 2)];
        label.backgroundColor = ZX_BG_COLOR;
        [cell addSubview:label];
        return cell;
    }
}

//卡券多选方法
-(void)kaQuanDuoXuan:(UIButton*)btn
{
    if (![[btn currentImage] isEqual:[UIImage imageNamed:@"选中"]])
    {
        [btn setImage:[UIImage imageNamed:@"选中"] forState:UIControlStateNormal];
        [_selectKaQuanArr addObject:_woDeKaQuanArr[btn.tag-1]];
    }
    else
    {
        [btn setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
        [_selectKaQuanArr removeObject:_woDeKaQuanArr[btn.tag-1]];
    }
}

//cell点击事件
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
}

//立即排队事件，跳转到我的排队页面
-(void)goToPaiDui
{
    if (_selectKaQuanArr.count <= 4)
    {
        //计算用了几张模拟卡
        _kaQuanShu = @"";
        for (int i = 0; i < _selectKaQuanArr.count; i ++)
        {
            if (i == 0)
            {
                _kaQuanShu = [NSString stringWithFormat:@"%@",_selectKaQuanArr[i][@"code"]];
            }
            else
            {
                _kaQuanShu = [NSString stringWithFormat:@"%@,%@",_kaQuanShu,_selectKaQuanArr[i][@"code"]];
            }
        }
        //弹出提示
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"温馨提示" message:[NSString stringWithFormat:@"您选了 %lu 张模拟卡，可以模拟 %lu 圈，上车时间：%@,是否确认排队？",(unsigned long)_selectKaQuanArr.count,(unsigned long)_selectKaQuanArr.count,[NSString stringWithFormat:@"%@ %@",_riQi,_goTime]] preferredStyle:UIAlertControllerStyleAlert];
        
        //创建action
        UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action)
                                  {
                                      if (_selectKaQuanArr.count == 0)
                                      {
                                          [MBProgressHUD showSuccess:@"请先选择要使用的模拟卡"];
                                      }
                                      else
                                      {
                                          //先排队，排队成功再去跳转到排队详情
                                          [self getKeErKaQaunPaiDuiData];
                                      }
                                  }];
        UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
            
        }];
        //添加action
        [alertController addAction:action1];
        [alertController addAction:action2];
        //显示弹出视图
        [self presentViewController:alertController animated:YES completion:nil];
    }
    else
    {
        //弹出提示
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"一次选择的卡劵不能超过四张，请重新选择。" preferredStyle:UIAlertControllerStyleAlert];
        //创建action
        UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action)
                                  {
                                      
                                  }];
        UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
            
        }];
        //添加action
        [alertController addAction:action1];
        [alertController addAction:action2];
        //显示弹出视图
        [self presentViewController:alertController animated:YES completion:nil];
    }
}

//获取我的卡券网络数据
- (void)getWoDeKaQuanData
{
    [MBProgressHUD showMessage:@"正在加载我的卡券"];
    [[ZXNetDataManager manager] myCardListDataWithRndstring:[ZXDriveGOHelper getCurrentTimeStamp] andIdent_code:[ZXUD objectForKey:@"ident_code"] andErid:_erId  success:^(NSURLSessionDataTask *task, id responseObject)
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
         [MBProgressHUD hideHUD];
         if([[ZXwangLuoDanLi WangLuoDanLi] resIsTrue:jsonDict andAlertView:self])
         {
             if ([jsonDict[@"list"] isKindOfClass:[NSArray class]])
             {
                 _woDeKaQuanArr = jsonDict[@"list"];
                 //赋值成功刷新表
                 [_WoDeKaQuanTabV reloadData];
             }
         }
     } failed:^(NSURLSessionTask *task, NSError *error)
     {
         [MBProgressHUD showSuccess:@"网络不好，请稍后重试。"];
         
     }];
}

//获取科二卡券排队数据
- (void)getKeErKaQaunPaiDuiData
{
    [MBProgressHUD showMessage:@"正在排队"];
    [[ZXNetDataManager manager] keErKaQuanPaiDuiDataWithaRndString:[ZXDriveGOHelper getCurrentTimeStamp] andIdent_code:[ZXUD objectForKey:@"ident_code"] andErid:_erId andDate:_riQi andCouids:_kaQuanShu success:^(NSURLSessionDataTask *task, id responseObject)
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
         [MBProgressHUD hideHUD];
         //排队成功
         if ([jsonDict[@"res"] isEqualToString:@"1008"])
         {
             [self getPaiDuiDetailData];
         }
         else
         {
             [MBProgressHUD showSuccess:jsonDict[@"msg"]];
         }
     }failed:^(NSURLSessionTask *task, NSError *error)
     {
     }];

}

//获取排队详情数据
- (void)getPaiDuiDetailData
{
    [[ZXNetDataManager manager]keErYuYueMoNiPaiDuiDetaiDatalWithRndString:[ZXDriveGOHelper getCurrentTimeStamp] andIdent_code:[ZXUD objectForKey:@"ident_code"] andErid:@"" andMoni_time:@"" andStid:@"" success:^(NSURLSessionDataTask *task, id responseObject)
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
         if([[ZXwangLuoDanLi WangLuoDanLi] resIsTrue:jsonDict andAlertView:self])
         {
             
             if ([jsonDict[@"resault"] isKindOfClass:[NSArray class]] && ((NSArray*)jsonDict[@"resault"]).count>0)
             {
                 ZX_KeErPaiDuiDetail_ViewController * keErPaiDuiDetailVC = [[ZX_KeErPaiDuiDetail_ViewController alloc] init];
                 keErPaiDuiDetailVC.riQi = _riQi;
                 keErPaiDuiDetailVC.kaoChangId = _erId;
                 keErPaiDuiDetailVC.kaoChangMing = _kaoChangMing;
                 keErPaiDuiDetailVC.nianYueRi = _nianYueRi;
                 keErPaiDuiDetailVC.zhouJi = _zhouJi;
                 keErPaiDuiDetailVC.keErPaiDuiArr = jsonDict[@"resault"];
                 keErPaiDuiDetailVC.kaoChangId = jsonDict[@"datares"][@"erid"];
                 keErPaiDuiDetailVC.stid = jsonDict[@"datares"][@"stid"];
                 self.hidesBottomBarWhenPushed = YES;
                 [self.navigationController pushViewController:keErPaiDuiDetailVC animated:YES];
//                 [self shuaxinsuoyoushuju];
                 [_selectKaQuanArr removeAllObjects];
             }
         }
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

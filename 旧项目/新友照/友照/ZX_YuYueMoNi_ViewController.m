//
//  ZX_YuYueMoNi_ViewController.m
//  友照
//
//  Created by cleloyang on 2016/11/25.
//  Copyright © 2016年 ZX_XPH. All rights reserved.
//

#import "ZX_YuYueMoNi_ViewController.h"
#import "ZX_xuan_ze_kao_cahng_TableViewCell.h"
#import "ZX_GouMaiMoNiKa_ViewController.h"
#import "ZX_WoDeKaQuan_ViewController.h"
#import "ZX_KeErPaiDuiDetail_ViewController.h"

@interface ZX_YuYueMoNi_ViewController ()<UITableViewDelegate, UITableViewDataSource>
//预约模拟tabelView
@property(nonatomic, strong) UITableView *yuYueMoNiTablV;
//选择考场列表
@property(strong,nonatomic)NSMutableArray* kaoChangListArr;
@property (nonatomic, assign) NSInteger page;
@property (nonatomic) BOOL isRefresh;
@property (nonatomic) BOOL isfresh;
@property (nonatomic) BOOL isfresh1;
@end

@implementation ZX_YuYueMoNi_ViewController



- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title=@"选择考场";
    _page=0;
    [self creatyuYueMoNiTablV];
    [self yuYueMoNiKaoChangListData];
}

//创建预约模拟tabelView
- (void)creatyuYueMoNiTablV
{
    _yuYueMoNiTablV = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight)];
    _yuYueMoNiTablV.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, 20)];
    _yuYueMoNiTablV.backgroundColor = [UIColor colorWithRed:241/255.0 green:241/255.0 blue:241/255.0 alpha:1];
    _yuYueMoNiTablV.separatorStyle = UITableViewCellSeparatorStyleNone;
    _yuYueMoNiTablV.mj_header = [HSFRefreshGifHeader headerWithRefreshingBlock:^{
        
        if (!_isfresh)
        {
            _page = 0;
            _isfresh = YES;
            _isRefresh = YES;
            [self yuYueMoNiKaoChangListData];
        }
        else
        {
            [_yuYueMoNiTablV.mj_header endRefreshing];
            
        }

        
    }];
    _yuYueMoNiTablV.mj_footer = [HSFRefreshAutoGifFooter footerWithRefreshingBlock:^{
        
        if (!_isfresh1)
        {
            _page ++;
            _isfresh1 = YES;
            _isRefresh = YES;
            [self yuYueMoNiKaoChangListData];
        }
        else
        {
            [_yuYueMoNiTablV.mj_footer endRefreshing];
        }

    }];

    //设置数据源和代理
    _yuYueMoNiTablV.dataSource = self;
    _yuYueMoNiTablV.delegate = self;
    _yuYueMoNiTablV.showsVerticalScrollIndicator = NO;
    [self.view addSubview:_yuYueMoNiTablV];
    //注册cell
    [_yuYueMoNiTablV registerNib:[UINib nibWithNibName:@"ZX_xuan_ze_kao_cahng_TableViewCell" bundle:nil] forCellReuseIdentifier:@"ZX_xuan_ze_kao_cahng_TableViewCell"];

}

//返回的组数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _kaoChangListArr.count;
}

//返回的每组cell的行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    if ([[_kaoChangListArr[section]objectForKey:@"zhankai"] isEqualToString:@"1"])
    {
        return 0;
    }
    else
    {
        return ((NSArray*)_kaoChangListArr[section][@"moni"]).count;
    }
}

//每组的headerView
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, 50)];
    headerView.backgroundColor = [UIColor colorWithRed:241/255.0 green:241/255.0 blue:241/255.0 alpha:1];
    UIImageView *imageV = [[UIImageView alloc]initWithFrame:CGRectMake(10, 0, 10, 50)];
    imageV.image = [UIImage imageNamed:@"圆角矩形-1-拷贝"];
    [headerView addSubview:imageV];
    
    UIButton * btn = [[UIButton alloc]initWithFrame:CGRectMake(20, 0, KScreenWidth-30, 50)];
    btn.backgroundColor = [UIColor whiteColor];
    [btn addTarget:self action:@selector(zhanKaiDuoHang:) forControlEvents:UIControlEventTouchDown];
    UILabel* lab = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, KScreenWidth/6*3, 50)];
    lab.text = _kaoChangListArr[section][@"name"];
    lab.textColor = ZX_Black_Color;
    lab.font = [UIFont systemFontOfSize:15];
    UILabel* Lab = [[UILabel alloc] initWithFrame:CGRectMake(KScreenWidth/6*3, 0, KScreenWidth/6*2, 50)];
    Lab.textAlignment = NSTextAlignmentRight;
    Lab.font = [UIFont systemFontOfSize:13];
    Lab.text = [NSString stringWithFormat:@"%@张模拟卡可用",_kaoChangListArr[section][@"card_num"]];
    Lab.textColor = ZX_DarkGray_Color;
    if ([[_kaoChangListArr[section]objectForKey:@"zhankai"] isEqualToString:@"1"])
    {
        [btn setImage:[UIImage imageNamed:@"下箭头.png"] forState:UIControlStateNormal];
    }
    else
    {
        [btn setImage:[UIImage imageNamed:@"上箭头.png"] forState:UIControlStateNormal];
    }
    //上左下右
    [btn setImageEdgeInsets:UIEdgeInsetsMake(18, KScreenWidth-50, 18,10)];
    btn.tag = section;
    UILabel* la = [[UILabel alloc] initWithFrame:CGRectMake(0, 49, KScreenWidth-30, 1)];
    la.backgroundColor = ZX_BG_COLOR;
    [btn addSubview:la];
    [btn addSubview:lab];
    [btn addSubview:Lab];
    [headerView addSubview:btn];
    return headerView;
}

//返回组headerView的高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 50;
}
//返回footerView的高度
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1;
}

//返回的cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    ZX_xuan_ze_kao_cahng_TableViewCell * cell = [_yuYueMoNiTablV dequeueReusableCellWithIdentifier:@"ZX_xuan_ze_kao_cahng_TableViewCell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.nianyueri.text = [NSString stringWithFormat:@"%@年%2d月%2d日",[_kaoChangListArr[indexPath.section][@"moni"][indexPath.row][@"date"] substringWithRange:NSMakeRange(0, 4)],[[_kaoChangListArr[indexPath.section][@"moni"][indexPath.row][@"date"] substringWithRange:NSMakeRange(5, 2)] intValue],[[_kaoChangListArr[indexPath.section][@"moni"][indexPath.row][@"date"] substringWithRange:NSMakeRange(8, 2)] intValue]];
    cell.nianyueri.font=[UIFont systemFontOfSize:14];
    cell.zhouji.text = _kaoChangListArr[indexPath.section][@"moni"][indexPath.row][@"week"];
    cell.zhouji.font=[UIFont systemFontOfSize:14];
    cell.yuyue.text = [NSString stringWithFormat:@"已预约%@人",_kaoChangListArr[indexPath.section][@"moni"][indexPath.row][@"dataNum"]];
    cell.yuyue.font = [UIFont systemFontOfSize:14];
    return cell;
}

//展开多行
-(void)zhanKaiDuoHang:(UIButton*)btn
{
    if ([[_kaoChangListArr[btn.tag]objectForKey:@"zhankai"] isEqualToString:@"1"])
    {
        [_kaoChangListArr[btn.tag] setValue:@"2" forKey:@"zhankai"];
    }
    else
    {
        [_kaoChangListArr[btn.tag] setValue:@"1" forKey:@"zhankai"];
    }
    [_yuYueMoNiTablV reloadData];
}

//cell的点击事件
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([_kaoChangListArr[indexPath.section][@"moni"][indexPath.row][@"status"] integerValue] == 1)
    {
        //排队详情数据
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
             
             if(err)
             {
                 NSLog(@"json解析失败：%@",err);
             }
             
             if([[ZXwangLuoDanLi WangLuoDanLi] resIsTrue:jsonDict andAlertView:self])
             {
                 if ([jsonDict[@"resault"] isKindOfClass:[NSArray class]] && ((NSArray*)jsonDict[@"resault"]).count>0)
                 {
                     ZX_KeErPaiDuiDetail_ViewController * keErPaiDuiDetailVC = [[ZX_KeErPaiDuiDetail_ViewController alloc] init];
                     keErPaiDuiDetailVC.keErPaiDuiArr = jsonDict[@"resault"];
                     keErPaiDuiDetailVC.riQi = _kaoChangListArr[indexPath.section][@"moni"][indexPath.row][@"date"];
                     self.hidesBottomBarWhenPushed = YES;
                     [self.navigationController pushViewController:keErPaiDuiDetailVC animated:YES];
                     //                 [self shuaxinsuoyoushuju];
                 }
             }
             
         } failed:^(NSURLSessionTask *task, NSError *error)
         {
             [MBProgressHUD showSuccess:@"网络不好，请稍后重试。"];
         }];
    }
    else if ([_kaoChangListArr[indexPath.section][@"card_num"] integerValue] >0)
    {
     // 有卡券 跳转到卡券界面
         ZX_WoDeKaQuan_ViewController *woDeKaQuanVC =[[ZX_WoDeKaQuan_ViewController alloc]init];
        woDeKaQuanVC.erId = _kaoChangListArr[indexPath.section][@"id"];
        woDeKaQuanVC.nianYueRi=[NSString stringWithFormat:@"%@年%2d月%2d日",[_kaoChangListArr[indexPath.section][@"moni"][indexPath.row][@"date"] substringWithRange:NSMakeRange(0, 4)],[[_kaoChangListArr[indexPath.section][@"moni"][indexPath.row][@"date"] substringWithRange:NSMakeRange(5, 2)] intValue],[[_kaoChangListArr[indexPath.section][@"moni"][indexPath.row][@"date"] substringWithRange:NSMakeRange(8, 2)] intValue]];
        woDeKaQuanVC.goTime = _kaoChangListArr[indexPath.section][@"moni"][indexPath.row][@"goTime"];
        woDeKaQuanVC.zhouJi = _kaoChangListArr[indexPath.section][@"moni"][indexPath.row][@"week"];
        woDeKaQuanVC.riQi = _kaoChangListArr[indexPath.section][@"moni"][indexPath.row][@"date"];
        woDeKaQuanVC.kaoChangMing = _kaoChangListArr[indexPath.section][@"name"];
        self.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:woDeKaQuanVC animated:YES];
    }
    else
    {
        //没有卡券 提示跳转到购买卡券界面
        //弹出提示
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"您没有可用的模拟卡，快去买一张吧！" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"去买卡" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action)
                                  {
                                      ZX_GouMaiMoNiKa_ViewController * gouMaiMoNiKaVC = [[ZX_GouMaiMoNiKa_ViewController alloc] init];
                                      gouMaiMoNiKaVC.kaoChangId = _kaoChangListArr[indexPath.section][@"id"];
                                      gouMaiMoNiKaVC.goods_type = @"1";
                                      [self.navigationController pushViewController:gouMaiMoNiKaVC animated:YES];
                                  }];
        UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
        }];
        [alertController addAction:action1];
        [alertController addAction:action2];
        [self presentViewController:alertController animated:YES completion:nil];
    }
}

//获取预约模拟考场列表数据
- (void)yuYueMoNiKaoChangListData
{
    if (!_kaoChangListArr || !_isRefresh)
    {
        _animationView=[[ZXAnimationView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight)];
        [self.view addSubview:_animationView];
    }
    
    if (_isfresh && _isfresh1)
    {
        return;
    }
    
    [[ZXNetDataManager manager] keErYuYueMoNiKaoChangListDataRndstring:[ZXDriveGOHelper getCurrentTimeStamp] andPage:[NSString stringWithFormat:@"%ld",(long)_page] andIdent_code:[ZXUD objectForKey:@"ident_code"] success:^(NSURLSessionDataTask *task, id responseObject)
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
             if([jsonDict[@"klist"] isKindOfClass:[NSArray class]] && ((NSArray*)jsonDict[@"klist"]).count > 0)
             {
                 if (_isfresh)
                 {
                     [_kaoChangListArr removeAllObjects];
                 }
                 
                 for (int i = 0; i < ((NSArray*)jsonDict[@"klist"]).count; i ++)
                 {
                     NSMutableDictionary* dict = [[NSMutableDictionary alloc] initWithDictionary:jsonDict[@"klist"][i]];
                     if ([dict[@"name"] isEqualToString:_kaoChangName])
                     {
                          [dict setValue:@"0" forKey:@"zhankai"];
                     }
                     else
                     {
                         [dict setValue:@"1" forKey:@"zhankai"];
                     }
                     
                     if (!_kaoChangListArr)
                     {
                         _kaoChangListArr = [NSMutableArray array];
                         [_kaoChangListArr addObject:dict];
                     }
                     else
                     {
                         [_kaoChangListArr addObject:dict];
                     }
                 }
             }
             [_yuYueMoNiTablV reloadData];
             
             dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                 [_animationView removeFromSuperview];
                 _isfresh1 = NO;
                 _isfresh = NO;
             });
             _isRefresh = NO;
             [self.yuYueMoNiTablV.mj_header endRefreshing];
             [self.yuYueMoNiTablV.mj_footer endRefreshing];
         }
     }failed:^(NSURLSessionTask *task, NSError *error)
    {
        [_animationView removeFromSuperview];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}



@end

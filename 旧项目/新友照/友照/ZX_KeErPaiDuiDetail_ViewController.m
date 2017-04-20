//
//  ZX_KeErPaiDuiDetail_ViewController.m
//  友照
//
//  Created by cleloyang on 2016/11/26.
//  Copyright © 2016年 ZX_XPH. All rights reserved.
//

#import "ZX_KeErPaiDuiDetail_ViewController.h"
#import "ZX_YuYueMoNi_ViewController.h"
#import "UIImage+LXDCreateBarcode.h"
#import "ZXTableViewCell_one.h"
#import "ZXTableViewCell_paidui_two.h"
#import "ZX_ke_er_mo_ni_pai_dui_monikuan_TableViewCell.h"
#import "ZX_ke_er_xiang_qing_TableViewCell.h"
#import "Ke_er_pai_dui_xiang_qing_shu_ju.h"

@interface ZX_KeErPaiDuiDetail_ViewController ()<UITableViewDelegate, UITableViewDataSource>

@property(nonatomic, strong) UITableView *keErPaiDuiDetailTabV;
@property(nonatomic, strong) UITableView *keErPaiDuiDetailTabV1;
//立即验证的按钮
@property(nonatomic, strong) UIButton *yanZhengBtn;
//判断是否第一次进入
@property(nonatomic) BOOL isFirst;
//选择的第几个
@property(nonatomic) NSInteger selectNum;
//当前日期
@property(nonatomic, copy) NSString *currentDayStr;
@end

@implementation ZX_KeErPaiDuiDetail_ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //当前时间
    NSDate * now = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    _currentDayStr = [dateFormatter stringFromDate:now];
    
    self.title=@"排队详情";
    [self creatkeErPaiDuiDetailTabV];
    
    if (_keErPaiDuiArr.count > 0 && _keErPaiDuiArr)
    {
        if (!_isFirst)
        {
            for (int i = 0; i < _keErPaiDuiArr.count; i++)
            {
                if ([_currentDayStr isEqualToString:_keErPaiDuiArr[i][@"moni_time"]])
                {
                    self.selectNum = i;
                    continue;
                }
            }
        }
        
        if ([_keErPaiDuiArr[self.selectNum][@"validate_button"] isEqualToString:@"0"])
        {
            _yanZhengBtn.hidden = YES;
            self.navigationItem.rightBarButtonItem = nil;
        }
        else
        {
            _yanZhengBtn.hidden = NO;
            [self creatCancelPaiDuiBtn];

        }
        [_keErPaiDuiDetailTabV reloadData];
    }
    else
    {
        [self getKeErPaiDuiDetailData];
    }
}

- (void)goToBack
{
    if (!_isWoDeDuiWu)
    {
        for (UIViewController* VC in self.navigationController.viewControllers)
        {
            if ([VC isKindOfClass:[ZX_YuYueMoNi_ViewController class]])
            {
                ((ZX_YuYueMoNi_ViewController*)VC).kaoChangName = _keErPaiDuiArr[_selectNum][@"name"];
                [self.navigationController popToViewController:VC animated:YES];
            }
        }
    }
    else
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
    
}

//创建科二模拟排队详情tableview
- (void)creatkeErPaiDuiDetailTabV
{
    _keErPaiDuiDetailTabV = [[UITableView alloc] initWithFrame:CGRectMake(0, 0,KScreenWidth,KScreenHeight-30) style:UITableViewStylePlain];

    _keErPaiDuiDetailTabV.delegate = self;
    _keErPaiDuiDetailTabV.dataSource = self;
    _keErPaiDuiDetailTabV.backgroundColor=[UIColor colorWithRed:241/255.0 green:241/255.0 blue:241/255.0 alpha:1];
    _keErPaiDuiDetailTabV.separatorStyle = UITableViewCellSeparatorStyleNone;
    _keErPaiDuiDetailTabV.showsVerticalScrollIndicator = NO;
    //注册cell
    [_keErPaiDuiDetailTabV registerNib:[UINib nibWithNibName:@"ZX_ke_er_xiang_qing_TableViewCell" bundle:nil] forCellReuseIdentifier:@"cellIDfive"];
    [_keErPaiDuiDetailTabV registerNib:[UINib nibWithNibName:@"ZXTableViewCell_paidui_two" bundle:nil] forCellReuseIdentifier:@"cellIDtwo"];
    [_keErPaiDuiDetailTabV registerNib:[UINib nibWithNibName:@"Ke_er_pai_dui_xiang_qing_shu_ju" bundle:nil] forCellReuseIdentifier:@"cellIDhehe"];
    [_keErPaiDuiDetailTabV registerNib:[UINib nibWithNibName:@"ZX_ke_er_mo_ni_pai_dui_monikuan_TableViewCell" bundle:nil] forCellReuseIdentifier:@"cellIDfour"];
    
    _yanZhengBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, KScreenHeight-50, KScreenWidth, 50)];
    [_yanZhengBtn setTitle:@"立即验证" forState:UIControlStateNormal];
    [_yanZhengBtn setBackgroundColor:[UIColor colorWithRed:239/255.0 green:131/255.0 blue:49/255.0 alpha:1]];
    [_yanZhengBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _yanZhengBtn.titleLabel.font=[UIFont systemFontOfSize:20];
    [_yanZhengBtn addTarget:self action:@selector(shangCheYanZheng) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:_keErPaiDuiDetailTabV];
    [self.view addSubview:_yanZhengBtn];
}

//返回的组数
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (tableView.tag != 100)
    {
        if ([_keErPaiDuiArr[_selectNum][@"goTime"] isEqualToString:@"已上车"])
        {
            return 3;
        }
        else
        {
            return 4;
        }
    }
    else
    {
        return 1;
    }
}

//返回每组的行数
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView.tag != 100)
    {
        //行数根据返回的数据来进行显示
        if(section == 2)
        {
            return ((NSArray*)_keErPaiDuiArr[_selectNum][@"plist"]).count;
        }
        else
        {
            return 1;
        }
    }
    else
    {
        return _keErPaiDuiArr.count;
    }
}

//返回每组的行高
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView.tag != 100)
    {
        if (indexPath.section == 0)
        {
            return 60;
        }
        else if (indexPath.section == 1)
        {
            return 120;
        }
        else if(indexPath.section == 3)
        {
            return 300;
        }
    }
    return 60;
}

//返回每组的headerView
-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (tableView.tag != 100)
    {
        UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, 15)];
        headerView.backgroundColor=[UIColor colorWithRed:241/255.0 green:241/255.0 blue:241/255.0 alpha:1];
        return headerView;
    }
    else
    {
        return [[UIView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, 10)];
    }
}

//返回每组的footerView
-(UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *footerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, 20)];
    footerView.backgroundColor=[UIColor colorWithRed:241/255.0 green:241/255.0 blue:241/255.0 alpha:1];
    return footerView;
}

//返回每组的headerView的高度
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (tableView.tag != 100)
    {
        return 15;
    }
    else
    {
        return 10;
    }
}

//返回每组的footerView的高度
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (tableView.tag != 100)
    {
        if (section == 3)
        {
            return 20;
        }
        else
        {
            return 0;
        }
    }
    else
    {
        return 0;
    }
}

//每行的内容
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.tag!=100)
    {
        //行数根据返回的数据来进行显示
        if (indexPath.section == 0 && indexPath.row == 0)
        {
            ZX_ke_er_xiang_qing_TableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellIDfive" forIndexPath:indexPath];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            [cell.beijing setImage:[UIImage imageNamed:@"下箭头"] forState:UIControlStateNormal];
            //上左下右
            [cell.beijing setImageEdgeInsets:UIEdgeInsetsMake(25, KScreenWidth-50, 25,40)];
            [cell.beijing addTarget:self action:@selector(creatKeErPaiDuiDetailTabV1:) forControlEvents:UIControlEventTouchDown];
            cell.beijing.clipsToBounds=YES;
            cell.beijing.layer.cornerRadius = 5.0;
            
            NSString *weekday = @"";
            if ([_keErPaiDuiArr[_selectNum][@"week"] isEqualToString:@"1"])
            {
                weekday = @"周一";
            }
            if ([_keErPaiDuiArr[_selectNum][@"week"] isEqualToString:@"2"])
            {
                weekday = @"周二";
            }
            if ([_keErPaiDuiArr[_selectNum][@"week"] isEqualToString:@"3"])
            {
                weekday = @"周三";
            }
            if ([_keErPaiDuiArr[_selectNum][@"week"] isEqualToString:@"4"])
            {
                weekday = @"周四";
            }
            if ([_keErPaiDuiArr[_selectNum][@"week"] isEqualToString:@"5"])
            {
                weekday = @"周五";
            }
            if ([_keErPaiDuiArr[_selectNum][@"week"] isEqualToString:@"6"])
            {
                weekday = @"周六";
            }
            if ([_keErPaiDuiArr[_selectNum][@"week"] isEqualToString:@"7"])
            {
                weekday = @"周日";
            }
            
            cell.riqi.text = [NSString stringWithFormat:@"%@   %@",[NSString stringWithFormat:@"%@年%2d月%2d日",[_keErPaiDuiArr[_selectNum][@"moni_time"] substringWithRange:NSMakeRange(0,4)],[[_keErPaiDuiArr[_selectNum][@"moni_time"] substringWithRange:NSMakeRange(5, 2)] intValue],[[_keErPaiDuiArr[_selectNum][@"moni_time"] substringWithRange:NSMakeRange(8, 2)] intValue]],weekday];
            cell.name.text = _keErPaiDuiArr[_selectNum][@"name"];
            return cell;
        }
        else if (indexPath.section == 1 && indexPath.row == 0)
        {
            ZXTableViewCell_paidui_two *cell = [tableView dequeueReusableCellWithIdentifier:@"cellIDtwo" forIndexPath:indexPath];
            cell.beijing.clipsToBounds = YES;
            cell.beijing.layer.cornerRadius = 5.0;
            
            if ([_keErPaiDuiArr[_selectNum][@"nownum"] isKindOfClass:[NSString class]])
            {
                cell.dangqianshangchehaoma_wenzi.text = [NSString stringWithFormat:@"%@",_keErPaiDuiArr[_selectNum][@"nownum"]];
                cell.sahngchehaoma_wode.text = _keErPaiDuiArr[_selectNum][@"pdnumber"];
            }
            else
            {
                cell.dangqianshangchehaoma_wenzi.text = [NSString stringWithFormat:@"%@",_keErPaiDuiArr[_selectNum][@"nownum"]];
                cell.sahngchehaoma_wode.text = [NSString stringWithFormat:@"%@",_keErPaiDuiArr[_selectNum][@"pdnumber"]];
            }
            
            cell.shangcheshijian.text = [NSString stringWithFormat:@"预计上车时间：%@",_keErPaiDuiArr[_selectNum][@"goTime"]];
            cell.dangqianshangchehaoma_wenzi.hidden = NO;
            cell.sahngchehaoma_wode.hidden = NO;
            cell.shangcheshijian.hidden = NO;
            cell.meiyouhaoma.hidden = YES;
            cell.meiyoudangqianhaoma.hidden = YES;
            return cell;
        }
        else if (indexPath.section==2)
        {
            Ke_er_pai_dui_xiang_qing_shu_ju *cell = [tableView dequeueReusableCellWithIdentifier:@"cellIDhehe" forIndexPath:indexPath];
            cell.btn.clipsToBounds = YES;
            
            cell.btn.layer.cornerRadius = 5.0;
            cell.one.text = [NSString stringWithFormat:@"%@号",_keErPaiDuiArr[_selectNum][@"plist"][indexPath.row][@"pdnumber"]];
            cell.two.text = _keErPaiDuiArr[_selectNum][@"plist"][indexPath.row][@"snick"];
            cell.three.text = [NSString stringWithFormat:@"%@****%@",[_keErPaiDuiArr[_selectNum][@"plist"][indexPath.row][@"stel"] substringWithRange:NSMakeRange(0, 3)],[_keErPaiDuiArr[_selectNum][@"plist"][indexPath.row][@"stel"] substringWithRange:NSMakeRange(7, 4)]];
            cell.three.textAlignment = NSTextAlignmentLeft;
            return cell;
        }
        else if (indexPath.section == 3)
        {
            ZX_ke_er_mo_ni_pai_dui_monikuan_TableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellIDfour" forIndexPath:indexPath];
            cell.beijing.clipsToBounds = YES;
            cell.beijing.layer.cornerRadius = 5.0;
            cell.yanzhengmashuzi.text = [NSString stringWithFormat:@"%@ %@ %@ %@",[_keErPaiDuiArr[_selectNum][@"coupcode"] substringWithRange:NSMakeRange(0, 4)] ,[ _keErPaiDuiArr[_selectNum][@"coupcode"] substringWithRange:NSMakeRange(4, 4)],[_keErPaiDuiArr[_selectNum][@"coupcode"] substringWithRange:NSMakeRange(8, 4)],[_keErPaiDuiArr[_selectNum][@"coupcode"] substringWithRange:NSMakeRange(12,[_keErPaiDuiArr[_selectNum][@"coupcode"] length]-12)]];
            cell.yanzhengmatupian.image = [UIImage imageOfQRFromURL:_keErPaiDuiArr[_selectNum][@"coupcode"]];
            return cell;
        }
    }
    else
    {
        ZX_ke_er_xiang_qing_TableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellIDfive" forIndexPath:indexPath];
        cell.beijing.tag = indexPath.row;
        [cell.beijing addTarget:self action:@selector(selectedHang:) forControlEvents:UIControlEventTouchDown];
        cell.beijing.clipsToBounds = YES;
        cell.beijing.layer.cornerRadius = 5.0;
        
        NSString* str = @"";
        if ([_keErPaiDuiArr[indexPath.row][@"week"] isEqualToString:@"1"])
        {
            str = @"周一";
        }
        if ([_keErPaiDuiArr[indexPath.row][@"week"] isEqualToString:@"2"])
        {
            str = @"周二";
        }
        if ([_keErPaiDuiArr[indexPath.row][@"week"] isEqualToString:@"3"])
        {
            str = @"周三";
        }
        if ([_keErPaiDuiArr[indexPath.row][@"week"] isEqualToString:@"4"])
        {
            str = @"周四";
        }
        if ([_keErPaiDuiArr[indexPath.row][@"week"] isEqualToString:@"5"])
        {
            str = @"周五";
        }
        if ([_keErPaiDuiArr[indexPath.row][@"week"] isEqualToString:@"6"])
        {
            str = @"周六";
        }
        if ([_keErPaiDuiArr[indexPath.row][@"week"] isEqualToString:@"7"])
        {
            str = @"周日";
        }
        cell.riqi.text = [NSString stringWithFormat:@"%@   %@",[NSString stringWithFormat:@"%@年%2d月%2d日",[_keErPaiDuiArr[indexPath.row][@"moni_time"] substringWithRange:NSMakeRange(0,4)],[[_keErPaiDuiArr[indexPath.row][@"moni_time"] substringWithRange:NSMakeRange(5, 2)] intValue],[[_keErPaiDuiArr[indexPath.row][@"moni_time"] substringWithRange:NSMakeRange(8, 2)] intValue]],str];
        cell.name.text = _keErPaiDuiArr[indexPath.row][@"name"];
        return cell;
    }
    return [[UITableViewCell alloc] init];
}

//点击事件
-(void)creatKeErPaiDuiDetailTabV1:(UIButton*)btn
{
    if ([[btn currentImage] isEqual:[UIImage imageNamed:@"下箭头"]])
    {
        self.navigationItem.rightBarButtonItem = nil;
        [btn setImage:[UIImage imageNamed:@"上箭头"] forState:UIControlStateNormal];
        //设置tableview 不能滚动
        _keErPaiDuiDetailTabV.scrollEnabled = NO;
        
        //显示内容
        if (!_keErPaiDuiDetailTabV1)
        {
            _keErPaiDuiDetailTabV1 = [[UITableView alloc]initWithFrame:CGRectMake(0, 150, KScreenWidth, KScreenHeight-150) style:UITableViewStylePlain];
            
            _keErPaiDuiDetailTabV1.tag = 100;
            _keErPaiDuiDetailTabV1.dataSource = self;
            _keErPaiDuiDetailTabV1.delegate = self;
            _keErPaiDuiDetailTabV1.separatorStyle = UITableViewCellSeparatorStyleNone;
            
            _keErPaiDuiDetailTabV1.backgroundColor = [UIColor colorWithRed:241/255.0 green:241/255.0 blue:241/255.0 alpha:1];
            [_keErPaiDuiDetailTabV1 registerNib:[UINib nibWithNibName:@"ZX_ke_er_xiang_qing_TableViewCell" bundle:nil] forCellReuseIdentifier:@"cellIDfive"];
            [self.view addSubview:_keErPaiDuiDetailTabV1];
        }
        _keErPaiDuiDetailTabV1.hidden = NO;
        [_keErPaiDuiDetailTabV1 reloadData];
    }
    else
    {
        [btn setImage:[UIImage imageNamed:@"下箭头"] forState:UIControlStateNormal];
        //隐藏内容
        _keErPaiDuiDetailTabV1.hidden = YES;
        
        //设置tableview 不能滚动
        _keErPaiDuiDetailTabV.scrollEnabled = YES;
    }
}

//选中某一行
-(void)selectedHang:(UIButton*)btn
{
    _isFirst = YES;
    _selectNum = btn.tag;
    _keErPaiDuiDetailTabV1.hidden = YES;
    _keErPaiDuiDetailTabV.scrollEnabled = YES; //设置tableview 不能滚动

    if ([_keErPaiDuiArr[self.selectNum][@"validate_button"] isEqualToString:@"0"])
    {
        _yanZhengBtn.hidden = YES;
        self.navigationItem.rightBarButtonItem = nil;
    }
    else
    {
        _yanZhengBtn.hidden=NO;
        [self creatCancelPaiDuiBtn];
    }

    [_keErPaiDuiDetailTabV reloadData];
}

//创建取消排队按钮
- (void)creatCancelPaiDuiBtn
{
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStyleDone target:self  action:@selector(cancelPaiDui)];
    self.navigationItem.rightBarButtonItem.tintColor=[UIColor whiteColor];
}

//取消排队
-(void)cancelPaiDui
{
    //弹出提示
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"您是否取消排队" preferredStyle:UIAlertControllerStyleAlert];
    //创建action
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"取消排队" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action)
                              {
                                  //找出取消排队的卡券的id
                                  for(int i = 0; i < ((NSArray*)_keErPaiDuiArr[_selectNum][@"plist"]).count; i ++)
                                  {
                                      if ([_keErPaiDuiArr[_selectNum][@"plist"][i][@"pdnumber"] isEqualToString:_keErPaiDuiArr[_selectNum][@"pdnumber"]])
                                      {
                                          //取消排队
                                          [self cancelPaiDuiData];
                                      }
                                  }
                              }];
    
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"返回" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action)
                              {
                              }];
    //添加action
    [alertController addAction:action1];
    [alertController addAction:action2];
    //显示弹出视图
    [self presentViewController:alertController animated:YES completion:nil];
}
//立即验证
-(void)shangCheYanZheng
{
    //弹出提示
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"点击验证将代表您已经上车，此卡不能再次使用。" preferredStyle:UIAlertControllerStyleAlert];
    //创建action
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"验证" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action)
                              {
                               //上车信息验证
                                  [self yanZhengShangCheXinXiData];
                              }];
    
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action)
                              {
                              }];
    //添加action
    [alertController addAction:action1];
    [alertController addAction:action2];
    //显示弹出视图
    [self presentViewController:alertController animated:YES completion:nil];
}

//验证上车信息
- (void)yanZhengShangCheXinXiData
{
    [[ZXNetDataManager manager] shangCheXinXiYanZhengDataWithRndstring:[ZXDriveGOHelper getCurrentTimeStamp] andIdent_code:[ZXUD objectForKey:@"ident_code"] andercode:_keErPaiDuiArr[_selectNum][@"coupcode"] success:^(NSURLSessionDataTask *task, id responseObject)
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
             [self getKeErPaiDuiDetailData];

             //验证成功弹出提示，再刷新一下表格
             [MBProgressHUD showSuccess:jsonDict[@"msg"]];
             _yanZhengBtn.hidden = YES;
             self.navigationItem.rightBarButtonItem = nil;
         }
     }failed:^(NSURLSessionTask *task, NSError *error)
     {
         [MBProgressHUD showSuccess:@"网络不好，请稍后重试。"];
         //网络失败弹出提示
     }];
}

//排队详情数据
- (void)getKeErPaiDuiDetailData
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
                 if (!_keErPaiDuiArr)
                 {
                     _keErPaiDuiArr = [NSArray arrayWithArray:jsonDict[@"resault"]];
                 }
                 else
                 {
                     _keErPaiDuiArr = jsonDict[@"resault"];
                 }
             }
             else
             {
                 _keErPaiDuiArr = nil;
             }
             [_keErPaiDuiDetailTabV reloadData];
         }
     } failed:^(NSURLSessionTask *task, NSError *error)
     {
         [MBProgressHUD showSuccess:@"网络不好，请稍后重试。"];
     }];
}

//取消排队
- (void)cancelPaiDuiData
{
    [MBProgressHUD showMessage:@"正在取消排队"];
    [[ZXNetDataManager manager] quXiaoPaiDuiDataWitnRndstring:[ZXDriveGOHelper getCurrentTimeStamp] andIdentCode:[ZXUD objectForKey:@"ident_code"] andid:_keErPaiDuiArr[_selectNum][@"id"] success:^(NSURLSessionDataTask *task, id responseObject)
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
             [MBProgressHUD showSuccess:@"取消排队成功"];
             _selectNum=0;
             if (!_isWoDeDuiWu)
             {
                 for (UIViewController* VC in self.navigationController.viewControllers)
                 {
                     if ([VC isKindOfClass:[ZX_YuYueMoNi_ViewController class]])
                     {
                         ((ZX_YuYueMoNi_ViewController*)VC).kaoChangName = _keErPaiDuiArr[_selectNum][@"name"];
                         [self.navigationController popToViewController:VC animated:YES];
                     }
                 }
             }
             else
             {
                 [self.navigationController popViewControllerAnimated:YES];
             }
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

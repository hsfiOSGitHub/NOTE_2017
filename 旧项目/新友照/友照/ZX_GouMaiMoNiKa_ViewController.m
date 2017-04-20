//
//  ZX_GouMaiMoNiKa_ViewController.m
//  友照
//
//  Created by cleloyang on 2016/11/24.
//  Copyright © 2016年 ZX_XPH. All rights reserved.
//

#import "ZX_GouMaiMoNiKa_ViewController.h"
//科二购买模拟卡cell
#import "KeErTableViewCell1.h"
#import "KeErTableViewCell3.h"
#import "KeErTableViewCell3-2.h"
#import "KeErTableViewCell4.h"
//选择考场
#import "ZX_XuanZeKaoChang_ViewController.h"
//提交订单界面
#import "ZX_TiJiaoDingDan_ViewController.h"

@interface ZX_GouMaiMoNiKa_ViewController ()<UITableViewDelegate,UITableViewDataSource>
//购买模拟卡tableview
@property(nonatomic, strong) UITableView *gouMaiMoNiKaTabV;
//模拟卡数据字典
@property(nonatomic, strong) NSDictionary *keErMoNiDic;
//课时卡数据字典
@property(nonatomic, strong) NSDictionary *keShiDic;
//卡劵ID
@property(nonatomic) NSInteger kaQuanId;
//购买卡券按钮
@property(nonatomic, strong) UIButton *gouMaiBtn;

@property(strong,nonatomic)NSString* guiZe;
@end

@implementation ZX_GouMaiMoNiKa_ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"购买详情";
    self.view.backgroundColor=[UIColor whiteColor];
    [self creatGouMaiMoNiKaBtn];
    [self creatGouMaiMoNiKaTabV];
    if ([_goods_type isEqualToString:@"1"])
    {
        [self gouMaiMoNiKaData];
    }
    else
    {
        [self gouMaiKeShiData];
    }
}
//创建购买模拟卡tableview
- (void)creatGouMaiMoNiKaTabV
{
    _gouMaiMoNiKaTabV = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight-60) style:UITableViewStylePlain];
    _gouMaiMoNiKaTabV.delegate = self;
    _gouMaiMoNiKaTabV.dataSource = self;
    _gouMaiMoNiKaTabV.separatorStyle = UITableViewCellSeparatorStyleNone;
    _gouMaiMoNiKaTabV.showsVerticalScrollIndicator = NO;
    [self.view addSubview:_gouMaiMoNiKaTabV];
    [_gouMaiMoNiKaTabV registerNib:[UINib nibWithNibName:@"KeErTableViewCell1" bundle:nil] forCellReuseIdentifier:@"KeErTableViewCell1"];
    [_gouMaiMoNiKaTabV registerNib:[UINib nibWithNibName:@"KeErTableViewCell3" bundle:nil] forCellReuseIdentifier:@"KeErTableViewCell3"];
    [_gouMaiMoNiKaTabV registerNib:[UINib nibWithNibName:@"KeErTableViewCell3-2" bundle:nil] forCellReuseIdentifier:@"KeErTableViewCell3_2"];
    [_gouMaiMoNiKaTabV registerNib:[UINib nibWithNibName:@"KeErTableViewCell4" bundle:nil] forCellReuseIdentifier:@"KeErTableViewCell4"];
}

//返回的组数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

//返回每组的cell行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

//返回每行cell的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0)
    {
        return 245;
    }
    else if (indexPath.row == 1)
    {
        if ([_goods_type isEqualToString:@"1"])
        {
            return 65;
        }
        else
        {
            return 120;
        }
    }
    else
    {
        if ([_goods_type isEqualToString:@"1"])
        {
            if ([_keErMoNiDic[@"content"] isKindOfClass:[NSString class]])
            {
                 return [self boundingRectWithSize:CGSizeMake(KScreenWidth-20, 0) andtext:_keErMoNiDic[@"content"]].height+188;
            }
            else
            {
                return 188;
            }
        }
        else
        {
            if ([_keErMoNiDic[@"content"] isKindOfClass:[NSString class]])
            {
                return [self boundingRectWithSize:CGSizeMake(KScreenWidth-20, 0) andtext:_keShiDic[@"content"]].height+188;
            }
            else
            {
                return 188;
            }
        }
    }
}

//计算文字的高度
- (CGSize)boundingRectWithSize:(CGSize)size andtext:(NSString*)str
{
    NSDictionary *attribute = @{NSFontAttributeName:[UIFont systemFontOfSize:15]};
    CGSize retSize = [str boundingRectWithSize:size
                                       options:\
                      NSStringDrawingTruncatesLastVisibleLine |
                      NSStringDrawingUsesLineFragmentOrigin |
                      NSStringDrawingUsesFontLeading
                                    attributes:attribute
                                       context:nil].size;
    return retSize;
}

//返回的cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0)
    {
        KeErTableViewCell1 *cell = [_gouMaiMoNiKaTabV dequeueReusableCellWithIdentifier:@"KeErTableViewCell1" forIndexPath:indexPath];
        //设置卡片图片、价格和模拟卡的名字
        if ([_goods_type isEqualToString:@"1"])
        {
            [cell.moNiKaPic setImage:[UIImage imageNamed:@"科二模拟卡"]];
            cell.monikamingzi.text = [NSString stringWithFormat:@"%@",_keErMoNiDic[@"name"]];
            cell.jiage.text=[NSString stringWithFormat:@"¥ %@/张",_keErMoNiDic[@"price"]];
            if ([_keErMoNiDic[@"price"] floatValue] == 0)
            {
                _gouMaiBtn.hidden=YES;
            }
            else
            {
                _gouMaiBtn.hidden=NO;
            }

        }
        else
        {
            if ([_goods_type isEqualToString:@"12"])
            {
                [cell.moNiKaPic setImage:[UIImage imageNamed:@"科二学时卡"]];
            }
            else
            {
                [cell.moNiKaPic setImage:[UIImage imageNamed:@"科三学时卡"]];
            }
            cell.monikamingzi.text = [NSString stringWithFormat:@"%@",_keShiDic[@"card_name"]];
            cell.jiage.text=[NSString stringWithFormat:@"¥ %@/张",_keShiDic[@"card_price"]];
            if ([_keShiDic[@"card_price"] floatValue] == 0)
            {
                _gouMaiBtn.hidden=YES;
            }
            else
            {
                _gouMaiBtn.hidden=NO;
            }
        }
        cell.monikamingzi.backgroundColor = [UIColor clearColor];
        cell.selectionStyle = NO;
        return cell;
    }
    else if (indexPath.row == 1)
    {
        //设置考场名字
        if ([_goods_type isEqualToString:@"1"])
        {
            KeErTableViewCell3 * cell = [_gouMaiMoNiKaTabV dequeueReusableCellWithIdentifier:@"KeErTableViewCell3"];
            cell.selectionStyle = NO;
            cell.kaochangmingzi.text = [NSString stringWithFormat:@"%@",_keErMoNiDic[@"ername"]];
            cell.userInteractionEnabled = YES;
            return cell;
        }
        else
        {
            KeErTableViewCell3_2 * cell = [_gouMaiMoNiKaTabV dequeueReusableCellWithIdentifier:@"KeErTableViewCell3_2"];
            cell.selectionStyle = NO;
            if ([_goods_type isEqualToString:@"12"])
            {
                cell.keMuLab.text = @"科目二";
            }
            else if ([_goods_type isEqualToString:@"13"])
            {
                cell.keMuLab.text = @"科目三";
            }
            cell.jiaoLianNameLab.text = _keShiDic[@"teacher_name"];
            cell.jiaXiaoNameLab.text = _keShiDic[@"school_name"];
            cell.userInteractionEnabled = NO;
            return cell;
        }
    }
    else
    {
        //设置购买须知
        KeErTableViewCell4 * cell = [_gouMaiMoNiKaTabV dequeueReusableCellWithIdentifier:@"KeErTableViewCell4"];
        if ([_keErMoNiDic[@"isvalid"] isEqualToString:@"0"])
        {
            cell.youxiaoqi.text = @"· 自购买之日起长期有效";
        }
        else
        {
            cell.youxiaoqi.text = @"· 自购买之日起一个月内有效";
        }
        if ([_goods_type isEqualToString:@"1"])
        {
            
            cell.guize.text = _guiZe;
        }
        else
        {
            cell.guize.text = _guiZe;
        }
        cell.selectionStyle = NO;
        return cell;
    }
}

//cell点击事件
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //弹出所有考场的列表
    if (indexPath.row == 1)
    {
        ZX_XuanZeKaoChang_ViewController *xuanZeKaoChangVC = [[ZX_XuanZeKaoChang_ViewController alloc] init];
        xuanZeKaoChangVC.gouMaiMoNiKaVC = self;
        [self.navigationController pushViewController:xuanZeKaoChangVC animated:YES];
    }
}

//创建购买button
- (void)creatGouMaiMoNiKaBtn
{
    _gouMaiBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, KScreenHeight - 60, KScreenWidth, 60)];
    [_gouMaiBtn setTitle:@"立即购买" forState:UIControlStateNormal];
    [_gouMaiBtn addTarget:self action:@selector(gouMaiKaQuan) forControlEvents:UIControlEventTouchDown];
    //橘色的RGB的值
    [_gouMaiBtn setBackgroundColor:[UIColor orangeColor]];
    [self.view addSubview:_gouMaiBtn];
}

//购买卡券,跳转到提交订单界面
- (void)gouMaiKaQuan
{
    ZX_TiJiaoDingDan_ViewController *tiJiaoDingDanVC = [[ZX_TiJiaoDingDan_ViewController alloc] init];
    tiJiaoDingDanVC.goods_type = _goods_type;
    
   if ([_goods_type isEqualToString:@"1"])
   {
       tiJiaoDingDanVC.priceValue = _keErMoNiDic[@"price"];
       tiJiaoDingDanVC.productId = _keErMoNiDic[@"cardid"];
       tiJiaoDingDanVC.kaoChangName = _keErMoNiDic[@"ername"];
       tiJiaoDingDanVC.cardNum = [_keErMoNiDic[@"cardnum"] integerValue];
    }
    else
    {
        tiJiaoDingDanVC.priceValue = _keShiDic[@"card_price"];
        tiJiaoDingDanVC.jiaXiaoName = _keShiDic[@"school_name"];
        tiJiaoDingDanVC.jiaoLianName = _keShiDic[@"teacher_name"];
    }
    
    [self.navigationController pushViewController:tiJiaoDingDanVC animated:YES];
}

//购买模拟卡详情数据
- (void)gouMaiMoNiKaData
{
    _animationView=[[ZXAnimationView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight)];
    [self.view addSubview:_animationView];
    
    [[ZXNetDataManager manager]gouMaiMoNiKaDataWithRndstring:[ZXDriveGOHelper getCurrentTimeStamp] andIdent_code:[ZXUD objectForKey:@"ident_code"] andErid:_kaoChangId andCardid:@"" success:^(NSURLSessionDataTask *task, id responseObject)
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
             if ([jsonDict[@"content"] isKindOfClass:[NSString class]])
             {
                 _guiZe =jsonDict[@"content"];
             }
             else
             {
                 _guiZe=@"";
             }
             
             if (!_keErMoNiDic)
             {
                 _keErMoNiDic = [NSDictionary dictionaryWithDictionary:jsonDict];
             }
             else
             {
                 _keErMoNiDic = jsonDict;
             }
         }
         [_gouMaiMoNiKaTabV reloadData];
         
         dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
             [_animationView removeFromSuperview];
         });

     }failed:^(NSURLSessionTask *task, NSError *error)
     {
          [MBProgressHUD hideHUD];
     }];
}

//购买课时详情数据
- (void)gouMaiKeShiData
{
    _animationView=[[ZXAnimationView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight)];
    [self.view addSubview:_animationView];
    
    [[ZXNetDataManager manager]gouMaiKeShiKaDataWithRndstring:[ZXDriveGOHelper getCurrentTimeStamp] andIdent_code:[ZXUD objectForKey:@"ident_code"] andGoods_type:_goods_type success:^(NSURLSessionDataTask *task, id responseObject)
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
             if ([jsonDict[@"content"] isKindOfClass:[NSString class]])
             {
                 _guiZe =jsonDict[@"content"];
             }
             else
             {
                 _guiZe=@"";
             }
             
             if (!_keShiDic)
             {
                 _keShiDic = [NSDictionary dictionaryWithDictionary:jsonDict];
             }
             else
             {
                 _keShiDic = jsonDict;
             }
         }
         [_gouMaiMoNiKaTabV reloadData];
         
         dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
             [_animationView removeFromSuperview];
         });
         
     }failed:^(NSURLSessionTask *task, NSError *error)
     {
     }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


@end

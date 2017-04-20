//
//  wo_de_ViewController.m
//  友照
//
//  Created by ZX on 16/11/18.
//  Copyright © 2016年 ZX_XPH. All rights reserved.
//

#import "wo_de_ViewController.h"
#import "ZX_WoDe_TableViewCell1.h"
#import "ZX_WoDe_TableViewCell2.h"
#import "ZX_WoDe_TableViewCell3.h"
#import "ZX_WoDe_TableViewCell4.h"
#import "ZX_WoDe_TableViewCell5.h"
#import <UMComDataStorage/UMComUser.h>

//系统设置
#import "ZX_SheZhi_ViewController.h"
//我的课程
#import "ZX_MyClass_ViewController.h"
//扫一扫
#import "saoYiSaoVC.h"
//我的合同
#import "ZX_WoDeHeTong_ViewController.h"
//我推荐的好友
#import "ZX_WoTuiJianDeHaoYou_ViewController.h"
//分享
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKUI/ShareSDK+SSUI.h>
#import "ZXPersonalDataTableViewController.h"
//考试记录
#import "ZX_KaoShiJiLu_ViewController.h"
//消息列表
#import "ZXMessageVCTableViewController.h"
//订单
#import "ZX_OrderList_ViewController.h"
//优惠券
#import "ZX_YouHuiQuan_ViewController.h"
//驾校列表
#import "NearbySchoolVC.h"
//驾校详情
#import "SchoolDetailVC.h"
//我的教练
#import "ZX_WoDeJiaoLian_ViewController.h"

@interface wo_de_ViewController ()<UITableViewDelegate, UITableViewDataSource,UINavigationControllerDelegate,UIImagePickerControllerDelegate>

@property (nonatomic, strong) UITableView *woDeTabV;
@property (nonatomic, strong) UILabel *woDeJiaXiaoLab;
@property (nonatomic, strong) UILabel *woDeJiaoLianLab;
@property (nonatomic, strong) UILabel *keErKeShiLab;
@property (nonatomic, strong) UILabel *keSanKeShiLab;

@property (nonatomic, assign) BOOL isTakePhoto;
@property (nonatomic, assign) BOOL isData;

@end

@implementation wo_de_ViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    if ([ZXUD boolForKey:@"IS_LOGIN"] )
    {
        [self chaKanXueYuanXinXiData];
    }
    else
    {
        [_woDeTabV reloadData];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
   
    self.title = @"我的";
    [self creatWoDeTabV];
}

//创建我的控制器的tableView
- (void)creatWoDeTabV
{
    _woDeTabV = [[UITableView alloc]initWithFrame:self.view.frame style:UITableViewStylePlain];
    _woDeTabV.delegate = self;
    _woDeTabV.dataSource = self;
    _woDeTabV.separatorStyle = UITableViewCellSeparatorStyleNone;
    _woDeTabV.showsVerticalScrollIndicator = NO;
    //注册各种cell
    [_woDeTabV registerNib:[UINib nibWithNibName:@"ZX_WoDe_TableViewCell1" bundle:nil] forCellReuseIdentifier:@"ZX_WoDe_TableViewCell1"];
    [_woDeTabV registerNib:[UINib nibWithNibName:@"ZX_WoDe_TableViewCell2" bundle:nil] forCellReuseIdentifier:@"ZX_WoDe_TableViewCell2"];
    [_woDeTabV registerNib:[UINib nibWithNibName:@"ZX_WoDe_TableViewCell3" bundle:nil] forCellReuseIdentifier:@"ZX_WoDe_TableViewCell3"];
    [_woDeTabV registerNib:[UINib nibWithNibName:@"ZX_WoDe_TableViewCell4" bundle:nil] forCellReuseIdentifier:@"ZX_WoDe_TableViewCell4"];
    [_woDeTabV registerNib:[UINib nibWithNibName:@"ZX_WoDe_TableViewCell5" bundle:nil] forCellReuseIdentifier:@"ZX_WoDe_TableViewCell5"];
    _woDeTabV.backgroundColor = ZX_BG_COLOR;
    [self.view addSubview:_woDeTabV];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0)
    {
        return 120;
    }
    else if (indexPath.row == 1)
    {
        return 100;
    }
    else if (indexPath.row == 2)
    {
        return 200;
    }
    else if (indexPath.row == 3)
    {
        return 213;
    }
    else
    {
        return 264;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0)
    {
        ZX_WoDe_TableViewCell1 *cell = [_woDeTabV dequeueReusableCellWithIdentifier:@"ZX_WoDe_TableViewCell1" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if ([ZXUD boolForKey:@"IS_LOGIN"])
        {
            cell.dengLuLab.hidden = YES;
            cell.yongHuMingLab.hidden = NO;
            cell.shouJiHaoLab.hidden = NO;
            if ([[ZXUD objectForKey:@"username"] isKindOfClass:[NSString class]])
            {
                cell.yongHuMingLab.text = [ZXUD objectForKey:@"username"];
            }
            else
            {
                if ([[ZXUD objectForKey:@"phoneNum"] isKindOfClass:[NSString class]])
                {
                    cell.yongHuMingLab.text = [NSString stringWithFormat:@"%@****%@",[[ZXUD objectForKey:@"phoneNum"] substringWithRange:NSMakeRange(0, 3)],[[ZXUD objectForKey:@"phoneNum"] substringWithRange:NSMakeRange(7, 4)]];
                }
                else
                {
                    cell.yongHuMingLab.text = @"";
                }
            }
            if ([ZXUD objectForKey:@"userpic"])
            {
                [cell.yongHuTouXiangImg sd_setImageWithURL:[ZXUD objectForKey:@"userpic"] placeholderImage:[UIImage imageNamed:@"touxiang"]];
            }
            else
            {
                cell.yongHuTouXiangImg.image = [UIImage imageNamed:@"touxiang"];
            }
            if ([[ZXUD objectForKey:@"phoneNum"] isKindOfClass:[NSString class]])
            {
                cell.shouJiHaoLab.text =[NSString stringWithFormat:@"%@****%@",[[ZXUD objectForKey:@"phoneNum"] substringWithRange:NSMakeRange(0, 3)],[[ZXUD objectForKey:@"phoneNum"] substringWithRange:NSMakeRange(7, 4)]];
            }
            else
            {
                cell.shouJiHaoLab.text = @"";
            }
        }
        else
        {
            cell.dengLuLab.hidden = NO;
            cell.yongHuMingLab.hidden = YES;
            cell.shouJiHaoLab.hidden = YES;
            cell.shouJiHaoLab.text = @"";
            cell.yongHuTouXiangImg.image = [UIImage imageNamed:@"touxiang"];
        }
        return cell;
    }
    else if (indexPath.row == 1)
    {
        ZX_WoDe_TableViewCell2 *cell = [_woDeTabV dequeueReusableCellWithIdentifier:@"ZX_WoDe_TableViewCell2" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        _keErKeShiLab = cell.keErKeShiLab;
        _keSanKeShiLab = cell.keSanKeShiLab;
        if (![ZXUD boolForKey:@"IS_LOGIN"])
        {
            _keErKeShiLab.hidden = YES;
            _keSanKeShiLab.hidden = YES;
        }
        else
        {
            _keErKeShiLab.hidden = NO;
            _keSanKeShiLab.hidden = NO;
            
            if (!_isData)
            {
                _keErKeShiLab.text = @"";
                _keSanKeShiLab.text = @"";
            }
        }
        return cell;
    }
    else if (indexPath.row == 2)
    {
        ZX_WoDe_TableViewCell3 *cell = [_woDeTabV dequeueReusableCellWithIdentifier:@"ZX_WoDe_TableViewCell3" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell.chaKanQuanBuDingDanBtn addTarget:self action:@selector(chaKanDingDan:) forControlEvents:UIControlEventTouchUpInside];
        [cell.daiFuKuanBtn addTarget:self action:@selector(chaKanDingDan:) forControlEvents:UIControlEventTouchUpInside];
        [cell.weiShiYongBtn addTarget:self action:@selector(chaKanDingDan:) forControlEvents:UIControlEventTouchUpInside];
        [cell.yiTuiKuanBtn addTarget:self action:@selector(chaKanDingDan:) forControlEvents:UIControlEventTouchUpInside];
        [cell.woDeQianBao addTarget:self action:@selector(woDeYouHuiQuan) forControlEvents:UIControlEventTouchUpInside];
        cell.chaKanQuanBuDingDanBtn.tag = 100;
        cell.daiFuKuanBtn.tag = 101;
        cell.weiShiYongBtn.tag = 102;
        cell.yiTuiKuanBtn.tag = 103;
        return cell;
    }
    else if (indexPath.row == 3)
    {
        ZX_WoDe_TableViewCell4 *cell = [_woDeTabV dequeueReusableCellWithIdentifier:@"ZX_WoDe_TableViewCell4" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        _woDeJiaXiaoLab = cell.xuanZeLab1;
        _woDeJiaoLianLab = cell.xuanZeLab2;
        [cell.woDeJiaXiaoBtn addTarget:self action:@selector(woDeJiaXiao) forControlEvents:UIControlEventTouchUpInside];
        [cell.woDeJiaoLianBtn addTarget:self action:@selector(woDeJiaoLian) forControlEvents:UIControlEventTouchUpInside];
        [cell.woDeKeChengBtn addTarget:self action:@selector(woDeKeCheng) forControlEvents:UIControlEventTouchUpInside];
        [cell.kaoShiJiLuBtn addTarget:self action:@selector(kaoShiJiLu) forControlEvents:UIControlEventTouchUpInside];
        if ([ZXUD boolForKey:@"IS_LOGIN"])
        {
            cell.xuanZeLab2.text = [ZXUD objectForKey:@"T_NAME"];
        }
        else
        {
            cell.xuanZeLab2.text = @"";
        }
        if ([ZXUD boolForKey:@"IS_LOGIN"])
        {
            cell.xuanZeLab1.text = [ZXUD objectForKey:@"S_NAME"];
        }
        else
        {
            cell.xuanZeLab1.text = @"";
        }
        return cell;
    }
    else
    {
        ZX_WoDe_TableViewCell5 *cell = [_woDeTabV dequeueReusableCellWithIdentifier:@"ZX_WoDe_TableViewCell5" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell.saoYiSaoBtn addTarget:self action:@selector(saoYiSao) forControlEvents:UIControlEventTouchUpInside];
        [cell.woDeHeTongBtn addTarget:self action:@selector(woDeHeTong) forControlEvents:UIControlEventTouchUpInside];
        [cell.woTuiJianDeHaoYouBtn addTarget:self action:@selector(woTuiJianDeHaoYou) forControlEvents:UIControlEventTouchUpInside];
        [cell.woDeFenXiangBtn addTarget:self action:@selector(woDeFenXiang) forControlEvents:UIControlEventTouchUpInside];
        [cell.xiTongSheZhiBtn addTarget:self action:@selector(xiTongSheZhi) forControlEvents:UIControlEventTouchUpInside];
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0)
    {
        /**
         未登录的时候跳转的页面
         */
        if (![ZXUD boolForKey:@"IS_LOGIN"])
        {
            [self login];
        }
        else
        {
            //已经登录
            ZXPersonalDataTableViewController *personDataTableVC = [[ZXPersonalDataTableViewController alloc] init];
            [self.navigationController pushViewController:personDataTableVC animated:YES];
        }
    }
}

//订单
- (void)chaKanDingDan:(UIButton *)btn
{
    if ([ZXUD boolForKey:@"IS_LOGIN"])
    {
        ZX_OrderList_ViewController *orderListVC = [[ZX_OrderList_ViewController alloc]init];
        
        if (btn.tag == 100)
        {
            orderListVC.title = @"全部订单";
            [ZXUD setObject:@"0" forKey:@"orderStatus"];
        }
        else if (btn.tag == 101)
        {
            orderListVC.title = @"待付款";
            [ZXUD setObject:@"1" forKey:@"orderStatus"];
        }
        else if (btn.tag == 102)
        {
            orderListVC.title = @"待使用";
            [ZXUD setObject:@"2" forKey:@"orderStatus"];
        }
        else if (btn.tag == 103)
        {
            orderListVC.title = @"已退款";
            [ZXUD setObject:@"4" forKey:@"orderStatus"];
        }
        [ZXUD synchronize];
        [self.navigationController pushViewController:orderListVC animated:YES];
    }
    else
    {
        [self login];
    }
}

//我的钱包
- (void)woDeYouHuiQuan
{
    if ([ZXUD boolForKey:@"IS_LOGIN"])
    {
        ZX_YouHuiQuan_ViewController *youHuiQuanVC =[[ZX_YouHuiQuan_ViewController alloc]init];
        youHuiQuanVC.list = @"1";
        [self.navigationController pushViewController:youHuiQuanVC animated:YES];
    }
    else
    {
        [self login];
    }
}

//跳转到我的驾校
- (void)woDeJiaXiao
{
    if ([ZXUD boolForKey:@"IS_LOGIN"])
    {
        if ([[ZXUD objectForKey:@"S_NAME"] isEqualToString:@""])
        {
            [MBProgressHUD showSuccess:@"您还没有报名驾校哦"];
            NearbySchoolVC *VC = [[NearbySchoolVC alloc]init];
            VC.city = [ZXUD objectForKey:@"city"];
            [self.navigationController pushViewController:VC animated:YES];
        }
        else
        {
            SchoolDetailVC *VC = [[SchoolDetailVC alloc]init];
            VC.schoolName = [ZXUD objectForKey:@"S_NAME"];
            VC.sid = [ZXUD objectForKey:@"S_ID"];
            [self.navigationController pushViewController:VC animated:YES];
        }
    }
    else
    {
        [self login];
    }
}

//跳转到我的教练
- (void)woDeJiaoLian
{
    if ([ZXUD boolForKey:@"IS_LOGIN"])
    {
        if ([[ZXUD objectForKey:@"S_NAME"] isEqualToString:@""])
        {
            [MBProgressHUD showSuccess:@"您还没有报名驾校哦"];
        }
        else
        {
            ZX_WoDeJiaoLian_ViewController *woDeJiaoLianVC = [[ZX_WoDeJiaoLian_ViewController alloc] init];
            [self.navigationController pushViewController:woDeJiaoLianVC animated:YES];
        }
    }
    else
    {
        [self login];
    }
}

//跳转到我的课程
- (void)woDeKeCheng
{
    if ([ZXUD boolForKey:@"IS_LOGIN"])
    {
        ZX_MyClass_ViewController *myClassVC = [[ZX_MyClass_ViewController alloc]init];
        [self.navigationController pushViewController:myClassVC animated:YES];
    }
    else
    {
        [self login];
    }
}

//跳转到考试记录
- (void)kaoShiJiLu
{
    if ([ZXUD boolForKey:@"IS_LOGIN"])
    {
        ZX_KaoShiJiLu_ViewController *kaoShiJiLuVC = [[ZX_KaoShiJiLu_ViewController alloc]init];
        [self.navigationController pushViewController:kaoShiJiLuVC animated:YES];
    }
    else
    {
        [self login];
    }
}

//跳转到扫一扫
- (void)saoYiSao
{
    if ([ZXUD boolForKey:@"IS_LOGIN"])
    {
        saoYiSaoVC *vc = [[saoYiSaoVC alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
    }
    else
    {
        [self login];
    }

}

//跳转到我的合同
- (void)woDeHeTong
{
    if ([ZXUD boolForKey:@"IS_LOGIN"])
    {
        ZX_WoDeHeTong_ViewController *woDeHeTongVC = [[ZX_WoDeHeTong_ViewController alloc]init];
        [self.navigationController pushViewController:woDeHeTongVC animated:YES];
    }
    else
    {
        [self login];
    }
}

//跳转到我推荐的好友
- (void)woTuiJianDeHaoYou
{
    if ([ZXUD boolForKey:@"IS_LOGIN"])
    {
        ZX_WoTuiJianDeHaoYou_ViewController *woTuiJianDeHaoYouVC = [[ZX_WoTuiJianDeHaoYou_ViewController alloc]init];
        [self.navigationController pushViewController:woTuiJianDeHaoYouVC animated:YES];
    }
    else
    {
        [self login];
    }
}

//我的分享
- (void)woDeFenXiang
{
    [self myShare];
}

//跳转到系统设置
- (void)xiTongSheZhi
{
    ZX_SheZhi_ViewController *xiTongSheZhiVC = [[ZX_SheZhi_ViewController alloc]init];
    [self.navigationController pushViewController:xiTongSheZhiVC animated:YES];
}
         
//跳转到登录界面
- (void)login
{
    ZX_Login_ViewController *loginVC = [[ZX_Login_ViewController alloc]init];
    [self.navigationController pushViewController:loginVC animated:YES];
}

// 查看学员信息
- (void)chaKanXueYuanXinXiData
{
    [[ZXNetDataManager manager5] chaKanXueYuanXinXiDataWithRndstring:[ZXDriveGOHelper getCurrentTimeStamp] andIdent_code:[ZXUD objectForKey:@"ident_code"] success:^(NSURLSessionDataTask *task, id responseObject)
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
             YZLog(@"jso n解析失败：%@",err);
         }
         
         if([[ZXwangLuoDanLi WangLuoDanLi] resIsTrue:jsonDict andAlertView:self])
         {
             //保存用户的登录状态
             NSDictionary *dict = [jsonDict objectForKey:@"info"][0];
             //程序启动就判断用户的登录状态，保存用户的基本信息
             [ZXUD setObject:dict[@"nickname"] forKey:@"username"];
             [ZXUD setObject:dict[@"area"] forKey:@"area"];
             [ZXUD setObject:dict[@"name"] forKey:@"userRealName"];
             [ZXUD setObject:dict[@"tid"] forKey:@"T_ID"];
             [ZXUD setObject:dict[@"tid2"] forKey:@"T_ID2"];
             [ZXUD setObject:dict[@"tid3"] forKey:@"T_ID3"];
             [ZXUD setObject:dict[@"sid"] forKey:@"S_ID"];
             [ZXUD setObject:dict[@"school_name"] forKey:@"S_NAME"];
             [ZXUD setObject:dict[@"teacher_name"] forKey:@"T_NAME"];
             [ZXUD setObject:dict[@"teacher_name2"] forKey:@"T_NAME2"];
             [ZXUD setObject:dict[@"teacher_name3"] forKey:@"T_NAME3"];
             [ZXUD setObject:dict[@"subject"] forKey:@"usersubject"];
             [ZXUD setObject:dict[@"id_card"] forKey:@"id_card"];
             [ZXUD setObject:dict[@"phone"] forKey:@"phoneNum"];
             [ZXUD setObject:dict[@"pic"] forKey:@"userpic"];
             [ZXUD setBool:[dict[@"gender"] boolValue] forKey:@"sex"];
             [ZXUD setObject:dict[@"teacher_comment2"] forKey:@"T_C2"];
             [ZXUD setObject:dict[@"teacher_comment3"] forKey:@"T_C3"];
             [ZXUD setObject:dict[@"school_comment"] forKey:@"S_C"];
             [ZXUD synchronize];
             if ([dict[@"teacher_name"] isKindOfClass:[NSString class]] && [dict[@"teacher_name"] length]>0)
             {
                  _woDeJiaoLianLab.text=dict[@"teacher_name"];
             }
             
             NSInteger class2 = [dict[@"total_class2"] integerValue] - [dict[@"book_class2"] integerValue];
             NSInteger class3 = [dict[@"total_class3"] integerValue] - [dict[@"book_class3"] integerValue];
             _keErKeShiLab.text = [NSString stringWithFormat:@"%ld / %@ / %@",(long)class2,dict[@"book_class2"],dict[@"total_class2"]];
             _keSanKeShiLab.text = [NSString stringWithFormat:@"%ld / %@ / %@",(long)class3,dict[@"book_class3"],dict[@"total_class3"]];
             _isData = YES;
             
             //友盟社区登录
             UMComLoginUser *userAccount = [[UMComLoginUser alloc] init];
             
             userAccount.userNameType = userNameNoRestrict;
             if ([dict[@"nickname"] length]>0)
             {
                 if ([dict[@"nickname"] isEqualToString:dict[@"phone"]])
                 {
                     userAccount.name=[NSString stringWithFormat:@"%@****%@",[dict[@"phone"] substringWithRange:NSMakeRange(0, 3)],[dict[@"phone"] substringWithRange:NSMakeRange(7, 4)]];
                 }
                 else
                 {
                     userAccount.name = dict[@"nickname"];
                 }
             }
             else
             {
                 userAccount.name=[NSString stringWithFormat:@"%@****%@",[dict[@"phone"] substringWithRange:NSMakeRange(0, 3)],[dict[@"phone"] substringWithRange:NSMakeRange(7, 4)]];
             }
             userAccount.updatedProfile=YES;
             userAccount.usid = [ZXUD objectForKey:@"phoneNum"];
             if ([dict[@"gender"] isEqualToString:@"0"])
             {
                 userAccount.gender = [NSNumber numberWithInt:1];//性别，0-女 1-男
             }
             else
             {
                 userAccount.gender = [NSNumber numberWithInt:0];//性别，0-女 1-男
             }
             
             UMComDataRequestManager *request = [UMComDataRequestManager defaultManager];
             [request updateProfileWithName:userAccount.name age:[[NSNumber alloc] initWithInt:18] gender:userAccount.gender custom:@"" userNameType:userNameNoRestrict userNameLength:userNameLengthNoRestrict completion:^(NSDictionary *responseObject, NSError *error)
              {
                  if (error)
                  {

                  }
                  else
                  {
                      [UMComLoginManager userLogout];
                      [UMComLoginManager requestLoginWithLoginAccount:userAccount requestCompletion:^(NSDictionary *responseObject, NSError *error, dispatch_block_t callbackCompletion) {
                          if (error)
                          {
                              
                          }
                          else
                          {
                              [[UMComDataRequestManager defaultManager] fetchConfigDataWithCompletion:^(NSDictionary *responseObject, NSError *error) {
                              }];
                          }
                      }];
                  }
              }];
         }
         [_woDeTabV reloadData];
         
     }failed:^(NSURLSessionTask *task, NSError *error)
     {
         [MBProgressHUD hideHUD];
     }];
}

//分享
- (void)myShare
{
    //1、创建分享参数
    NSArray* imageArray = @[[UIImage imageNamed:@"图标"]];
    //（注意：图片必须要在Xcode左边目录里面，名称必须要传正确，如果要分享网络图片，可以这样传iamge参数 images:@[@"http://mob.com/Assets/images/logo.png?v=20150320"]）
    if (imageArray)
    {
        NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
        [shareParams SSDKSetupShareParamsByText:@"一款解决了人与车之间各种难题的好软件，赶快推荐给好友吧" images:imageArray url:[NSURL URLWithString:@"http://www.youzhaola.com/index.php?m=student"] title:@"好东西分享给我关心的人" type:SSDKContentTypeAuto];
        //2、分享（可以弹出我们的分享菜单和编辑界面）
        //要显示菜单的视图, iPad版中此参数作为弹出菜单的参照视图，只有传这个才可以弹出我们的分享菜单，可以传分享的按钮对象或者自己创建小的view 对象，iPhone可以传nil不会影响
        [ShareSDK showShareActionSheet:nil items:nil shareParams:shareParams onShareStateChanged:^(SSDKResponseState state, SSDKPlatformType platformType, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error, BOOL end)
         {
             switch (state)
             {
                 case SSDKResponseStateSuccess:
                 {
                     UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"分享成功" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
                     [alertView show];
                     break;
                 }
                 case SSDKResponseStateFail:
                 {
                     UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"分享失败" message:[NSString stringWithFormat:@"%@",error] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                     [alert show];
                     break;
                 }
                 default:
                     break;
             }
         }
         ];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end

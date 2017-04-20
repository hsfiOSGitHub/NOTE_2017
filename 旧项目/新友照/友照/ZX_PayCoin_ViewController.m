//
//  ZX_PayCoin_ViewController.m
//  友照
//
//  Created by cleloyang on 2016/11/26.
//  Copyright © 2016年 ZX_XPH. All rights reserved.
//

#import "ZX_PayCoin_ViewController.h"
#import <AlipaySDK/AlipaySDK.h>
#import "ZX_GouMaiMoNiKa_ViewController.h"
#import "WXApi.h"
#import "DataMD5.h"
#import "ZXCarDetailControllerVC.h"
#import "ZXKeSanOrderDetailVC.h"
#import "ZX_OrderList_ViewController.h"
#import "ZXCarDetailControllerVC.h"
#import "zhu_ye_ViewController.h"
//支付类型
typedef NS_ENUM(NSInteger, ZXPaySortType)
{
    ZXPaySortTypeAliPay = 100,//支付宝
    ZXPaySortTypeWeiXi,//微信
};

@interface ZX_PayCoin_ViewController ()<WXApiDelegate>
//支付方式
@property (nonatomic, assign) ZXPaySortType paySortType;

@property (nonatomic, copy) NSArray <UIButton *> *btnsArr;
//微信支付参数
@property (nonatomic, strong) NSDictionary *WXDic;
//测试
@property (nonatomic, strong) NSString * str;
@property (nonatomic, copy) NSString *resultStatus;
@end

@implementation ZX_PayCoin_ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationController.navigationBar.barTintColor = dao_hang_lan_Color;
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"fanhui"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStyleDone target:self action:@selector(goToBack)];
    self.view.backgroundColor = ZX_BG_COLOR;
    self.title = @"付款";
    [self PaymentCountDown];
    _gouMaiPriceLab.text = [NSString stringWithFormat:@"%@ 元",_payPrice];
    _zhiFuBaoImg.layer.cornerRadius = 20;
    _zhiFuBaoImg.layer.masksToBounds = YES;
    //默认支付类型是支付宝
    _paySortType = ZXPaySortTypeAliPay;
    [_selectZFBtn setImage:[UIImage imageNamed:@"对"] forState:UIControlStateNormal];
    _selectZFBtn.tag = ZXPaySortTypeAliPay;
    _selectZFBtn.layer.cornerRadius = 15;
    _selectZFBtn.layer.masksToBounds = YES;
    _selectZFBtn.layer.borderWidth = 1;
    _selectZFBtn.layer.borderColor = [UIColor lightGrayColor].CGColor;
    [_selectZFBtn addTarget:self action:@selector(choosePaySort:) forControlEvents:UIControlEventTouchUpInside];
    
    _selectWXBtn.tag = ZXPaySortTypeWeiXi;
    _selectWXBtn.layer.cornerRadius = 15;
    _selectWXBtn.layer.borderWidth = 1;
    _selectWXBtn.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _selectWXBtn.layer.masksToBounds = YES;
    [_selectWXBtn addTarget:self action:@selector(choosePaySort:) forControlEvents:UIControlEventTouchUpInside];
    
    _confirmPayBtn.layer.cornerRadius = 6;
    _confirmPayBtn.layer.masksToBounds = YES;
    [_confirmPayBtn addTarget:self action:@selector(confirmPay:) forControlEvents:UIControlEventTouchDown];
    
    //将支付选择按钮放在数组，便于修改扩充
    _btnsArr = @[_selectZFBtn,_selectWXBtn];
    
    //订单类型
    if ([_froms isEqualToString:@"1"])
    {
        _gouMaiLeiXingLab.text = @"科二模拟卡劵";
    }
    else if([_froms isEqualToString:@"12"])
    {
        _gouMaiLeiXingLab.text = @"科二课时";
    }
    else if([_froms isEqualToString:@"13"])
    {
        _gouMaiLeiXingLab.text = @"科三课时";
    }
    else if([_froms isEqualToString:@"2"])
    {
        _gouMaiLeiXingLab.text = @"科三模拟包车";
    }
    else if([_froms isEqualToString:@"101"])
    {
        _gouMaiLeiXingLab.text = @"科目一补考费";
    }
    else if([_froms isEqualToString:@"102"])
    {
        _gouMaiLeiXingLab.text = @"科目二补考费";
    }
    else if([_froms isEqualToString:@"103"])
    {
        _gouMaiLeiXingLab.text = @"科目三补考费";
    }
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(paySuccess:) name:@"NFPaySuccess" object:nil];
}

- (void)goToBack
{
    for (UIViewController* VC in self.navigationController.viewControllers)
    {
        if ([VC isKindOfClass:[ZX_GouMaiMoNiKa_ViewController class]])
        {
            [self.navigationController popToViewController:VC animated:YES];
            return;
        }
        if ([VC isKindOfClass:[ZX_OrderList_ViewController class]])
        {
            [self.navigationController popToViewController:VC animated:YES];
            return;
        }
        if ([VC isKindOfClass:[ZXCarDetailControllerVC class]])
        {
            [self.navigationController popToViewController:VC animated:YES];
            return;
        }
        if (_fromBuKaoJiaoFei)
        {
            if ([VC isKindOfClass:[zhu_ye_ViewController class]])
            {
                [self.navigationController popToViewController:VC animated:YES];
                return;
            }
        }
    }
}

//付款倒计时
- (void)PaymentCountDown
{
    //获取服务器的时间
    //获取当前日期
//    NSDate* date = [NSDate date];
//    //获取订单日期
//    NSDateFormatter *inputFormatter= [[NSDateFormatter alloc] init];
//    [inputFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"]];
//    [inputFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
//    NSDate *inputDate = [inputFormatter dateFromString:_riQi];
//    NSTimeInterval timeBetween = [date timeIntervalSinceDate:inputDate];
    //如果服务器返回的服务器时间和订单时间差如果大于600过期，小于600  _miao=时间差
    if (_fromOrderList)
    {
        //科三传过来的
        _miao = _timebetween;
    }
    else
    {
        if (!_fukuan)
        {
            _miao = 600 - _timebetween;
        }
        else
        {
            _miao = _timebetween;
        }
    }
    //进行比对，开始倒计时，如果分钟达到的话停止倒计时
    //定时器
    _myTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(PaymentCountDownStart) userInfo:nil repeats:YES];
}

//定时器启动
- (void)PaymentCountDownStart
{
    //计时结束，计时器停止
    if (_miao == 0)
    {
        //关闭定时器
        [_myTimer setFireDate:[NSDate distantFuture]];
        
        for (UIViewController* VC in self.navigationController.viewControllers)
        {
            if ([VC isKindOfClass:[ZX_GouMaiMoNiKa_ViewController class]])
            {
                [self.navigationController popToViewController:VC animated:YES];
            }
        }
    }
    else if(_miao > 0)
    {
        _miao --;
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:[NSString stringWithFormat:@"%ld:%02ld",(long)_miao/60,(long)_miao%60] style:UIBarButtonItemStylePlain target:self action:@selector(gotoedit)];
        self.navigationItem.rightBarButtonItem.tintColor = [UIColor whiteColor];
    }
}

-(void)gotoedit
{
    
}

//选择支付类型
- (void)choosePaySort:(UIButton *)btn
{
    //将数组按钮的图片置空
    for (UIButton *btn in _btnsArr)
    {
        [btn setImage:nil forState:UIControlStateNormal];
    }
    [btn setImage:[UIImage imageNamed:@"对"] forState:UIControlStateNormal];
    //通过tag值传递支付类型
    _paySortType = btn.tag;
}

//dealloc方法
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"NFPaySuccess" object:nil];
}

//确认支付
- (void)confirmPay:(UIButton *)btn
{
    _confirmPayBtn.userInteractionEnabled = NO;
    if (_paySortType == ZXPaySortTypeAliPay)
    {
        [self ZFBZhiFuData];
    }
    
    else if(_paySortType == ZXPaySortTypeWeiXi)
    {
        [self WXZhiFuData];
    }
}

//支付宝支付
- (void)ZFBZhiFuData
{
    [[ZXNetDataManager manager] confirmZFBPayDataWithOrder_id:_orderId andRndstring:[ZXDriveGOHelper getCurrentTimeStamp] andIdent_code:[ZXUD objectForKey:@"ident_code"] andFroms:_froms andPay_type:@"alipay" success:^(NSURLSessionDataTask *task, id responseObject)
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
         _confirmPayBtn.userInteractionEnabled = YES;
         if([[ZXwangLuoDanLi WangLuoDanLi] resIsTrue:jsonDict andAlertView:self])
         {
             _str = jsonDict[@"result"];
             NSString *orderString = _str;
             NSString *appScheme = @"ZXYouZhaoApp";
             //调用支付宝接口,发起支付请求
             [[AlipaySDK defaultService] payOrder:orderString fromScheme:appScheme callback:^(NSDictionary *resultDic)
              {
                  //支付成功
                  YZLog(@"reslut = %@",resultDic);
                  //较高级别安全验证支付成功与否,需要与服务器再进行一次验证
                  self.resultStatus = [resultDic objectForKey:@"resultStatus"];
                  
                  ZX_OrderList_ViewController *orderListVC = [[ZX_OrderList_ViewController alloc]init];
                  
                  if ([_resultStatus isEqualToString:@"6001"])
                  {
                      [ZXUD setObject:@"1" forKey:@"orderStatus"];
                      orderListVC.title = @"待付款";
                  }
                  else if ([_resultStatus isEqualToString:@"9000"])
                  {
                      if ([_froms isEqualToString:@"101"] || [_froms isEqualToString:@"102"] || [_froms isEqualToString:@"103"])
                      {
                          [ZXUD setObject:@"0" forKey:@"orderStatus"];
                          orderListVC.title = @"全部订单";
                      }
                      else
                      {
                          [ZXUD setObject:@"2" forKey:@"orderStatus"];
                          orderListVC.title = @"待使用";
                      }
                  }
                  [self.navigationController pushViewController:orderListVC animated:YES];
              }];
         }
     }failed:^(NSURLSessionTask *task, NSError *error)
     {
         [MBProgressHUD showSuccess:@"网络不好，请稍后重试。"];
         YZLog(@"向后台提交订单支付失败");
     }];
}

//微信支付
- (void)WXZhiFuData
{
    [[ZXNetDataManager manager] confirmWXPayDataWithOrder_id:_orderId andRndString:[ZXDriveGOHelper getCurrentTimeStamp] andIdent_code:[ZXUD objectForKey:@"ident_code"] andFroms:_froms andPayType:@"wechatpay" success:^(NSURLSessionDataTask *task, id responseObject)
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
             NSArray *dataArr = jsonDict[@"data"];
             _WXDic = dataArr.firstObject;
             if ([_WXDic[@"result_code"]isEqualToString:@"SUCCESS"])
             {
                 [self weixinPay];
             }
         }
     }failed:^(NSURLSessionTask *task, NSError *error)
     {
         [MBProgressHUD showSuccess:@"网络不好，请稍后重试。"];
         YZLog(@"微信调起失败");
     }];
}

//调起微信支付
- (void)weixinPay
{
    //调起微信支付
    PayReq * req = [[PayReq alloc] init];
    /** 商家向财付通申请的商家id */
    req.partnerId = @"1338857201";
    /** 预支付订单 */
    req.prepayId = self.WXDic[@"prepay_id"];
    /** 随机串，防重发 */
    req.nonceStr = self.WXDic[@"nonce_str"];
    /** 时间戳，防重发 */
    NSUInteger time = [[ZXDriveGOHelper getCurrentTimeStamp] integerValue];
    req.timeStamp = (UInt32)time;
    YZLog(@"%lu", (unsigned long)time);
    /** 商家根据财付通文档填写的数据和签名 */
    req.package = @"Sign=WXPay";
    /** 商家根据微信开放平台文档对数据做的签名 */
    req.sign = self.WXDic[@"sign"];
    DataMD5 *md5 = [[DataMD5 alloc] init];
    req.sign = [md5 createMD5SingForPay:@"wxe120920b1ec6d0c4" partnerid:req.partnerId prepayid:req.prepayId package:req.package noncestr:req.nonceStr timestamp:req.timeStamp];
    //调用微信客户端
    if(![WXApi sendReq:req])
    {
        [MBProgressHUD showSuccess:@"没有微信客户端，请选支付宝"];
    }
    _confirmPayBtn.userInteractionEnabled = YES;
}

//客户端支付成功返回APP
- (void)paySuccess:(NSNotification *)notification
{
    NSDictionary *dict = [notification userInfo];
    if ([[dict objectForKey:@"result"] isEqualToString:@"9000"] || [[dict objectForKey:@"result"] isEqualToString:@"1"])
    {
        ZX_OrderList_ViewController *orderListVC = [[ZX_OrderList_ViewController alloc]init];
        if ([_froms isEqualToString:@"101"] || [_froms isEqualToString:@"102"] || [_froms isEqualToString:@"103"])
        {
            [ZXUD setObject:@"0" forKey:@"orderStatus"];
            orderListVC.title = @"全部订单";
        }
        else
        {
            [ZXUD setObject:@"2" forKey:@"orderStatus"];
            orderListVC.title = @"待使用";
        }
        [self.navigationController pushViewController:orderListVC animated:YES];
    }
    else if ([[dict objectForKey:@"result"] isEqualToString:@"6001"] || [[dict objectForKey:@"result"] isEqualToString:@"2"])
    {
        ZX_OrderList_ViewController *orderListVC = [[ZX_OrderList_ViewController alloc]init];
        [ZXUD setObject:@"1" forKey:@"orderStatus"];
        orderListVC.title = @"待付款";
        [self.navigationController pushViewController:orderListVC animated:YES];
    }
        
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end

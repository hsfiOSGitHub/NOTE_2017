//
//  ZX_TiJiaoDingDan_ViewController.m
//  友照
//
//  Created by cleloyang on 2016/11/25.
//  Copyright © 2016年 ZX_XPH. All rights reserved.
//

#import "ZX_TiJiaoDingDan_ViewController.h"
#import "ZX_PayCoin_ViewController.h"
#import "ZX_YouHuiQuan_ViewController.h"

@interface ZX_TiJiaoDingDan_ViewController ()
//价格
@property (nonatomic, strong) UIView *priceView;
//驾校
@property (nonatomic, strong) UIView *jiaXiaoView;
//科目
@property (nonatomic, strong) UIView *keMuView;
//教练
@property (nonatomic, strong) UIView *jiaoLianView;
//购买数量
@property (nonatomic, strong) UIView *buyNumview;
@property (nonatomic, strong) UILabel *shuLiangLab;
//优惠券
@property (nonatomic, strong) UIView *youHuiQuanView;
//赠送数量
@property (nonatomic, strong) UIView *zengsongView;
//优惠活动
@property (nonatomic, strong) UIView *youhuiView;
//优惠活动
@property (nonatomic, strong) UIView *zongshuView;
//合计
@property (nonatomic, strong) UIView *totalView ;
//下完订单服务器返回的时间
@property (nonatomic, copy) NSString *fuqsj;
//合计花费钱数
@property (nonatomic, copy) NSString *totalPrice;
@property (nonatomic, strong) UILabel *totalPriceLab;

@property (nonatomic, strong) UILabel *youHuiLab;

@property (nonatomic, copy) NSString *orderID;
@property (nonatomic, strong) UIButton *dingDanBtn;
@property (nonatomic, copy) NSString *froms;
@end

@implementation ZX_TiJiaoDingDan_ViewController

-(void)viewWillAppear:(BOOL)animated
{
    _dingDanBtn.userInteractionEnabled = YES;
    if ((_money_discount != nil))
    {
        if ([_discount isEqualToString:@"1"])
        {
            _youHuiLab.text = [NSString stringWithFormat:@"优惠金额:%@ 元",_money_discount];
            _totalPriceLab.text = [NSString stringWithFormat:@"￥%0.2f元",_shuLiang * [_priceValue floatValue] - [_money_discount floatValue]];

        }
        else
        {
            _youHuiLab.text = [NSString stringWithFormat:@"优惠折扣:%@ 折",_money_discount];
            _totalPriceLab.text = [NSString stringWithFormat:@"￥%0.2f元", _shuLiang * [_priceValue floatValue]*[_money_discount floatValue]/10.00];
        }
    }
    else
    {
        _youHuiLab.text = @"";
        _totalPriceLab.text = [NSString stringWithFormat:@"￥%0.2f元",_shuLiang * [_priceValue floatValue]];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"提交订单";
    self.view.backgroundColor = ZX_BG_COLOR;
    if (![_goods_type isEqualToString:@"2"])
    {
        if (_cardNum && _cardNum == 0)
        {
            _shuLiang = 0;
        }
        else
        {
          _shuLiang = 1;
        }
    }
    
    _totalPrice = _priceValue;
    if (_boo)
    {
        [self keshi];
    }
    else
    {
        //科二和科三的提交订单界面不一样
        if([_goods_type isEqualToString:@"1"])
        {
            [self setKeErDingDanJieMian];
        }
        else if([_goods_type isEqualToString:@"2"])
        {
            [self setKeSanDingDanJieMian];
        }
        else
        {
            if ([_goods_type isEqualToString:@"12"])
            {
                //科目
                _keMuView = [self firstViewString:[NSString stringWithFormat:@"科目:"] andSecondView:[NSString stringWithFormat:@"科目二"] andframe:CGRectMake(0,161,KScreenWidth,40) andSuperView:self.view];
            }
            else
            {
                //科目
                _keMuView = [self firstViewString:[NSString stringWithFormat:@"科目:"] andSecondView:[NSString stringWithFormat:@"科目三"] andframe:CGRectMake(0,161,KScreenWidth,40) andSuperView:self.view];
            }
            [self keshi];
        }
    }
}

//课时
-(void)keshi
{
    //价格
    _priceView = [self firstViewString:[NSString stringWithFormat:@"价格:"] andSecondView:[NSString stringWithFormat:@"%@元/张",_priceValue] andframe:CGRectMake(0,70,KScreenWidth,40) andSuperView:self.view];
    
    //驾校
    _jiaXiaoView = [self firstViewString:[NSString stringWithFormat:@"驾校:"] andSecondView:[NSString stringWithFormat:@"%@",_jiaXiaoName] andframe:CGRectMake(0,120,KScreenWidth,40) andSuperView:self.view];
        
    //教练
    _jiaoLianView = [self firstViewString:[NSString stringWithFormat:@"教练:"] andSecondView:[NSString stringWithFormat:@"%@",_jiaoLianName] andframe:CGRectMake(0,202,KScreenWidth,40) andSuperView:self.view];
    
    //购买数量
    _buyNumview = [[UIView alloc] initWithFrame:CGRectMake(0,252,KScreenWidth,40)];
    _buyNumview.backgroundColor = [UIColor whiteColor];
    UILabel *lab = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, KScreenWidth/4, 40)];
    lab.text = @"购买数量";
    lab.textColor = ZX_Black_Color;
    [_buyNumview addSubview:lab];
    UIButton *jiaBtn = [[UIButton alloc]initWithFrame:CGRectMake(KScreenWidth-45, 5, 30, 30)];
    [jiaBtn setImage:[UIImage imageNamed:@"加"] forState:UIControlStateNormal];
    [_buyNumview addSubview:jiaBtn];
    UIButton *jianBtn = [[UIButton alloc]initWithFrame:CGRectMake(KScreenWidth-120, 5, 30, 30)];
    [jianBtn setImage:[UIImage imageNamed:@"减"] forState:UIControlStateNormal];
    [_buyNumview addSubview:jianBtn];
    _shuLiangLab = [[UILabel alloc] initWithFrame:CGRectMake(KScreenWidth-90, 0, 45, 40)];
    _shuLiangLab.textAlignment = NSTextAlignmentCenter;
    _shuLiangLab.text = [NSString stringWithFormat:@"%ld",(long)_shuLiang];
    _shuLiangLab.textColor = ZX_DarkGray_Color;
    [_buyNumview addSubview:_shuLiangLab];
    jiaBtn.tag = 100;
    jianBtn.tag = 101;
    [jiaBtn addTarget:self action:@selector(gouMaiShuLiang:) forControlEvents:UIControlEventTouchDown];
    [jianBtn addTarget:self action:@selector(gouMaiShuLiang:) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:_buyNumview];
    
    //优惠券
    _youhuiView = [self firstViewString:[NSString stringWithFormat:@"优惠券"] andSecondView:[NSString stringWithFormat:@""] andframe:CGRectMake(0,293,KScreenWidth,40) andSuperView:self.view];
    _youHuiLab = [[UILabel alloc]initWithFrame:CGRectMake(KScreenWidth/2, 0, KScreenWidth/2-30, 40)];
    _youHuiLab.text = @"";
    _youHuiLab.font = [UIFont systemFontOfSize:15];
    _youHuiLab.textColor = dao_hang_lan_Color;
    _youHuiLab.textAlignment = NSTextAlignmentRight;
    [_youhuiView addSubview:_youHuiLab];
    UIImageView *imgV = [[UIImageView alloc]initWithFrame:CGRectMake(KScreenWidth-30, 0, 30, 40)];
    imgV.contentMode = UIViewContentModeCenter;
    [imgV setImage:[UIImage imageNamed:@"下一步"]];
    [_youhuiView addSubview:imgV];
    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, 40)];
    [_youhuiView addSubview:btn];
    [btn addTarget:self action:@selector(selectYouHuiQuan) forControlEvents:UIControlEventTouchDown];

    //合计
    _totalView = [[UIView alloc]initWithFrame:CGRectMake(0,343,KScreenWidth,40)];
    _totalView.backgroundColor = [UIColor whiteColor];
    UILabel *lab2 = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, KScreenWidth/4, 40)];
    lab2.text = @"合计:";
    lab2.textColor = ZX_Black_Color;
    [_totalView addSubview:lab2];
    _totalPriceLab = [[UILabel alloc]initWithFrame:CGRectMake(KScreenWidth/2, 0, KScreenWidth/2-15, 40)];
    _totalPriceLab.textAlignment = NSTextAlignmentRight;
    _totalPriceLab.textColor = [UIColor orangeColor];
    _totalPriceLab.text = [NSString stringWithFormat:@"￥%0.2f元",[_priceValue floatValue]];
    [_totalView addSubview:_totalPriceLab];
    [self.view addSubview:_totalView];
    
    //提交按钮
    _dingDanBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, KScreenHeight - 60, KScreenWidth, 60)];
    [_dingDanBtn addTarget:self action:@selector(tiJiaoDingDanData) forControlEvents:UIControlEventTouchUpInside];
    [_dingDanBtn setTitle:@"提交订单" forState:UIControlStateNormal];
    [_dingDanBtn setBackgroundColor:[UIColor orangeColor]];
    _dingDanBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    _dingDanBtn.titleLabel.font = [UIFont systemFontOfSize: 17.0];
    [self.view addSubview:_dingDanBtn];
    
}

//科二模拟提交订单的界面
- (void)setKeErDingDanJieMian
{
    //价格
    _priceView = [self firstViewString:[NSString stringWithFormat:@"价格:"] andSecondView:[NSString stringWithFormat:@"%@元/张",_priceValue] andframe:CGRectMake(0,70,KScreenWidth,40) andSuperView:self.view];
    
    //考场
    _jiaXiaoView = [self firstViewString:[NSString stringWithFormat:@"考场:"] andSecondView:[NSString stringWithFormat:@"%@",_kaoChangName] andframe:CGRectMake(0,120,KScreenWidth,40) andSuperView:self.view];
    
    //科目
    _keMuView = [self firstViewString:[NSString stringWithFormat:@"科目:"] andSecondView:[NSString stringWithFormat:@"科目二"] andframe:CGRectMake(0,161,KScreenWidth,40) andSuperView:self.view];
    
    //购买数量
    _buyNumview = [[UIView alloc] initWithFrame:CGRectMake(0,212,KScreenWidth,40)];
    _buyNumview.backgroundColor = [UIColor whiteColor];
    UILabel *lab = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, KScreenWidth/4, 40)];
    lab.text = @"购买数量";
    lab.textColor = ZX_Black_Color;
    [_buyNumview addSubview:lab];
    UIButton *jiaBtn = [[UIButton alloc]initWithFrame:CGRectMake(KScreenWidth-45, 5, 30, 30)];
    [jiaBtn setImage:[UIImage imageNamed:@"加"] forState:UIControlStateNormal];
    [_buyNumview addSubview:jiaBtn];
    UIButton *jianBtn = [[UIButton alloc]initWithFrame:CGRectMake(KScreenWidth-120, 5, 30, 30)];
    [jianBtn setImage:[UIImage imageNamed:@"减"] forState:UIControlStateNormal];
    [_buyNumview addSubview:jianBtn];
    _shuLiangLab = [[UILabel alloc] initWithFrame:CGRectMake(KScreenWidth-90, 0, 45, 40)];
    _shuLiangLab.textAlignment = NSTextAlignmentCenter;
    _shuLiangLab.text = [NSString stringWithFormat:@"%ld",(long)_shuLiang];
    _shuLiangLab.textColor = ZX_DarkGray_Color;
    [_buyNumview addSubview:_shuLiangLab];
    jiaBtn.tag = 100;
    jianBtn.tag = 101;
    [jiaBtn addTarget:self action:@selector(gouMaiShuLiang:) forControlEvents:UIControlEventTouchDown];
    [jianBtn addTarget:self action:@selector(gouMaiShuLiang:) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:_buyNumview];
    
    //优惠券
    _youhuiView = [self firstViewString:[NSString stringWithFormat:@"优惠券"] andSecondView:[NSString stringWithFormat:@""] andframe:CGRectMake(0,253,KScreenWidth,40) andSuperView:self.view];
    _youHuiLab = [[UILabel alloc]initWithFrame:CGRectMake(KScreenWidth/2, 0, KScreenWidth/2-30, 40)];
    _youHuiLab.text = @"";
    _youHuiLab.font = [UIFont systemFontOfSize:15];
    _youHuiLab.textColor = dao_hang_lan_Color;
    _youHuiLab.textAlignment = NSTextAlignmentRight;
    [_youhuiView addSubview:_youHuiLab];
    UIImageView *imgV = [[UIImageView alloc]initWithFrame:CGRectMake(KScreenWidth-30, 0, 30, 40)];
    imgV.contentMode = UIViewContentModeCenter;
    [imgV setImage:[UIImage imageNamed:@"下一步"]];
    [_youhuiView addSubview:imgV];
    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, 40)];
    [_youhuiView addSubview:btn];
    [btn addTarget:self action:@selector(selectYouHuiQuan) forControlEvents:UIControlEventTouchDown];
    
    //合计
    _totalView = [[UIView alloc]initWithFrame:CGRectMake(0,303,KScreenWidth,40)];
    _totalView.backgroundColor = [UIColor whiteColor];
    UILabel *lab2 = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, KScreenWidth/4, 40)];
    lab2.text = @"合计:";
    lab2.textColor = ZX_Black_Color;
    [_totalView addSubview:lab2];
    _totalPriceLab = [[UILabel alloc]initWithFrame:CGRectMake(KScreenWidth/2, 0, KScreenWidth/2-15, 40)];
    _totalPriceLab.textAlignment = NSTextAlignmentRight;
    _totalPriceLab.textColor = [UIColor orangeColor];
    _totalPriceLab.text = [NSString stringWithFormat:@"￥%0.2f元",[_priceValue floatValue]];
    [_totalView addSubview:_totalPriceLab];
    [self.view addSubview:_totalView];
    
    //提交按钮
    _dingDanBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, KScreenHeight - 60, KScreenWidth, 60)];
    [_dingDanBtn addTarget:self action:@selector(tiJiaoDingDanData) forControlEvents:UIControlEventTouchUpInside];
    [_dingDanBtn setTitle:@"提交订单" forState:UIControlStateNormal];
    [_dingDanBtn setBackgroundColor:[UIColor orangeColor]];
    _dingDanBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    _dingDanBtn.titleLabel.font = [UIFont systemFontOfSize: 17.0];
    [self.view addSubview:_dingDanBtn];
}

//科三提交订单的界面
- (void)setKeSanDingDanJieMian
{
    //单价
    _priceView = [self firstViewString:[NSString stringWithFormat:@"价格(%@):",_baocheleixing] andSecondView:[NSString stringWithFormat:@"%@元",self.priceValue] andframe:CGRectMake(0,80,KScreenWidth,40) andSuperView:self.view];
    
    //数量
    _buyNumview = [self firstViewString:@"购买数量" andSecondView:[NSString stringWithFormat:@"%ld张",(long)_shuLiang] andframe:CGRectMake(0,122,KScreenWidth,40) andSuperView:self.view];
    
    //优惠活动
    _youhuiView = [self firstViewString:@"优惠活动" andSecondView:self.youhuihuodong andframe:CGRectMake(0,172,KScreenWidth,40) andSuperView:self.view];
    
    //赠送数量
    _zengsongView = [self firstViewString:@"赠送数量" andSecondView:self.zengsongshuliang andframe:CGRectMake(0,214,KScreenWidth,40) andSuperView:self.view];
    
    //总数量
    _zongshuView = [self firstViewString:@"总数" andSecondView:[NSString stringWithFormat:@"%ld张",(long)_shuLiang+[self.zengsongshuliang integerValue]] andframe:CGRectMake(0,264,KScreenWidth,40) andSuperView:self.view];
    
    //合计
    _totalView = [self firstViewString:@"合计" andSecondView:[NSString stringWithFormat:@"￥%0.2f元",(long)_shuLiang * [_priceValue floatValue]]  andframe:CGRectMake(0,306,KScreenWidth,40) andSuperView:self.view];
    
    //提交按钮
    _dingDanBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, KScreenHeight - 60, KScreenWidth, 60)];
    [_dingDanBtn addTarget:self action:@selector(keSanTiJiaoDingDanData) forControlEvents:UIControlEventTouchUpInside];
    [_dingDanBtn setTitle:@"提交订单" forState:UIControlStateNormal];
    [_dingDanBtn setBackgroundColor:[UIColor orangeColor]];
    _dingDanBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    _dingDanBtn.titleLabel.font = [UIFont systemFontOfSize: 17.0];
    [self.view addSubview:_dingDanBtn];
}

//设置商品的名称数量以及优惠活动和满几送几
- (UIView *)firstViewString:(NSString *)content andSecondView:(NSString *)secSrting andframe:(CGRect)rect andSuperView:(UIView *)view
{
    //父视图，为了显示价格数量和名称等等
    UIView *dyView = [[UIView alloc] initWithFrame:rect];
    dyView.backgroundColor=[UIColor whiteColor];
    //左边显示内容及控件的大小
    UILabel *firLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, (KScreenWidth-30)/2, 40)];
    firLabel.text = content;
    
    //右边显示内容及控件的大小
    UILabel *secLabel = [[UILabel alloc] initWithFrame:CGRectMake(KScreenWidth/2, 0, (KScreenWidth-30)/2, 40)];
    secLabel.text = secSrting;
    firLabel.textColor = ZX_Black_Color;
    if([content isEqualToString:@"合计:"])
    {
        secLabel.textColor = [UIColor orangeColor];
    }
    else
    {
        secLabel.textColor = ZX_DarkGray_Color;
    }
    secLabel.textAlignment = NSTextAlignmentRight;
    secLabel.tag = 1001;
    [dyView addSubview:firLabel];
    [dyView addSubview:secLabel];
    [view addSubview:dyView];
    return dyView;
}

//购买模拟卡数量加减调用的方法
-(void)gouMaiShuLiang:(UIButton*)btn
{
    switch (btn.tag)
    {
            //购买数量加一
        case 100:
            if ([_goods_type isEqualToString:@"1"])
            {
                if (_cardNum >= 4)
                {
                    if (_shuLiang < 4 )
                    {
                        _shuLiang ++;
                    }
                    else
                    {
                        [MBProgressHUD showSuccess:@"您一次性最多只能购买4张卡券哦"];
                    }
                }
                else
                {
                    
                    if (_shuLiang < _cardNum )
                    {
                        _shuLiang ++;
                    }
                    else
                    {
                        [MBProgressHUD showSuccess:@"剩余卡券数量不足"];
                    }
                }
            }
            else
            {
                _shuLiang ++;
            }
            _shuLiangLab.text = [NSString stringWithFormat:@"%ld",(long)_shuLiang];
            _totalPriceLab.text = [NSString stringWithFormat:@"￥%0.2f元",_shuLiang * [_priceValue floatValue]];
            break;
            //购买数量减一
        case 101:
            if (_shuLiang > 1)
            {
                _shuLiang --;
            }
            else
            {
                [MBProgressHUD showSuccess:@"您至少要购买一张卡券哦"];
            }
            _shuLiangLab.text = [NSString stringWithFormat:@"%ld",(long)_shuLiang];
            _totalPriceLab.text = [NSString stringWithFormat:@"￥%0.2f元",_shuLiang * [_priceValue floatValue]];
            break;
        default:
            break;
    }
}

//选择优惠券
- (void)selectYouHuiQuan
{
    ZX_YouHuiQuan_ViewController *youHuiQuanVC = [[ZX_YouHuiQuan_ViewController alloc]init];
    youHuiQuanVC.goodsType = _goods_type;
    youHuiQuanVC.goodsNum = _shuLiang;
    youHuiQuanVC.tiJiaoDingDanVC = self;
    youHuiQuanVC.price = _shuLiang * [_priceValue floatValue];
    if ([_goods_type isEqualToString:@"1"])
    {
        youHuiQuanVC.orderId = _productId;
    }
    [self.navigationController pushViewController:youHuiQuanVC animated:YES];
}

//提交订单
- (void)tiJiaoDingDanData
{
    [MBProgressHUD showSuccess:@"正在提交订单"];
    _dingDanBtn.userInteractionEnabled = NO;

    [[ZXNetDataManager manager]tiJiaoDingDanDataWithRndstring:[ZXDriveGOHelper getCurrentTimeStamp] andId:_productId andIdent_code:[ZXUD objectForKey:@"ident_code"] andGoods_type:_goods_type andNum:[NSString stringWithFormat:@"%ld", (long)_shuLiang] andDiscount_id:_discount_id success:^(NSURLSessionDataTask *task, id responseObject)
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
              _fuqsj = [NSString stringWithFormat:@"%@",jsonDict[@"data"][@"futime"]];
              _orderID = jsonDict[@"data"][@"order_id"];
              _froms = jsonDict[@"data"][@"froms"];
              [self goToPayCoinVC];
          }
    } failed:^(NSURLSessionTask *task, NSError *error)
     {
        
    }];
}

//科三提交订单
- (void)keSanTiJiaoDingDanData
{
    [MBProgressHUD showSuccess:@"正在提交订单"];
    [[ZXNetDataManager manager] keSanTiJiaoDingDanDataWithRndstring:[ZXDriveGOHelper getCurrentTimeStamp] andId:_productId andIdent_code:[ZXUD objectForKey:@"ident_code"] andFroms:_goods_type andNum:[NSString stringWithFormat:@"%ld张",(long)_shuLiang] success:^(NSURLSessionDataTask *task, id responseObject)
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
             _orderID = jsonDict[@"data"][@"order_id"];
             _froms = jsonDict[@"data"][@"froms"];
             [self goToPayCoinVC];
         }
     } failed:^(NSURLSessionTask *task, NSError *error)
     {
         [MBProgressHUD showSuccess:@"网络不好，请稍后重试。"];
     }];
}

//跳转到支付的界面去付款
- (void) goToPayCoinVC
{
    ZX_PayCoin_ViewController *payCoinVC = [[ZX_PayCoin_ViewController alloc]init];
    //把价钱和产品id传到支付界面
    if ([_discount isEqualToString:@"2"])
    {
        payCoinVC.payPrice = [NSString stringWithFormat:@"￥%0.2f", _shuLiang * [_priceValue floatValue]*[_money_discount floatValue]/10.00];;
    }
    else
    {
        payCoinVC.payPrice = [NSString stringWithFormat:@"¥%0.2f",_shuLiang * [_priceValue floatValue] - [_money_discount floatValue]];
    }
    //传过去预约订单的id
    payCoinVC.orderId = _orderID;
    payCoinVC.froms = _froms;
//    NSTimeInterval secondsPerDay1 = 10*60;
//    NSDate *now = [NSDate date];
//    NSDate *yesterDay = [now dateByAddingTimeInterval:-secondsPerDay1];
//    NSDateFormatter *inputFormatter= [[NSDateFormatter alloc] init];
//    [inputFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"]];
//    [inputFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
//    //用[NSDate date]可以获取系统当前时间
//    NSString *currentDateStr = [inputFormatter stringFromDate:yesterDay];
//    payCoinVC.riQi = currentDateStr;
    [self.navigationController pushViewController:payCoinVC animated:YES];
    [payCoinVC.myTimer setFireDate:[NSDate distantFuture]];
    _dingDanBtn.userInteractionEnabled = YES;
}


@end

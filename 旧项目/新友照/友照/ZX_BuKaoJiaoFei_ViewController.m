//
//  ZX_BuKaoJiaoFei_ViewController.m
//  友照
//
//  Created by cleloyang on 2017/2/6.
//  Copyright © 2017年 ZX_XPH. All rights reserved.
//

#import "ZX_BuKaoJiaoFei_ViewController.h"
#import "ZX_PayCoin_ViewController.h"

@interface ZX_BuKaoJiaoFei_ViewController ()

@property (nonatomic, strong) UILabel *nameLab;
@property (nonatomic, strong) UILabel *phoneLab;
@property (nonatomic, strong) UILabel *idLab;
@property (nonatomic, strong) UILabel *jiaXiaoLab;
@property (nonatomic, strong) UILabel *priceLab;
@property (nonatomic, strong) UILabel *keMuLab;
@end

@implementation ZX_BuKaoJiaoFei_ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"确认";
    [self setBuKaoJiaoFeiView];
    [self buKaoFeiData];
}

//设置补考缴费界面
- (void)setBuKaoJiaoFeiView
{
    //身份信息
    UIView *msgV1 = [[UIView alloc] initWithFrame:CGRectMake(0, 64, KScreenWidth, 120)];
    msgV1.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:msgV1];
    _nameLab = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, KScreenWidth-15, 40)];
    _nameLab.textColor = ZX_DarkGray_Color;
    _nameLab.font = [UIFont systemFontOfSize:16];
    _nameLab.textAlignment = NSTextAlignmentLeft;
    [msgV1 addSubview:_nameLab];
    _phoneLab = [[UILabel alloc] initWithFrame:CGRectMake(15, 40, KScreenWidth-15, 40)];
    _phoneLab.textColor = ZX_DarkGray_Color;
    _phoneLab.font = [UIFont systemFontOfSize:16];
    _phoneLab.textAlignment = NSTextAlignmentLeft;
    [msgV1 addSubview:_phoneLab];
    _idLab = [[UILabel alloc] initWithFrame:CGRectMake(15, 80, KScreenWidth-15, 40)];
    _idLab.textColor = ZX_DarkGray_Color;
    _idLab.font = [UIFont systemFontOfSize:16];
    _idLab.textAlignment = NSTextAlignmentLeft;
    [msgV1 addSubview:_idLab];
    //分割线
    UILabel *fLab1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 184, KScreenWidth, 1)];
    UILabel *fLab2 = [[UILabel alloc] initWithFrame:CGRectMake(0, 193, KScreenWidth, 1)];
    fLab1.backgroundColor = ZX_BG_COLOR;
    fLab2.backgroundColor = ZX_BG_COLOR;
    [self.view addSubview:fLab1];
    [self.view addSubview:fLab2];
    //驾校、科目信息
    UIView *msgV2 = [[UIView alloc] initWithFrame:CGRectMake(0, 194, KScreenWidth, 100)];
    msgV2.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:msgV2];
    _jiaXiaoLab = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, KScreenWidth-15, 50)];
    _jiaXiaoLab.textColor = ZX_DarkGray_Color;
    _jiaXiaoLab.font = [UIFont systemFontOfSize:16];
    _jiaXiaoLab.textAlignment = NSTextAlignmentLeft;
    [msgV2 addSubview:_jiaXiaoLab];
    _keMuLab = [[UILabel alloc] initWithFrame:CGRectMake(15, 50, KScreenWidth-15, 50)];
    _keMuLab.textColor = ZX_DarkGray_Color;
    _keMuLab.font = [UIFont systemFontOfSize:16];
    _keMuLab.textAlignment = NSTextAlignmentLeft;
    [msgV2 addSubview:_keMuLab];
    //分割线
    UILabel *fLab3 = [[UILabel alloc] initWithFrame:CGRectMake(0, 294, KScreenWidth, 1)];
    UILabel *fLab4 = [[UILabel alloc] initWithFrame:CGRectMake(0, 303, KScreenWidth, 1)];
    fLab3.backgroundColor = ZX_BG_COLOR;
    fLab4.backgroundColor = ZX_BG_COLOR;
    [self.view addSubview:fLab3];
    [self.view addSubview:fLab4];
    //价格、提醒信息
    UIView *msgV3 = [[UIView alloc] initWithFrame:CGRectMake(0, 304, KScreenWidth, 110)];
    msgV3.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:msgV3];
    UILabel *jiaGeLab = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, KScreenWidth/3, 50)];
    jiaGeLab.textColor = ZX_DarkGray_Color;
    jiaGeLab.font = [UIFont systemFontOfSize:16];
    jiaGeLab.textAlignment = NSTextAlignmentLeft;
    jiaGeLab.text = @"价格:";
    [msgV3 addSubview:jiaGeLab];
    _priceLab = [[UILabel alloc] initWithFrame:CGRectMake(KScreenWidth/3+15, 0, KScreenWidth*2/3-30, 50)];
    _priceLab.textColor = [UIColor orangeColor];
    _priceLab.font = [UIFont systemFontOfSize:16];
    _priceLab.textAlignment = NSTextAlignmentRight;
    [msgV3 addSubview:_priceLab];
    UILabel *tiXingLab = [[UILabel alloc] initWithFrame:CGRectMake(15, 51, KScreenWidth-30, 59)];
    tiXingLab.textColor = ZX_DarkGray_Color;
    tiXingLab.numberOfLines = 0;
    tiXingLab.font = [UIFont systemFontOfSize:15];
    tiXingLab.textAlignment = NSTextAlignmentLeft;
    tiXingLab.text = @"缴费成功后即可预约三日后的考试，概不退款，请谨慎缴费！";
    [msgV3 addSubview:tiXingLab];
    //分割线
    UILabel *fLab5 = [[UILabel alloc] initWithFrame:CGRectMake(0, 50, KScreenWidth, 1)];
    UILabel *fLab6 = [[UILabel alloc] initWithFrame:CGRectMake(0, KScreenHeight-49, KScreenWidth, 1)];
    fLab5.backgroundColor = ZX_BG_COLOR;
    fLab6.backgroundColor = ZX_BG_COLOR;
    [msgV3 addSubview:fLab5];
    [msgV3 addSubview:fLab6];
    //提交按钮
    UIButton *submitBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, KScreenHeight-50, KScreenWidth, 50)];
    [submitBtn addTarget:self action:@selector(tiJiaoBuKaoFei) forControlEvents:UIControlEventTouchUpInside];
    [submitBtn setTitle:@"提交" forState:UIControlStateNormal];
    [submitBtn setBackgroundColor:[UIColor orangeColor]];
    submitBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    submitBtn.titleLabel.font = [UIFont systemFontOfSize: 18.0];
    [self.view addSubview:submitBtn];
}

//补考费购买详情
- (void)buKaoFeiData
{
    _animationView=[[ZXAnimationView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight)];
    [self.view addSubview:_animationView];
    
    [[ZXNetDataManager manager]buKaoJiaoFeiDataWithRndStrng:[ZXDriveGOHelper getCurrentTimeStamp] andIdent_code:[ZXUD objectForKey:@"ident_code"] andSubject:_subject success:^(NSURLSessionDataTask *task, id responseObject)
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
            _nameLab.text = [NSString stringWithFormat:@"姓名: %@",jsonDict[@"student_name"]];
            _phoneLab.text = [NSString stringWithFormat:@"手机号: %@",jsonDict[@"student_phone"]];
            _idLab.text = [NSString stringWithFormat:@"身份证号: %@",jsonDict[@"student_id_card"]];
            _jiaXiaoLab.text = [NSString stringWithFormat:@"驾校: %@",jsonDict[@"school_name"]];
            _keMuLab.text = [NSString stringWithFormat:@"科目: %@",jsonDict[@"subject_name"]];
            _priceLab.text = [NSString stringWithFormat:@"%@ 元",jsonDict[@"price"]];
        }
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [_animationView removeFromSuperview];
        });
        
    } failed:^(NSURLSessionTask *task, NSError *error)
    {
        
    }];
}

//补考费提交
- (void)tiJiaoBuKaoFei
{
    [[ZXNetDataManager manager]buKaoJiaoFeiDingdanDataWithRndStrng:[ZXDriveGOHelper getCurrentTimeStamp] andIdent_code:[ZXUD objectForKey:@"ident_code"] andSubject:_subject success:^(NSURLSessionDataTask *task, id responseObject)
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
             ZX_PayCoin_ViewController *payCoinVC = [[ZX_PayCoin_ViewController alloc]init];
             payCoinVC.froms = jsonDict[@"data"][@"froms"];
             payCoinVC.orderId = jsonDict[@"data"][@"order_id"];
             payCoinVC.payPrice = [_priceLab.text substringWithRange:NSMakeRange(0, _priceLab.text.length-2)];
             payCoinVC.fromBuKaoJiaoFei = YES;
             [self.navigationController pushViewController:payCoinVC animated:YES];
             [payCoinVC.myTimer setFireDate:[NSDate distantFuture]];
         }
     } failed:^(NSURLSessionTask *task, NSError *error)
     {
         
     }];
    
}

- (void)didReceiveMemoryWarning
{
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

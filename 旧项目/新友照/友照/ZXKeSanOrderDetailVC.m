//
//  ZXKeSanOrderDetailVC.m
//  ZXJiaXiao
//
//  Created by yujian on 16/5/21.
//  Copyright © 2016年 ZX. All rights reserved.
//

#import "ZXKeSanOrderDetailVC.h"
#import "ZXKeSanDetailCell1.h"
#import "ZXTableViewCell2.h"
#import "ZXTableViewCell3.h"
#import "ZXTableViewCell4.h"
#import "ZX_OrderList_ViewController.h"
//调用二维码
#import "UIImage+LXDCreateBarcode.h"
#import "ZXCarDetailControllerVC.h"
@interface ZXKeSanOrderDetailVC ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *orderDetailTableView;
@property (nonatomic,copy) NSString *op;

@property (nonatomic,copy) NSString *identCode;
@property (nonatomic,copy) NSString *froms;
@property (nonatomic,copy) NSString *num;
@property (nonatomic,copy) NSString *clientType;
//创建一个字典接收值
@property (nonatomic,strong) NSDictionary *orderListDict;
//获取教练的电话号，实现打电话功能
@property (nonatomic,copy) NSString *teacherPhone;
@property (nonatomic) UIImageView *erWeiMaImage;

@property (nonatomic,copy) NSString *kid;
@end

@implementation ZXKeSanOrderDetailVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title=@"科三订单详情";
    
    self.navigationController.navigationBar.barTintColor = dao_hang_lan_Color;
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"fanhui"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStyleDone target:self action:@selector(goToBack)];
    self.view.backgroundColor = ZX_BG_COLOR;
    [self.orderDetailTableView registerNib:[UINib nibWithNibName:@"ZXKeSanDetailCell1" bundle:nil] forCellReuseIdentifier:@"ZXKeSanDetailCell1"];
    [self.orderDetailTableView registerNib:[UINib nibWithNibName:@"ZXTableViewCell2" bundle:nil] forCellReuseIdentifier:@"ZXTableViewCell2"];
    [self.orderDetailTableView registerNib:[UINib nibWithNibName:@"ZXTableViewCell3" bundle:nil] forCellReuseIdentifier:@"ZXTableViewCell3"];
    [self.orderDetailTableView registerNib:[UINib nibWithNibName:@"ZXTableViewCell4" bundle:nil] forCellReuseIdentifier:@"ZXTableViewCell4"];
    _orderDetailTableView.delegate = self;
    _orderDetailTableView.dataSource = self;
    _orderDetailTableView.showsVerticalScrollIndicator = NO;
    _orderDetailTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self getNetData];
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
- (void) getNetData
{
    //小车动画
    _animationView=[[ZXAnimationView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight)];
    [self.view addSubview:_animationView];
    
    [[ZXNetDataManager manager] KeSanOrderDetailWithTimeStamp:[ZXDriveGOHelper getCurrentTimeStamp] andIdent_code:[ZXUD objectForKey:@"ident_code"] andOrder_id:_orderId success:^(NSURLSessionDataTask *task, id responseObject)
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
         
         if([[ZXwangLuoDanLi WangLuoDanLi] resIsTrue:jsonDict andAlertView:nil])
         {
             _orderListDict = jsonDict[@"orderlist"];
             _teacherPhone = _orderListDict[@"teacher_phone"];
             [self.orderDetailTableView reloadData];
             [self carListData];
         }
         
         dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
             [_animationView removeFromSuperview];
         });
         
     }failed:^(NSURLSessionTask *task, NSError *error)
     {
         [_animationView removeFromSuperview];
         [MBProgressHUD showSuccess:@"网络不好，请稍后重试。"];
         
     }];
    
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0)
    {
        ZXKeSanDetailCell1 *cell = [tableView dequeueReusableCellWithIdentifier:@"ZXKeSanDetailCell1" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        //车类型
        cell.carBrandLabel.text = [NSString stringWithFormat:@"科目三模拟包车(%@)",_orderListDict[@"car_calssify"]];
        cell.moNiImage.image=[UIImage imageNamed:@"科三车"];
        //使用日期
        cell.useDateLabel.text = [NSString stringWithFormat:@"使用日期：%@",[_orderListDict[@"yuyue_time"] substringToIndex:10]];
        [cell.moNiBtn addTarget:self action:@selector(goToCarDetail) forControlEvents:UIControlEventTouchDown];
        return cell;
    }
    else if (indexPath.row == 1)
    {
        ZXTableViewCell2 *cell = [tableView dequeueReusableCellWithIdentifier:@"ZXTableViewCell2" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        //订单的券码号
        cell.quanMaLabel.text = @"券码";
        cell.quanLabel.text = [NSString stringWithFormat:@"%@",_orderListDict[@"order_sn"]];
        UIImage *i= [UIImage imageOfQRFromURL:_orderListDict[@"order_sn"]];
        _erWeiMaImage = [[UIImageView alloc] initWithImage:i];
        return cell;
    }
    else if (indexPath.row == 2)
    {
        ZXTableViewCell3 *cell = [tableView dequeueReusableCellWithIdentifier:@"ZXTableViewCell3" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        //二维码图片，需要根据券码生成
        cell.erWeiMaImage.image = _erWeiMaImage.image;
        return cell;
    }
    else
    {
        ZXTableViewCell4 *cell = [tableView dequeueReusableCellWithIdentifier:@"ZXTableViewCell4" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        //教练、车型、车牌号、地址赋值
        cell.jiaoLianLabel.text = [NSString stringWithFormat:@"教练: %@",_orderListDict[@"teacher_name"]];
        cell.CarType.text = [NSString stringWithFormat:@"车型: %@",_orderListDict[@"car_calssify"]];
        cell.carNumberLabel.text = [NSString stringWithFormat:@"车牌号: %@",_orderListDict[@"car_code"]];
        cell.kaoChangAdressLabel.text = [NSString stringWithFormat:@"考场地址: %@",_orderListDict[@"test_address"]];
        cell.kaoChangAdressLabel.numberOfLines=0;
        
        //根据宽度来自动更改字体的大小
        
        //cell.kaoChangAdressLabel.adjustsFontSizeToFitWidth=YES;
        
        [cell.callPhoneBtn addTarget:self action:@selector(callPhone) forControlEvents:UIControlEventTouchUpInside];
        
        return cell;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0)
    {
        return 70;
    }
    else if (indexPath.row == 1)
    {
        return 100;
    }
    else if (indexPath.row == 2)
    {
        return 190;
    }
    else
    {
        return 238;
    }
}

- (void)goToCarDetail
{
    ZXCarDetailControllerVC *carDetailVC = [[ZXCarDetailControllerVC alloc]init];
    carDetailVC.kid = _kid;
    [self.navigationController pushViewController:carDetailVC animated:YES];
}

//实现打电话功能
- (void)callPhone
{
    
    if ([_teacherPhone isEqualToString:@""])
    {
        return;
    }
    if (![[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",_teacherPhone]]])
    {
        return;
    }
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",_teacherPhone]]];
}

//车辆列表
- (void)carListData
{
    [[ZXNetDataManager manager] KeSanMoNiWithTimeStamp:[ZXDriveGOHelper getCurrentTimeStamp] andClassify:@"" andOrder:@"" success:^(NSURLSessionDataTask *task, id responseObject)
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
             if([jsonDict[@"carlist"] isKindOfClass:[NSArray class]])
             {
                 for (int i = 0; i < [jsonDict[@"carlist"] count]; i ++)
                 {
                     if ([jsonDict[@"carlist"][i][@"code"] isEqualToString:_orderListDict[@"car_code"]])
                     {
                         _kid = jsonDict[@"carlist"][i][@"id"];
                     }
                 }
             }
         }
     }failed:^(NSURLSessionTask *task, NSError *error)
     {
         [MBProgressHUD showSuccess:@"网络不好，请稍后重试。"];
     }];
}

@end

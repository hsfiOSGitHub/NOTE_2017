//
//  one_ViewController.m
//  友照
//
//  Created by ZX on 16/11/26.
//  Copyright © 2016年 ZX_XPH. All rights reserved.
//

#import "one_ViewController.h"
//切换城市
#import "ZXCityTableViewController.h"
//消息
#import "ZXMessageVCTableViewController.h"

@interface one_ViewController ()<BMKLocationServiceDelegate>

@property(strong,nonatomic)BMKLocationService* locService;//定位
@property(nonatomic)BOOL pd;//只取定位一次的数据
@property(nonatomic,strong)NSMutableArray* xinxiaoxi;//新消息

@end

@implementation one_ViewController

-(void)viewWillAppear:(BOOL)animated
{
    self.hidesBottomBarWhenPushed=NO;
    [_xinxiaoxi removeAllObjects];
    if ([ZXUD boolForKey:@"IS_LOGIN"])
    {
        self.dataSource = [NSMutableArray arrayWithArray:[ZXUD objectForKey:@"xiaoxi"]];
    }
    else
    {
        self.dataSource = [NSMutableArray array];
    }
    if (![ZXUD objectForKey:@"city"])
    {
        [self addCityLocation:@"洛阳"];
    }
    else
    {
        if (![_city isEqualToString:[ZXUD objectForKey:@"city"]])
        {
            _city = [ZXUD objectForKey:@"city"];
            [self addCityLocation:_city];
            if ([ZXUD boolForKey:@"dw"])
            {
                [self getDingWeiData1];
            }
            else
            {
                [self getDingWeiData2];
            }
        }
    }
    self.navigationItem.leftBarButtonItem.tintColor = [UIColor whiteColor];
    if (![ZXUD boolForKey:@"xx"])
    {
        if ([ZXUD boolForKey:@"IS_LOGIN"])
        {
            //请求系统消息
            [self xiaoxi];
        }
        else
        {
            self.messageNum = 0;
            //系统消息
            [self rightMessageBtn];
        }
    }
    else
    {
        _xinxiaoxi = [NSMutableArray arrayWithArray:[ZXUD objectForKey:@"xinxiaoxi"]];
        self.messageNum = _xinxiaoxi.count;
        [self rightMessageBtn];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    if ([ZXUD boolForKey:@"dwcg"])
    {
        if (![[ZXUD objectForKey:@"city"] isKindOfClass:[NSString class]])
        {
            [ZXUD setObject:@"洛阳市" forKey:@"city"];
            _city = @"洛阳市";
        }
        else
        {
            _city = [ZXUD objectForKey:@"city"];
        }
        //默认选择城市
        [self addCityLocation:_city];
        //系统消息
        [self rightMessageBtn];
    }
    else
    {
        if (![[ZXUD objectForKey:@"city"] isKindOfClass:[NSString class]])
        {
            [ZXUD setObject:@"洛阳市" forKey:@"city"];
            _city = @"洛阳市";
        }
        else
        {
            _city = [ZXUD objectForKey:@"city"];
        }
        //默认选择城市
        [self addCityLocation:_city];
        //定位城市
        [self dingwei];
        //系统消息
        [self rightMessageBtn];
    }
}

//右边消息按钮
- (void)rightMessageBtn
{
    UIButton *customButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 26, 20)];
    [customButton addTarget:self action:@selector(handleRightBtn1:) forControlEvents:UIControlEventTouchUpInside];
    [customButton setImage:[UIImage imageNamed:@"消息.png"] forState:UIControlStateNormal];
    
    BBBadgeBarButtonItem *barButton = [[BBBadgeBarButtonItem alloc] initWithCustomUIButton:customButton];
    barButton.badgeValue = [NSString stringWithFormat:@"%ld", (long)self.messageNum];
    barButton.badgeOriginX = 20;
    self.navigationItem.rightBarButtonItem = barButton;
}

//定位城市
-(void)dingwei
{
    _locService = [[BMKLocationService alloc]init];
    _locService.delegate = self;
    _locService.desiredAccuracy = kCLLocationAccuracyBest;
    //启动LocationService
    [_locService startUserLocationService];
}

//百度定位成功
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation
{
    [ZXUD setBool:NO forKey:@"dw"];
    [ZXUD setBool:YES forKey:@"dwcg"];
    
    _jingdu = [NSString stringWithFormat:@"%f",userLocation.location.coordinate.longitude];
    _weidu = [NSString stringWithFormat:@"%f",userLocation.location.coordinate.latitude];
    [_locService stopUserLocationService];
    [ZXUD setObject:_jingdu forKey:@"jingdu"];
    [ZXUD setObject:_weidu forKey:@"weidu"];
    
    //反地理编码出地理位置
    BMKReverseGeoCodeOption *haha = [[BMKReverseGeoCodeOption alloc] init];
    haha.reverseGeoPoint = (CLLocationCoordinate2D){userLocation.location.coordinate.latitude,userLocation.location.coordinate.longitude};
    //经纬度
    if (!_pd)
    {
        _pd = YES;
        // 获取当前所在的城市名
        CLLocation *geocoder = [[CLLocation alloc] initWithLatitude:userLocation.location.coordinate.latitude longitude:userLocation.location.coordinate.longitude];
        CLGeocoder *dingwei = [[CLGeocoder alloc] init];
        //根据经纬度反向地理编译出地址信息
        [dingwei reverseGeocodeLocation:geocoder completionHandler:^(NSArray *array, NSError *error)
        {
            if (array.count > 0)
            {
                CLPlacemark *placemark = [array objectAtIndex:0];
                //省
                if (!placemark.locality)
                {
                    //四大直辖市的城市信息无法通过locality获得，只能通过获取省份的方法来获得（如果city为空，则可知为直辖市）
                }
                if (placemark.locality)
                {
                    _city = placemark.locality;
                    //请求该城市的驾校列表
                    
                    [[ZXNetDataManager manager2] schoolLocationDataWithRndstring:[ZXDriveGOHelper getCurrentTimeStamp] andCity:_city success:^(NSURLSessionDataTask *task, id responseObject)
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
                             NSMutableArray* jl = [NSMutableArray array];
                             NSMutableArray* zb = [NSMutableArray arrayWithArray:jsonDict[@"school_location_list"]];
                             if(zb.count > 0)
                             {
                                 for (int i = 0; i < zb.count; i ++)
                                 {
                                     if(![zb[i][@"location"] isEqualToString:@""])
                                     {
                                         NSArray* wz = [zb[i][@"location"] componentsSeparatedByString:@","];
                                         //第一个坐标
                                         CLLocation *current = [[CLLocation alloc] initWithLatitude:[_jingdu doubleValue] longitude:[_weidu doubleValue]];
                                         //第二个坐标
                                         CLLocation *before = [[CLLocation alloc] initWithLatitude:[wz[0] doubleValue] longitude:[wz[1] doubleValue]];
                                         // 计算距离
                                         CLLocationDistance distance = [current distanceFromLocation:before];
                                         if (distance==0)
                                         {
                                             continue;
                                         }
                                         NSMutableDictionary* dict=[NSMutableDictionary dictionary ];
                                         [dict setValue:zb[i][@"id"] forKey:@"bh"];
                                         [dict setValue:[NSString stringWithFormat:@"%f",distance] forKey:@"jl"];
                                         if (!jl)
                                         {
                                             jl = [NSMutableArray array];
                                             [jl addObject:dict];
                                         }
                                         else
                                         {
                                             [jl addObject:dict];
                                         }
                                     }
                                     else
                                     {
                                         [zb removeObjectAtIndex:i];
                                         i--;
                                     }
                                 }
                                 //距离计算完毕进行排序
                                 for (int j = 0; j < jl.count-1; j ++)
                                 {
                                     for (int k = j+1; k < jl.count; k ++)
                                     {
                                         NSMutableDictionary* dict1 = jl[j];
                                         NSMutableDictionary* dict2 = jl[k];
                                         if([dict1[@"jl"] doubleValue] >= [dict2[@"jl"] doubleValue])
                                         {
                                             NSMutableDictionary* dict3 = [NSMutableDictionary dictionary];
                                             dict3 = jl[j];
                                             jl[j] = jl[k];
                                             jl[k] = dict3;
                                         }
                                     }
                                 }
                                 [ZXUD setObject:jl forKey:@"jl"];
                             }
                         }
                     }failed:^(NSURLSessionTask *task, NSError *error)
                     {
                         
                     }];
                    
                    //市
                    [ZXUD setObject:placemark.locality forKey:@"city"];
                    [self addCityLocation:placemark.locality];
                }
            }
        }];
    }
}

//百度地图API定位失败
- (void)didFailToLocateUserWithError:(NSError *)error;
{
    [ZXUD setObject:@"洛阳市" forKey:@"city"];
    [ZXUD setBool:NO forKey:@"dwcg"];
    [ZXUD setBool:YES forKey:@"dw"];
    _city = @"洛阳市";
    //请求洛阳的驾校列表
    [[ZXNetDataManager manager2] schoolLocationDataWithRndstring:[ZXDriveGOHelper getCurrentTimeStamp] andCity:_city success:^(NSURLSessionDataTask *task, id responseObject)
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
             NSMutableArray* jl = [NSMutableArray array];
             NSMutableArray* zb = [NSMutableArray arrayWithArray:jsonDict[@"school_location_list"]];
             for (int i = 0; i < zb.count; i ++)
             {
                 // 计算距离
                 CLLocationDistance distance = 0;
                 NSMutableDictionary* dict = [NSMutableDictionary dictionary];
                 [dict setValue:zb[i][@"id"] forKey:@"bh"];
                 [dict setValue:[NSString stringWithFormat:@"%f",distance] forKey:@"jl"];
                 if (!jl)
                 {
                     jl = [NSMutableArray array];
                     [jl addObject:dict];
                 }
                 else
                 {
                     [jl addObject:dict];
                 }
             }
             [ZXUD setObject:jl forKey:@"jl"];
         }
     }
    failed:^(NSURLSessionTask *task, NSError *error)
     {
         
     }];
}




//获取定位数据
- (void)getDingWeiData1
{
    [[ZXNetDataManager manager4] schoolLocationDataWithRndstring:[ZXDriveGOHelper getCurrentTimeStamp] andCity:_city success:^(NSURLSessionDataTask *task, id responseObject)
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
             NSMutableArray* jl = [NSMutableArray array];
             NSMutableArray* zb = [NSMutableArray arrayWithArray:jsonDict[@"school_location_list"]];
             for (int i = 0; i < zb.count; i ++)
             {
                 // 计算距离
                 CLLocationDistance distance=0;
                 NSMutableDictionary* dict = [NSMutableDictionary dictionary ];
                 [dict setValue:zb[i][@"id"] forKey:@"bh"];
                 [dict setValue:[NSString stringWithFormat:@"%f",distance] forKey:@"jl"];
                 
                 if (!jl)
                 {
                     jl = [NSMutableArray array];
                     [jl addObject:dict];
                 }
                 else
                 {
                     [jl addObject:dict];
                 }
             }
             [ZXUD setObject:jl forKey:@"jl"];
         }
     }failed:^(NSURLSessionTask *task, NSError *error)
     {
     }];
}


- (void)getDingWeiData2
{
    [[ZXNetDataManager manager4] schoolLocationDataWithRndstring:[ZXDriveGOHelper getCurrentTimeStamp] andCity:_city success:^(NSURLSessionDataTask *task, id responseObject)
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
             NSMutableArray* jl = [NSMutableArray array];
             NSMutableArray* zb = [NSMutableArray arrayWithArray:jsonDict[@"school_location_list"]];
             if (zb.count>0)
             {
                 for (int i = 0; i < zb.count; i ++)
                 {
                     if(![zb[i][@"location"] isEqualToString:@""])
                     {
                         NSArray* wz = [zb[i][@"location"] componentsSeparatedByString:@","];
                         //第一个坐标
                         CLLocation *current = [[CLLocation alloc] initWithLatitude:[_jingdu doubleValue] longitude:[_weidu doubleValue]];
                         //第二个坐标
                         CLLocation *before = [[CLLocation alloc] initWithLatitude:[wz[0] doubleValue] longitude:[wz[1] doubleValue]];
                         // 计算距离
                         CLLocationDistance distance = [current distanceFromLocation:before];
                         NSMutableDictionary* dict = [NSMutableDictionary dictionary ];
                         [dict setValue:zb[i][@"id"] forKey:@"bh"];
                         [dict setValue:[NSString stringWithFormat:@"%f",distance] forKey:@"jl"];
//                         YZLog(@"编号：%@,经度：%f，纬度：%f,距离：%@", dict[@"bh"],[wz[0] doubleValue] ,[wz[1] doubleValue],dict[@"jl"]);
                         if (!jl)
                         {
                             jl = [NSMutableArray array];
                             [jl addObject:dict];
                         }
                         else
                         {
                             [jl addObject:dict];
                         }
                     }
                     else
                     {
                         [zb removeObjectAtIndex:i];
                         i--;
                     }
                 }
                 //距离计算完毕进行排序
                 for (int j = 0; j < jl.count-1; j ++)
                 {
                     for (int k = j+1; k < jl.count; k ++)
                     {
                         NSMutableDictionary* dict1 = jl[j];
                         NSMutableDictionary* dict2 = jl[k];
                         if([dict1[@"jl"] doubleValue] >= [dict2[@"jl"] doubleValue])
                         {
                             NSMutableDictionary* dict3 = [NSMutableDictionary dictionary];
                             dict3 = jl[j];
                             jl[j] = jl[k];
                             jl[k] = dict3;
                         }
                     }
                 }
                 [ZXUD setObject:jl forKey:@"jl"];
             }
         }
     }failed:^(NSURLSessionTask *task, NSError *error)
     {
         YZLog(@"%@",error);
     }];
}


//请求系统消息
-(void)xiaoxi
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSMutableSet *set = [NSMutableSet setWithSet:manager.responseSerializer.acceptableContentTypes];
    [set addObject:@"text/html"];
    manager.responseSerializer.acceptableContentTypes = set;
    NSDictionary *parameters = @{@"m":@"info_list",
                                 @"rndstring":[ZXDriveGOHelper getCurrentTimeStamp],
                                 @"ident_code":[ZXUD objectForKey:@"ident_code"],
                                 };
    
    [manager POST:ZX_URL parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
     {
         if([[ZXwangLuoDanLi WangLuoDanLi] resIsTrue:responseObject andAlertView:self])
         {
             NSMutableArray *arr = [NSMutableArray arrayWithArray: responseObject[@"list"]];
             for (int i = 0; i < arr.count; i ++)
             {
                 if ([[arr[i] allKeys] containsObject:@"url"])
                 {
                     [arr removeObject:arr[i]];
                     i--;
                 }
             }
             if(arr.count > 0)
             {
                 [ZXUD setBool:YES forKey:@"xx"];
                 [ZXUD setObject:arr forKey:@"xinxiaoxi"];
             }
             self.messageNum = (int)arr.count;
             [arr addObjectsFromArray:self.dataSource];
             self.dataSource = arr;
             [ZXUD setObject:self.dataSource forKey:@"xiaoxi"];
             [ZXUD synchronize];
             for (int p = 0; p < _dataSource.count; p ++)
             {
                 if ([[_dataSource[p] allKeys] containsObject:@"url"])
                 {
                     [_dataSource removeObject:_dataSource[p]];
                 }
             }
         }
         //右边消息按钮
         [self rightMessageBtn];
         
     } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error)
     {
         
     }];
}


//选择城市
-(void)xuanZeCity1
{
    ZXCityTableViewController *cityVC = [[ZXCityTableViewController alloc]init];
    [self.navigationController  pushViewController:cityVC animated:YES];
}
//右边消息按钮
- (void)handleRightBtn1:(UIBarButtonItem *)item
{
    //先判断是否登录
    if (![ZXUD boolForKey:@"IS_LOGIN"])
    {
        ZX_Login_ViewController *loginVC = [[ZX_Login_ViewController alloc]init];
        [self.navigationController pushViewController:loginVC animated:YES];
    }
    else
    {
        //已经登录
        if (_dataSource.count == 0)
        {
            [MBProgressHUD showSuccess:@"您现在还没有系统消息"];
        }
        else
        {
            BBBadgeBarButtonItem *barButton = (BBBadgeBarButtonItem *)self.navigationItem.rightBarButtonItem;
            barButton.badgeValue = @"0";
            //跳转到消息列表
            ZXMessageVCTableViewController *VC = [[ZXMessageVCTableViewController alloc]init];
            VC.dataSource = self.dataSource;
            [ZXUD setObject:[NSMutableArray array] forKey:@"xinxiaoxi"];
            [ZXUD setBool:NO forKey:@"xx"];
            [ZXUD synchronize];
            [self.navigationController pushViewController:VC animated:YES];
        }
    }
}


//左边城市按钮
- (void)addCityLocation:(NSString*)name
{
    self.navigationItem.leftBarButtonItem = nil;
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    NSDictionary *attrs = @{NSFontAttributeName : [UIFont boldSystemFontOfSize:18]};
    CGSize size = [name sizeWithAttributes:attrs];
    btn.frame = CGRectMake(15, 10, size.width+5, 24);
    btn.titleLabel.adjustsFontSizeToFitWidth = YES;
    btn.titleLabel.textAlignment = NSTextAlignmentCenter;
    [btn setTitle:name forState:UIControlStateNormal];
    //给按钮加一个白色的板框
    btn.layer.borderColor = [[UIColor whiteColor] CGColor];
    btn.layer.borderWidth = 1.0f;
    //给按钮设置弧度,这里将按钮变成了圆形
    btn.layer.cornerRadius = 0.0;
    btn.layer.masksToBounds = YES;
    [btn addTarget: self action: @selector(xuanZeCity1) forControlEvents: UIControlEventTouchUpInside];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    UIBarButtonItem* leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
    self.navigationItem.leftBarButtonItem = leftBarButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}



@end

//
//  UMComSimpleHomeViewController.m
//  UMCommunity
//
//  Created by umeng on 16/4/29.
//  Copyright © 2016年 Umeng. All rights reserved.
//

#import "UMComSimpleHomeViewController.h"
#import "UMComSimpleFeedTableViewController.h"
#import "UMComFeedListDataController.h"
#import "UIViewController+UMComAddition.h"
#import "UMComSimplicityDiscoverViewController.h"

#import "UMComBriefEditViewController.h"
#import "UMComSelectTopicViewController.h"
#import "UMComLoginManager.h"

//切换城市
#import "ZXCityTableViewController.h"
#import "ZXMessageVCTableViewController.h"

#import <UMCommunitySDK/UMComSession.h>
#import <UMComDataStorage/UMComUnReadNoticeModel.h>
#import "UMComNotificationMacro.h"

@interface UMComSimpleHomeViewController ()

@property(nonatomic,strong)UMComSimpleFeedTableViewController *realTimeFeedVc;
@property(nonatomic,strong)UMComSimpleFeedTableViewController *hotFeedVc;
@property (nonatomic)NSInteger messageNum;//消息数量
@property(strong,nonatomic)BMKLocationService* locService;//定位
@property(nonatomic,strong)NSString* jingdu;//当前所在经度
@property(nonatomic,strong)NSString* weidu;//当前所在纬度
@property(nonatomic,strong)NSString* city;//当前所在纬度
@property (nonatomic, strong)NSMutableArray *dataSource;//消息数据源
@property(nonatomic,strong)NSMutableArray* xinxiaoxi;//新消息
- (void)refreshNoticeItemViews:(NSNotification*)notification;

@end

@implementation UMComSimpleHomeViewController

- (id)init
{
     self.hidesBottomBarWhenPushed = NO;
    if (self = [super init]) {
      
        [UMComResourceManager setResourceType:UMComResourceType_Simplicity];
    }
     self.hidesBottomBarWhenPushed = NO;
    return self;
}

- (void)refreshNoticeItemViews:(NSNotification*)notification
{
    YZLog(@"%ld",(long)[UMComSession sharedInstance].unReadNoticeModel.totalNotiCount);
    
//    if ([UMComSession sharedInstance].unReadNoticeModel.totalNotiCount == 0)
//    {
//        self.userMessageView.hidden = NO;
//    }
//    else
//    {
//        self.userMessageView.hidden = YES;
//    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.hidesBottomBarWhenPushed=NO;

    [_xinxiaoxi removeAllObjects];
    self.dataSource = [NSMutableArray arrayWithArray:[ZXUD objectForKey:@"xiaoxi"]];

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
        _xinxiaoxi=[NSMutableArray arrayWithArray:[ZXUD objectForKey:@"xinxiaoxi"]];
        self.messageNum = _xinxiaoxi.count;
        [self rightMessageBtn];
    }
    /**
     * 获取初始化数据和更新未读消息数
     *
     * @param completion 初始化数据结果，responseObject`的key`msg_box`是各个未读消息数，`msg_box`下面的`total`为所有未读通知数，key为`notice`为管理员未读通知数，`comment`为被评论未读通知数，`at`为被@未读通知数，`like`为被点赞未读通知数
     */
    [[UMComDataRequestManager defaultManager] fetchConfigDataWithCompletion:^(NSDictionary *responseObject, NSError *error) {
        
        YZLog(@"%@",responseObject);
        
        if ([responseObject[@"msg_box"][@"total"] intValue]>0)
        {
            self.userMessageView.hidden = NO;
        }
        else
        {
            self.userMessageView.hidden = YES;
        }
        
    }];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)refreshData
{
    UMComSimpleFeedTableViewController *vc = self.childViewControllers[self.showIndex];
    [vc refreshData];
}

- (void)didTransitionToIndex:(NSInteger)index
{
    UMComSimpleFeedTableViewController *vc = self.childViewControllers[index];
    if (vc.dataController && vc.dataController.dataArray.count == 0) {
        [vc refreshData];
    }
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    _jingdu=[ZXUD objectForKey:@"jingdu"];
    _weidu=[ZXUD objectForKey:@"weidu"];
    
    if ([ZXUD boolForKey:@"dwcg"])
    {
        if (![ZXUD objectForKey:@"city"])
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
        if (![ZXUD objectForKey:@"city"])
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
    if ([ZXUD boolForKey:@"IS_LOGIN"])
    {
        self.dataSource = [NSMutableArray arrayWithArray:[ZXUD objectForKey:@"xiaoxi"]];
    }
    else
    {
        self.dataSource=[NSMutableArray array];
    }
    self.view.backgroundColor=[UIColor whiteColor];
    self.view.frame=CGRectMake(0, 100, KScreenWidth, KScreenHeight-97);
    [UMComResourceManager setResourceType:UMComResourceType_Simplicity];
    [[UMComDataRequestManager defaultManager] updateTemplateChoice:2 completion:nil];

    [self createSubViews];
    
    [self creatSubViewControllers];
    
//    UIViewController *rootViewController = [UIApplication sharedApplication].keyWindow.rootViewController;
    //    如果当前NavigationViewController是跟视图， 则不需要显示返回按钮
//    if ((rootViewController == self.navigationController && rootViewController.childViewControllers.count == 1) || rootViewController == self) {

//    }
//    else
//    {
//        [self setForumUIBackButton];
//    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshNoticeItemViews:) name:kUMComUnreadNotificationRefreshNotification object:nil];
    
    //注册通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(Login:) name:@"Login" object:nil];
}
-(void)Login:(NSNotification *)noti{
    ZX_Login_ViewController *VC = [[ZX_Login_ViewController alloc] init];
    UINavigationController *navi = [[UINavigationController alloc]initWithRootViewController:VC];
    [self presentViewController:navi animated:YES completion:nil];
}


-(void) dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kUMComUnreadNotificationRefreshNotification object:nil];
}

- (void)createSubViews
{
    
    
}

- (void)creatSubViewControllers
{
    //最新Feed流页面
    UMComSimpleFeedTableViewController *realTimeFeedVc = [[UMComLatestSimpleFeedTableViewController alloc] init];
    realTimeFeedVc.isShowEditButton = YES;
    realTimeFeedVc.isAutoStartLoadData = NO;
    realTimeFeedVc.dataController = [[UMComFeedRealTimeDataController alloc] initWithCount:UMCom_Limit_Page_Count];
    UMComFeedListDataController* topFeedListDataController= (UMComFeedListDataController*)realTimeFeedVc.dataController;
    topFeedListDataController.isReadLoacalData = YES;
    topFeedListDataController.isSaveLoacalData = YES;
    realTimeFeedVc.view.frame=CGRectMake(0, 100, KScreenWidth, KScreenHeight-97);
    topFeedListDataController.topFeedListDataController = [[UMComGlobalTopFeedListDataController alloc] init];
    realTimeFeedVc.topFeedType = UMComTopFeedType_GloalTopFeed;
    [self.view addSubview:realTimeFeedVc.view];
    self.realTimeFeedVc = realTimeFeedVc;

    //最热feed流页面
    UMComSimpleFeedTableViewController *hotFeedVc = [[UMComSimpleFeedTableViewController alloc] init];
    hotFeedVc.isShowEditButton = YES;
    hotFeedVc.isAutoStartLoadData = NO;
    hotFeedVc.dataController = [[UMComFeedRealTimeHotDataController alloc] initWithCount:UMCom_Limit_Page_Count];
    hotFeedVc.dataController.isReadLoacalData = YES;
    hotFeedVc.dataController.isSaveLoacalData = YES;
    hotFeedVc.view.frame=CGRectMake(0, 100, KScreenWidth, KScreenHeight-97);

    [self.view addSubview:hotFeedVc.view];
    self.hotFeedVc = hotFeedVc;

    self.titlesArray = [NSArray arrayWithObjects:UMComLocalizedString(@"umcom_newest_feed", @"最新"), UMComLocalizedString(@"umcom_hotest_feed", @"最热"), nil];
    self.subViewControllers = [NSArray arrayWithObjects:realTimeFeedVc,hotFeedVc, nil];
    self.showIndex = 0;
}

-(void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    //设置两个child的frame
    self.realTimeFeedVc.view.frame = CGRectMake(0, 40, KScreenWidth, KScreenHeight-153);
    self.hotFeedVc.view.frame = CGRectMake(0, 40, KScreenWidth, KScreenHeight-153);
    
}



//获取定位数据
- (void)getDingWeiData1
{
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
             NSMutableArray* jl=[NSMutableArray array];
             NSMutableArray* zb=[NSMutableArray arrayWithArray:jsonDict[@"school_location_list"]];
             for (int i=0; i<zb.count; i++)
             {
                 // 计算距离
                 CLLocationDistance distance=0;
                 NSMutableDictionary* dict=[NSMutableDictionary dictionary ];
                 [dict setValue:zb[i][@"id"] forKey:@"bh"];
                 [dict setValue:[NSString stringWithFormat:@"%f",distance] forKey:@"jl"];
                 
                 if (!jl)
                 {
                     jl=[NSMutableArray array];
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
             NSMutableArray* jl=[NSMutableArray array];
             NSMutableArray* zb=[NSMutableArray arrayWithArray:jsonDict[@"school_location_list"]];
             if (zb.count>0)
             {
                 for (int i=0; i<zb.count; i++)
                 {
                     if(![zb[i][@"location"] isEqualToString:@""])
                     {
                         NSArray* wz=[zb[i][@"location"] componentsSeparatedByString:@","];
                         //第一个坐标
                         CLLocation *current=[[CLLocation alloc] initWithLatitude:[_jingdu doubleValue] longitude:[_weidu doubleValue]];
                         //第二个坐标
                         CLLocation *before=[[CLLocation alloc] initWithLatitude:[wz[0] doubleValue] longitude:[wz[1] doubleValue]];
                         // 计算距离
                         CLLocationDistance distance=[current distanceFromLocation:before];
                         NSMutableDictionary* dict=[NSMutableDictionary dictionary ];
                         [dict setValue:zb[i][@"id"] forKey:@"bh"];
                         [dict setValue:[NSString stringWithFormat:@"%f",distance] forKey:@"jl"];
                         
                         if (!jl)
                         {
                             jl=[NSMutableArray array];
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
                 for (int j=0; j<jl.count-1; j++)
                 {
                     for (int k=j+1; k<jl.count; k++)
                     {
                         NSMutableDictionary* dict1=jl[j];
                         NSMutableDictionary* dict2=jl[k];
                         if([dict1[@"jl"] doubleValue] >=[dict2[@"jl"] doubleValue])
                         {
                             NSMutableDictionary* dict3=[NSMutableDictionary dictionary];
                             dict3=jl[j];
                             jl[j]=jl[k];
                             jl[k]=dict3;
                         }
                     }
                 }
                 [ZXUD setObject:jl forKey:@"jl"];
             }
         }
     }failed:^(NSURLSessionTask *task, NSError *error)
     {
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
             if(arr.count>0)
             {
                 [ZXUD setBool:YES forKey:@"xx"];
                 [ZXUD setObject:arr forKey:@"xinxiaoxi"];
             }
             self.messageNum = (int)arr.count;
             [arr addObjectsFromArray:self.dataSource];
             self.dataSource = arr;
             [ZXUD setObject:self.dataSource forKey:@"xiaoxi"];
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
-(void)xuanZeCity3
{
    ZXCityTableViewController *cityVC =[[ZXCityTableViewController alloc]init];
    [self.navigationController  pushViewController:cityVC animated:YES];
}

//右边消息按钮
- (void)rightMessageBtn
{

    UIButton *customButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 26, 20)];
    [customButton addTarget:self action:@selector(handleRightBtn3:) forControlEvents:UIControlEventTouchUpInside];
    [customButton setImage:[UIImage imageNamed:@"消息.png"] forState:UIControlStateNormal];
    
    BBBadgeBarButtonItem *barButton = [[BBBadgeBarButtonItem alloc] initWithCustomUIButton:customButton];
    barButton.badgeValue = [NSString stringWithFormat:@"%ld", (long)self.messageNum];
    barButton.badgeOriginX = 20;
    self.navigationItem.rightBarButtonItem = barButton;
}

//右边消息按钮
- (void)handleRightBtn3:(UIBarButtonItem *)item
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
            [ZXUD setBool:NO forKey:@"xx"];
            [ZXUD synchronize];
            [self.navigationController pushViewController:VC animated:YES];
        }
    }
}

//左边城市按钮
- (void)addCityLocation:(NSString*)name
{
    self.navigationItem.leftBarButtonItem=nil;
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    NSDictionary *attrs = @{NSFontAttributeName : [UIFont boldSystemFontOfSize:18]};
    CGSize size=[name sizeWithAttributes:attrs];
    btn.frame = CGRectMake(15, 10, size.width+5, 24);
    btn.titleLabel.adjustsFontSizeToFitWidth=YES;
    btn.titleLabel.textAlignment=NSTextAlignmentCenter;
    [btn setTitle:name forState:UIControlStateNormal];
    //给按钮加一个白色的板框
    btn.layer.borderColor = [[UIColor whiteColor] CGColor];
    btn.layer.borderWidth = 1.0f;
    //给按钮设置弧度,这里将按钮变成了圆形
    btn.layer.cornerRadius = 0.0;
    btn.layer.masksToBounds = YES;
    [btn addTarget: self action: @selector(xuanZeCity3) forControlEvents: UIControlEventTouchUpInside];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    UIBarButtonItem* leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
    self.navigationItem.leftBarButtonItem = leftBarButtonItem;
}

- (void)onTouchDiscover
{
    UMComSimplicityDiscoverViewController *VC = [[UMComSimplicityDiscoverViewController alloc] init];
    [self.navigationController pushViewController:VC animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end

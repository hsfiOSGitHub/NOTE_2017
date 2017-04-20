
//
//  AppDelegate.m
//  yuntangyi
//
//  Created by yuntangyi on 16/8/26.
//  Copyright © 2016年 yuntangyi. All rights reserved.
//
#import "AppDelegate.h"
#import "XHLaunchAd.h"//启动广告
#import "WebViewController.h"
#import "PushVC.h"
#import "LoginVC.h"
#define yuntangyiAppKey @"zx2016#szbdoctor"
#import "MainTabBarController.h"
#import "GuideVC.h"
#import "UMMobClick/MobClick.h"

#import <ShareSDK/ShareSDK.h>
#import <ShareSDKConnector/ShareSDKConnector.h>

//腾讯开放平台（对应QQ和QQ空间）SDK头文件
#import <TencentOpenAPI/TencentOAuth.h>
#import <TencentOpenAPI/QQApiInterface.h>

//微信SDK头文件
#import "WXApi.h"


//新浪微博SDK需要在项目Build Settings中的Other Linker Flags添加"-ObjC"
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKConnector/ShareSDKConnector.h>
//新浪微博SDK头文件
#import "WeiboSDK.h"
//初始化的import参数注意要链接原生新浪微博SDK。
#import "NetStateView.h"

//推送
#import "UMessage.h"
#import <UserNotifications/UserNotifications.h>


@interface AppDelegate () <UNUserNotificationCenterDelegate>
@property (nonatomic,strong) NetStateView *netStateView;
@end

@implementation AppDelegate
#pragma mark -懒加载

//进入app
/**
 *  启动页广告
 */
-(void)startApp
{
    //获取根视图控制器对象
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    MainTabBarController *mainTabBar_C = [mainStoryboard instantiateViewControllerWithIdentifier:@"mainTab"];
    /**
     *  1.显示启动页广告
     */
    [XHLaunchAd showWithAdFrame:CGRectMake(0, 0,self.window.bounds.size.width, self.window.bounds.size.height-150) setAdImage:^(XHLaunchAd *launchAd) {
        
        //未检测到广告数据,启动页停留时间,不设置默认为3,(设置4即表示:启动页显示了4s,还未检测到广告数据,就自动进入window根控制器)
        //launchAd.noDataDuration = 4;
        
        //获取广告数据
        [self requestImageData:^(NSString *imgUrl, NSInteger duration, NSString *openUrl) {
            /**
             *  2.设置广告数据
             */
            
            //定义一个weakLaunchAd
            __weak __typeof(launchAd) weakLaunchAd = launchAd;
            [launchAd setImageUrl:imgUrl duration:duration skipType:SkipTypeTimeText options:XHWebImageDefault completed:^(UIImage *image, NSURL *url) {
                
                //异步加载图片完成回调(若需根据图片尺寸,刷新广告frame,可在这里操作)
                weakLaunchAd.adFrame = CGRectMake(0, 0,self.window.bounds.size.width, self.window.bounds.size.height - 150);
                
            } click:^{
                
                //广告点击事件
                
                //1.用浏览器打开
//                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:openUrl]];
                
                //2.在webview中打开
                WebViewController *VC = [[WebViewController alloc] init];
                VC.URLString = openUrl;
                [weakLaunchAd presentViewController:VC animated:YES completion:nil];
                
            }];
        }];
        
    } showFinish:^{
        
        //广告展示完成回调,设置window根控制器
      
        //判断是否进入登录界面
        NSString *ident_coed = [ZXUD objectForKey:@"ident_code"];
        if (ident_coed)
        {
            [UMessage setAlias:@"suizhenbao" type:[ZXUD objectForKey:@"phone"] response:^(id responseObject, NSError *error) {
            }];
            
            //进入主界面
            self.window.rootViewController = mainTabBar_C;
            [self.window makeKeyAndVisible];
         
            dispatch_queue_t queue = dispatch_queue_create("com.baidu.wwwGCD", DISPATCH_QUEUE_CONCURRENT);
            //创建任务
            dispatch_async(queue, ^{
                //登录环信账号
                EMError *error2 = [[EMClient sharedClient] loginWithUsername:[ZXUD objectForKey:@"phone"] password:@"suizhenbao"];
                if (!error2) {
                    NSLog(@"登录成功");
                }
            });
        }else{
            //进入登录界面
            LoginVC *login_VC = [[LoginVC alloc]init];
            UINavigationController *login_Navi = [[UINavigationController alloc]initWithRootViewController:login_VC];
            self.window.rootViewController = login_Navi;
            [self.window makeKeyAndVisible];
        }
    }];
}

/**
 *  模拟:向服务器请求广告数据
 *
 *  @param imageData 回调imageUrl,及停留时间,跳转链接
 */
-(void)requestImageData:(void(^)(NSString *imgUrl,NSInteger duration,NSString *openUrl))imageData{
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if(imageData)
        {
            imageData([[NSUserDefaults standardUserDefaults] objectForKey:@"adpic"], 3,[[NSUserDefaults standardUserDefaults] objectForKey:@"adurl"]);
            AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
            NSMutableSet *set = [NSMutableSet setWithSet:manager.responseSerializer.acceptableContentTypes];
            [set addObject:@"text/html"];
            manager.responseSerializer.acceptableContentTypes = set;
            NSString *newUrlString = [@"http://app.yuntangyi.com/api/index.php?m=adpic" stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            [manager GET:newUrlString parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
            } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                    if ([responseObject[@"res"] isEqualToString:@"1001"]) {
                        NSLog(@"%@", responseObject);
                        if ([responseObject[@"list"][@"pic"] isKindOfClass:[NSString class]] && ![responseObject[@"list"][@"pic"] isEqualToString:@""] ) {
                            [[NSUserDefaults standardUserDefaults] setObject:responseObject[@"list"][@"pic"] forKey:@"adpic"];
                            [[NSUserDefaults standardUserDefaults] setObject:responseObject[@"list"][@"url"] forKey:@"adurl"];
                            [[NSUserDefaults standardUserDefaults] synchronize];
                        }else {
                            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"adpic"];
                    }
                }
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
               
            }];
        }
    });
}


#pragma mark -didFinishLaunchingWithOptions
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    [ZXUD setBool:NO forKey:@"ht"];

    
    //引导页
    //判断是否是第一次打开,如果是第一次打开,则显示引导页,否则直接进入程序
    //版本
    NSString *key = (NSString *)kCFBundleVersionKey;
    //新版本号
    NSString *version = [NSBundle mainBundle].infoDictionary[key];
    //老版本号
    NSString *oldVersion = [[NSUserDefaults standardUserDefaults]valueForKey:@"firstLanch"];
    //统一的环信APPKEY suizhenbao#suizhenbao
    EMOptions *options = [EMOptions optionsWithAppkey:@"1111161009178761#yuntangyi"];
    [[EMClient sharedClient] initializeSDKWithOptions:options];
    //获取根视图控制器对象
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UINavigationController *guide_Navi1 = [mainStoryboard instantiateViewControllerWithIdentifier:@"guideNavi1"];
    UMConfigInstance.appKey = @"5822ea89f29d986b8000141b";
    UMConfigInstance.channelId = @"App Store";
    [MobClick startWithConfigure:UMConfigInstance];
    //判断版本号
    if ([version isEqualToString:oldVersion])
    {
        [[NSUserDefaults standardUserDefaults]setObject:@"skipGuide_YES" forKey:@"skipGuide"];
        [self startApp];
    }
    else
    {   //进入新手引导页
        [ZXUD setObject:NO forKey:@"new"];
        [ZXUD setBool:YES forKey:@"zd"];
        [ZXUD setBool:YES forKey:@"sy"];

        [[NSUserDefaults standardUserDefaults]setObject:@"skipGuide_NO" forKey:@"skipGuide"];
        self.window.rootViewController = guide_Navi1;
        //用于知识界面
        NSArray *pageArr = @[@"0", @"0", @"0", @"0"];
        [ZXUD setObject:pageArr forKey:@"pageArr"];
        
        [ZXUD setObject:@"0" forKey:@"firstSource_meeting"];
        [ZXUD setObject:@"0" forKey:@"firstSource_news1"];
        [ZXUD setObject:@"0" forKey:@"firstSource_news2"];
        [ZXUD setObject:@"0" forKey:@"firstSource_news3"];
        
        [ZXUD synchronize];
        [self.window makeKeyAndVisible];
    }

    [ZXUD synchronize];

#pragma mark -推送  58003a7e67e58eb970002aab
    //友盟
    //初始化方法,也可以使用(void)startWithAppkey:(NSString *)appKey launchOptions:(NSDictionary * )launchOptions httpsenable:(BOOL)value;这个方法，方便设置https请求。App Master Secret :xcqsmngr9inuhebdsg8nnanrfqm58noc
    [UMessage startWithAppkey:@"5822ea89f29d986b8000141b" launchOptions:launchOptions];
    
    //注册通知，如果要使用category的自定义策略，可以参考demo中的代码。
    [UMessage registerForRemoteNotifications];
    
    //iOS10必须加下面这段代码。
    UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
    center.delegate=self;
    UNAuthorizationOptions types10=UNAuthorizationOptionBadge|  UNAuthorizationOptionAlert|UNAuthorizationOptionSound;
    [center requestAuthorizationWithOptions:types10     completionHandler:^(BOOL granted, NSError * _Nullable error)
     {
         if (granted)
         {
             //点击允许
             //打开日志，方便调试
             [UMessage setLogEnabled:YES];
             //这里可以添加一些自己的逻辑
         }
         else
         {
             //点击不允许
             //这里可以添加一些自己的逻辑
//             [MBProgressHUD showSuccess:@"您将不能接收到消息推送"];
         }
     }];

#pragma mark -分享
    [ShareSDK registerApp:@"17e85a43d2bb4" activePlatforms:@[
                                                             @(SSDKPlatformTypeSinaWeibo),
                                                             @(SSDKPlatformTypeWechat),
                                                             @(SSDKPlatformTypeQQ)]
                 onImport:^(SSDKPlatformType platformType)
     {
         switch (platformType)
         {
             
             case SSDKPlatformTypeSinaWeibo:
                 [ShareSDKConnector connectWeibo:[WeiboSDK class]];
                 break;
             case SSDKPlatformTypeWechat:
                 [ShareSDKConnector connectWeChat:[WXApi class]];
                 break;
             case SSDKPlatformTypeQQ:
                 [ShareSDKConnector connectQQ:[QQApiInterface class] tencentOAuthClass:[TencentOAuth class]];
                 break;
             default:
                 break;
         }
     }
          onConfiguration:^(SSDKPlatformType platformType, NSMutableDictionary *appInfo)
     {
         switch (platformType)
         {
             case SSDKPlatformTypeSinaWeibo:
                 //设置新浪微博应用信息,其中authType设置为使用SSO＋Web形式授权
                 [appInfo SSDKSetupSinaWeiboByAppKey:@"3610890762" appSecret:@"53eaf9aa1f6458a8ce2021768b7f4a75" redirectUri:@"http://www.healthvision.cn/" authType:SSDKAuthTypeBoth];
                 break;
             case SSDKPlatformTypeWechat:
                 //设置微信应用信息
                 [appInfo SSDKSetupWeChatByAppId:@"wx1cde6a6f89251845" appSecret:@"997ed3cedd1f43b211cd469dda23bfd2"];
                 break;
             case SSDKPlatformTypeQQ:
                 //设置QQ应用信息，其中authType设置为只用SSO形式授权
                 [appInfo SSDKSetupQQByAppId:@"1105753956" appKey:@"Ghb6aKODEN8IGdui" authType:SSDKAuthTypeSSO];
                 break;
             default:
                 break;
         }
     }
     ];
    
    
#pragma mark -判断网络状态
    [self checkNetWork];
    
    
    return YES;
}
#pragma mark - 检测网络
- (void)checkNetWork {

    //创建一个用于测试的url
    NSURL *url=[NSURL URLWithString:@"https://www.baidu.com"];
    AFHTTPSessionManager *operationManager=[[AFHTTPSessionManager alloc]initWithBaseURL:url];
    //根据不同的网络状态改变去做相应处理
    [operationManager.reachabilityManager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {

        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            switch (status) {
                    
                case AFNetworkReachabilityStatusReachableViaWiFi:{
                    [ZXUD setObject:@"1" forKey:@"NetDataState"];
                    [ZXUD synchronize];
                    //创建弹出框
                    self.netStateView = [[NetStateView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth - 2*20, 60)];
                    self.netStateView.center = CGPointMake(self.window.center.x, KScreenHeight);
                    self.netStateView.icon.image = [UIImage imageNamed:@"wifi"];
                    self.netStateView.message.text = @"已切换到Wi-Fi网络，请放心使用";
                    //添加网络状态弹出框
//                    [self.window addSubview:self.netStateView];
                    [UIView animateWithDuration:0.1 animations:^{
                        [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
                        self.netStateView.center = CGPointMake(self.window.center.x, KScreenHeight - 45 - 60);
                    } completion:^(BOOL finished) {
                        [self performSelector:@selector(netStateViewRemove) withObject:nil afterDelay:2.0];
                    }];
                }
                    break;
                    
                case AFNetworkReachabilityStatusReachableViaWWAN:{
                    [ZXUD setObject:@"1" forKey:@"NetDataState"];
                    [ZXUD synchronize];
                    //创建弹出框
                    self.netStateView = [[NetStateView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth - 2*20, 60)];
                    self.netStateView.center = CGPointMake(self.window.center.x, KScreenHeight);
                    self.netStateView.icon.image = [UIImage imageNamed:@"2G3G"];
                    self.netStateView.message.text = @"已切换到3G/4G网络，请注意流量";
                    //添加网络状态弹出框
//                    [self.window addSubview:self.netStateView];
                    [UIView animateWithDuration:0.1 animations:^{
                        [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
                        self.netStateView.center = CGPointMake(self.window.center.x, KScreenHeight - 45 - 60);
                    } completion:^(BOOL finished) {
                        [self performSelector:@selector(netStateViewRemove) withObject:nil afterDelay:2.0];
                    }];
                }
                    break;
                    
                case AFNetworkReachabilityStatusNotReachable:{
                    [ZXUD setObject:@"0" forKey:@"NetDataState"];
                    [ZXUD synchronize];
                    //创建弹出框
                    self.netStateView = [[NetStateView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth - 2*20, 60)];
                    self.netStateView.center = CGPointMake(self.window.center.x, KScreenHeight);
                    self.netStateView.icon.image = [UIImage imageNamed:@"noNet"];
                    self.netStateView.message.text = @"当前网络不可用，请检查当前网络状态";
                    //添加网络状态弹出框
                    [self.window addSubview:self.netStateView];
                    [UIView animateWithDuration:0.1 animations:^{
                        [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
                        self.netStateView.center = CGPointMake(self.window.center.x, KScreenHeight - 45 - 60);
                    } completion:^(BOOL finished) {
                        [self performSelector:@selector(netStateViewRemove) withObject:nil afterDelay:2.0];
                    }];
                }
                    break;
                    
                case AFNetworkReachabilityStatusUnknown:{
                    [ZXUD setObject:@"0" forKey:@"NetDataState"];
                    [ZXUD synchronize];
                    //创建弹出框
                    self.netStateView = [[NetStateView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth - 2*20, 60)];
                    self.netStateView.center = CGPointMake(self.window.center.x, KScreenHeight);
                    self.netStateView.icon.image = [UIImage imageNamed:@"NetUnuse_hd"];
                    self.netStateView.message.text = @"未知网络状态";
                    //添加网络状态弹出框
                    [self.window addSubview:self.netStateView];
                    [UIView animateWithDuration:0.1 animations:^{
                        [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
                        self.netStateView.center = CGPointMake(self.window.center.x, KScreenHeight - 45 - 60);
                    } completion:^(BOOL finished) {
                        [self performSelector:@selector(netStateViewRemove) withObject:nil afterDelay:2.0];
                    }];
                }
                    break;
                default:
                    
                    break;

            }
        });
    }];
    //开始监控
    [operationManager.reachabilityManager startMonitoring];
    
}
-(void)netStateViewRemove{
    [self.netStateView removeFromSuperview];
}


//iOS10以下使用这个方法接收通知
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    //关闭友盟自带的弹出框
    [UMessage setAutoAlert:NO];
    [UMessage didReceiveRemoteNotification:userInfo];
    
    //    self.userInfo = userInfo;
    //    //定制自定的的弹出框
    //    if([UIApplication sharedApplication].applicationState == UIApplicationStateActive)
    //    {
    //        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"标题"
    //                                                            message:@"Test On ApplicationStateActive"
    //                                                           delegate:self
    //                                                  cancelButtonTitle:@"确定"
    //                                                  otherButtonTitles:nil];
    //
    //        [alertView show];
    //
    //    }
}


//iOS10新增：处理前台收到通知的代理方法
-(void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler
{
    NSDictionary * userInfo = notification.request.content.userInfo;
    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        //应用处于前台时的远程推送接受
        //关闭友盟自带的弹出框
        [UMessage setAutoAlert:NO];
        //必须加这句代码
        [UMessage didReceiveRemoteNotification:userInfo];
        NSString *Idstr = userInfo[@"aps"][@"nid"];

//        PushVC *VC = [[PushVC alloc] init];
//        VC.nid = Idstr;
//        self.window.rootViewController = VC;

//        PushVC *VC = [[PushVC alloc] init];
//        VC.nid = Idstr;
//        self.window.rootViewController = VC;
        UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
       
//        [((UITabBarController*)self.window.rootViewController) setSelectedIndex:3];
//        self.window.rootViewController = mainTabBar_C;

    }
    else
    {
        //应用处于前台时的本地推送接受
        [((UITabBarController*)self.window.rootViewController) setSelectedIndex:0];
        
    }
    //当应用处于前台时提示设置，需要哪个可以设置哪一个
    completionHandler(UNNotificationPresentationOptionSound|UNNotificationPresentationOptionBadge|UNNotificationPresentationOptionAlert);
    
}


-(void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification{
    
    [((UITabBarController*)self.window.rootViewController) setSelectedIndex:0];
    
    
}

//iOS10新增：处理后台点击通知的代理方法
-(void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler{
    NSDictionary * userInfo = response.notification.request.content.userInfo;
    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        //应用处于后台时的远程推送接受
        //必须加这句代码
        [UMessage didReceiveRemoteNotification:userInfo];
        NSString *Idstr = userInfo[@"aps"][@"nid"];

        PushVC *VC = [[PushVC alloc] init];
        VC.nid = Idstr;
        
        self.window.rootViewController = VC;

//        PushVC *VC = [[PushVC alloc] init];
//        VC.nid = Idstr;
//        self.window.rootViewController = VC;
        [((UITabBarController*)self.window.rootViewController) setSelectedIndex:3];
        if ([Idstr isEqualToString:@"meeting"]) {
            [ZXUD setObject:@"0" forKey:@"isMeeting"];
        }else {
            [ZXUD setObject:@"1" forKey:@"isMeeting"];
        }
    }
    else
    {
        //应用处于后台时的本地推送接受
         [((UITabBarController*)self.window.rootViewController) setSelectedIndex:0];
    }
    
}


- (void)applicationWillResignActive:(UIApplication *)application {
    
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    [ZXUD setBool:YES forKey:@"ht"];
    [[EMClient sharedClient] applicationDidEnterBackground:application];

}

- (void)applicationWillEnterForeground:(UIApplication *)application {
   [ZXUD setBool:NO forKey:@"ht"];
    [[EMClient sharedClient] applicationWillEnterForeground:application];

}

- (void)applicationDidBecomeActive:(UIApplication *)application {

}

- (void)applicationWillTerminate:(UIApplication *)application {
    
    [self saveContext];
}

#pragma mark - Core Data stack

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (NSURL *)applicationDocumentsDirectory {
    
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (NSManagedObjectModel *)managedObjectModel {
   
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"yuntangyi" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {

    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"yuntangyi.sqlite"];
    NSError *error = nil;
    NSString *failureReason = @"There was an error creating or loading the application's saved data.";
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[NSLocalizedDescriptionKey] = @"Failed to initialize the application's saved data";
        dict[NSLocalizedFailureReasonErrorKey] = failureReason;
        dict[NSUnderlyingErrorKey] = error;
        error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}


- (NSManagedObjectContext *)managedObjectContext {
   
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (!coordinator) {
        return nil;
    }
    _managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
    [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    return _managedObjectContext;
}

#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        NSError *error = nil;
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

//推送相关
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    // 1.2.7版本开始不需要用户再手动注册devicetoken，SDK会自动注册
    [UMessage registerDeviceToken:deviceToken];
    
//   NSLog(@"%@",[[[[deviceToken description] stringByReplacingOccurrencesOfString: @"<" withString: @""]
//                  stringByReplacingOccurrencesOfString: @">" withString: @""]
//                 stringByReplacingOccurrencesOfString: @" " withString: @""]);
}


@end

//
//  AppDelegate.m
//  友照
//
//  Created by ZX on 16/11/17.
//  Copyright © 2016年 ZX_XPH. All rights reserved.
//


#import "AppDelegate.h"

//tabBar
#import "tab_ViewController.h"
//引导页
#import "yin_dao_ye_ViewController.h"
//友盟统计
#import "UMMobClick/MobClick.h"
//友盟推送
#import "UMessage.h"
//支付
#import "ZX_PayCoin_ViewController.h"
//ShareSDK分享
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKConnector/ShareSDKConnector.h>
#import <TencentOpenAPI/TencentOAuth.h>
#import <TencentOpenAPI/QQApiInterface.h>
#import "WXApi.h"
#import "WeiboSDK.h"

#import <AlipaySDK/AlipaySDK.h>

@interface AppDelegate ()<UNUserNotificationCenterDelegate,WXApiDelegate>


@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];

    //监测网络状态
    [self checkNetWork];
    [ZXUD setBool:NO forKey:@"dwcg"];
    [ZXUD setObject:@"1" forKey:@"personalCity"];

    //注册微信app
    [WXApi registerApp:@"wxe120920b1ec6d0c4"];
    
    //友盟
    //社区
    [UMCommunitySDK setAppkey:@"5710e5d9e0f55a661e000a26" withAppSecret:@"137e632b0f30740eceb2054e0bc71d59"];
    
    //后台收到消息推送之后处理消息
//    NSDictionary *notificationDict = [launchOptions valueForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
//
//    if ([notificationDict valueForKey:@"umwsq"])
//    {
//        //判断是否石友盟微社区的消息推送
//        [UMComMessageManager startWithOptions:launchOptions];
//        if ([notificationDict valueForKey:@"aps"]) // 点击推送进入
//        {
//            [UMComMessageManager didReceiveRemoteNotification:notificationDict];
//        }
//    } else
//    {
//        [UMComMessageManager startWithOptions:nil];
//    }
//
//    //推送
//    [UMessage startWithAppkey:@"5710e5d9e0f55a661e000a26" launchOptions:launchOptions];
//    [UMessage registerForRemoteNotifications];
//    UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
//    center.delegate=self;
//    UNAuthorizationOptions types10=UNAuthorizationOptionBadge|  UNAuthorizationOptionAlert|UNAuthorizationOptionSound;
//    [center requestAuthorizationWithOptions:types10     completionHandler:^(BOOL granted, NSError * _Nullable error)
//    {
//        if (granted)
//        {
//            //打开日志，方便调试
//            [UMessage setLogEnabled:YES];
//        }
//        else
//        {
//            //这里可以添加一些自己的逻辑
//            [MBProgressHUD showSuccess:@"您将不能接收到消息推送"];
//        }
//    }];
//    
    //统计
    UMConfigInstance.appKey = @"5710e5d9e0f55a661e000a26";
    UMConfigInstance.channelId = @"App Store";
    [MobClick startWithConfigure:UMConfigInstance];

    //分享
    [ShareSDK registerApp:@"19f9919628e1a"
          activePlatforms:@[
                            @(SSDKPlatformTypeWechat),
                            @(SSDKPlatformTypeQQ)]
                 onImport:^(SSDKPlatformType platformType)
     {
         switch (platformType)
         {
             case SSDKPlatformTypeWechat:
                 [ShareSDKConnector connectWeChat:[WXApi class]];
                 break;
             case SSDKPlatformTypeQQ:
                 [ShareSDKConnector connectQQ:[QQApiInterface class] tencentOAuthClass:[TencentOAuth class]];
                 break;
             case SSDKPlatformTypeSinaWeibo:
                 [ShareSDKConnector connectWeibo:[WeiboSDK class]];
                 break;
             default:
                 break;
         }
     }
          onConfiguration:^(SSDKPlatformType platformType, NSMutableDictionary *appInfo)
     {
         
         switch (platformType)
         {
             case SSDKPlatformTypeWechat:
                 [appInfo SSDKSetupWeChatByAppId:@"wxe120920b1ec6d0c4"
                                       appSecret:@"9b2c9819fc1785033a709935c797e57b"];
                 break;
             case SSDKPlatformTypeQQ:
                 [appInfo SSDKSetupQQByAppId:@"1105392236"
                                      appKey:@"Y3X0EIdOBcJMq4o37"
                                    authType:SSDKAuthTypeBoth];
                 break;
            default:
                 break;
         }
     }];
    
    //判断是否显示引导页
    
    //获取版本的 key
    NSString *key = (NSString *)kCFBundleVersionKey;
    //获取当前的版本
    NSString *version = [NSBundle mainBundle].infoDictionary[key];
    //获取原来的版本
    NSString *oldVersion = [[NSUserDefaults standardUserDefaults] objectForKey:@"firstlaunch"];
    //不是第一次启动
    if ([version isEqualToString:oldVersion])
    {
        tab_ViewController *tabbar = [[tab_ViewController alloc]init];
        self.window.rootViewController = tabbar;        
    }
    else
    {
        yin_dao_ye_ViewController *yindao = [[yin_dao_ye_ViewController alloc]init];
        self.window.rootViewController = yindao;
        [[NSUserDefaults standardUserDefaults] setObject:version forKey:@"firstlaunch"];
        //保存考试次数
        [[NSUserDefaults standardUserDefaults] setObject:@"0" forKey:@"mockTime1"];
        [[NSUserDefaults standardUserDefaults] setObject:@"0" forKey:@"mockTime4"];
        //是否引导答题
        [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"guideQuestion"];
        
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    [self.window makeKeyAndVisible];
    
    return YES;
}

//监测网络状态
- (void)checkNetWork
{
    //创建一个用于测试的url
    NSURL *url=[NSURL URLWithString:@"https://www.apple.com"];
    AFHTTPSessionManager *operationManager=[[AFHTTPSessionManager alloc]initWithBaseURL:url];
    
    //根据不同的网络状态改变去做相应处理
    [operationManager.reachabilityManager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        switch (status)
        {
            case AFNetworkReachabilityStatusReachableViaWWAN:
                [ZXUD setBool:YES forKey:@"NetDataState"];
                [ZXUD synchronize];
                break;
                
            case AFNetworkReachabilityStatusReachableViaWiFi:
                [ZXUD setBool:YES forKey:@"NetDataState"];
                [ZXUD synchronize];
                break;
                
            case AFNetworkReachabilityStatusNotReachable:{
                [ZXUD setBool:NO forKey:@"NetDataState"];
                [ZXUD synchronize];
                UIAlertView *netStateAlertView = [[UIAlertView alloc] initWithTitle:@"没有网络连接" message:@"设置你的网络？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
                [netStateAlertView show];
            }
                break;
            case AFNetworkReachabilityStatusUnknown:
            default:
                break;
        }
    }];
    //开始监控
    [operationManager.reachabilityManager startMonitoring];
}

//支付回调
- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString *,id> *)options
{
    if ([[[[url absoluteString] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding] substringToIndex:2] isEqualToString:@"wx"])
    {
        //微信支付回调
        return [WXApi handleOpenURL:url delegate:self];
    }
    else
    {
        //支付宝支付回调
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic)
         {
             YZLog(@"result = %@",resultDic);
             NSString *resultValue = resultDic[@"resultStatus"];
             [[NSNotificationCenter defaultCenter]postNotificationName:@"NFPaySuccess" object:nil userInfo:@{@"result":resultValue}];
         }];
    }
    return YES;
}

//微信支付返回app
-(void)onResp:(BaseResp*)resp
{
    if ([resp isKindOfClass:[PayResp class]])
    {
        PayResp*response = (PayResp*)resp;
        switch(response.errCode)
        {
            case WXSuccess:
                //服务器端查询支付通知或查询API返回的结果再提示成功
                YZLog(@"支付成功");
                [ZXUD setValue:@"1" forKey:@"wxresult"];
                break;
                
            case WXErrCodeUserCancel:
                YZLog(@"用户取消支付");
                YZLog(@"用户取消支付: %d",resp.errCode);
                [ZXUD setValue:@"2" forKey:@"wxresult"];
                break;
                
            default:
                YZLog(@"支付失败，retcode=%d",resp.errCode);
                [MBProgressHUD showSuccess:@"支付失败"];
                break;
        }
        NSString *WXresult = [ZXUD objectForKey:@"wxresult"];
        [[NSNotificationCenter defaultCenter]postNotificationName:@"NFPaySuccess" object:nil userInfo:@{@"result":WXresult}];
    }
}
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    YZLog(@"----devicetoken------%@",[[[[deviceToken description] stringByReplacingOccurrencesOfString: @"<" withString: @""]
                                       stringByReplacingOccurrencesOfString: @">" withString: @""]
                                      stringByReplacingOccurrencesOfString: @" " withString: @""]);
    [UMComMessageManager registerDeviceToken:deviceToken];
}
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    if ([userInfo valueForKey:@"umwsq"])
    {
        [UMComMessageManager didReceiveRemoteNotification:userInfo];
    }
    else
    {
        //使用你自己的消息推送处理
    }
}

//微信支付
- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    
    return  [WXApi handleOpenURL:url delegate:self];
}
- (void)applicationWillResignActive:(UIApplication *)application {
  
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
   
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
   
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    
}


- (void)applicationWillTerminate:(UIApplication *)application {

}


@end

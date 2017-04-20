//
//  AppDelegate.m
//  银联支付1
//
//  Created by syq on 16/3/13.
//  Copyright © 2016年 lanou.syq. All rights reserved.
//

#import "AppDelegate.h"
#import "UPPaymentControl.h"
@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString*, id> *)options{
    [[UPPaymentControl defaultControl] handlePaymentResult:url completeBlock:^(NSString *code, NSDictionary *data) {
        NSLog(@"%@",data);
        //结果code为成功时，先校验签名，校验成功后做后续处理
        if([code isEqualToString:@"success"]) {
            //判断签名数据是否存在
            if(data == nil){
                //如果没有签名数据，建议商户app后台查询交易结果
                return;
            }
            //数据从NSDictionary转换为NSString
            NSData *signData = [NSJSONSerialization dataWithJSONObject:data
                                                               options:0
                                                                 error:nil];
            NSString *sign = [[NSString alloc] initWithData:signData encoding:NSUTF8StringEncoding];
            //验签证书同后台验签证书
            //此处的verify，商户需送去商户后台做验签
            if([self verify:sign]) {
                //支付成功且验签成功，展示支付成功提示
            }
            else {
                //验签失败，交易结果数据被篡改，商户app后台查询交易结果
                NSLog(@"验签失败，交易结果数据被篡改，商户app后台查询交易结果");
            }
        }
        else if([code isEqualToString:@"fail"]) {
            //交易失败
            NSLog(@"交易失败");
        }
        else if([code isEqualToString:@"cancel"]) {
            //交易取消
            NSLog(@"交易取消");
        }
    }];
    return YES;
}



- (NSString *) readPublicKey:(NSString *) keyName
{
    if (keyName == nil || [keyName isEqualToString:@""]) return nil;
    
    NSMutableArray *filenameChunks = [[keyName componentsSeparatedByString:@"."] mutableCopy];
    NSString *extension = filenameChunks[[filenameChunks count] - 1];
    [filenameChunks removeLastObject]; // remove the extension
    NSString *filename = [filenameChunks componentsJoinedByString:@"."]; // reconstruct the filename with no extension
    
    NSString *keyPath = [[NSBundle mainBundle] pathForResource:filename ofType:extension];
    
    NSString *keyStr = [NSString stringWithContentsOfFile:keyPath encoding:NSUTF8StringEncoding error:nil];
    
    return keyStr;
}

-(BOOL) verify:(NSString *) resultStr {
    
    //验签证书同后台验签证书
    //此处的verify，商户需送去商户后台做验签
    return NO;
}

//-(BOOL) verifyLocal:(NSString *) resultStr {
//
//    //从NSString转化为NSDictionary
//    NSData *resultData = [resultStr dataUsingEncoding:NSUTF8StringEncoding];
//    NSDictionary *data = [NSJSONSerialization JSONObjectWithData:resultData options:0 error:nil];
//
//    //获取生成签名的数据
//    NSString *sign = data[@"sign"];
//    NSString *signElements = data[@"data"];
//    //NSString *pay_result = signElements[@"pay_result"];
//    //NSString *tn = signElements[@"tn"];
//    //转换服务器签名数据
//    NSData *nsdataFromBase64String = [[NSData alloc]
//                                      initWithBase64EncodedString:sign options:0];
//    //生成本地签名数据，并生成摘要
////    NSString *mySignBlock = [NSString stringWithFormat:@"pay_result=%@tn=%@",pay_result,tn];
//    NSData *dataOriginal = [[self sha1:signElements] dataUsingEncoding:NSUTF8StringEncoding];
//    //验证签名
//    //TODO：此处如果是正式环境需要换成public_product.key
//    NSString *pubkey =[self readPublicKey:@"public_test.key"];
//    OSStatus result=[RSA verifyData:dataOriginal sig:nsdataFromBase64String publicKey:pubkey];
//
//
//
//    //签名验证成功，商户app做后续处理
//    if(result == 0) {
//        //支付成功且验签成功，展示支付成功提示
//        return YES;
//    }
//    else {
//        //验签失败，交易结果数据被篡改，商户app后台查询交易结果
//        return NO;
//    }
//
//    return NO;
//}


@end

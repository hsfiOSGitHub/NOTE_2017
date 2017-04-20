//
//  UMComLoginManager.m
//  UMCommunity
//
//  Created by Gavin Ye on 8/25/14.
//  Copyright (c) 2014 Umeng. All rights reserved.
//

#import "UMComLoginManager.h"
#import <UMCommunitySDK/UMComSession.h>
#import "UMComMessageManager.h"
#import "UMComShowToast.h"
#import <UMComFoundation/UMUtils.h>
#import "UMComNavigationController.h"
#import <UMComNetwork/UMComHttpCode.h>
#import <UMComDataStorage/UMComDataBaseManager.h>
#import <UMCommunitySDK/UMComDataTypeDefine.h>
#import "UMComNotificationMacro.h"
#import <UMCommunitySDK/UMCommunitySDK.h>

@interface UMComLoginManager ()

@property (nonatomic, strong) UIViewController *currentViewController;

@property (nonatomic, copy) void (^loginCompletion)(id responseObject, NSError *error);//登录回调


@property (nonatomic, assign) BOOL didUpdateFinish;


@end

@implementation UMComLoginManager

+ (void)load
{
    [self shareInstance];
}

+ (UMComLoginManager *)shareInstance {
    static UMComLoginManager *_instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[UMComLoginManager alloc] init];

    });
    return _instance;
}

- (id)init
{
    self = [super init];
    if (self) {
        [self registerNotifications];
    }
    return self;
}

- (void)registerNotifications
{
    __weak typeof(self) ws = self;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(removePushAlias) name:kUserLogoutSucceedNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(loginWhenReceivedLoginError) name:kUMComUserDidNotLoginErrorNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserverForName:kUMComUpdateAppKeyNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification * _Nonnull note) {
        [ws setAppKey:[UMCommunitySDK appKey]];
    }];
}

- (void)loginWhenReceivedLoginError
{
    [UMComLoginManager performLogin:[UIApplication sharedApplication].keyWindow.rootViewController completion:^(id responseObject, NSError *error) {
        
    }];
}

- (void)setAppKey:(NSString *)appKey
{
    if ([self.loginHandler respondsToSelector:@selector(setAppKey:)]) {
        [self.loginHandler setAppKey:appKey];
    }
}

+ (void)performLogin:(UIViewController *)viewController completion:(void (^)(id responseObject, NSError *error))completion
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if ([ZXUD boolForKey:@"IS_LOGIN"]) {
            if (completion) {
                completion([UMComSession sharedInstance].loginUser,nil);
            }
            //    }
            //    else if ([self shareInstance].loginHandler) {
            //        id<UMComLoginDelegate> loginHandler = [self shareInstance].loginHandler;
            ////
            //        if ([loginHandler respondsToSelector:@selector(presentLoginViewController:finishResponse:)]) {
            //            [self shareInstance].currentViewController = viewController;
            //            [self shareInstance].loginCompletion = completion;
            //            [loginHandler presentLoginViewController:viewController finishResponse:nil];
            ////        }
        }else{
            //        UMLog(@"There is no implement login delegate method");
            //发通知(跳到登录界面)
            [[NSNotificationCenter defaultCenter] postNotificationName:@"Login" object:nil userInfo:nil];
        }

    });
}

+ (BOOL)isLogin{
     BOOL isLogin = ([UMComSession sharedInstance].uid != nil);
     return isLogin;
}

+ (BOOL)handleOpenURL:(NSURL *)url
{
    if ([[self shareInstance].loginHandler respondsToSelector:@selector(handleOpenURL:)]) {
        return [[self shareInstance].loginHandler handleOpenURL:url];
    }
    return NO;
}

+ (void)userLogout
{
    [[UMComLoginManager shareInstance] removePushAlias];
    [[UMComSession sharedInstance] userLogout];
    [[NSNotificationCenter defaultCenter] postNotificationName:kUserLogoutSucceedNotification object:nil];
}

- (void)removePushAlias
{
    if ([UMComSession sharedInstance].uid) {
        [UMComMessageManager removeAlias:[UMComSession sharedInstance].uid type:kNSAliasKey response:^(id responseObject, NSError *error) {
            if (error) {
                UMLog(@"remove alias error: %@", error);
            }
        }];
    }
}

+ (void)loginSuccessWithUser:(UMComUser *)loginUser
{
    if (![loginUser isKindOfClass:[UMComUser class]]) {
        return;
    }
    [UMComSession sharedInstance].loginUser = loginUser;
    [[UMComDataBaseManager shareManager] saveRelatedIDTableWithType:UMComRelatedRegisterUserID withUsers:@[loginUser]];
    
    [[UMComSession sharedInstance] refreshConfigDataWithCompletion:nil];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kUserLoginSucceedNotification object:nil];
    [UMComMessageManager addAlias:loginUser.uid type:kNSAliasKey response:^(id responseObject, NSError *error) {
        if (error) {
            //添加alias失败的话在每次启动时候重新添加
            [[NSUserDefaults standardUserDefaults] setObject:@YES forKey:@"UMComMessageAddAliasFail"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            UMLog(@"add alias error: %@", error);
        }
    }];
}


/**
 *  登录流程：
 *  1、修复登录错误：若用户名问题，需改后提交成功继续下一步
 *  2、保存用户登录数据，注册推送消息，获取配置信息
 *  3、若没有触发1，则弹出个人信息页面确认修改
 *  4、第一次登录弹出推荐页
 *  5、返回调用者
 *
 *  @param responseObject 登录返回user相关数据
 *  @param error          错误信息
 *  @param originalUser   第三方平台登录用户信息或待修改信息
 */
+ (void)loginFlowWithData:(NSDictionary *)responseObject error:(NSError *)error originalLoginData:(UMComLoginUser *)originalUser;
{
    __weak UMComLoginManager *weakLoginManager = [self shareInstance];
    id<UMComLoginDelegate> handler = weakLoginManager.loginHandler;
    if (error) {
        if ([handler respondsToSelector:@selector(handleLoginError:inViewController:withLoginData:)]) {
            [handler handleLoginError:error inViewController:weakLoginManager.currentViewController withLoginData:originalUser];
        }
        return;
    }
    
    UMComUser *loginUser = responseObject[@"data"];
    
    dispatch_block_t returnBlock = ^{
        SafeCompletionDataAndError(weakLoginManager.loginCompletion, [UMComSession sharedInstance].uid, nil);
        weakLoginManager.loginCompletion = nil;
        weakLoginManager.currentViewController = nil;
    };
    
    if (loginUser) {
        [self loginSuccessWithUser:loginUser];
        
        /**
         *  第一次登录逻辑
         */
        if ([loginUser.registered integerValue] == 0) {
            dispatch_block_t afterRegisterEvent = ^{
                /**
                 *  处理第一次登陆后事务，如展示推荐等
                 */
                if ([handler respondsToSelector:@selector(handleEventAfterRegister:completion:)]) {
                    [handler handleEventAfterRegister:[self shareInstance].currentViewController completion:returnBlock];
                } else {
                    returnBlock();
                }
            };
            
            /**
             *  处理第一次登陆后个人信息的修改
             */
            if ([handler respondsToSelector:@selector(updateProfileInViewController:withLoginData:completion:)]) {
                [handler updateProfileInViewController:[self shareInstance].currentViewController withLoginData:originalUser completion:afterRegisterEvent];
            } else {
                afterRegisterEvent();
            }
            
        } else {
            returnBlock();
        }
    } else {
        returnBlock();
    }
}

@end

@implementation UMComLoginManager (LoginRequest)

+ (void)requestLoginWithLoginAccount:(UMComLoginUser *)userAccount requestCompletion:(UMComLoginCompletion)completion
{
    UMComDataRequestManager *request = [UMComDataRequestManager defaultManager];
    if (userAccount.snsType > 0)
    {
        NSMutableDictionary *context = [NSMutableDictionary dictionary];
        context[@"wxunionid"] = userAccount.unionId;
        [request userLoginWithName:userAccount.name
                            source:userAccount.snsType
                          sourceId:userAccount.usid
                          icon_url:userAccount.icon_url
                            gender:userAccount.gender.integerValue
                               age:userAccount.age.integerValue
                            custom:userAccount.custom
                             score:0
                        levelTitle:nil
                             level:0
                 contextDictionary:context
                      userNameType:userNameDefault
                    userNameLength:userNameLengthDefault completion:^(NSDictionary *responseObject, NSError *error) {
                        if (completion) {
                            completion(responseObject, error, ^{
                                [self loginFlowWithData:responseObject error:error originalLoginData:userAccount];
                            });
                        }
                    }];
    }
    else
    {
        [request userCustomAccountLoginWithName:userAccount.name
                                       sourceId:userAccount.usid
                                       icon_url:userAccount.icon_url
                                         gender:userAccount.gender.integerValue
                                            age:userAccount.age.integerValue
                                         custom:userAccount.custom
                                          score:0
                                     levelTitle:nil
                                          level:0
                              contextDictionary:nil
                                   userNameType:userNameDefault
                                 userNameLength:userNameLengthDefault completion:^(NSDictionary *responseObject, NSError *error) {
                                     if (completion) {
                                         completion(responseObject, error, ^{
                                             [self loginFlowWithData:responseObject error:error originalLoginData:userAccount];
                                         });
                                     }
                                 }];
    }
}

+ (void)requestLoginWithEmailAccount:(NSString *)emailAccount password:(NSString *)password requestCompletion:(UMComLoginCompletion)completion
{
    if (![emailAccount isKindOfClass:[NSString class]] ||
        ![password isKindOfClass:[NSString class]] ||
        emailAccount.length == 0 || password.length == 0) {
        UMLog(@"%s: invalid params", __func__);
        return;
    }
    [[UMComDataRequestManager defaultManager] userLoginInUMCommunity:emailAccount password:password response:^(NSDictionary *responseObject, NSError *error) {
        if (completion) {
            completion(responseObject, error, ^{
                [self loginFlowWithData:responseObject error:error originalLoginData:nil];
            });
        }
    }];
}

+ (void)requestRegisterWithEmailAccount:(NSString *)emailAccount password:(NSString *)password nickName:(NSString *)nickName requestCompletion:(UMComLoginCompletion)completion
{
    if (![emailAccount isKindOfClass:[NSString class]] ||
        ![password isKindOfClass:[NSString class]] ||
        ![nickName isKindOfClass:[NSString class]] ||
        emailAccount.length == 0 || password.length == 0 || nickName.length == 0) {
        UMLog(@"%s: invalid params", __func__);
        return;
    }
    [[UMComDataRequestManager defaultManager] userSignUpUMCommunity:emailAccount password:password nickName:nickName response:^(NSDictionary *responseObject, NSError *error) {
        if (completion) {
            completion(responseObject, error, ^{
                [self loginFlowWithData:responseObject error:error originalLoginData:nil];
            });
        }
    }];
}


@end

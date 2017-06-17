//
//  DDNetworkManager.m
//  
//
//  Created by Qin on 16/6/7.
//  Copyright © 2016年 秦. All rights reserved.
//

#import "DDNetworkManager.h"
#import "AFNetworking.h"
#import "SVProgressHUD.h"
#import "DDCache.h"

@interface DDNetworkManager ()


@end

@implementation DDNetworkManager

DDNetworkObjSingleM;

+(void)loginPOST {
    AFHTTPSessionManager *manager = [self AFNetManager];
    AFSecurityPolicy *securityPolicy = [[AFSecurityPolicy alloc] init];
    [securityPolicy setAllowInvalidCertificates:NO];
    manager.securityPolicy = securityPolicy;
}

+ (void)GET:(NSString *)urlString parameters:(NSDictionary *)parameters success:(RequestSuccessBlock)resposeValue failure:(RequestFailureBlock )failure{

    [self starInfocatorVisible];
    
    [[self AFNetManager] GET:urlString
                         parameters:parameters
                         progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (resposeValue) {
            resposeValue(responseObject);
        }
        [self stopIndicatorVisible];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
             failure(error.localizedDescription);
        }
        [self showError:error.localizedDescription];
    }];
}

+ (void)GETCache:(NSString *)urlString parameters:(NSDictionary *)parameters success:(void (^)(id))resposeValue failure:(RequestFailureBlock )failure{
    [self starInfocatorVisible];
    [[self AFNetManager] GET:urlString
                         parameters:parameters
                         progress:^(NSProgress * _Nonnull downloadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (resposeValue) {
            resposeValue(responseObject);
        }
        [DDCache qsh_saveDataCache:responseObject forKey:urlString];
        [self stopIndicatorVisible];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        resposeValue([DDCache qsh_ReadCache:urlString]);
        if (failure) {
            failure(error.localizedDescription);
        }
        [self showError:error.localizedDescription];
    }];
}

+ (void)POST:(NSString *)urlString parameters:(NSDictionary *)parameters success:(RequestSuccessBlock)resposeValue failure:(RequestFailureBlock )failure{
    [self starInfocatorVisible];
    [[self AFNetManager] POST:urlString parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (resposeValue) {
            resposeValue(responseObject);
        }
        [self stopIndicatorVisible];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self showError:error.localizedDescription];
        if (failure) {
            failure(error.localizedDescription);
        }
    }];
}

+ (void)POSTCache:(NSString *)urlString parameters:(NSDictionary *)parameters success:(void (^)(id))resposeValue failure:(RequestFailureBlock )failure {
    [self starInfocatorVisible];
    [[self AFNetManager] POST:urlString parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (resposeValue) {
            resposeValue(responseObject);
        }
        [DDCache qsh_saveDataCache:responseObject forKey:urlString];
        [self stopIndicatorVisible];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        resposeValue([DDCache qsh_ReadCache:urlString]);
        if (failure) {
            failure(error.localizedDescription);
        }
        [self showError:error.localizedDescription];
    }];
}

+ (void)POST:(NSString *)URLString
        parameters:(id)parameters
constructingBodyWithFormDataArray:(NSArray<FormData *> *)formDataArray
     success:(void (^)(id responseObject))success
     failure:(void (^)(NSError *error))failure
{
    [[self AFNetManager] POST:URLString
                         parameters:parameters
                         constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        for (FormData * data in formDataArray) {
            [formData appendPartWithFileData:data.data
                      name:data.name
                      fileName:data.fileName
                      mimeType:data.mimeType];
            
        }
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        NSLog(@"%lf",1.0 * uploadProgress.completedUnitCount / uploadProgress.totalUnitCount);
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        //   [MBProgressHUD showMessage:error.localizedDescription];
        
        failure(error);
    }];
}

+ (void)POSTs:(NSString *)URLString
  parameters:(id)parameters
constructingBodyWithFormDataArray:(NSArray *)formDataArray
     success:(void (^)(id responseObject))success
     failure:(void (^)(NSError *error))failure
{
    [[self AFNetManager] POST:URLString parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        for (int i = 0; i < formDataArray.count; i++) {
            UIImage *image = formDataArray[i];
            NSData *imageData = UIImageJPEGRepresentation(image, 0.5);
            
            FormData *data = [[FormData alloc] init];
            data.name = @"avatar";
            data.data = imageData;
            data.mimeType = @"image/jpg";
            data.fileName = @"headicon.jpg";
            
            [formData appendPartWithFileData:data.data
                                        name:data.name
                                    fileName:data.fileName
                                    mimeType:data.mimeType];
//            // 在网络开发中，上传文件时，是文件不允许被覆盖，文件重名
//            // 要解决此问题，
//            // 可以在上传时使用当前的系统事件作为文件名
//            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
//            // 设置时间格式
//            [formatter setDateFormat:@"yyyyMMddHHmmss"];
//            NSString *dateString = [formatter stringFromDate:[NSDate date]];
//            NSString *fileName = [NSString  stringWithFormat:@"%@%d.jpg", dateString,i];
//            /*
//             *该方法的参数
//             1. appendPartWithFileData：要上传的照片[二进制流]
//             2. name：对应网站上[upload.php中]处理文件的字段（比如upload）
//             3. fileName：要保存在服务器上的文件名
//             4. mimeType：上传的文件的类型
//             */
//            [formData appendPartWithFileData:imageData name:@"Upload" fileName:fileName mimeType:@"image/jpeg"]; //
        }
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
    }];
//    
//    [[self AFNetManager] POST:[NSString stringWithFormat:@"%@%@",kRequestHeaderUrl,URLString] parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
//        //        for (FormData * data in formDataArray) {
//        //            [formData appendPartWithFileData:data.data
//        //                                        name:data.name
//        //                                    fileName:data.fileName
//        //                                    mimeType:data.mimeType];
//        //        }
//        // formData: 专门用于拼接需要上传的数据,在此位置生成一个要上传的数据体
//        // 这里的_photoArr是你存放图片的数组
//        for (int i = 0; i < formDataArray.count; i++) {
//            
//            UIImage *image = formDataArray[i];
//            NSData *imageData = UIImageJPEGRepresentation(image, 0.5);
//            // 在网络开发中，上传文件时，是文件不允许被覆盖，文件重名
//            // 要解决此问题，
//            // 可以在上传时使用当前的系统事件作为文件名
//            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
//            // 设置时间格式
//            [formatter setDateFormat:@"yyyyMMddHHmmss"];
//            NSString *dateString = [formatter stringFromDate:[NSDate date]];
//            NSString *fileName = [NSString  stringWithFormat:@"%@%d.jpg", dateString,i];
//            /*
//             *该方法的参数
//             1. appendPartWithFileData：要上传的照片[二进制流]
//             2. name：对应网站上[upload.php中]处理文件的字段（比如upload）
//             3. fileName：要保存在服务器上的文件名
//             4. mimeType：上传的文件的类型
//             */
//            [formData appendPartWithFileData:imageData name:@"Upload" fileName:fileName mimeType:@"image/jpeg"]; //
//        }
//    } success:^(NSURLSessionDataTask *task, id responseObject) {
//        success(responseObject);
//        
//    } failure:^(NSURLSessionDataTask *task, NSError *error) {
//        failure(error);
//    }];
}

/**
 *  公用一个AFHTTPSessionManager
 *
 *  @return AFHTTPSessionManager
 */
+ (AFHTTPSessionManager *)AFNetManager
{
    static AFHTTPSessionManager *manager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [AFHTTPSessionManager manager];
        //设置请求的超时时间
        manager.requestSerializer.timeoutInterval = 2000.f;
//        manager.securityPolicy = [self customSecurityPolicy];
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html", @"text/json", @"text/plain", @"text/javascript", @"text/xml", @"image/*", nil];
    });
    return manager;
}

// SSL认证
+ (AFSecurityPolicy*)customSecurityPolicy

{
    // /先导入证书,证书导入项目中
    
    NSString *cerPath = [[NSBundle mainBundle] pathForResource:@"YourCertificate" ofType:@"cer"];//证书的路径
    
    NSData *certData = [NSData dataWithContentsOfFile:cerPath];
    
    // AFSSLPinningModeCertificate 使用证书验证模式
    
    AFSecurityPolicy *securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeCertificate];
    
    // allowInvalidCertificates 是否允许无效证书（也就是自建的证书），默认为NO
    
    // 如果是需要验证自建证书，需要设置为YES
    
    securityPolicy.allowInvalidCertificates = YES;
    
    //validatesDomainName 是否需要验证域名，默认为YES；
    
    //假如证书的域名与你请求的域名不一致，需把该项设置为NO；如设成NO的话，即服务器使用其他可信任机构颁发的证书，也可以建立连接，这个非常危险，建议打开。
    
    //置为NO，主要用于这种情况：客户端请求的是子域名，而证书上的是另外一个域名。因为SSL证书上的域名是独立的，假如证书上注册的域名是www.google.com，那么mail.google.com是无法验证通过的；当然，有钱可以注册通配符的域名*.google.com，但这个还是比较贵的。
    
    //如置为NO，建议自己添加对应域名的校验逻辑。
    
    securityPolicy.validatesDomainName = NO;
    
    securityPolicy.pinnedCertificates = [NSSet setWithObjects:certData, nil];// @[certData];
    
    return securityPolicy;
    
}

#pragma mark - 网络加载相关

+ (void)starInfocatorVisible {
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleCustom];
    
    [SVProgressHUD setDefaultAnimationType:SVProgressHUDAnimationTypeNative];
    
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeClear];
    
    [SVProgressHUD show ];
}

+ (void)stopIndicatorVisible {
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    
    [SVProgressHUD dismiss];

}

+ (void)showError:(NSString *)errorString {
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    
    [SVProgressHUD showErrorWithStatus:errorString];
    
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
    
    [SVProgressHUD setDefaultAnimationType:SVProgressHUDAnimationTypeNative];
}
@end

#pragma mark request_sendModel


@interface DDNetworkManagerDate ()

@property(nonatomic,copy,readonly)NSString *url;
@property(nonatomic,strong,readonly)NSDictionary *parameters;

@end

@implementation DDNetworkManagerDate

+(instancetype)initWithUrl:(NSString *)url parameters:(NSDictionary *)parameters{
    return [[self alloc] initWithUrl:url parameters:parameters];
}

-(instancetype)initWithUrl:(NSString *)url parameters:(NSDictionary *)parameters{
    if (self = [super init]) {
        self.url = url;
        self.parameters = parameters;
    }
    return self;
}

-(void)setUrl:(NSString *)url{
    _url = url;
}

-(void)setParameters:(NSDictionary *)parameters{
    NSMutableDictionary *muparameters =(parameters)?parameters.mutableCopy:@{}.mutableCopy;
    //([DDUserManager sharedInstance].isLogin)?[muparameters setValue:[DDUserManager sharedInstance].userToken forKey:@"token"]:muparameters;
    NSArray *allKey = [muparameters allKeys];
    NSArray *values = [muparameters allValues];
    __block NSString *urlStr = @"";
    
    [allKey enumerateObjectsUsingBlock:^(NSString  *_Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSString *value = (idx < values.count)?value = values[idx]:@"";
        urlStr = [urlStr stringByAppendingFormat:@"&%@=%@",obj,value];
    }];
    
#ifdef DEBUG
    DLog(@"\n\n\n\n*************\n*****************\n%@%@%@?%@\n***************\n***************\n\n\n\n",kRequestHeaderUrl,@"",_url,urlStr);
#else
    
#endif
    _parameters = muparameters.copy;
    _url = [NSString stringWithFormat:@"%@%@",kRequestHeaderUrl,_url];
}

/**
 请求数据成功结果
 */
-(void)post_RequestFinshSuccess:(RequestSuccessBlock)success failure:(RequestFailureBlock )failure{
    [DDNetworkManager POST:self.url parameters:self.parameters success:success failure:failure];
}

/**
 get请求数据成功结果
 */
-(void)get_RequestFinshSuccess:(RequestSuccessBlock )success failure:(RequestFailureBlock )failure{
    [DDNetworkManager GET:self.url parameters:self.parameters success:success failure:failure];
}

/**
 post缓存 请求数据成功结果
 */
-(void)postCache_RequestFinshSuccess:(RequestSuccessBlock )success failure:(RequestFailureBlock )failure{
    [DDNetworkManager POSTCache:self.url parameters:self.parameters success:success failure:failure];
}

/**
 get 缓存 请求数据成功结果
 */
-(void)getCache_RequestFinshSuccess:(RequestSuccessBlock )success failure:(RequestFailureBlock )failure{
    [DDNetworkManager GETCache:self.url parameters:self.parameters success:success failure:failure];
}



#pragma mark-request_URL


#pragma mark- 我的模块接口
/*
 1.获取验证码
 URL：  /api/api/sendMsg
 参数：  phone（手机号）
 **/
+(instancetype)makeUrlResult_sendMsg_withPhone:(NSString *)phone{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    if (phone) {
        [param setObject:phone forKey:@"phone"];
    }
    return [DDNetworkManagerDate initWithUrl:@"/api/api/sendMsg" parameters:param];
}

/*
 2.注册
 URL：  /userapi/user/register
 参数：  nickname（用户名）
 phone(手机号)
 password（密码）
 repassword（确认密码）
 verifyCode（短信验证码）
 **/
+(instancetype)makeUrlResult_register_withNickname:(NSString *)nickname phone:(NSString *)phone password:(NSString *)password repassword:(NSString *)repassword verifyCode:(NSString *)verifyCode{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    if (nickname) {
        [param setObject:nickname forKey:@"nickname"];
    }
    if (phone) {
        [param setObject:phone forKey:@"phone"];
    }
    if (password) {
        [param setObject:password forKey:@"password"];
    }
    if (repassword) {
        [param setObject:repassword forKey:@"repassword"];
    }
    if (verifyCode) {
        [param setObject:verifyCode forKey:@"verifyCode"];
    }
    
    return [DDNetworkManagerDate initWithUrl:@"/userapi/user/register" parameters:param];
}

/*
 3.登录
 URL：  /userapi/user/login
 参数：  type（密码登录方式 ： 传2）
 phone(手机号)
 password（密码）
 **/
+(instancetype)makeUrlResult_login_withType:(NSString *)type phone:(NSString *)phone password:(NSString *)password{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    if (type) {
        [param setObject:type forKey:@"type"];
    }
    if (phone) {
        [param setObject:phone forKey:@"phone"];
    }
    if (password) {
        [param setObject:password forKey:@"password"];
    }
    
    return [DDNetworkManagerDate initWithUrl:@"/userapi/user/login" parameters:param];
}

/*
 5.修改昵称
 URL：  /userapi/user/changeName
 参数：  uid（用户id）
 nickname(用户新的昵称)
 token（用户token）
 **/
+(instancetype)makeUrlResult_changeName_withUid:(NSString *)uid nickname:(NSString *)nickname token:(NSString *)token{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    if (uid) {
        [param setObject:uid forKey:@"uid"];
    }
    if (nickname) {
        [param setObject:nickname forKey:@"nickname"];
    }
    if (token) {
        [param setObject:token forKey:@"token"];
    }
    
    return [DDNetworkManagerDate initWithUrl:@"/userapi/user/changeName" parameters:param];
}

/*
 6.我的帐户信息
 URL：  /userapi/user/getPartInfo
 参数：  token（用户token）
 **/
+(instancetype)makeUrlResult_getPartInfo_withToken:(NSString *)token{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    if (token) {
        [param setObject:token forKey:@"token"];
    }
    
    return [DDNetworkManagerDate initWithUrl:@"/userapi/user/getPartInfo" parameters:param];
}

/*
 7.修改密码
 URL：  /userapi/user/changePass
 参数：  password（用户新的密码）
 repassword(重复密码)
 token（用户token）
 **/
+(instancetype)makeUrlResult_changePass_withPassword:(NSString *)password repassword:(NSString *)repassword token:(NSString *)token{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    if (password) {
        [param setObject:password forKey:@"password"];
    }
    if (repassword) {
        [param setObject:repassword forKey:@"repassword"];
    }
    if (token) {
        [param setObject:token forKey:@"token"];
    }
    
    return [DDNetworkManagerDate initWithUrl:@"/userapi/user/changePass" parameters:param];
}

/*
 8.找回密码（step 1）
 URL：  /userapi/user/findStep1
 参数：  phone（手机号码）
 verifyCode(验证码)
 **/
+(instancetype)makeUrlResult_findStep1_withPhone:(NSString *)phone verifyCode:(NSString *)verifyCode{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    if (phone) {
        [param setObject:phone forKey:@"phone"];
    }
    if (verifyCode) {
        [param setObject:verifyCode forKey:@"verifyCode"];
    }
    
    return [DDNetworkManagerDate initWithUrl:@"/userapi/user/findStep1" parameters:param];
}

/*
 9.找回密码（step 2）
 URL：  /userapi/user/findStep2
 参数：  phone（手机号码）
 password(用户新的密码)
 repassword(重复密码)
 **/
+(instancetype)makeUrlResult_findStep2_withPhone:(NSString *)phone password:(NSString *)password repassword:(NSString *)repassword{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    if (phone) {
        [param setObject:phone forKey:@"phone"];
    }
    if (password) {
        [param setObject:password forKey:@"password"];
    }
    if (repassword) {
        [param setObject:repassword forKey:@"repassword"];
    }
    return [DDNetworkManagerDate initWithUrl:@"/userapi/user/findStep2" parameters:param];
}

/*
 10.个人中心
 URL：  /userapi/user/getMyCount
 参数：  token（用户token）
 **/
+(instancetype)makeUrlResult_getMyCount_withToken:(NSString *)token{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    if (token) {
        [param setObject:token forKey:@"token"];
    }
    return [DDNetworkManagerDate initWithUrl:@"/userapi/user/getMyCount" parameters:param];
}

/*
 11.我的钱包
 URL：  /userapi/user/purse
 参数：  token（用户token）
 **/
+(instancetype)makeUrlResult_purse_withToken:(NSString *)token{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    if (token) {
        [param setObject:token forKey:@"token"];
    }
    return [DDNetworkManagerDate initWithUrl:@"/userapi/user/purse" parameters:param];
}

/*
 12.设置支付密码
 URL：  /userapi/user/paypass
 参数：  token（用户token）
 paypass(密码)
 repaypass(重复密码)
 **/
+(instancetype)makeUrlResult_paypass_withToken:(NSString *)token paypass:(NSString *)paypass repaypass:(NSString *)repaypass{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    if (token) {
        [param setObject:token forKey:@"token"];
    }
    if (paypass) {
        [param setObject:paypass forKey:@"paypass"];
    }
    if (repaypass) {
        [param setObject:repaypass forKey:@"repaypass"];
    }
    return [DDNetworkManagerDate initWithUrl:@"/userapi/user/paypass" parameters:param];
}

/*
 13.我的红包信息
 URL：  /userapi/user/getMyRedbag
 参数：  token（用户token）
 **/
+(instancetype)makeUrlResult_getMyRedbag_withToken:(NSString *)token{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    if (token) {
        [param setObject:token forKey:@"token"];
    }
    return [DDNetworkManagerDate initWithUrl:@"/userapi/user/getMyRedbag" parameters:param];
}

/*
 14.我的代金券信息
 URL：  /userapi/user/getMyCoupon
 参数：  token（用户token）
 uid(用户id)
 **/
+(instancetype)makeUrlResult_getMyCoupon_withToken:(NSString *)token uid:(NSString *)uid{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    if (token) {
        [param setObject:token forKey:@"token"];
    }
    if (uid) {
        [param setObject:uid forKey:@"uid"];
    }
    return [DDNetworkManagerDate initWithUrl:@"/userapi/user/getMyCoupon" parameters:param];
}

/*
 15.我的收藏信息
 URL：  /userapi/user/getMyCollect
 参数：  token（用户token）
 **/
+(instancetype)makeUrlResult_getMyCollect_withToken:(NSString *)token{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    if (token) {
        [param setObject:token forKey:@"token"];
    }
    return [DDNetworkManagerDate initWithUrl:@"/userapi/user/getMyCollect" parameters:param];
}

/*
 16.我的评论接口
 URL：  /userapi/user/getMyComment
 参数：  token（用户token）
 **/
+(instancetype)makeUrlResult_getMyComment_withToken:(NSString *)token{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    if (token) {
        [param setObject:token forKey:@"token"];
    }
    return [DDNetworkManagerDate initWithUrl:@"/userapi/user/getMyComment" parameters:param];
}

/*
 17.获取我的收货地址
 URL：  /userapi/user/getMyAddress
 参数：  token（用户token）
 **/
+(instancetype)makeUrlResult_getMyAddress_withToken:(NSString *)token{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    if (token) {
        [param setObject:token forKey:@"token"];
    }
    return [DDNetworkManagerDate initWithUrl:@"/userapi/user/getMyAddress" parameters:param];
}

/*
 18.设为默认地址
 URL：  /userapi/user/setDefault
 参数：  token（用户token）
 addressId(收货地址Id)
 **/
+(instancetype)makeUrlResult_setDefault_withToken:(NSString *)token addressId:(NSString *)addressId{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    if (token) {
        [param setObject:token forKey:@"token"];
    }
    if (addressId) {
        [param setObject:addressId forKey:@"addressId"];
    }
    return [DDNetworkManagerDate initWithUrl:@"/userapi/user/setDefault" parameters:param];
}

/*
 19.新增收货地址
 URL：  /userapi/user/address
 参数：  token（用户token）
 consignee(收货人 2-6位)
 sex(性别 1男 0 女)
 mobile(手机号)
 province(省)
 city(市)
 area(县/区)
 address(地址  2-50位)
 **/
+(instancetype)makeUrlResult_address_withToken:(NSString *)token consignee:(NSString *)consignee sex:(NSString *)sex mobile:(NSString *)mobile province:(NSString *)province city:(NSString *)city area:(NSString *)area address:(NSString *)address{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    if (token) {
        [param setObject:token forKey:@"token"];
    }
    if (consignee) {
        [param setObject:consignee forKey:@"consignee"];
    }
    if (sex) {
        [param setObject:sex forKey:@"sex"];
    }
    if (mobile) {
        [param setObject:mobile forKey:@"mobile"];
    }
    if (province) {
        [param setObject:province forKey:@"province"];
    }
    if (city) {
        [param setObject:city forKey:@"city"];
    }
    if (area) {
        [param setObject:area forKey:@"area"];
    }
    if (address) {
        [param setObject:address forKey:@"address"];
    }
    
    return [DDNetworkManagerDate initWithUrl:@"/userapi/user/address" parameters:param];
}

/*
 20.处理帮助和反馈
 URL：  /userapi/user/feedback
 参数：  token（用户token）
 uid(用户id)
 content（反馈内容）
 phone（手机号码）
 **/
+(instancetype)makeUrlResult_feedback_withToken:(NSString *)token uid:(NSString *)uid content:(NSString *)content phone:(NSString *)phone{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    if (token) {
        [param setObject:token forKey:@"token"];
    }
    if (content) {
        [param setObject:content forKey:@"content"];
    }
    if (phone) {
        [param setObject:phone forKey:@"phone"];
    }
    
    return [DDNetworkManagerDate initWithUrl:@"/userapi/user/feedback" parameters:param];
}

/*
 21.余额明细
 URL：  /userapi/user/moneyDetail
 参数：  token（用户token）
 **/
+(instancetype)makeUrlResult_moneyDetail_withToken:(NSString *)token{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    if (token) {
        [param setObject:token forKey:@"token"];
    }
    return [DDNetworkManagerDate initWithUrl:@"/userapi/user/moneyDetail" parameters:param];
}

/*
 22.上传头像/修改
 URL：  /userapi/user/upload
 参数：  token（用户token）
 file（用户头像）
 **/
+(instancetype)makeUrlResult_upload_withToken:(NSString *)token file:(NSString *)file{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    if (token) {
        [param setObject:token forKey:@"token"];
    }
    if (file) {
        [param setObject:file forKey:@"file"];
    }
    return [DDNetworkManagerDate initWithUrl:@"/userapi/user/upload" parameters:param];
}

/*
 23.添加支付宝账号
 URL：  /userapi/user/alipay_account
 参数：  token（用户token）
 account（支付宝账号）
 **/
+(instancetype)makeUrlResult_alipay_account_withToken:(NSString *)token account:(NSString *)account{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    if (token) {
        [param setObject:token forKey:@"token"];
    }
    if (account) {
        [param setObject:account forKey:@"account"];
    }
    return [DDNetworkManagerDate initWithUrl:@"/userapi/user/alipay_account" parameters:param];
}

/*
 24.提现接口
 URL：  /userapi/user/cash
 参数：  token（用户token）
 money（提现金额）
 **/
+(instancetype)makeUrlResult_cash_withToken:(NSString *)token money:(NSString *)money{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    if (token) {
        [param setObject:token forKey:@"token"];
    }
    if (money) {
        [param setObject:money forKey:@"money"];
    }
    return [DDNetworkManagerDate initWithUrl:@"/userapi/user/cash" parameters:param];
}



#pragma mark -首页模块
/*
 1.首页轮播图
 URL：  /userapi/user/getHomeBanner
 参数：  无
 **/
+(instancetype)makeUrlResult_getHomeBanner{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    return [DDNetworkManagerDate initWithUrl:@"/userapi/user/getHomeBanner" parameters:param];
}

/*
 2.首页分类
 URL：  /userapi/user/TopCategory
 参数：  无
 **/
+(instancetype)makeUrlResult_TopCategory{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    return [DDNetworkManagerDate initWithUrl:@"/userapi/user/TopCategory" parameters:param];
}

/*
 3.获取公告
 URL：  /userapi/user/getBulletin
 参数：  无
 **/
+(instancetype)makeUrlResult_getBulletin{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    return [DDNetworkManagerDate initWithUrl:@"/userapi/user/getBulletin" parameters:param];
}

/*
 4.首页综合部分
 URL：  /userapi/user/getIntegrated
 参数：  无
 **/
+(instancetype)makeUrlResult_getIntegrated{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    return [DDNetworkManagerDate initWithUrl:@"/userapi/user/getIntegrated" parameters:param];
}

/*
 4.2.获取综合区域下的商铺
 URL：  /userapi/user/intShop
 参数：  intId（综合区域id）
 **/
+(instancetype)makeUrlResult_intShop_withIntId:(NSString *)intId{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    if (intId) {
        [param setObject:intId forKey:@"intId"];
    }
    return [DDNetworkManagerDate initWithUrl:@"/userapi/user/intShop" parameters:param];
}

/*
 5.首页商铺列表信息
 URL：  /userapi/user/getHomeShop
 参数：  无
 **/
+(instancetype)makeUrlResult_getHomeShop{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    return [DDNetworkManagerDate initWithUrl:@"/userapi/user/getHomeShop" parameters:param];
}

/*
 6.分类页面
 URL：  /userapi/user/category
 参数：  无
 **/
+(instancetype)makeUrlResult_category{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    return [DDNetworkManagerDate initWithUrl:@"/userapi/user/category" parameters:param];
}

/*
 7.首页的商家智能排序
 URL：  /userapi/user/ordering
 参数：  category（分类id）
 type（排序类型 1：总销量 2：价格从高到底 3：价格从低到高 4：评分）
 **/
+(instancetype)makeUrlResult_ordering_withCategory:(NSString *)category type:(NSString *)type{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    if (category) {
        [param setObject:category forKey:@"category"];
    }
    if (type) {
        [param setObject:type forKey:@"type"];
    }
    return [DDNetworkManagerDate initWithUrl:@"/userapi/user/ordering" parameters:param];
}

/*
 8.商家自送
 URL：  /userapi/user/shopPs
 参数：  self（ ）
 category（分类id（前面未选择分类传0否则传已选的分类id））
 ordertype(排序类型（如未选择排序类型传0 否则1：总销量 2：价格从高到底 3：价格从低到高）)
 **/
+(instancetype)makeUrlResult_shopPs_withSelf:(NSString *)isSelf category:(NSString *)category ordertype:(NSString *)ordertype{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    if (isSelf) {
        [param setObject:isSelf forKey:@"self"];
    }
    if (category) {
        [param setObject:category forKey:@"category"];
    }
    if (ordertype) {
        [param setObject:ordertype forKey:@"ordertype"];
    }
    return [DDNetworkManagerDate initWithUrl:@"/userapi/user/shopPs" parameters:param];
}

/*
 9.搜索商家或商品的名称
 URL：  /userapi/user/searchShop
 参数：  content（搜索内容 ）
 **/
+(instancetype)makeUrlResult_searchShop_withContent:(NSString *)content{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    if (content) {
        [param setObject:content forKey:@"content"];
    }
    return [DDNetworkManagerDate initWithUrl:@"/userapi/user/searchShop" parameters:param];
}

/*
 10.商家信息
 URL：  /userapi/user/getShopInfo
 参数：  shop_id（商铺id）
 token
 **/
+(instancetype)makeUrlResult_getShopInfo_withShop_id:(NSString *)shop_id token:(NSString *)token{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    if (shop_id) {
        [param setObject:shop_id forKey:@"shop_id"];
    }
    if (token) {
        [param setObject:token forKey:@"token"];
    }
    return [DDNetworkManagerDate initWithUrl:@"/userapi/user/getShopInfo" parameters:param];
}

/*
 11.显示商家热搜
 URL：  /userapi/user/searchPro
 参数：  shop_id（商铺id）
 **/
+(instancetype)makeUrlResult_searchPro_withShop_id:(NSString *)shop_id{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    if (shop_id) {
        [param setObject:shop_id forKey:@"shop_id"];
    }
    return [DDNetworkManagerDate initWithUrl:@"/userapi/user/searchPro" parameters:param];
}

/*
 12.搜索店内商品
 URL：  /userapi/user/searchProduct
 参数：  shop_id（商铺id）
 content(搜索内容)
 **/
+(instancetype)makeUrlResult_searchProduct_withShop_id:(NSString *)shop_id content:(NSString *)content{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    if (shop_id) {
        [param setObject:shop_id forKey:@"shop_id"];
    }
    if (content) {
        [param setObject:content forKey:@"content"];
    }
    return [DDNetworkManagerDate initWithUrl:@"/userapi/user/searchProduct" parameters:param];
}

/*
 13.获取店铺下所有的商品
 URL：  /userapi/user/productList
 参数：  shop_id（商铺id）
 **/
+(instancetype)makeUrlResult_productList_withShop_id:(NSString *)shop_id{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    if (shop_id) {
        [param setObject:shop_id forKey:@"shop_id"];
    }
    return [DDNetworkManagerDate initWithUrl:@"/userapi/user/productList" parameters:param];
}

/*
 14.获取商品详情
 URL：  /userapi/user/getProduct
 参数：  shop_id（商铺id）
 product_id(商品id)
 **/
+(instancetype)makeUrlResult_getProduct_withShop_id:(NSString *)shop_id product_id:(NSString *)product_id{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    if (shop_id) {
        [param setObject:shop_id forKey:@"shop_id"];
    }
    if (product_id) {
        [param setObject:product_id forKey:@"product_id"];
    }
    return [DDNetworkManagerDate initWithUrl:@"/userapi/user/getProduct" parameters:param];
}

/*
 15.获取店铺评论
 URL：  /userapi/user/getShopComment
 参数：  shop_id（商铺id）
 type(评论标签  type 1：物美价廉 2：品类齐全 3：送货上门 4：风雨无阻 5：不准时 6货品错误  7:好评 8：中评 9：差评10：全部)
 status(评论状态 1为只看有内容的评论的)
 **/
+(instancetype)makeUrlResult_getShopComment_withShop_id:(NSString *)shopid type:(NSString *)type status:(NSString *)status{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    if (shopid) {
        [param setObject:shopid forKey:@"shopId"];
    }
    if (type) {
        [param setObject:type forKey:@"type"];
    }
    if (status) {
        [param setObject:status forKey:@"status"];
    }
    return [DDNetworkManagerDate initWithUrl:@"/userapi/user/getShopComment" parameters:param];
}

/*
 16.获取店铺评分
 URL：  /userapi/user/getShopScore
 参数：  shop_id（商铺id）
 **/
+(instancetype)makeUrlResult_getShopScore_withShop_id:(NSString *)shop_id{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    if (shop_id) {
        [param setObject:shop_id forKey:@"shop_id"];
    }
    return [DDNetworkManagerDate initWithUrl:@"/userapi/user/getShopScore" parameters:param];
}

/*
 17.获取店铺评论相应数量
 URL：  /userapi/user/getShopCount
 参数：  shop_id（商铺id）
 **/
+(instancetype)makeUrlResult_getShopCount_withShop_id:(NSString *)shop_id{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    if (shop_id) {
        [param setObject:shop_id forKey:@"shop_id"];
    }
    return [DDNetworkManagerDate initWithUrl:@"/userapi/user/getShopCount" parameters:param];
}

/*
 18.评论接口
 URL：  /userapi/user/comment
 参数：  uid（用户id）
 token(用户token)
 shop_id(商铺id)
 shop_score(商品相符评分)
 shop_server(商铺服务评分)
 shop_content(商铺评论内容)
 shop_type(评论标签)
 img(商品图片)
 pid(派送员id)
 ps_score(派送评价)
 ps_server(派送员评价)
 ps_content(派送评价内容)
 **/
+(instancetype)makeUrlResult_comment_withUid:(NSString *)uid token:(NSString *)token shop_id:(NSString *)shop_id shop_score:(NSString *)shop_score shop_server:(NSString *)shop_server shop_content:(NSString *)shop_content shop_type:(NSString *)shop_type img:(NSString *)img pid:(NSString *)pid ps_score:(NSString *)ps_score ps_server:(NSString *)ps_server ps_content:(NSString *)ps_content{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    if (uid) {
        [param setObject:uid forKey:@"uid"];
    }
    if (token) {
        [param setObject:token forKey:@"token"];
    }
    if (shop_id) {
        [param setObject:shop_id forKey:@"shop_id"];
    }
    if (shop_score) {
        [param setObject:shop_score forKey:@"shop_score"];
    }
    if (shop_server) {
        [param setObject:shop_server forKey:@"shop_server"];
    }
    if (shop_content) {
        [param setObject:shop_content forKey:@"shop_content"];
    }
    if (shop_type) {
        [param setObject:shop_type forKey:@"shop_type"];
    }
    if (img) {
        [param setObject:img forKey:@"img"];
    }
    if (pid) {
        [param setObject:pid forKey:@"pid"];
    }
    if (ps_score) {
        [param setObject:ps_score forKey:@"ps_score"];
    }
    if (ps_server) {
        [param setObject:ps_server forKey:@"ps_server"];
    }
    if (ps_content) {
        [param setObject:ps_content forKey:@"ps_content"];
    }
    return [DDNetworkManagerDate initWithUrl:@"/userapi/user/comment" parameters:param];
}

/*
 19.收藏商家
 URL：  /userapi/user/keepShop
 参数：  shop_id（商铺id）
 uid(用户id)
 token(用户token)
 **/
+(instancetype)makeUrlResult_keepShop_withShop_id:(NSString *)shop_id uid:(NSString *)uid token:(NSString *)token{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    if (shop_id) {
        [param setObject:shop_id forKey:@"shop_id"];
    }
    if (uid) {
        [param setObject:uid forKey:@"uid"];
    }
    if (token) {
        [param setObject:token forKey:@"token"];
    }
    return [DDNetworkManagerDate initWithUrl:@"/userapi/user/keepShop" parameters:param];
}


#pragma mark -订单模块接口
/*
 1.我的订单
 URL：  /userapi/user/obligations
 参数：  token（用户token）
 type(订单类型    待付款：8 已付款：1 待配送：2 已确认：6)
 **/
+(instancetype)makeUrlResult_obligations_withToken:(NSString *)token type:(NSString *)type{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    if (token) {
        [param setObject:token forKey:@"token"];
    }
    if (type) {
        [param setObject:type forKey:@"type"];
    }
    return [DDNetworkManagerDate initWithUrl:@"/userapi/user/obligations" parameters:param];
}

/*
 2.取消订单
 URL：  /userapi/user/cancel
 参数：  token（用户token）
 orderId( 订单id)
 **/
+(instancetype)makeUrlResult_cancel_withToken:(NSString *)token orderId:(NSString *)orderId{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    if (token) {
        [param setObject:token forKey:@"token"];
    }
    if (orderId) {
        [param setObject:orderId forKey:@"orderId"];
    }
    return [DDNetworkManagerDate initWithUrl:@"/userapi/user/cancel" parameters:param];
}

/*
 3.购物车结算并且生成未付款订单
 URL：  /userapi/user/dealCart
 参数：  token（用户token）
 shop_id(商铺id)
 price(总价)
 arr(数组里面是每件商品对应的价格)
 
 <-- arr 解释 -->
 arr内部数据[
 product_id => 商品id
 product_title =>商品名称
 price =>商品单价
 num => 所购商品数量
 product_attr => 商品属性值(未选择传空)
 option_id => 商品属性id(未选择传空)
	]
 **/
+(instancetype)makeUrlResult_dealCart_withToken:(NSString *)token shop_id:(NSString *)shop_id price:(NSString *)price arr:(NSString *)arr{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    if (token) {
        [param setObject:token forKey:@"token"];
    }
    if (shop_id) {
        [param setObject:shop_id forKey:@"shop_id"];
    }
    if (price) {
        [param setObject:price forKey:@"price"];
    }
    if (arr) {
        [param setObject:arr forKey:@"arr"];
    }
    return [DDNetworkManagerDate initWithUrl:@"/userapi/user/dealCart" parameters:param];
}

/*
 4.确认订单页面
 URL：  /userapi/user/firmOrder
 参数：  token（用户token）
 orderId( 订单id)
 shopId(商铺id)
 **/
+(instancetype)makeUrlResult_firmOrder_withToken:(NSString *)token orderId:(NSString *)orderId shopId:(NSString *)shopId{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    if (token) {
        [param setObject:token forKey:@"token"];
    }
    if (orderId) {
        [param setObject:orderId forKey:@"orderId"];
    }
    if (shopId) {
        [param setObject:shopId forKey:@"shopId"];
    }
    return [DDNetworkManagerDate initWithUrl:@"/userapi/user/firmOrder" parameters:param];
}

/*
 5.点击确认订单的支付按钮
 URL：  /userapi/user/orderPay
 参数：  token（用户token）
 consignee(收货人)
 mobile(手机号)
 province(省)
 city(市)
 area(县)
 address(补充地址)
 orderId(订单id)
 redbag_id(红包id 没有传空)
 coupon_id(优惠卷id 无传空)
 price(折后价，未打折传原价)
 message(备注(0-20字符))
 send_time(送达时间)
 **/
+(instancetype)makeUrlResult_orderPay_withToken:(NSString *)token consignee:(NSString *)consignee mobile:(NSString *)mobile province:(NSString *)province city:(NSString *)city area:(NSString *)area address:(NSString *)address orderId:(NSString *)orderId redbag_id:(NSString *)redbag_id coupon_id:(NSString *)coupon_id price:(NSString *)price message:(NSString *)message send_time:(NSString *)send_time{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    if (token) {
        [param setObject:token forKey:@"token"];
    }
    if (consignee) {
        [param setObject:consignee forKey:@"consignee"];
    }
    if (mobile) {
        [param setObject:mobile forKey:@"mobile"];
    }
    if (province) {
        [param setObject:province forKey:@"province"];
    }
    if (city) {
        [param setObject:city forKey:@"city"];
    }
    if (area) {
        [param setObject:area forKey:@"area"];
    }
    if (address) {
        [param setObject:address forKey:@"address"];
    }
    if (orderId) {
        [param setObject:orderId forKey:@"orderId"];
    }
    if (redbag_id) {
        [param setObject:redbag_id forKey:@"redbag_id"];
    }
    if (coupon_id) {
        [param setObject:coupon_id forKey:@"coupon_id"];
    }
    if (price) {
        [param setObject:price forKey:@"price"];
    }
    if (message) {
        [param setObject:message forKey:@"message"];
    }
    if (send_time) {
        [param setObject:send_time forKey:@"send_time"];
    }
    return [DDNetworkManagerDate initWithUrl:@"/userapi/user/orderPay" parameters:param];
}

/*
 6 订单详情--已完成交易流程显示的订单详情
 URL：  /userapi/user/orderDetail
 参数：  token（用户token）
 orderId( 订单id)
 **/
+(instancetype)makeUrlResult_orderDetail_withToken:(NSString *)token orderId:(NSString *)orderId{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    if (token) {
        [param setObject:token forKey:@"token"];
    }
    if (orderId) {
        [param setObject:orderId forKey:@"orderId"];
    }
    return [DDNetworkManagerDate initWithUrl:@"/userapi/user/orderDetail" parameters:param];
}

/*
 7 获取订单详情：取货中
 URL：  /userapi/user/orderStatus
 参数：  token（用户token）
 orderId( 订单id)
 uid(用户id)
 **/
+(instancetype)makeUrlResult_orderStatus_withToken:(NSString *)token orderId:(NSString *)orderId uid:(NSString *)uid{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    if (token) {
        [param setObject:token forKey:@"token"];
    }
    if (orderId) {
        [param setObject:orderId forKey:@"orderId"];
    }
    if (uid) {
        [param setObject:uid forKey:@"uid"];
    }
    return [DDNetworkManagerDate initWithUrl:@"/userapi/user/orderStatus" parameters:param];
}

/*
 8 获取订单详情：配送中
 URL：  /userapi/user/orderPs
 参数：  token（用户token）
 orderId( 订单id)
 **/
+(instancetype)makeUrlResult_orderPs_withToken:(NSString *)token orderId:(NSString *)orderId{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    if (token) {
        [param setObject:token forKey:@"token"];
    }
    if (orderId) {
        [param setObject:orderId forKey:@"orderId"];
    }
    return [DDNetworkManagerDate initWithUrl:@"/userapi/user/orderPs" parameters:param];
}

/*
 9 申请退款
 URL：  /userapi/user/refund
 参数：  token（用户token）
 orderId( 订单id)
 **/
+(instancetype)makeUrlResult_refund_withToken:(NSString *)token orderId:(NSString *)orderId{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    if (token) {
        [param setObject:token forKey:@"token"];
    }
    if (orderId) {
        [param setObject:orderId forKey:@"orderId"];
    }
    return [DDNetworkManagerDate initWithUrl:@"/userapi/user/refund" parameters:param];
}

/*
 10.确认收货
 URL：  /userapi/user/confirm
 参数：  token（用户token）
 orderId( 订单id)
 **/
+(instancetype)makeUrlResult_confirm_withToken:(NSString *)token orderId:(NSString *)orderId{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    if (token) {
        [param setObject:token forKey:@"token"];
    }
    if (orderId) {
        [param setObject:orderId forKey:@"orderId"];
    }
    return [DDNetworkManagerDate initWithUrl:@"/userapi/user/confirm" parameters:param];
}

/*
 11.根据经纬度获取距离
 URL：  /userapi/user/location
 参数：  token（用户token）
 orderId( 订单id)
 **/
+(instancetype)makeUrlResult_location_withToken:(NSString *)token orderId:(NSString *)orderId{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    if (token) {
        [param setObject:token forKey:@"token"];
    }
    if (orderId) {
        [param setObject:orderId forKey:@"orderId"];
    }
    return [DDNetworkManagerDate initWithUrl:@"/userapi/user/location" parameters:param];
}

/*
 12.余额支付
 URL：  /userapi/user/moneypay
 参数：  token（用户token）
 orderId( 订单id)
 **/
+(instancetype)makeUrlResult_moneypay_withToken:(NSString *)token orderId:(NSString *)orderId{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    if (token) {
        [param setObject:token forKey:@"token"];
    }
    if (orderId) {
        [param setObject:orderId forKey:@"orderId"];
    }
    return [DDNetworkManagerDate initWithUrl:@"/userapi/user/moneypay" parameters:param];
}


/**
 5.TN
 order_no	订单号
 txnTime	付款时间
 txnAmt  充值金额
 reqReserved
 token
 */
+(instancetype)getTNorder_no:(NSString *)order_no txnTime:(NSString *)txnTime txnAmt:(NSString *)txnAmt token:(NSString *)token type:(NSNumber *)type{
    return [DDNetworkManagerDate initWithUrl:@"/api/Pay/achieveTN" parameters:@{@"order_no":order_no,
                                                                                @"txnTime":txnTime,
                                                                                @"txnAmt":txnAmt,
                                                                                @"token":token,
                                                                                @"type":type}];
}



@end

@implementation FormData


@end

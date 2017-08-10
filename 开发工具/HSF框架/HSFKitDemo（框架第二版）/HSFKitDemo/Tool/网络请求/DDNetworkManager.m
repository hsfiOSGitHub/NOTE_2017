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

////////////////////////////
///                      ///
///      网络接口         ///
///                     ///
///////////////////////////

#pragma mark-request_URL
/*state:
 200     操作成功
 300     用户未登录
 400     未找到相关信息
 500     操作失败
 其他      未知错误
 */

#pragma mark- 公共
/*
 ==>发送验证码<==
 
 参数说明
 参数      说明
 mobile      手机号码
 type        短信类型
 
 短信类型取值
 register        注册
 forgotten       忘记密码
 modifypassword  修改密码
 login           短信登录
 返回信息
 {"code":200,"message":"发送成功"}
 **/
+(instancetype)makeUrlResult_sendMsg_withPhone:(NSString *)phone{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    if (phone) {
        [param setObject:phone forKey:@"phone"];
    }
    return [DDNetworkManagerDate initWithUrl:@"/api/api/sendMsg" parameters:param];
}

#pragma mark -登录注册
/*
 1.1 登录（/api/public/login）
 
 参数说明
 参数          说明
 mobile          手机号码
 password        密码
 返回信息
 {"code":400,"message":"手机号不能为空","data":[]}
 */
+(instancetype)makeUrlResult_login_withMobile:(NSString *)mobile password:(NSString *)password{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    if (mobile) {
        [param setObject:mobile forKey:@"mobile"];
    }
    if (password) {
        [param setObject:password forKey:@"password"];
    }
    return [DDNetworkManagerDate initWithUrl:@"/api/public/login" parameters:param];
}

/*
 1.2 验证码登录 （/api/public/verifylogin)
 
 参数说明
 
 参数      说明
 mobile          手机号码
 code            短信验证码
 返回信息
 {"code":400,"message":"手机号不能为空"}
 */
+(instancetype)makeUrlResult_verifylogin_withMobile:(NSString *)mobile code:(NSString *)code{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    if (mobile) {
        [param setObject:mobile forKey:@"mobile"];
    }
    if (code) {
        [param setObject:code forKey:@"code"];
    }
    return [DDNetworkManagerDate initWithUrl:@"/api/public/verifylogin" parameters:param];
}

/*
 1.3 注册 （/api/public/register)
 
 参数说明
 参数      说明
 mobile      手机号码
 password    密码
 code        短信验证码
 返回信息
 {"code":400,"message":"手机号不能为空","data":[]}
 */
+(instancetype)makeUrlResult_register_withMobile:(NSString *)mobile password:(NSString *)password code:(NSString *)code{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    if (mobile) {
        [param setObject:mobile forKey:@"mobile"];
    }
    if (password) {
        [param setObject:password forKey:@"password"];
    }
    if (code) {
        [param setObject:code forKey:@"code"];
    }
    return [DDNetworkManagerDate initWithUrl:@"/api/public/register" parameters:param];
}

/*
 1.4 忘记密码 （/api/public/forgetpwd)
 
 参数说明
 参数      说明
 mobile      手机号码
 password    密码
 code        短信验证码
 返回信息
 {"code":400,"message":"手机号不能为空","data":[]}
 */
+(instancetype)makeUrlResult_forgetpwd_withMobile:(NSString *)mobile password:(NSString *)password code:(NSString *)code{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    if (mobile) {
        [param setObject:mobile forKey:@"mobile"];
    }
    if (password) {
        [param setObject:password forKey:@"password"];
    }
    if (code) {
        [param setObject:code forKey:@"code"];
    }
    return [DDNetworkManagerDate initWithUrl:@"/api/public/forgetpwd" parameters:param];
}

#pragma mark -用户
/*
 获取登录用户信息 （/api/user/getuserinfo)
 
 参数说明
 参数          说明
 token           登录token信息
 返回信息
 "code": 200,
 "message": "操作成功",
 "data": {
 "id": 2,
 "sex": 0,
 "birthday": 0,
 "score": 0,
 "coin": 0,
 "create_time": 1500536372,
 "user_login": "",
 "user_nickname": "",
 "user_email": "",
 "avatar": "",
 "signature": "",
 "mobile": ""
 }
 */
+(instancetype)makeUrlResult_getuserinfo_withToken:(NSString *)token{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    if (token) {
        [param setObject:token forKey:@"token"];
    }
    return [DDNetworkManagerDate initWithUrl:@"/api/user/getuserinfo" parameters:param];
}

#pragma mark -门店
/*
 获取门店套餐 （/api/shop/shoptype_list）
 
 参数说明
 参数          说明
 返回信息
 
 {
 "code": 200,
 "message": "操作成功",
 "data": [
 {
 "id": 1,
 "name": "基础版",
 "info": "旗舰店标志+旗舰版店铺  同等条件下排名优先 开放全网通移动电话",
 "list_order": 1
 },……
 ]
 }
 */
+(instancetype)makeUrlResult_shoptype_list_withToken:(NSString *)token{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    if (token) {
        [param setObject:token forKey:@"token"];
    }
    return [DDNetworkManagerDate initWithUrl:@"/api/shop/shoptype_list" parameters:param];
}

/*
 获取门店信息 （’/api/shop/getshopinfo’)
 
 参数说明
 参数      说明
 shopid      门店id
 返回信息
 "code": 200,
 "message": "操作成功",
 "data": {
 "id": 1,
 "uid": 2,
 "shop_name": "测试店铺",
 "shop_type": 2,
 "province": "山东",
 "city": "济宁",
 "area": "兖州",
 "address": "收拾收拾",
 "cat_ids": "1|2",
 "brand_ids": "1",
 "car_type": "1",
 "pic": "",
 "contact": "sdf",
 "mobile": "645645",
 "is_recommend": 1,
 "status": 1,
 "expire_time": 1500566400,
 "add_time": 0
 }
 */
+(instancetype)makeUrlResult_getshopinfo_withToken:(NSString *)token shopid:(NSString *)shopid{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    if (token) {
        [param setObject:token forKey:@"token"];
    }
    if (shopid) {
        [param setObject:shopid forKey:@"shopid"];
    }
    return [DDNetworkManagerDate initWithUrl:@"/api/shop/getshopinfo" parameters:param];
}

#pragma mark -商品
/*
 获取商品分类（/api/goods/getcategorylist)
 
 参数说明
 
 参数          说明
 parent_id       上级分类id 默认 0
 返回信息
 "code": 200,
 "message": "操作成功",
 "data": [
 {
 "id": 1,
 "name": "汽车用品",
 "pic": "/upload/20170718/bd1afd50fe7eb7e4cb9308d086a4ede3.png",
 "parent_id": 0,
 "list_order": 1000
 },
 ……
 ]
 */
+(instancetype)makeUrlResult_getcategorylist{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    return [DDNetworkManagerDate initWithUrl:@"/api/goods/getcategorylist" parameters:param];
}



@end

@implementation FormData


@end

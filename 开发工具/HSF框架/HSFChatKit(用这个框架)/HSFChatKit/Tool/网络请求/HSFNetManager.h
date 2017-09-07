//
//  HSFNetManager.h
//  HSFChatKit
//
//  Created by JuZhenBaoiMac on 2017/9/1.
//  Copyright © 2017年 JuZhenBaoiMac. All rights reserved.
//

#import <Foundation/Foundation.h>

// >注意：这里的block和pod库里的一样

/*! 实时监测网络状态的 block */
typedef void(^BANetworkStatusBlock)(BANetworkStatus status);

/*! 定义请求成功的 block */
typedef void( ^ BAResponseSuccessBlock)(id response);
/*! 定义请求失败的 block */
typedef void( ^ BAResponseFailBlock)(NSError *error);

/*! 定义上传进度 block */
typedef void( ^ BAUploadProgressBlock)(int64_t bytesProgress,
int64_t totalBytesProgress);
/*! 定义下载进度 block */
typedef void( ^ BADownloadProgressBlock)(int64_t bytesProgress,
int64_t totalBytesProgress);


@interface HSFNetManager : NSObject


//单例的创建
HSFSingleton_h(NetManager)


/** 说明：
 由于BANetManager 在加载中、返回成功、失败时 没有HUD提示，所以我这里单独创建一个类 来完善提示功能
 
 */



/**
 网络请求的实例方法 get
 
 @param urlString 请求的地址
 @param isNeedCache 是否需要缓存，只有 get / post 请求有缓存配置
 @param parameters 请求的参数
 @param successBlock 请求成功的回调
 @param failureBlock 请求失败的回调
 @param progressBlock 进度
 @return BAURLSessionTask
 */
+ (BAURLSessionTask *)hsf_request_GETWithUrlString:(NSString *)urlString
                                       isNeedCache:(BOOL)isNeedCache
                                        parameters:(NSDictionary *)parameters
                                      successBlock:(BAResponseSuccessBlock)successBlock
                                      failureBlock:(BAResponseFailBlock)failureBlock
                                     progressBlock:(BADownloadProgressBlock)progressBlock;
/**
 网络请求的实例方法 post
 
 @param urlString 请求的地址
 @param isNeedCache 是否需要缓存，只有 get / post 请求有缓存配置
 @param parameters 请求的参数
 @param successBlock 请求成功的回调
 @param failureBlock 请求失败的回调
 @param progressBlock 进度
 @return BAURLSessionTask
 */
+ (BAURLSessionTask *)hsf_request_POSTWithUrlString:(NSString *)urlString
                                        isNeedCache:(BOOL)isNeedCache
                                         parameters:(NSDictionary *)parameters
                                       successBlock:(BAResponseSuccessBlock)successBlock
                                       failureBlock:(BAResponseFailBlock)failureBlock
                                      progressBlock:(BADownloadProgressBlock)progressBlock;

/**
 网络请求的实例方法 put
 
 @param urlString 请求的地址
 @param parameters 请求的参数
 @param successBlock 请求成功的回调
 @param failureBlock 请求失败的回调
 @param progressBlock 进度
 @return BAURLSessionTask
 */
+ (BAURLSessionTask *)hsf_request_PUTWithUrlString:(NSString *)urlString
                                        parameters:(NSDictionary *)parameters
                                      successBlock:(BAResponseSuccessBlock)successBlock
                                      failureBlock:(BAResponseFailBlock)failureBlock
                                     progressBlock:(BADownloadProgressBlock)progressBlock;

/**
 网络请求的实例方法 delete
 
 @param urlString 请求的地址
 @param parameters 请求的参数
 @param successBlock 请求成功的回调
 @param failureBlock 请求失败的回调
 @param progressBlock 进度
 @return BAURLSessionTask
 */
+ (BAURLSessionTask *)hsf_request_DELETEWithUrlString:(NSString *)urlString
                                           parameters:(NSDictionary *)parameters
                                         successBlock:(BAResponseSuccessBlock)successBlock
                                         failureBlock:(BAResponseFailBlock)failureBlock
                                        progressBlock:(BADownloadProgressBlock)progressBlock;

/**
 上传图片(多图)
 
 @param urlString 上传的url
 @param parameters 上传图片预留参数---视具体情况而定 可移除
 @param imageArray 上传的图片数组
 @param fileName 上传的图片数组fileName
 @param successBlock 上传成功的回调
 @param failureBlock 上传失败的回调
 @param progress 上传进度
 @return BAURLSessionTask
 */
+ (BAURLSessionTask *)hsf_uploadImageWithUrlString:(NSString *)urlString
                                        parameters:(NSDictionary *)parameters
                                        imageArray:(NSArray *)imageArray
                                          fileName:(NSString *)fileName
                                      successBlock:(BAResponseSuccess)successBlock
                                       failurBlock:(BAResponseFail)failureBlock
                                    upLoadProgress:(BAUploadProgress)progress;

/**
 视频上传
 
 @param urlString 上传的url
 @param parameters 上传视频预留参数---视具体情况而定 可移除
 @param videoPath 上传视频的本地沙河路径
 @param successBlock 成功的回调
 @param failureBlock 失败的回调
 @param progress 上传的进度
 */
+ (void)hsf_uploadVideoWithUrlString:(NSString *)urlString
                          parameters:(NSDictionary *)parameters
                           videoPath:(NSString *)videoPath
                        successBlock:(BAResponseSuccess)successBlock
                        failureBlock:(BAResponseFail)failureBlock
                      uploadProgress:(BAUploadProgress)progress;

/**
 文件下载
 
 @param urlString 请求的url
 @param parameters 文件下载预留参数---视具体情况而定 可移除
 @param savePath 下载文件保存路径
 @param successBlock 下载文件成功的回调
 @param failureBlock 下载文件失败的回调
 @param progress 下载文件的进度显示
 @return BAURLSessionTask
 */
+ (BAURLSessionTask *)hsf_downLoadFileWithUrlString:(NSString *)urlString
                                         parameters:(NSDictionary *)parameters
                                           savaPath:(NSString *)savePath
                                       successBlock:(BAResponseSuccess)successBlock
                                       failureBlock:(BAResponseFail)failureBlock
                                   downLoadProgress:(BADownloadProgress)progress;



#pragma mark - 网络状态监测
/*!
 *  开启实时网络状态监测，通过Block回调实时获取(此方法可多次调用)
 */
+ (void)hsf_startNetWorkMonitoringWithBlock:(BANetworkStatusBlock)networkStatus;

#pragma mark - 自定义请求头
/**
 *  自定义请求头
 */
+ (void)hsf_setValue:(NSString *)value forHTTPHeaderKey:(NSString *)HTTPHeaderKey;

#pragma mark - 取消 Http 请求
/*!
 *  取消所有 Http 请求
 */
+ (void)hsf_cancelAllRequest;

/*!
 *  取消指定 URL 的 Http 请求
 */
+ (void)hsf_cancelRequestWithURL:(NSString *)URL;





@end

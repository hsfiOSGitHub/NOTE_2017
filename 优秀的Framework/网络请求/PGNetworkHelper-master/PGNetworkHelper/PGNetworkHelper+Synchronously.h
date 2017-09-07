//
//  PGNetworkHelper+Synchronously.h
//  AFNetworking
//
//  Created by piggybear on 2017/7/25.
//

#import "PGNetworkHelper.h"

@interface PGNetworkHelper (Synchronously)
/**
 *  GET请求
 *
 *  @param URL           请求地址
 *  @param parameters    请求参数
 *  @param cache         是否缓存数据
 *  @param responseCache 缓存数据的回调
 *  @param success       请求成功的回调
 *  @param failure       请求失败的回调
 *
 *  @return 返回的对象可取消请求,调用cancle方法
 */
+ (NSURLSessionTask *)synchronouslyGET:(NSString *)URL
                            parameters:(id)parameters
                                 cache:(BOOL)cache
                         responseCache:(HttpRequestCache)responseCache
                               success:(HttpRequestSuccess)success
                               failure:(HttpRequestFailed)failure;

/**
 *  POST请求
 *
 *  @param URL           请求地址
 *  @param parameters    请求参数
 *  @param cache         是否缓存数据
 *  @param responseCache 缓存数据的回调
 *  @param success       请求成功的回调
 *  @param failure       请求失败的回调
 *
 *  @return 返回的对象可取消请求,调用cancle方法
 */
+ (NSURLSessionTask *)synchronouslyPOST:(NSString *)URL
                             parameters:(id)parameters
                                  cache:(BOOL)cache
                          responseCache:(HttpRequestCache)responseCache
                                success:(HttpRequestSuccess)success
                                failure:(HttpRequestFailed)failure;

/**
 *  上传图片文件
 *
 *  @param URL        请求地址
 *  @param parameters 请求参数
 *  @param images     图片数组
 *  @param name       文件对应服务器上的字段
 *  @param mimeType   图片文件的类型,例:png、jpeg(默认类型)....
 *  @param progress   上传进度信息
 *  @param success    请求成功的回调
 *  @param failure    请求失败的回调
 *
 *  @return 返回的对象可取消请求,调用cancle方法
 */
+ (NSURLSessionTask *)synchronouslyUploadWithURL:(NSString *)URL
                                      parameters:(NSDictionary *)parameters
                                          images:(NSArray<UIImage *> *)images
                                            name:(NSString *)name
                                        mimeType:(NSString *)mimeType
                                        progress:(HttpProgress)progress
                                         success:(HttpRequestSuccess)success
                                         failure:(HttpRequestFailed)failure;

/**
 *  下载文件
 *
 *  @param URL      请求地址
 *  @param fileDir  文件存储目录(默认存储目录为Download)
 *  @param progress 文件下载的进度信息
 *  @param success  下载成功的回调(回调参数filePath:文件的路径)
 *  @param failure  下载失败的回调
 *
 *  @return 返回NSURLSessionDownloadTask实例，可用于暂停继续，暂停调用suspend方法，开始下载调用resume方法
 */
+ (__kindof NSURLSessionTask *)synchronouslyDownloadWithURL:(NSString *)URL
                                                    fileDir:(NSString *)fileDir
                                                   progress:(HttpProgress)progress
                                                    success:(void(^)(NSString *filePath))success
                                                    failure:(HttpRequestFailed)failure;
@end

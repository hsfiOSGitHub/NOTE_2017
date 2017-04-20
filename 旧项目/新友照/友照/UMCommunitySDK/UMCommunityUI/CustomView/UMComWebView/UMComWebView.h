//
//  UMComWebView.h
//  UMCommunity
//
//  Created by 张军华 on 16/3/21.
//  Copyright © 2016年 Umeng. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *  webview的errorCode
 */
typedef NS_ENUM(NSInteger, UMComWebViewError) {
    UMComWebViewError_NullUrl, //!< 空的数据
    UMComWebViewError_SomeUrl, //!< 相同的url地址
};


/**
 *  webview的执行状态
 */
typedef NS_OPTIONS(NSUInteger, EUMComWebViewState) {
    EUMComWebViewStateNone                     = 0,        //!< 初始化状态
    EUMComWebViewStateLoading                  = 1 << 0,   //!< 加载状态
//    EUMComWebViewStateLoadingFirst             = 1 << 1,   //!< 初始化状态第一次loading
//    EUMComWebViewStateLoadingSendcond          = 1 << 2,   //!< 初始化状态第二次loading
    EUMComWebViewStateLoadingFinish            = 1 << 3,   //!< 加载完成
    EUMComWebViewStateLoadingError             = 1 << 4,   //!< 失败
    EUMComWebViewStateReload                   = 1 << 5,   //!< 重新加载
};


extern NSString *const UMComWebViewErrorDomain;


@protocol UMComWebViewDelegate <NSObject>

@optional
- (BOOL)UMComWebView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType;
- (void)UMComWebViewDidStartLoad:(UIWebView *)webView;
- (void)UMComWebViewDidFinishLoad:(UIWebView *)webView;
- (void)UMComWebView:(UIWebView *)webView didFailLoadWithError:(nullable NSError *)error;
@end
/**
 *  UIWebView的子类
 *  @discuss 本类只显示本地的html的数据
 */
@interface UMComWebView : UIWebView



@property (nullable, nonatomic, weak) id <UMComWebViewDelegate> UMComWebViewDelegate;

/**
 *  uiview的内容高度
 */
@property(nonatomic,assign)CGFloat fullHeight;

/**
 *  当前的webview的状态
 */
@property(nonatomic,assign,readonly)EUMComWebViewState webviewState;

/**
 *  显示本地的数据
 */
@property(nonatomic,readonly,copy)NSString* localHtmlData;

/**
 *  显示远程的Url
 */
@property(nonatomic,readonly,copy)NSString* remoteUrl;

- (void)loadHTMLString:(NSString *)string baseURL:(nullable NSURL *)baseURL error:(NSError**)err;


/**
 *  加载远程数据
 *
 */
- (void)loadRequest:(NSURLRequest*)request error:(NSError**)err;


/**
 *  如果需要强行要加载已经存在的url的话，可以在调用加载函数
 *  loadHTMLString or loadRequest函数之前调用此函数,强行加载
 *  @discuss 此函数不推荐反复使用浪费webview的加载效率
 */
-(void) setReloadWebViewState;
@end

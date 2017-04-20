//
//  UMComWebView.m
//  UMCommunity
//
//  Created by 张军华 on 16/3/21.
//  Copyright © 2016年 Umeng. All rights reserved.
//

#import "UMComWebView.h"

NSString *const UMComWebViewErrorDomain = @"UMComWebViewErrorDomain";

@interface UMComWebView ()<UIWebViewDelegate>
@property(nonatomic,readwrite,copy,)NSString* localHtmlData;
@property(nonatomic,readwrite,copy)NSString* remoteUrl;

@property(nonatomic,readwrite,assign)BOOL isLoadingFinished;//控制实际加载的完成的状态

@property(nonatomic,readwrite,assign)EUMComWebViewState webviewState;
@end

@implementation UMComWebView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        //设置自身的回调
        self.delegate = self;
        
        self.webviewState = EUMComWebViewStateNone;
        
        //设置背景透明
        self.backgroundColor = [UIColor clearColor];
        self.opaque = NO;
    }
    return self;
}

-(void)dealloc
{
    YZLog(@"UMComWebView delloc");
}


- (void)loadHTMLString:(NSString *)string baseURL:(nullable NSURL *)baseURL error:(NSError**)err
{
    //1.判断合法性
    if (!string) {
       *err =  [NSError errorWithDomain:UMComWebViewErrorDomain code:UMComWebViewError_NullUrl userInfo:nil];
        self.webviewState = EUMComWebViewStateLoadingError;
        return;
    }
    
    //2.检查有效性（此处忽略）
    
    //如果设置为EUMComWebViewStateReload模式或者EUMComWebViewStateLoadingError，不做检查
    if (self.webviewState == EUMComWebViewStateReload || self.webviewState == EUMComWebViewStateLoadingError) {
        goto UMComWebView_loadHTMLString_condition4;
    }
    
    //3.检查和上一次是否一致
    if ([self.localHtmlData isEqualToString:string]) {
        *err =  [NSError errorWithDomain:UMComWebViewErrorDomain code:UMComWebViewError_SomeUrl userInfo:nil];
        return;
    }
    
UMComWebView_loadHTMLString_condition4:
    
    //4.如果在加载就停止
    if (self.loading) {
        [self stopLoading];
    }

    //5.设置本地加载的html
    self.localHtmlData = string;
    
    //6.首先隐藏
    self.hidden = YES;
    
    //7.设置状态
    self.webviewState = EUMComWebViewStateLoading;
    
    //8.设置为true是为了只加载一次
    self.isLoadingFinished = YES;
    
    //9.加载数据
    [self loadHTMLString:string baseURL:baseURL];
}


- (void)loadRequest:(NSURLRequest *)request error:(NSError**)err
{
    //1.判断合法性
    if (!request) {
        *err =  [NSError errorWithDomain:UMComWebViewErrorDomain code:UMComWebViewError_NullUrl userInfo:nil];
        self.webviewState = EUMComWebViewStateLoadingError;
        return;
    }
    
    //2.检查有效性（此处忽略）
    
    //3.检查request的合法性
    NSString* reuqestUrl = [request.URL absoluteString];
    if (!reuqestUrl) {
        *err =  [NSError errorWithDomain:UMComWebViewErrorDomain code:UMComWebViewError_NullUrl userInfo:nil];
        self.webviewState = EUMComWebViewStateLoadingError;
        return;
    }
    
    //如果设置为EUMComWebViewStateReload模式或者EUMComWebViewStateLoadingError，不做检查
    if (self.webviewState == EUMComWebViewStateReload || self.webviewState == EUMComWebViewStateLoadingError) {
        goto UMComWebView_loadRequest_condition5;
    }

    //4.检查和上一次是否一致
    if ([self.remoteUrl isEqualToString:reuqestUrl]) {
        *err =  [NSError errorWithDomain:UMComWebViewErrorDomain code:UMComWebViewError_SomeUrl userInfo:nil];
        return;
    }
  
UMComWebView_loadRequest_condition5:
    //5.如果在加载就停止
    if (self.loading) {
        [self stopLoading];
    }
    
    //6.设置远程加载的url
    self.remoteUrl = reuqestUrl;
    
    //7.首先隐藏
    self.hidden = YES;
    
    //8.设置状态
    self.webviewState = EUMComWebViewStateLoading;
    
    //9.设置为true是为了只加载一次
    self.isLoadingFinished = YES;
    
    //10.执行加载
    [self loadRequest:request];
}

#pragma mark - privateMethod

-(void) setReloadWebViewState
{
    self.webviewState = EUMComWebViewStateReload;
}

//获取宽度已经适配于webView的html。这里的原始html也可以通过js从webView里获取
- (NSString *)htmlAdjustWithPageWidth:(CGFloat )pageWidth
                                 html:(NSString *)html
                              webView:(UIWebView *)webView
{
    NSMutableString *str = [NSMutableString stringWithString:html];
    //计算要缩放的比例
    CGFloat initialScale = webView.frame.size.width/pageWidth;
    //将</head>替换为meta+head
    NSString *stringForReplace = [NSString stringWithFormat:@"<meta name=\"viewport\" content=\" initial-scale=%f, minimum-scale=0.1, maximum-scale=2.0, user-scalable=yes\"></head>",initialScale];
    
    NSRange range =  NSMakeRange(0, str.length);
    //替换
    [str replaceOccurrencesOfString:@"</head>" withString:stringForReplace options:NSLiteralSearch range:range];
    return str;
}

//处理整个屏幕的缩放比例和图片的缩放比例
-(NSString*) processSencondLoadHTMLStringAutoFitWebViewWithd
{
    //js获取body宽度
    NSString *bodyWidth= [self stringByEvaluatingJavaScriptFromString: @"document.body.scrollWidth "];

    [self stringByEvaluatingJavaScriptFromString:
     @"var script = document.createElement('script');"
     "script.type = 'text/javascript';"
     "script.text = \"function ResizeImages() { "
     "var myimg,oldwidth;"
     "var maxwidth=380;" //缩放系数
     "for(i=0;i <document.images.length;i++){"
     "myimg = document.images[i];"
     "if(myimg.width > maxwidth){"
     "oldwidth = myimg.width;"
     "myimg.width = maxwidth;"
     "myimg.height = myimg.height * (maxwidth/oldwidth);"
     "}"
     "}"
     "}\";"
     "document.getElementsByTagName('head')[0].appendChild(script);"];

    [self stringByEvaluatingJavaScriptFromString:@"ResizeImages();"];

    int widthOfBody = [bodyWidth intValue];

    //获取实际要显示的html
    NSString *html = [self htmlAdjustWithPageWidth:widthOfBody
                                              html:self.localHtmlData
                                           webView:self];
    return html;
}

//处理图片的最大宽度的js
-(void)processIMGAutoFitInWebView
{
    NSString *js = @"function imgAutoFit() { \
    var imgs = document.getElementsByTagName('img'); \
    for (var i = 0; i < imgs.length; ++i) {\
    var img = imgs[i];   \
    img.style.maxWidth = %f;   \
    } \
    }";
    js = [NSString stringWithFormat:js, self.bounds.size.width - 20];
    
    [self stringByEvaluatingJavaScriptFromString:js];
    [self stringByEvaluatingJavaScriptFromString:@"imgAutoFit()"];
}


/**
 *  处理第二次请求
 */
-(void) processSencondLoadHTMLString
{
    //设置为已经加载完成
    self.isLoadingFinished = YES;
    //加载实际要现实的html
    [self loadHTMLString:self.localHtmlData baseURL:nil];
}


#pragma mark - UIWebViewDelegate
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSString* requesetURLString = request.URL.absoluteString;
    
    //第一次加载的时候会回调
    if ([requesetURLString isEqualToString:@"about:blank"]) {
        return YES;
    }
    
    if (self.UMComWebViewDelegate && [self.UMComWebViewDelegate respondsToSelector:@selector(UMComWebView:shouldStartLoadWithRequest:navigationType:)] ) {
        return [self.UMComWebViewDelegate UMComWebView:webView shouldStartLoadWithRequest:request navigationType:navigationType];
    }
    return YES;
}
- (void)webViewDidStartLoad:(UIWebView *)webView
{
    if (self.UMComWebViewDelegate && [self.UMComWebViewDelegate respondsToSelector:@selector(UMComWebViewDidStartLoad:)]) {
        [self.UMComWebViewDelegate UMComWebViewDidStartLoad:webView];
    }
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    //若加载完成第一次，则显示webView并return
    if(!self.isLoadingFinished)
    {
        [self processSencondLoadHTMLString];
        return;
    }
    
    //处理图片的缩放问题
    //[self processIMGAutoFitInWebView];
    
    //重置状态
    self.isLoadingFinished = NO;
    self.webviewState = EUMComWebViewStateLoadingFinish;
    
    self.hidden = NO;
    if (self.UMComWebViewDelegate && [self.UMComWebViewDelegate respondsToSelector:@selector(UMComWebViewDidFinishLoad:)]) {
        __weak typeof(self) weakself = self;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [weakself.UMComWebViewDelegate UMComWebViewDidFinishLoad:webView];
        });
    }
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    self.webviewState = EUMComWebViewStateLoadingError;
    self.isLoadingFinished = NO;
    if (self.UMComWebViewDelegate && [self.UMComWebViewDelegate respondsToSelector:@selector(UMComWebView:didFailLoadWithError:)]) {
        [self.UMComWebViewDelegate UMComWebView:webView didFailLoadWithError:error];
    }
}

@end

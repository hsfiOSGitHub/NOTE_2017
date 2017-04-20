//
//  ViewController.m
//  JS-OC_Interaction
//
//  Created by tonin on 2017/4/12.
//  Copyright © 2017年 tonin. All rights reserved.
//

#import "ViewController.h"
@interface ViewController ()<UIWebViewDelegate, TestObjectProtocol>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIWebView *webView = [[UIWebView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:webView];
    
    //oc 调用 js函数
    NSString *jsPath = [[NSBundle mainBundle] pathForResource:@"TestJSFunction" ofType:@"js"];
    NSString *jsStr = [NSString stringWithContentsOfFile:jsPath encoding:NSUTF8StringEncoding error:nil];
    JSContext *content = [[JSContext alloc] init];
    [content evaluateScript:jsStr];
    
    JSValue *function = content[@"factorial"];
    JSValue *result = [function callWithArguments:@[@5]];
    NSLog(@" =============> factorial(5) = %d", [result toInt32]);
    
    //加载本地 html
    NSString *path = [[NSBundle mainBundle] bundlePath];
    NSURL *baseURL = [NSURL fileURLWithPath:path];
    NSString *htmlPath = [[NSBundle mainBundle] pathForResource:@"html01"
                                                          ofType:@"html"];
    NSString *htmlContent = [NSString stringWithContentsOfFile:htmlPath
                                                    encoding:NSUTF8StringEncoding
                                                    error:nil];

    [webView loadHTMLString:htmlContent baseURL:baseURL];
    webView.delegate = self;

}
- (void)webViewDidFinishLoad:(UIWebView *)webView {
    //在加载完 webview 界面,传入'ocFunc函数'给 js 调用
    //js 调用 oc 的函数
    JSContext *content = [webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    content[@"ocFunc"] = ^() {
        NSLog(@" =============> 我在测试js 调用 oc函数");
        return @"js调用了oc函数";
    };
    //通过 JSExport 协议,把对象给 js 调用, 对象去掉 oc 的方法
    //对象要 遵守 JSExport 协议,实现 js 要调用的协议方法
    //调用多个参数的方法,要把 第二参数(包含第二个参数)以后的参数前面的方法体首字母转换成大写
    //如:testOCMethodWithFirstParam:(NSString *)className secondMethod:(int)number ----->  testOCMethodWithFirstParamSecondMethod(className, number)
    content[@"testObject"] = self;
    
}
- (NSString *)testOCMethodWithFirstParam:(NSString *)className secondMethod:(int)number {
    NSLog(@" ===========> js调用了oc的方法:%@, %d", className, number);
    return @"js调用了oc对象";
}

@end

//
//  ZX_Web_ViewController.h
//  友照
//
//  Created by cleloyang on 2016/11/24.
//  Copyright © 2016年 ZX_XPH. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZX_Web_ViewController : ZXSeconBaseViewController

@property (weak, nonatomic) IBOutlet UIWebView *webV;
@property (nonatomic, copy) NSString *htmlStr;
@property (nonatomic, copy) NSString *titleStr;

@end

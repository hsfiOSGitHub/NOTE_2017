//
//  ZXCycleDetailViewController.h
//  ZXJiaXiao
//
//  Created by Finsen on 16/7/8.
//  Copyright © 2016年 ZX. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZXCycleDetailViewController : ZXSeconBaseViewController

@property (weak, nonatomic) IBOutlet UIWebView *webV;
@property (nonatomic, strong)NSString *url;

@end

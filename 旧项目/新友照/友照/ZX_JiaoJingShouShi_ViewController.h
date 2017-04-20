//
//  ZX_JiaoJingShouShi_ViewController.h
//  友照
//
//  Created by cleloyang on 2016/12/12.
//  Copyright © 2016年 ZX_XPH. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZX_JiaoJingShouShi_ViewController : ZXSeconBaseViewController

@property (nonatomic, copy) NSString *fileName;
@property(nonatomic,strong) NSArray* tupianArr;     //驾校图片数组
@property (nonatomic, copy) NSString *biaoZhiTitle;
@property(nonatomic)BOOL isJiaXiaoTuPian;
@property(nonatomic)BOOL isJiaoTongBiaoZhi;

@end

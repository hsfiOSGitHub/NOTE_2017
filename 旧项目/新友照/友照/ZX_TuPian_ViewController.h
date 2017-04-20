//
//  ZX_TuPian_ViewController.h
//  友照
//
//  Created by cleloyang on 2016/12/12.
//  Copyright © 2016年 ZX_XPH. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZX_TuPian_ViewController : ZXSeconBaseViewController

@property(nonatomic)NSInteger pianyiliang;
@property (nonatomic, copy) NSDictionary *dataSourceDic;
@property (nonatomic ,copy) NSIndexPath* contentIndexPath;
@property (nonatomic, strong) NSMutableArray *nameArr;
@property (nonatomic, strong) NSMutableArray *imgsArr;
@property (nonatomic, strong) NSMutableArray *fenShuArr;
@property (nonatomic, strong) NSMutableArray *titleArr;
@property(nonatomic)BOOL isJiaXiaoTuPian;

@end

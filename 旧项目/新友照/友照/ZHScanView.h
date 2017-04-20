//
//  ZHScanView.h
//  sasasas
//
//  Created by WZH on 16/3/8.
//  Copyright © 2016年 lyj. All rights reserved.
//


/**
 *  二维码扫描框的大小 正方形
 */
#define ScanWidth 220

/**
 *  扫描框的摆放位置
 */
#define ScanY (KScreenHeight / 2 - 110)

#import <UIKit/UIKit.h>

typedef void(^resultBlock)(NSString * result);

@interface ZHScanView : UIView
/**
 *  扫描框下提示信息
 */
@property (nonatomic, copy) NSString *promptMessage;

/**
 *  获取默认大小的scanView(全屏)
 *
 */
+ (instancetype)scanView;

/**
 *  获取指定大小的scanView;
 *
 */
+ (instancetype)scanViewWithFrame:(CGRect)frame;

/**
 *  开始扫描
 */
- (void)startScaning;

/**
 *  输出结果
 */
- (void)outPutResult:(resultBlock)result;


@end
// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com
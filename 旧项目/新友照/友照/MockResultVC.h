//
//  MockResultVC.h
//  友照
//
//  Created by monkey2016 on 16/12/14.
//  Copyright © 2016年 ZX_XPH. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MockResultVC : UIViewController
@property (nonatomic,assign) NSInteger yourScore;
@property (nonatomic,strong) NSString *usedTimeStr;
@property (nonatomic,strong) NSString *subject;

@property (nonatomic,strong) NSString *url;//网址
@property (nonatomic,strong) NSString *BT;//标题
@property (nonatomic,strong) NSString *NR;//内容
@property (nonatomic,strong) NSString *TPurl;//图片网址

@end

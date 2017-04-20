//
//  SZBAlertView.h
//  yuntangyi
//
//  Created by yuntangyi on 16/9/19.
//  Copyright © 2016年 yuntangyi. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger, SZBAlertType) {
    SZBAlertType1 = 0,
    SZBAlertType2,
    SZBAlertType3,
    SZBAlertType4,
    SZBAlertType5,
    SZBAlertType6,
};

@protocol RemoveSelf <NSObject>
-(void)removeSelfAction;
@end

@interface SZBAlertView : UIView
@property (nonatomic,assign) SZBAlertType type;//类型
@property (nonatomic,strong) UIView *bgView;//背景view
@property (nonatomic,assign) id<RemoveSelf> agency;//代理
//选择器的头文字
@property (nonatomic,strong) NSString *headerStr;
//姓名
@property (nonatomic,strong) NSString *name;
//报名的标题和内容字典
@property (nonatomic,strong) NSDictionary *contentDic;
//职称数据源
@property (nonatomic,strong) NSArray *source;


//延迟移除
-(void)removeAfterTime:(NSTimeInterval)time;

@end

//
//  KnCellType2VC.h
//  yuntangyi
//
//  Created by yuntangyi on 16/8/30.
//  Copyright © 2016年 yuntangyi. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol KnCellType2Delegate <NSObject>
-(void)changeIsCollectStateWith:(NSString *)iscollect andNewsIndex:(NSInteger)newsIndex andIndex:(NSInteger)index;
-(void)changeIsPraiseStateWith:(NSString *)ispraise andNewsIndex:(NSInteger)newsIndex andIndex:(NSInteger)index;
@end

@interface KnCellType2VC : UIViewController
@property (nonatomic,strong) NSString *newsID;//新闻id
@property (nonatomic,strong) NSString *url;//网址
@property (nonatomic,strong) NSString *BT;//标题
@property (nonatomic,strong) NSString *NR;//内容
@property (nonatomic,strong) NSString *TPurl;//图片网址



/*
 "iscollect": "0",———————————是否收藏
 "ispraise": "0",———————————是否点赞
 */
@property (nonatomic,strong) NSString *iscollect;
@property (nonatomic,strong) NSString *ispraise;
@property (nonatomic,assign) NSInteger newsIndex;//第几个资讯
@property (nonatomic,assign) NSInteger index;//数据所在列表下表
@property (nonatomic,assign) id<KnCellType2Delegate> delegate;//代理
@end

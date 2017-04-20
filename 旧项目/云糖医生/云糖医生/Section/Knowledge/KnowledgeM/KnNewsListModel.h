//
//  KnNewsListModel.h
//  yuntangyi
//
//  Created by yuntangyi on 16/9/23.
//  Copyright © 2016年 yuntangyi. All rights reserved.
//

#import <Foundation/Foundation.h>
/*
 返回值说明
 {
 "res": "1001",
 "msg": "请求成功",
 "newslist": [
         {
         "id": "38",
         "pic": "http://localhost:8089/attachment/news/thumb/20160919144933-XNnXUY3Luj.jpg",
         "title": "移动医疗行业陷入“高流量低收益”困局",
         "content": "对于移动医疗行业来说，今年可能是“移不动...",
         "addtime": "2016-09-19 14:49:33",
         "click": "0",———————————点击数
         "collect": "0",———————————收藏数
         "praise": "0",———————————点赞数
         "iscollect": "0",———————————是否收藏
         "ispraise": "0",———————————是否点赞
         "url": "?m=news&nid=38"——————资讯详情
         }
     ]
 }
 {"res":"1004","msg":"重复请求"}
 {"res":"1005","msg":"缺少参数"}
 */

@interface KnNewsListModel : NSObject
@property (nonatomic,strong) NSString *KnID;
@property (nonatomic,strong) NSString *pic;
@property (nonatomic,strong) NSString *title;
@property (nonatomic,strong) NSString *content;
@property (nonatomic,strong) NSString *addtime;
@property (nonatomic,strong) NSString *click;
@property (nonatomic,strong) NSString *collect;
@property (nonatomic,strong) NSString *praise;
@property (nonatomic,strong) NSString *iscollect;
@property (nonatomic,strong) NSString *ispraise;
@property (nonatomic,strong) NSString *url;

//初始化方法
-(instancetype)initWithDict:(NSDictionary *)dict;
+(instancetype)modelWithDict:(NSDictionary *)dict;

@end

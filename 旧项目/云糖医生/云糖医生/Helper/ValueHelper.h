//
//  ValueHelper.h
//  yuntangyi
//
//  Created by yuntangyi on 16/9/21.
//  Copyright © 2016年 yuntangyi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ValueHelper : NSObject
//姓名
@property (nonatomic,strong) NSString *nameStr;
//性别
@property (nonatomic,strong) NSString *sexStr;
//医院
@property (nonatomic,strong) NSString *hospitalStr;
//科室
@property (nonatomic,strong) NSString *departmentStr;
//职称
@property (nonatomic,strong) NSString *jobStr;
//个人经历
@property (nonatomic,strong) NSString *contentStr;


//>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
@property (nonatomic,strong) NSString *registerGuider;//用来判断选择医院的入口 是注册  还是修改基本信息
@property (nonatomic,strong) NSString *registerName;
@property (nonatomic,strong) NSDictionary *registerJob;
@property (nonatomic,strong) NSDictionary *registerHospital;
@property (nonatomic,strong) NSDictionary *registerDepartment;
@property (nonatomic,strong) NSString *registerSex;

//>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
@property (nonatomic,strong) NSArray *kn_pageArr;//
@property (nonatomic,assign) BOOL updateKn;//是否刷新知识界面
@property (nonatomic,assign) BOOL updateCollect;//是否刷新我的收藏页面


//单例的创建
+(instancetype)sharedHelper;
//清理缓存
-(void)cleanDisk;

@end

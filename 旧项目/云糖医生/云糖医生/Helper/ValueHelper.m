//
//  ValueHelper.m
//  yuntangyi
//
//  Created by yuntangyi on 16/9/21.
//  Copyright © 2016年 yuntangyi. All rights reserved.
//

#import "ValueHelper.h"

#import "SZBFmdbManager+project.h"
#import "SZBFmdbManager+meeting.h"
#import "SZBFmdbManager+news.h"
#import "SZBFmdbManager+userInfo.h"

static ValueHelper *helper;
@implementation ValueHelper
//单例的创建
+(instancetype)sharedHelper{
    if (!helper) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            helper = [[ValueHelper alloc]init];
        });
    }
    return helper;
}

#pragma mark -懒加载
-(NSString *)nameStr{
    if (!_nameStr) {
        _nameStr = @"点击修改";
    }
    return _nameStr;
}
-(NSString *)sexStr{
    if (!_sexStr) {
        _sexStr = @"女";
    }
    return _sexStr;
}
-(NSString *)hospitalStr{
    if (!_hospitalStr) {
        _hospitalStr = @"选择您所在的医院";
    }
    return _hospitalStr;
}
-(NSString  *)departmentStr{
    if (!_departmentStr) {
        _departmentStr = @"选择您所在的科室";
    }
    return _departmentStr;
}
-(NSString *)jobStr{
    if (!_jobStr) {
        _jobStr = @"选择您的职称";
    }
    return _jobStr;
}
-(NSString *)contentStr{
    if (!_contentStr) {
        _contentStr = @"请填写您的工作经历";
    }
    return _contentStr;
}


//>>>>>>>>>>>>>>>>>>>>>>>>>>>
-(NSString *)registerSex{
    if (!_registerSex) {
        _registerSex = @"0";
    }
    return _registerSex;
}

//>>>>>>>>>>>>>>>>>>>>>>>>>>>>
-(NSArray *)kn_pageArr{
    if (!_kn_pageArr) {
        _kn_pageArr = [NSMutableArray arrayWithObjects:@"0", @"0", @"0", @"0", nil];
    }
    return _kn_pageArr;
}








//清理缓存
-(void)cleanDisk{
    [[SZBFmdbManager sharedManager] cleanDisk_projectList];
    [[SZBFmdbManager sharedManager] cleanDisk_meetingList];
    [[SZBFmdbManager sharedManager] cleanDisk_newsList];
    [[SZBFmdbManager sharedManager] cleanDisk_userInfo];
    
    //用于知识界面
    NSArray *pageArr = @[@"0", @"0", @"0", @"0"];
    [ZXUD setObject:pageArr forKey:@"pageArr"];
    
    [ZXUD setObject:@"0" forKey:@"firstSource_meeting"];
    [ZXUD setObject:@"0" forKey:@"firstSource_news1"];
    [ZXUD setObject:@"0" forKey:@"firstSource_news2"];
    [ZXUD setObject:@"0" forKey:@"firstSource_news3"];
    
    [ZXUD synchronize];
}













@end

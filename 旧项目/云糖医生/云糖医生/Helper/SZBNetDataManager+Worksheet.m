//
//  SZBNetDataManager+Worksheet.m
//  yuntangyi
//
//  Created by yuntangyi on 16/9/6.
//  Copyright © 2016年 yuntangyi. All rights reserved.
//

#import "SZBNetDataManager+Worksheet.h"

@implementation SZBNetDataManager (Worksheet)
//医生排班修改worksheet_update
-(void)worksheet_updateWithRandomStamp:(NSString *)randomString andIdentCode:(NSString *)identCode andAmStartTime:(NSString *)amStartTime andAmEndTime:(NSString *)amEndTime andAmnum:(NSString *)amnum andPmStartTime:(NSString *)pmStartTime andPmEndTime:(NSString *)pmEndTime andPmnum:(NSString *)pmnum andPoint:(NSString *)pointStr andID:(NSString *)iD success:(SuccessBlockType)successBlock failed:(FailuerBlockType)failedBlock {
    self.successBlock = successBlock;
    self.failedBlock = failedBlock;
    NSString *url =[NSString stringWithFormat:SWorksheet_update_Url,randomString, identCode, amStartTime, amEndTime, amnum, pmStartTime, pmEndTime, pmnum, pointStr,iD];
    //转码
    NSString *WorksheetUrl = [url stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]];
    NSLog(@"%@", WorksheetUrl);
    [self.manager GET:WorksheetUrl parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (self.successBlock) {
            self.successBlock(task,responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (self.failedBlock) {
            self.failedBlock(task,error);
        }
    }];
}
//删除排班worksheet_del
-(void)worksheet_delWithRandomStamp:(NSString *)randomString andIdentCode:(NSString *)identCode andDwp_id:(NSString *)dwp_id success:(SuccessBlockType)successBlock failed:(FailuerBlockType)failedBlock {
    self.successBlock = successBlock;
    self.failedBlock = failedBlock;
    NSString *url =[NSString stringWithFormat:Sworksheet_del_Url,randomString, identCode, dwp_id];
    //转码
    NSString *WorksheetUrl = [url stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]];
    NSLog(@"%@", WorksheetUrl);
    [self.manager GET:WorksheetUrl parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (self.successBlock) {
            self.successBlock(task,responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (self.failedBlock) {
            self.failedBlock(task,error);
        }
    }];

}
//医生排班设置 worksheet_set
-(void)worksheetSetWithRandomStamp:(NSString *)randomString andIdentCode:(NSString *)identCode andStartDate:(NSString *)startDate andEndDate:(NSString *)endDate andAmStartTime:(NSString *)amStartTime andAmEndTime:(NSString *)amEndTime andAmnum:(NSString *)amnum andPmStartTime:(NSString *)pmStartTime andPmEndTime:(NSString *)pmEndTime andPmnum:(NSString *)pmnum andPoint:(NSString *)pointStr success:(SuccessBlockType)successBlock failed:(FailuerBlockType)failedBlock {
    self.successBlock = successBlock;
    self.failedBlock = failedBlock;
    NSString *url =[NSString stringWithFormat:SWorksheet_set_Url,randomString, identCode, startDate, endDate, amStartTime, amEndTime, amnum, pmStartTime, pmEndTime, pmnum, pointStr];
    //转码
    NSString *WorksheetUrl = [url stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]];
     NSLog(@"%@", WorksheetUrl);
    [self.manager GET:WorksheetUrl parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (self.successBlock) {
            self.successBlock(task,responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (self.failedBlock) {
            self.failedBlock(task,error);
        }
    }];
}
//预约日程表worksheet
-(void)worksheetWithRandomStamp:(NSString *)randomString andIdentCode:(NSString *)identCode success:(SuccessBlockType)successBlock failed:(FailuerBlockType)failedBlock {
    self.successBlock = successBlock;
    self.failedBlock = failedBlock;
    NSString *url =[NSString stringWithFormat:SWorksheet_Url,randomString, identCode];
    //转码
//    NSString *WorksheetUrl = [url stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]];
     NSLog(@"%@", url);
    [self.manager GET:url parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (self.successBlock) {
            self.successBlock(task,responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (self.failedBlock) {
            self.failedBlock(task,error);
        }
    }];
}
//预约数据列表
-(void)worksheetListWithRandomStamp:(NSString *)randomString andIdentCode:(NSString *)identCode andDate:(NSString *)date andPage:(NSString *)page success:(SuccessBlockType)successBlock failed:(FailuerBlockType)failedBlock {
    self.successBlock = successBlock;
    self.failedBlock = failedBlock;
    NSString *url =[NSString stringWithFormat:SWorksheetList_Url,randomString, identCode , date, page];
    //转码
    NSString *WorksheetListUrl = [url stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]];
    NSLog(@"%@", WorksheetListUrl);
    [self.manager GET:WorksheetListUrl parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (self.successBlock) {
            self.successBlock(task,responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (self.failedBlock) {
            self.failedBlock(task,error);
        }
    }];

}
@end

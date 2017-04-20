//
//  SZBNetDataManager+KnowLedgeNetData.m
//  yuntangyi
//
//  Created by yuntangyi on 16/9/2.
//  Copyright © 2016年 yuntangyi. All rights reserved.
//

#import "SZBNetDataManager+KnowLedgeNetData.h"

@implementation SZBNetDataManager (KnowLedgeNetData)
//资讯类型news_type
-(void)news_typeRandomStamp:(NSString *)randomString andIdent_code:(NSString *)ident_code success:(SuccessBlockType)successBlock failed:(FailuerBlockType)failedBlock {
    self.successBlock = successBlock;
    self.failedBlock = failedBlock;
    NSString *url =[NSString stringWithFormat:SNews_type_Url,randomString,ident_code];
    //转码
    NSString *NewUrl = [url stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]];
    NSLog(@"%@", NewUrl);
    [self.manager GET:NewUrl parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
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

//资讯news_list
-(void)news_listRandomStamp:(NSString *)randomString andPage:(NSString *)page andIdent_code:(NSString *)ident_code andPid:(NSString *)pid success:(SuccessBlockType)successBlock failed:(FailuerBlockType)failedBlock {
    self.successBlock = successBlock;
    self.failedBlock = failedBlock;
    NSString *url =[NSString stringWithFormat:SNews_list_Url,randomString ,page,ident_code, pid];
    //转码
    NSString *NewUrl = [url stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]];
    NSLog(@"%@", NewUrl);
    [self.manager GET:NewUrl parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
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
//资讯news
-(void)newsRandomStamp:(NSString *)randomString andID:(NSString *)ID success:(SuccessBlockType)successBlock failed:(FailuerBlockType)failedBlock {
    self.successBlock = successBlock;
    self.failedBlock = failedBlock;
    NSString *url =[NSString stringWithFormat:SNews_Url,randomString ,ID];
    //转码
    NSString *NewUrl = [url stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]];
    //    NSLog(@"%@", NewUrl);
    [self.manager GET:NewUrl parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
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
//资讯收藏 news_collect
-(void)news_collectWithRandomStamp:(NSString *)randomString AndIdent_code:(NSString *)ident_code AndId:(NSString *)ID success:(SuccessBlockType)successBlock failed:(FailuerBlockType)failedBlock {
    self.successBlock = successBlock;
    self.failedBlock = failedBlock;
    NSString *url =[NSString stringWithFormat:SNews_collect_Url, randomString, ident_code, ID];
    //转码
    NSString *NewUrl = [url stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]];
    NSLog(@"%@", NewUrl);
    //    self.manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [self.manager GET:NewUrl parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
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
//资讯点赞 news_praise
-(void)news_praiseWithRandomStamp:(NSString *)randomString AndIdent_code:(NSString *)ident_code AndId:(NSString *)ID success:(SuccessBlockType)successBlock failed:(FailuerBlockType)failedBlock {
    self.successBlock = successBlock;
    self.failedBlock = failedBlock;
    NSString *url =[NSString stringWithFormat:SNews_praise_Url, randomString, ident_code, ID];
    //转码
    NSString *NewUrl = [url stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]];
    NSLog(@"%@", NewUrl);
    //    self.manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [self.manager GET:NewUrl parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
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


//会议列表 meeting_list
-(void)meeting_listWithRandomStamp:(NSString *)randomString andIdent_code:(NSString *)ident_code AndPage:(NSString *)page success:(SuccessBlockType)successBlock failed:(FailuerBlockType)failedBlock {
    self.successBlock = successBlock;
    self.failedBlock = failedBlock;
    NSString *url =[NSString stringWithFormat:SMeeting_list_Url,randomString ,ident_code , page];
    //转码
    NSString *NewUrl = [url stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]];
    NSLog(@"%@", NewUrl);
//    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
//    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [self.manager GET:NewUrl parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
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
//会议详情 meeting_info
-(void)meeting_infoWithID:(NSString *)ID AndRandomStamp:(NSString *)randomString andIdent_code:(NSString *)ident_code success:(SuccessBlockType)successBlock failed:(FailuerBlockType)failedBlock {
    self.successBlock = successBlock;
    self.failedBlock = failedBlock;
    NSString *url =[NSString stringWithFormat:SMeeting_info_Url,ID,randomString ,ident_code];
    //转码
    NSString *NewUrl = [url stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]];
    NSLog(@"%@", NewUrl);
    //    self.manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [self.manager GET:NewUrl parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
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
//会议报名 meeting_sign_up
-(void)meeting_sign_upWithMid:(NSString *)mid AndRandomStamp:(NSString *)randomString andIdent_code:(NSString *)ident_code success:(SuccessBlockType)successBlock failed:(FailuerBlockType)failedBlock {
    self.successBlock = successBlock;
    self.failedBlock = failedBlock;
    NSString *url =[NSString stringWithFormat:SMeeting_sign_up_Url,mid,randomString ,ident_code];
    //转码
    NSString *NewUrl = [url stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]];
    NSLog(@"%@", NewUrl);
    //    self.manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [self.manager GET:NewUrl parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
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

//
//  UMComDataController.m
//  UMCommunity
//
//  Created by umeng on 16/4/29.
//  Copyright © 2016年 Umeng. All rights reserved.
//

#import "UMComListDataController.h"
#import <UMCommunitySDK/UMComDataTypeDefine.h>

@implementation UMComListDataController
@synthesize haveNextPage = _haveNextPage;

@synthesize dataArray = _dataArray;

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.dataArray = [NSMutableArray array];
        self.count = UMCom_Limit_Page_Count;
    }
    return self;
}

+ (UMComListDataController *)dataControllerWithCount:(NSInteger)count
{
    UMComListDataController *dataController = [[[self class] alloc] initWithCount:count];
    return dataController;
}

- (instancetype)initWithCount:(NSInteger)count
{
    self = [self init];
    if (self) {
        if (count > 0) {
            self.count = count;
        }else{
            self.count = UMCom_Limit_Page_Count;
        }
    }
    return self;
}

- (instancetype)initWithRequestType:(UMComPageRequestType)requestType count:(NSInteger)count
{
    self = [self init];
    if (self) {
        self.pageRequestType = requestType;
        self.count = count;
    }
    return self;
}

- (void)setDataArray:(NSMutableArray *)dataArray
{
    _dataArray = dataArray;
}

- (NSMutableArray *)dataArray
{
    if (!_dataArray) {
        _dataArray = [[NSMutableArray alloc] init];
    }
    return _dataArray;
}

- (void)setHaveNextPage:(BOOL)haveNextPage
{
    _haveNextPage = haveNextPage;
}

- (BOOL)haveNextPage
{
    _haveNextPage = ([self.nextPageUrl isKindOfClass:[NSString class]] &&self.nextPageUrl.length > 0);
    return _haveNextPage;
}


/**
 *请求第一页数据
 */
- (void)refreshNewDataCompletion:(UMComDataListRequestCompletion)completion
{
}

/**
 *请求下一页数据
 */
- (void)loadNextPageDataWithCompletion:(UMComDataListRequestCompletion)completion
{
    __weak typeof(self) weakSelf = self;
    [[UMComDataRequestManager defaultManager] fetchNextPageWithNextPageUrl:self.nextPageUrl pageRequestType:self.pageRequestType completion:^(NSDictionary *responseObject, NSError *error) {
        [weakSelf handleNextPageData:responseObject error:error completion:completion];
    }];
}


-(void)fetchLocalDataWithCompletion:(UMComDataListRequestCompletion)localfetchcompletion
{
    __weak typeof(self) weakSelf = self;
    [[UMComDataBaseManager shareManager] fetchASyncWithType:g_relatedIDTableTypeFromPageRequestType(self.pageRequestType) withCompleteBlock:^(NSArray* dataArray, NSError * error) {
        [weakSelf handleLocalData:dataArray error:error completion:localfetchcompletion];
    }];
}

-(void)saveLocalDataWithDataArray:(NSArray*)dataArray
{
    [[UMComDataBaseManager shareManager]  saveRelatedIDTableWithType:g_relatedIDTableTypeFromPageRequestType(self.pageRequestType) withUMComModelObjects:dataArray];
}

- (void)handleLocalData:(NSArray *)data error:(NSError *)error completion:(UMComDataListRequestCompletion)completion
{
    self.haveNextPage = NO;
    self.canVisitNextPage = NO;
    self.nextPageUrl = nil;
    [self.dataArray removeAllObjects];
    if ([data isKindOfClass:[NSArray class]] && data.count >0) {
        [self.dataArray addObjectsFromArray:data];
    }
    if (completion) {
        completion(data, error);
    }
}

- (void)handleNewData:(NSDictionary *)data error:(NSError *)error completion:(UMComDataListRequestCompletion)completion
{
    if (![data isKindOfClass:[NSDictionary class]] || error) {
        if (completion) {
            completion(nil, error);
        }
        return;
    }
    if (!self.dataArray) {
        self.dataArray = [NSMutableArray array];
    }else{
        [self.dataArray removeAllObjects];
    }
    NSArray *dataArray = [data valueForKey:UMComModelDataKey];
    if ([dataArray isKindOfClass:[NSArray class]] && dataArray.count >0) {
        [self.dataArray addObjectsFromArray:dataArray];
    }
    self.nextPageUrl = [data valueForKey:UMComModelDataNextPageUrlKey];
    self.canVisitNextPage = [[data valueForKey:UMComModelDataVisitKey] boolValue];
    
    //调用保存方法
    if (self.isSaveLoacalData && !error) {
        [self saveLocalDataWithDataArray:self.dataArray];
    }
    
    if (completion) {
        completion([data valueForKey:UMComModelDataKey], nil);
    }
}

- (void)handleNextPageData:(NSDictionary *)data error:(NSError *)error completion:(UMComDataListRequestCompletion)completion
{
    if (![data isKindOfClass:[NSDictionary class]] || error) {
        if (completion) {
            completion(nil, error);
        }
        return;
    }
    NSArray *dataArray = [data valueForKey:UMComModelDataKey];
    if ([dataArray isKindOfClass:[NSArray class]] && dataArray.count >0) {
        [self.dataArray addObjectsFromArray:dataArray];
    }
    self.nextPageUrl = [data valueForKey:UMComModelDataNextPageUrlKey];
    self.canVisitNextPage = [[data valueForKey:UMComModelDataVisitKey] boolValue];

    if (completion) {
        completion([data valueForKey:UMComModelDataKey], nil);
    }
}


@end

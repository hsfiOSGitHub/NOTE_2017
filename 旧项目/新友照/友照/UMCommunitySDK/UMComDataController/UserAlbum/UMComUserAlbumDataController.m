//
//  UMComUserAlbumDataController.m
//  UMCommunity
//
//  Created by 张军华 on 16/6/27.
//  Copyright © 2016年 Umeng. All rights reserved.
//

#import "UMComUserAlbumDataController.h"
#import <UMComDataStorage/UMComUser.h>
#import <UMCommunitySDK/UMComSession.h>

@implementation UMComUserAlbumDataController


+ (UMComUserAlbumDataController *)userAlbumDataControllWithUser:(UMComUser *)user count:(NSInteger)count
{
    UMComUserAlbumDataController *userDataController = [[[self class] alloc] initWithCount:count];
    userDataController.user = user;
    return userDataController;
}

- (instancetype)initWithCount:(NSInteger)count
{
    self = [super initWithRequestType:UMComRequestType_UserAlbum count:count];
    if (self) {
        
    }
    return self;
}

- (void)refreshNewDataCompletion:(UMComDataListRequestCompletion)completion
{
    //获取用户相册列表
    __weak typeof(self) weakSelf = self;
    [[UMComDataRequestManager defaultManager] fetchAlbumWithUid:self.user.uid count:self.count completion:^(NSDictionary *responseObject, NSError *error) {
        [weakSelf handleNewData:responseObject error:error completion:completion];
    }];
}

-(void)fetchLocalDataWithCompletion:(UMComDataListRequestCompletion)localfetchcompletion
{
    /*
    //登陆用户相册判断
    if (![self.user.uid isEqualToString:[UMComSession sharedInstance].uid]) {
        if (localfetchcompletion) {
            localfetchcompletion(nil, nil);
        }
        return;
    }
    __weak typeof(self) weakSelf = self;
    [[UMComDataBaseManager shareManager] fetchASyncWithType:g_relatedIDTableTypeFromPageRequestType(self.pageRequestType) withCompleteBlock:^(NSArray* dataArray, NSError * error) {
        [weakSelf handleLocalData:dataArray error:error completion:localfetchcompletion];
    }];
     */
    
    //根据用户uid来取相册
    __weak typeof(self) weakSelf = self;
    [[UMComDataBaseManager shareManager] fetchASyncRelatedAlbumIDWithUID:self.user.uid withCompleteBlock:^(NSArray* dataArray, NSError * error) {
        [weakSelf handleLocalData:dataArray error:error completion:localfetchcompletion];
    }];
    
    
}

-(void)saveLocalDataWithDataArray:(NSArray*)dataArray
{
    /*
    //登陆用户相册判断
    if (![self.user.uid isEqualToString:[UMComSession sharedInstance].uid]) {
        return;
    }
    [[UMComDataBaseManager shareManager]  saveRelatedIDTableWithType:g_relatedIDTableTypeFromPageRequestType(self.pageRequestType) withUMComModelObjects:dataArray];
     */
    
    //根据用户uid来存相册
    [[UMComDataBaseManager shareManager] saveRelatedAlbumIDWithUID:self.user.uid withAlbums:dataArray];
    
}

@end

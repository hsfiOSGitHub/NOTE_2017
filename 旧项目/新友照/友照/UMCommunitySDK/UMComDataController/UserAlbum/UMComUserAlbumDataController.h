//
//  UMComUserAlbumDataController.h
//  UMCommunity
//
//  Created by 张军华 on 16/6/27.
//  Copyright © 2016年 Umeng. All rights reserved.
//

#import "UMComListDataController.h"

@class UMComUser;

@interface UMComUserAlbumDataController : UMComListDataController

@property(nonatomic,strong)UMComUser* user;

+ (UMComUserAlbumDataController *)userAlbumDataControllWithUser:(UMComUser *)user count:(NSInteger)count;

@end

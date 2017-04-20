//
//  UMComLikeListDataController.h
//  UMCommunity
//
//  Created by 张军华 on 16/6/24.
//  Copyright © 2016年 Umeng. All rights reserved.
//

#import "UMComListDataController.h"

/**
 *  对应feedID的点赞列表
 */
@interface UMComLikeListDataController : UMComListDataController


@end

/**
 *  对应feedID的点赞列表
 */
@interface UMComFeedLikeListDataController : UMComListDataController

- (instancetype)initWithFeedId:(NSString *)feedId count:(NSInteger)count;

@property(nonatomic,strong)NSString* feedId;

@end

/**
 * 当前登录用户被赞的feed列表
 */
@interface UMComUserReceivedLikeDataController : UMComLikeListDataController


@end


/**
 * 当前登录用户发出的赞
 */
@interface UMComUserSendLikeDataController : UMComLikeListDataController

@end

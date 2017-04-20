//
//  UMComTopicListDataController.h
//  UMCommunity
//
//  Created by umeng on 16/5/5.
//  Copyright © 2016年 Umeng. All rights reserved.
//

#import "UMComListDataController.h"

@class UMComTopic;


@interface UMComTopicListDataController : UMComListDataController

- (void)followOrDisfollowTopic:(UMComTopic *)topic completion:(UMComDataRequestCompletion)completion;


@end

/**
 *全部话题列表
 */
@interface UMComTopicsAllDataController : UMComTopicListDataController

@end

/**
 *推荐话题列表
 */
@interface UMComTopicsRecommendDataController : UMComTopicListDataController

@end

/**
 *我关注的话题列表
 */
@interface UMComTopicsFocusDataController : UMComTopicListDataController

- (instancetype)initWithCount:(NSInteger)count withUID:(NSString*)uid;

@property(nonatomic, copy)NSString* uid;

@end

/**
 *搜索话题
 */
@interface UMComTopicsSearchDataController : UMComTopicListDataController

- (instancetype)initWithCount:(NSInteger)count withKeyWord:(NSString*)keyWord;

@property(nonatomic, copy)NSString* keyWord;
@end

/**
 *话题组下的话题列表
 */
@interface UMComGroupTopicDataController : UMComTopicListDataController

- (instancetype)initWithCount:(NSInteger)count withGroupID:(NSString*)groupID;

@property(nonatomic, copy)NSString* groupID;

@end




//
//  UMComFeedListDataController.h
//  UMCommunity
//
//  Created by umeng on 16/5/3.
//  Copyright © 2016年 Umeng. All rights reserved.
//

#import "UMComListDataController.h"

@class UMComFeed, UMComComment, UMComUser;
@class UMComTopFeedListDataController;

@interface UMComFeedListDataController : UMComListDataController

//置顶的topFeedListDataController
@property(nonatomic,strong)UMComTopFeedListDataController* topFeedListDataController;


- (void)deleteFeed:(UMComFeed *)feed completion:(UMComDataRequestCompletion)completion;

- (void)likeFeed:(UMComFeed *)feed completion:(UMComDataRequestCompletion)completion;

- (void)favouriteFeed:(UMComFeed *)feed completion:(UMComDataRequestCompletion)completion;

//
- (void)spamFeed:(UMComFeed *)feed completion:(UMComDataRequestCompletion)completion;

- (void)commentFeed:(UMComFeed *)feed
            content:(NSString *)content
             images:(NSArray *)images
         completion:(UMComDataRequestCompletion)completion;


- (void)replyCommentFeed:(UMComFeed *)feed
                 comment:(UMComComment *)comment
                 content:(NSString *)content
                  images:(NSArray *)images
              completion:(UMComDataRequestCompletion)completion;

- (void)spamUser:(UMComUser *)user completion:(UMComDataRequestCompletion)completion;

- (void)banUser:(UMComUser *)user topics:(NSArray *)topics completion:(UMComDataRequestCompletion)completion;


//
- (void)shareFeed:(UMComFeed *)feed toPlatform:(NSString *)platform completion:(UMComDataRequestCompletion)completion;


/**
 *  继承UMComFeedListDataController的类，需要重新此类发送下拉刷新的请求
 *
 *  @param completion 成功回调
 */
- (void)doRefreshNewDataCompletion:(UMComDataListRequestCompletion)completion;

/**
 *  过滤普通流中的置顶数据
 *
 *  @param orginCommonFeedList 从网络取得普通流
 *
 *  @return 返回新的过滤的array(默认返回自身)
 *  @子类可以重写来重新过滤的条件
 */
-(NSArray*) filterTopItemWithCommonFeed:(NSArray*)orginCommonFeedList;
@end

/**
 *实时热门Feed流
 */
@interface UMComFeedRealTimeHotDataController : UMComFeedListDataController

@end

/**
 *热门Feed流
 */
@interface UMComFeedHotDataController : UMComFeedListDataController

@property (nonatomic, assign) NSInteger hotDay;

- (instancetype)initWithCount:(NSInteger)count hotDay:(NSInteger)hotDay;

@end

/**
 *实时feed流
 */
@interface UMComFeedRealTimeDataController : UMComFeedListDataController

@end


/**
 *关注feed流
 */
@interface UMComFeedFocusDataController : UMComFeedListDataController

@end

/**
 *推荐feed流
 */
@interface UMComFeedRecommendDataController : UMComFeedListDataController

@end

/**
 *时间戳feed流
 */
@interface UMComFeedTimeLineDataController : UMComFeedListDataController

@property (nonatomic, assign) UMComTimeLineFeedListType timeLineFeedListType;

@property (nonatomic, copy) NSString *userID;

- (instancetype)initWithCount:(NSInteger)count userID:(NSString *)userID timeLineFeedListType:(UMComTimeLineFeedListType)timeLineFeedListType;

@end

/**
 *话题下最新发布的feed流
 */
@interface UMComFeedTopicFeedDataController : UMComFeedListDataController

@property (nonatomic, copy) NSString *topicId;
/**
 *话题下Feed的排序方式
 */
@property (nonatomic, assign) UMComTopicFeedListSortType topicFeedSortType;

@property (nonatomic, assign) BOOL isReverse;

- (instancetype)initWithCount:(NSInteger)count topicId:(NSString *)topicId topicFeedSortType:(UMComTopicFeedListSortType)topicFeedSortType isReverse:(BOOL)isReverse;

@end

/**
 *话题下热门feed流
 */
@interface UMComFeedTopicHotDataController : UMComFeedListDataController

@property (nonatomic, copy) NSString *topicId;

@property (nonatomic, assign) NSInteger hotDay;

- (instancetype)initWithCount:(NSInteger)count topicId:(NSString *)topicId hotDay:(NSInteger)hotDay;
@end

///**
// *话题下最新评论的feed流
// */
//@interface UMComFeedListOfToicLatesCommentController : UMComFeedListDataController
//
//@property (nonatomic, copy) NSString *topicId;
//
//
//@end


/**
 *话题下推荐feed流
 */
@interface UMComFeedTopicRecommendDataController : UMComFeedListDataController

@property (nonatomic, copy) NSString *topicId;

- (instancetype)initWithCount:(NSInteger)count topicId:(NSString *)topicId;

@end

/**
 *被@的feed流
 */
@interface UMComFeedBeAtDataController : UMComFeedListDataController

@end

/**
 *我的好友圈的feed流
 */
@interface UMComFeedFriendsDataController : UMComFeedListDataController

@end

/**
 *我的收藏的feed流
 */
@interface UMComFeedFavoriteDataController : UMComFeedListDataController

@end

/**
 *附近的feed流
 */
@interface UMComFeedSurroundingDataController : UMComFeedListDataController

@property (nonatomic, strong) CLLocation *locatoion;

- (instancetype)initWithCount:(NSInteger)count location:(CLLocation *)location;

@end

/**
 *搜索的feed流
 */
@interface UMComFeedSearchDataController : UMComFeedListDataController

@property (nonatomic, copy) NSString *keyWord;

- (instancetype)initWithCount:(NSInteger)count keyWord:(NSString *)keyWord;

@end


/**
 *  话题下的feed列表
 */
@interface UMComTopicFeedDataController : UMComFeedListDataController

@property(nonatomic,assign)UMComTopicFeedListSortType sortType;

+ (id)fetchFeedsTopicRelatedWithTopicId:(NSString *)topicId
                               sortType:(UMComTopicFeedListSortType)sortType
                              isReverse:(BOOL)isReverse
                                  count:(NSInteger)count;

@end



/*******************************************************/
/*置顶DataController begin*/
/*******************************************************/

//所有置顶数据的基类
@interface UMComTopFeedListDataController : UMComListDataController

//置顶的数据
@property(nonatomic,strong)NSMutableArray* topDataArray;

@end

/**
 *  全局置顶DataController
 */
@interface UMComGlobalTopFeedListDataController : UMComTopFeedListDataController

@end

/**
 *  话题置顶DataController
 */
@interface UMComTopTopicFeedListDataController : UMComTopFeedListDataController

@property(nonatomic,strong) NSString* topicID;
@end

/*******************************************************/
/*置顶DataController end*/
/*******************************************************/

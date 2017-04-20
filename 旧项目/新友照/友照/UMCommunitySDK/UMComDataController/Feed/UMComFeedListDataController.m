//
//  UMComFeedListDataController.m
//  UMCommunity
//
//  Created by umeng on 16/5/3.
//  Copyright © 2016年 Umeng. All rights reserved.
//

#import "UMComFeedListDataController.h"
#import <UMCommunitySDK/UMComSession.h>
#import <UMComDataStorage/UMComFeed.h>
#import <UMCommunitySDK/UMComDataTypeDefine.h>
#import <UMComDataStorage/UMComDataBasePublicHeader.h>
#import <UMComNetwork/UMComHttpCode.h>
#import "UMComFeedDetailDataController.h"
#import "UMComUserDataController.h"

@interface UMComFeedListDataController ()

@property (nonatomic, strong) UMComFeedDetailDataController *feedDataController;

@property (nonatomic, strong) UMComUserDataController *userDataController;

@end

@implementation UMComFeedListDataController


- (instancetype)init
{
    self = [super init];
    if (self) {
        self.count = UMCom_Limit_Page_Count;
    }
    return self;
}

- (void)deleteFeed:(UMComFeed *)feed completion:(UMComDataRequestCompletion)completion
{
    self.feedDataController = [[UMComFeedDetailDataController alloc] initWithFeed:feed viewExtra:nil];
    [self.feedDataController deletedFeedWithCompletion:^(id responseObject, NSError *error) {
        if (completion) {
            completion(feed, error);
        }
    }];
}

- (void)likeFeed:(UMComFeed *)feed completion:(UMComDataRequestCompletion)completion
{
    self.feedDataController = [[UMComFeedDetailDataController alloc] initWithFeed:feed viewExtra:nil];
    [self.feedDataController likeFeedWithCompletion:^(id responseObject, NSError *error) {
        if (completion) {
            completion(feed, error);
        }
    }];
}

- (void)favouriteFeed:(UMComFeed *)feed completion:(UMComDataRequestCompletion)completion
{
    self.feedDataController = [[UMComFeedDetailDataController alloc] initWithFeed:feed viewExtra:nil];
    [self.feedDataController favoriteFeedWithCompletion:^(id responseObject, NSError *error) {
        if (completion) {
            completion(feed, error);
        }
    }];
}

//
- (void)spamFeed:(UMComFeed *)feed completion:(UMComDataRequestCompletion)completion
{
    self.feedDataController = [[UMComFeedDetailDataController alloc] initWithFeed:feed viewExtra:nil];
    [self.feedDataController spamFeedWithCompletion:^(id responseObject, NSError *error) {
        if (completion) {
            completion(feed, error);
        }
    }];
}

- (void)commentFeed:(UMComFeed *)feed
            content:(NSString *)content
             images:(NSArray *)images
         completion:(UMComDataRequestCompletion)completion
{
    self.feedDataController = [[UMComFeedDetailDataController alloc] initWithFeed:feed viewExtra:nil];
    [self.feedDataController commentFeedWithContent:content images:images completion:^(id responseObject, NSError *error) {
        if (completion) {
            completion(feed, error);
        }
    }];
}


- (void)replyCommentFeed:(UMComFeed *)feed
                 comment:(UMComComment *)comment
                 content:(NSString *)content
                  images:(NSArray *)images
              completion:(UMComDataRequestCompletion)completion
{
    self.feedDataController = [[UMComFeedDetailDataController alloc] initWithFeed:feed viewExtra:nil];
    [self.feedDataController replyCommentFeedWithComment:comment content:content images:images completion:^(id responseObject, NSError *error) {
        if (completion) {
            completion(feed, error);
        }
    }];
}

- (void)shareFeed:(UMComFeed *)feed toPlatform:(NSString *)platform completion:(UMComDataRequestCompletion)completion
{
    self.feedDataController = [[UMComFeedDetailDataController alloc] initWithFeed:feed viewExtra:nil];
    [self.feedDataController shareToPlatform:platform completion:^(id responseObject, NSError *error) {
        if (completion) {
            completion(feed, error);
        }
    }];
}

#define mark - user
- (void)spamUser:(UMComUser *)user completion:(UMComDataRequestCompletion)completion
{
    self.userDataController = [UMComUserDataController userDataControllerWithUser:user];
    [self.userDataController spamUserCompletion:^(id responseObject, NSError *error) {
        if (completion) {
            completion(user, error);
        }
    }];
}

- (void)banUser:(UMComUser *)user
         topics:(NSArray *)topics
     completion:(UMComDataRequestCompletion)completion
{
    self.userDataController = [UMComUserDataController userDataControllerWithUser:user];
    [self.userDataController banUserWithTopics:[topics valueForKeyPath:@"topicID"] completion:^(id responseObject, NSError *error) {
        if (completion) {
            completion(user, error);
        }
    }];
}


#pragma mark -
- (void)fetchDataWithCompletion:(UMComDataListRequestCompletion)localfetchcompletion            serverDataCompletion:(UMComDataListRequestCompletion)serverRequestCompletion
{
    __weak typeof(self) weakSelf = self;
    if (self.isReadLoacalData) {
        [self fetchLocalDataWithCompletion:^(NSArray *responseData, NSError *error) {
            if (localfetchcompletion) {
                localfetchcompletion(responseData, error);
            }
            [weakSelf refreshNewDataCompletion:serverRequestCompletion];
        }];
    }else{
        [self refreshNewDataCompletion:serverRequestCompletion];
        
    }
}


/**
 *  过滤普通流中的置顶数据
 *
 *  @param orginCommonFeedList 从网络取得普通流
 *
 *  @return 返回新的过滤的array(默认返回自身)
 */
-(NSArray*) filterTopItemWithCommonFeed:(NSArray*)orginCommonFeedList;
{
    return orginCommonFeedList;
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
    
    NSMutableArray *dataArray = [NSMutableArray array];
    //设置置顶数据
    if (self.topFeedListDataController && self.topFeedListDataController.topDataArray &&
        self.topFeedListDataController.topDataArray.count > 0) {
        [dataArray addObjectsFromArray:self.topFeedListDataController.topDataArray];
        self.topItemsCount = self.topFeedListDataController.topDataArray.count;
    }
    else
    {
        self.topItemsCount = 0;
    }
    
    NSArray *feedList = [data valueForKey:UMComModelDataKey];
    
    if (self.topFeedListDataController) {
        feedList = [self filterTopItemWithCommonFeed:feedList];
    }
    
    if ([feedList isKindOfClass:[NSArray class]] && feedList.count >0) {
        [dataArray addObjectsFromArray:feedList];
    }
    [self.dataArray addObjectsFromArray:dataArray];
    
    self.nextPageUrl = [data valueForKey:UMComModelDataNextPageUrlKey];
    self.canVisitNextPage = [[data valueForKey:UMComModelDataVisitKey] boolValue];
    if (completion) {
        completion(self.dataArray, error);
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
    
    NSArray *feedList = [data valueForKey:UMComModelDataKey];
    
    if (self.topFeedListDataController) {
        //过滤置顶数据
        feedList = [self filterTopItemWithCommonFeed:feedList];
    }
    
    if ([feedList isKindOfClass:[NSArray class]] && feedList.count >0) {
        [self.dataArray addObjectsFromArray:feedList];
    }
    
    self.nextPageUrl = [data valueForKey:UMComModelDataNextPageUrlKey];
    self.canVisitNextPage = [[data valueForKey:UMComModelDataVisitKey] boolValue];

    if (completion) {
        completion(feedList, error);
    }
}

- (void)refreshNewDataCompletion:(UMComDataListRequestCompletion)completion
{
    
    __weak typeof(self) weakself = self;
    if (self.topFeedListDataController) {
        
        [self.topFeedListDataController refreshNewDataCompletion:^(NSArray *responseData, NSError *error) {
            
            [weakself doRefreshNewDataCompletion:^(NSArray *responseData, NSError *error) {

                //是否存储网络的对象
                if (weakself.isSaveLoacalData && responseData && [responseData isKindOfClass:[NSArray class]]) {
                    [weakself saveLocalDataWithDataArray:responseData];
                }
                
                if (completion) {
                    completion(responseData,error);
                }
            }];
        }];
    }
    else{
        [self doRefreshNewDataCompletion:^(NSArray *responseData, NSError *error) {
            
            //是否存储网络的对象
            if (weakself.isSaveLoacalData && responseData && [responseData isKindOfClass:[NSArray class]]) {
                [weakself saveLocalDataWithDataArray:responseData];
            }
            
            if (completion) {
                completion(responseData,error);
            }

        }];
    }
}


- (void)doRefreshNewDataCompletion:(UMComDataListRequestCompletion)completion
{
    if (completion) {
        completion(nil,nil);
    }
}



@end

@implementation UMComFeedRealTimeHotDataController

- (instancetype)initWithCount:(NSInteger)count
{
    self = [super initWithRequestType:UMComRequestType_RealTimeHotFeed count:count];
    if (self) {
        
    }
    return self;
}

- (void)doRefreshNewDataCompletion:(UMComDataListRequestCompletion)completion
{
    __weak typeof(self) weakSelf = self;
    [[UMComDataRequestManager defaultManager] fetchRealTimeHotFeedsWithCount:self.count completion:^(NSDictionary *responseObject, NSError *error) {
        [weakSelf handleNewData:responseObject error:error completion:completion];
    }];
}

-(void)fetchLocalDataWithCompletion:(UMComDataListRequestCompletion)localfetchcompletion
{
    [super fetchLocalDataWithCompletion:localfetchcompletion];
}

-(void)saveLocalDataWithDataArray:(NSArray*)dataArray
{
    [super saveLocalDataWithDataArray:dataArray];
}

@end

/**
 *热门Feed流
 */
@implementation UMComFeedHotDataController

- (instancetype)initWithCount:(NSInteger)count
{
    self = [super initWithRequestType:UMComRequestType_CommunityHotFeed count:count];
    if (self) {
        
    }
    return self;
}

- (instancetype)initWithCount:(NSInteger)count hotDay:(NSInteger)hotDay
{
    self = [self initWithCount:count];
    if (self) {
        self.hotDay = hotDay;
    }
    return self;
}


- (void)doRefreshNewDataCompletion:(UMComDataListRequestCompletion)completion
{
    __weak typeof(self) weakSelf = self;
    [[UMComDataRequestManager defaultManager] fetchFeedsHotestWithDays:self.hotDay count:self.count completion:^(NSDictionary *responseObject, NSError *error) {
        [weakSelf handleNewData:responseObject error:error completion:completion];
    }];
}

-(void)fetchLocalDataWithCompletion:(UMComDataListRequestCompletion)localfetchcompletion
{
    __weak typeof(self) weakSelf = self;
    [[UMComDataBaseManager shareManager] fetchASyncCommunityHotFeedWithHotDay:self.hotDay withCompleteBlock:^(NSArray* dataArray, NSError * error) {
        [weakSelf handleLocalData:dataArray error:error completion:localfetchcompletion];
    }];
    
}

-(void)saveLocalDataWithDataArray:(NSArray*)dataArray
{

    [[UMComDataBaseManager shareManager] saveCommunityHotFeedWithHotDay:self.hotDay withFeeds:dataArray];
}

@end


/**
 *实时feed流
 */
@implementation UMComFeedRealTimeDataController

- (instancetype)initWithCount:(NSInteger)count
{
    self = [super initWithRequestType:UMComRequestType_RealTimeFeed count:count];
    if (self) {
        
    }
    return self;
}

- (void)doRefreshNewDataCompletion:(UMComDataListRequestCompletion)completion
{
    __weak typeof(self) weakSelf = self;
    [[UMComDataRequestManager defaultManager] fetchFeedsRealTimeWithCount:self.count completion:^(NSDictionary *responseObject, NSError *error) {
        [weakSelf handleNewData:responseObject error:error completion:completion];
    }];
}


-(void)fetchLocalDataWithCompletion:(UMComDataListRequestCompletion)localfetchcompletion
{
    CFAbsoluteTime start = CFAbsoluteTimeGetCurrent();
    [[UMComDataBaseManager shareManager] fetchASyncUMComFeedWithType:g_relatedIDTableTypeFromPageRequestType(self.pageRequestType) withCompleteBlock:^(id feedArray, NSError * error) {
        CFAbsoluteTime end = CFAbsoluteTimeGetCurrent();
        YZLog(@"time fetchLocalDataWithCompletion: %0.3f", end - start);
        if (localfetchcompletion) {
            localfetchcompletion(feedArray,error);
        }
    }];
}

-(void)saveLocalDataWithDataArray:(NSArray*)dataArray
{
    [[UMComDataBaseManager shareManager]  saveRelatedIDTableWithType:g_relatedIDTableTypeFromPageRequestType(self.pageRequestType) withFeeds:dataArray];
}


-(NSArray*) filterTopItemWithCommonFeed:(NSArray*)orginCommonFeedList
{
    
    if (orginCommonFeedList && [orginCommonFeedList isKindOfClass:[NSArray class]] && orginCommonFeedList.count > 0) {
        
        NSMutableArray* filterCommonFeedList =  [NSMutableArray arrayWithCapacity:10];
        
        [orginCommonFeedList enumerateObjectsUsingBlock:^(UMComFeed*  _Nonnull feed, NSUInteger idx, BOOL * _Nonnull stop) {
            
            if (feed && [feed isKindOfClass:[UMComFeed class]]) {
                
                if ([feed.is_top isKindOfClass:[NSNumber class]] && feed.is_top.integerValue == 1) {
                    
                }
                else{
                    [filterCommonFeedList addObject:feed];
                }
            }
            
        }];
        
        return filterCommonFeedList;
    }
    
    return [super filterTopItemWithCommonFeed:orginCommonFeedList];
}

@end


/**
 *关注feed流
 */
@implementation UMComFeedFocusDataController

- (instancetype)initWithCount:(NSInteger)count
{
    self = [super initWithRequestType:UMComRequestType_FocusedFeed count:count];
    if (self) {
        
    }
    return self;
}

- (void)doRefreshNewDataCompletion:(UMComDataListRequestCompletion)completion
{
    __weak typeof(self) weakSelf = self;
    [[UMComDataRequestManager defaultManager] fetchFeedsByFollowWithCount:self.count completion:^(NSDictionary *responseObject, NSError *error) {
        [weakSelf handleNewData:responseObject error:error completion:completion];
    }];
}

@end

/**
 *推荐feed流
 */
@implementation UMComFeedRecommendDataController

- (instancetype)initWithCount:(NSInteger)count
{
    self = [super initWithRequestType:UMComRequestType_RecommendFeed count:count];
    if (self) {
        
    }
    return self;
}

- (void)doRefreshNewDataCompletion:(UMComDataListRequestCompletion)completion
{
    __weak typeof(self) weakSelf = self;
    [[UMComDataRequestManager defaultManager] fetchFeedsRecommentWithCount:self.count completion:^(NSDictionary *responseObject, NSError *error) {
        [weakSelf handleNewData:responseObject error:error completion:completion];
    }];
}

@end

/**
 *时间戳feed流
 */
@implementation UMComFeedTimeLineDataController

- (instancetype)initWithCount:(NSInteger)count
                       userID:(NSString *)userID
         timeLineFeedListType:(UMComTimeLineFeedListType)timeLineFeedListType
{
    self = [super initWithRequestType:UMComRequestType_RealTimeFeed count:count];
    if (self) {
        self.userID = userID;
        self.timeLineFeedListType = timeLineFeedListType;
    }
    return self;
}

- (void)doRefreshNewDataCompletion:(UMComDataListRequestCompletion)completion
{
    __weak typeof(self) weakSelf = self;
    [[UMComDataRequestManager defaultManager] fetchFeedsTimelineWithUid:self.userID sortType:self.timeLineFeedListType count:self.count completion:^(NSDictionary *responseObject, NSError *error) {
        [weakSelf handleNewData:responseObject error:error completion:completion];
    }];
}

-(void)fetchLocalDataWithCompletion:(UMComDataListRequestCompletion)localfetchcompletion
{
    __weak typeof(self) weakSelf = self;
    [[UMComDataBaseManager shareManager] fetchASyncRelatedFeedIDWithUID:self.userID withCompleteBlock:^(NSArray* dataArray, NSError * error) {
        [weakSelf handleLocalData:dataArray error:error completion:localfetchcompletion];
    }];
}

-(void)saveLocalDataWithDataArray:(NSArray*)dataArray
{
    [[UMComDataBaseManager shareManager] saveRelatedFeedIDWithUID:self.userID withFeeds:dataArray];
}

@end

/**
 *话题下最新发布的feed流
 */
@implementation UMComFeedTopicFeedDataController

- (instancetype)initWithCount:(NSInteger)count
{
    self = [super initWithRequestType:UMComRequestType_TopicLatesReleaseFeed count:count];
    if (self) {
        
    }
    return self;
}

- (instancetype)initWithCount:(NSInteger)count topicId:(NSString *)topicId topicFeedSortType:(UMComTopicFeedListSortType)topicFeedSortType
{
    self = [super initWithRequestType:UMComRequestType_TopicLatesReleaseFeed count:count];
    if (self) {
        self.topicId = topicId;
        self.topicFeedSortType = topicFeedSortType;
        self.isReverse = NO;
    }
    return self;
}

- (instancetype)initWithCount:(NSInteger)count topicId:(NSString *)topicId topicFeedSortType:(UMComTopicFeedListSortType)topicFeedSortType isReverse:(BOOL)isReverse
{
    if (self = [super initWithCount:count]) {
        self.topicId = topicId;
        self.topicFeedSortType = topicFeedSortType;
        self.isReverse = isReverse;
    }
    return self;
}


- (void)doRefreshNewDataCompletion:(UMComDataListRequestCompletion)completion
{
    __weak typeof(self) weakSelf = self;
    [[UMComDataRequestManager defaultManager] fetchFeedsTopicRelatedWithTopicId:self.topicId sortType:self.topicFeedSortType isReverse:self.isReverse count:self.count completion:^(NSDictionary *responseObject, NSError *error) {
        [weakSelf handleNewData:responseObject error:error completion:completion];
    }];
}

@end

/**
 *话题下热门feed流
 */
@implementation UMComFeedTopicHotDataController

- (instancetype)initWithCount:(NSInteger)count
{
    self = [super initWithRequestType:UMComRequestType_TopicHottestFeed count:count];
    if (self) {
        
    }
    return self;
}

- (instancetype)initWithCount:(NSInteger)count topicId:(NSString *)topicId hotDay:(NSInteger)hotDay
{
    self = [super initWithRequestType:UMComRequestType_TopicHottestFeed count:count];
    if (self) {
        self.topicId = topicId;
        self.hotDay = hotDay;
    }
    return self;
}

- (void)doRefreshNewDataCompletion:(UMComDataListRequestCompletion)completion
{
    __weak typeof(self) weakSelf = self;
    [[UMComDataRequestManager defaultManager] fetchFeedsTopicHotWithDays:self.hotDay topicId:self.topicId count:self.count completion:^(NSDictionary *responseObject, NSError *error) {
        [weakSelf handleNewData:responseObject error:error completion:completion];
    }];
}

@end

/**
 *话题下推荐feed流
 */
@implementation UMComFeedTopicRecommendDataController

- (instancetype)initWithCount:(NSInteger)count
{
    self = [super initWithRequestType:UMComRequestType_TopicRecommendFeed count:count];
    if (self) {
        
    }
    return self;
}

- (instancetype)initWithCount:(NSInteger)count topicId:(NSString *)topicId
{
    self = [super initWithRequestType:UMComRequestType_TopicRecommendFeed count:count];
    if (self) {
        self.topicId = topicId;
    }
    return self;
}

- (void)doRefreshNewDataCompletion:(UMComDataListRequestCompletion)completion
{
    __weak typeof(self) weakSelf = self;
    [[UMComDataRequestManager defaultManager] fetchFeedsTopicRecommendWithTopicId:self.topicId count:self.count completion:^(NSDictionary *responseObject, NSError *error) {
        [weakSelf handleNewData:responseObject error:error completion:completion];
    }];
}

@end

/**
 *被@的feed流
 */
@implementation UMComFeedBeAtDataController

- (instancetype)initWithCount:(NSInteger)count
{
    self = [super initWithRequestType:UMComRequestType_UserBaAtFeed count:count];
    if (self) {
        
    }
    return self;
}

- (void)doRefreshNewDataCompletion:(UMComDataListRequestCompletion)completion
{
    __weak typeof(self) weakSelf = self;
    [[UMComDataRequestManager defaultManager] fetchFeedsUserBeAtWithCount:self.count completion:^(NSDictionary *responseObject, NSError *error) {
        [weakSelf handleNewData:responseObject error:error completion:completion];
    }];
}

@end

/**
 *我的好友圈的feed流
 */
@implementation UMComFeedFriendsDataController

- (instancetype)initWithCount:(NSInteger)count
{
    self = [super initWithRequestType:UMComRequestType_UserFriendsFeed count:count];
    if (self) {
        
    }
    return self;
}

- (void)doRefreshNewDataCompletion:(UMComDataListRequestCompletion)completion
{
    __weak typeof(self) weakSelf = self;
    [[UMComDataRequestManager defaultManager] fetchFeedsFriendsWithCount:self.count completion:^(NSDictionary *responseObject, NSError *error) {
        [weakSelf handleNewData:responseObject error:error completion:completion];
    }];
}

@end

/**
 *我的收藏的feed流
 */
@implementation UMComFeedFavoriteDataController

- (instancetype)initWithCount:(NSInteger)count
{
    self = [super initWithRequestType:UMComRequestType_UserFavoriteFeed count:count];
    if (self) {
        
    }
    return self;
}

- (void)doRefreshNewDataCompletion:(UMComDataListRequestCompletion)completion
{
    __weak typeof(self) weakSelf = self;
    [[UMComDataRequestManager defaultManager] fetchFeedsUserFavouriteWithCount:self.count completion:^(NSDictionary *responseObject, NSError *error) {
        [weakSelf handleNewData:responseObject error:error completion:completion];
    }];
}

@end

/**
 *附近的feed流
 */
@implementation UMComFeedSurroundingDataController

- (instancetype)initWithCount:(NSInteger)count
{
    self = [super initWithRequestType:UMComRequestType_SurroundingFeed count:count];
    if (self) {
        
    }
    return self;
}

- (instancetype)initWithCount:(NSInteger)count location:(CLLocation *)location
{
    self = [super initWithRequestType:UMComRequestType_SurroundingFeed count:count];
    if (self) {
        self.locatoion = location;
    }
    return self;
}

- (void)doRefreshNewDataCompletion:(UMComDataListRequestCompletion)completion
{
    __weak typeof(self) weakSelf = self;
    [[UMComDataRequestManager defaultManager] fetchFeedsNearbyWithLocation:self.locatoion count:self.count completion:^(NSDictionary *responseObject, NSError *error) {
        [weakSelf handleNewData:responseObject error:error completion:completion];
    }];
}

@end

/**
 *搜索的feed流
 */
@implementation UMComFeedSearchDataController

- (instancetype)initWithCount:(NSInteger)count
{
    self = [super initWithRequestType:UMComRequestType_CoummunitySearchFeed count:count];
    if (self) {
    }
    return self;
}

- (instancetype)initWithCount:(NSInteger)count keyWord:(NSString *)keyWord
{
    self = [super initWithRequestType:UMComRequestType_CoummunitySearchFeed count:count];
    if (self) {
        self.keyWord = keyWord;
    }
    return self;
}

- (void)doRefreshNewDataCompletion:(UMComDataListRequestCompletion)completion
{
    __weak typeof(self) weakSelf = self;
    [[UMComDataRequestManager defaultManager] fetchFeedsSearchWithKeywords:self.keyWord count:self.count completion:^(NSDictionary *responseObject, NSError *error) {
        [weakSelf handleNewData:responseObject error:error completion:completion];
    }];
}

@end


@interface UMComTopicFeedDataController ()

@property(nonatomic,strong)NSString* topicId;

@property(nonatomic,assign)BOOL isReverse;
@property(nonatomic,assign)NSInteger topicFeedcount;
@end

@implementation UMComTopicFeedDataController


- (instancetype)initWithCount:(NSInteger)count
{
    self = [super initWithRequestType:UMComRequestType_RealTimeHotFeed count:count];
    if (self) {
        
    }
    return self;
}

+ (id)fetchFeedsTopicRelatedWithTopicId:(NSString *)topicId
                               sortType:(UMComTopicFeedListSortType)sortType
                              isReverse:(BOOL)isReverse
                                  count:(NSInteger)count
{
    UMComTopicFeedDataController*  topicFeedDataController = [[UMComTopicFeedDataController alloc] initWithRequestType:UMComRequestType_FeedWithTopicID count:count];
    topicFeedDataController.topicId = topicId;
    topicFeedDataController.sortType = sortType;
    topicFeedDataController.isReverse = isReverse;
    return topicFeedDataController;
}


- (void)doRefreshNewDataCompletion:(UMComDataListRequestCompletion)completion
{
    
    __weak typeof(self) weakself  = self;
    [[UMComDataRequestManager defaultManager]  fetchFeedsTopicRelatedWithTopicId:self.topicId sortType:self.sortType isReverse:self.isReverse count:self.count completion:^(NSDictionary *responseObject, NSError *error) {
        [weakself handleNewData:responseObject error:error completion:completion];
    }];
}

-(NSArray*) filterTopItemWithCommonFeed:(NSArray*)orginCommonFeedList
{
    
    if (orginCommonFeedList && [orginCommonFeedList isKindOfClass:[NSArray class]] && orginCommonFeedList.count > 0) {
        
        NSMutableArray* filterCommonFeedList =  [NSMutableArray arrayWithCapacity:10];
        
        [orginCommonFeedList enumerateObjectsUsingBlock:^(UMComFeed*  _Nonnull feed, NSUInteger idx, BOOL * _Nonnull stop) {
            
            if (feed && [feed isKindOfClass:[UMComFeed class]]) {
                
                if ([feed.is_topic_top isKindOfClass:[NSNumber class]] && feed.is_topic_top.integerValue == 1) {
                    
                }
                else
                {
                    [filterCommonFeedList addObject:feed];
                }
            }
        }];
        
        return filterCommonFeedList;
    }
    
    return [super filterTopItemWithCommonFeed:orginCommonFeedList];
}

@end


/*******************************************************/
/*置顶DataController begin*/
/*******************************************************/

@implementation UMComTopFeedListDataController

- (void)handleNewData:(NSDictionary *)data error:(NSError *)error completion:(UMComDataListRequestCompletion)completion
{
    if (!self.topDataArray) {
        self.topDataArray = [NSMutableArray array];
    }
    else{
        [self.topDataArray removeAllObjects];
    }
    
    if (![data isKindOfClass:[NSDictionary class]]) {
        if (completion) {
            completion(nil, error);
        }
        return;
    }
    
    NSArray *feedList = [data valueForKey:UMComModelDataKey];
    if ([feedList isKindOfClass:[NSArray class]] && feedList.count >0) {
        [self.topDataArray addObjectsFromArray:feedList];
    }
    self.nextPageUrl = [data valueForKey:UMComModelDataNextPageUrlKey];
    self.canVisitNextPage = [[data valueForKey:UMComModelDataVisitKey] boolValue];
    self.topItemsCount = self.topDataArray.count;

    if (completion) {
        completion([data valueForKey:UMComModelDataKey], error);
    }
}

@end
/**
 *  全局置顶DataController
 */
@implementation UMComGlobalTopFeedListDataController

- (void)refreshNewDataCompletion:(UMComDataListRequestCompletion)completion
{
    __weak typeof(self) weakself  = self;
    [[UMComDataRequestManager defaultManager] fetchTopFeedWithCount:self.count
                                                     WithCompletion:^(NSDictionary *responseObject, NSError *error) {
        
        [weakself handleNewData:responseObject error:error completion:completion];
    }];
}

@end

/**
 *  话题置顶DataController
 */
@implementation UMComTopTopicFeedListDataController

- (void)refreshNewDataCompletion:(UMComDataListRequestCompletion)completion
{
    __weak typeof(self) weakself  = self;
    [[UMComDataRequestManager defaultManager] fetchTopTopicFeedWithCount:self.count
                                                          topfeedTopicID:self.topicID
                                                          WithCompletion:^(NSDictionary *responseObject, NSError *error) {
            [weakself handleNewData:responseObject error:error completion:completion];
      }];
}

@end

/*******************************************************/
/*置顶DataController end*/
/*******************************************************/

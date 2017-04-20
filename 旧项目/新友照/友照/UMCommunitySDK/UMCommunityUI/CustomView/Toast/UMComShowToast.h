//
//  UMComShowToast.h
//  UMCommunity
//
//  Created by Gavin Ye on 1/21/15.
//  Copyright (c) 2015 Umeng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UMComLoginManager.h"
#import <UMComNetwork/UMComHttpCode.h>

@interface UMComShowToast : NSObject


+ (void)showFetchResultTipWithError:(NSError *)error;

+ (void)createFeedSuccess;

+ (void)showNotInstall;

+ (void)showNoMore;

+ (void)spamSuccess:(NSError *)error;

+ (void)spamComment:(NSError *)error;

+ (void)spamUser:(NSError *)error;

+ (void)commentMoreWord;

+ (void)nameLenghtMoreWord;

+ (void)fetchFailWithNoticeMessage:(NSString *)message;

+ (void)notSupportPlatform;

+ (void)saveIamgeResultNotice:(NSError *)error;

+ (void)favouriteFeedFail:(NSError *)error isFavourite:(BOOL)isFavourite;

+ (void)focuseUserSuccess:(NSError *)error focused:(BOOL)focused;

+ (void)focusTopicFail:(NSError *)error focused:(BOOL)focused;

+ (void)showMessage:(NSString *)message;

#pragma mark - User Account

+ (void)accountEmailNotExist;

+ (void)accountEmailEmpty;

+ (void)accountEmailInvalid;

+ (void)accountEmailDuplicated;

+ (void)accountPasswordEmpty;

+ (void)accountPasswordWrong;

+ (void)accountPasswordInvalid;

+ (void)accountNicknameEmpty;

+ (void)accountNicknameInvalid;

+ (void)accountNicknameDuplicated;

+ (void)accountRegisterSuccess;

+ (void)accountLoginSuccess;

+ (void)accountFindPasswordSuccess;

+ (void)accountModifyProfileSuccess;

//+ (void)loginFail:(NSError *)error;

//+ (void)createCommentFail:(NSError *)error;

//+ (void)createFeedFail:(NSError *)error;

//+ (void)fetchFeedFail:(NSError *)error;

//+ (void)createLikeFail:(NSError *)error;

//+ (void)deleteLikeFail:(NSError *)error;

//+ (void)fetchMoreFeedFail:(NSError *)error;



//+ (void)fetchTopcsFail:(NSError *)error;

//+ (void)fetchLocationsFail:(NSError *)error;

//+ (void)fetchFriendsFail:(NSError *)error;


//+ (void)focusUserFail:(NSError *)error;

//+ (void)fetchRecommendUserFail:(NSError *)error;

//+ (void)fetchUserFail:(NSError *)error;

//+ (void)deletedFail:(NSError *)error;


#pragma mark - feed like

+ (void)like:(NSError *)error liked:(BOOL)liked;
+(void) likeFeedSuccess;
+(void) unlikeFeedSuccess;

#pragma mark - reply feed
+(void) replyFeedSuccess;

#pragma mark - reply Comment
+(void) replyCommentSuccess;

#pragma mark - delete comment
+(void) deleteCommentSuccess;

#pragma mark - copy succeed
+(void) copySuccess;

#pragma mark - delete feed succeed
+(void) deleteFeedSuccess;
@end

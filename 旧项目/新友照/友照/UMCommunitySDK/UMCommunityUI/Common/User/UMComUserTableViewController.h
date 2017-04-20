//
//  UMComUserTableViewController.h
//  UMCommunity
//
//  Created by wyq.Cloudayc on 3/22/16.
//  Copyright © 2016 Umeng. All rights reserved.
//

#import "UMComRequestTableViewController.h"

@class UMComUser, UMComUserTableViewController;

@protocol UMComUserOperationFinishDelegate;

typedef NS_ENUM(NSUInteger, UMComUserTableViewCallBackEvent) {
    UMComUserTableViewCallBackEventUser = 0
};
typedef void(^UMComUserTableViewCallBackBlock)(UMComUserTableViewController *controller, UMComUserTableViewCallBackEvent event, UMComUser *user);

@interface UMComUserTableViewController : UMComRequestTableViewController

@property (nonatomic, strong) NSArray *userList;

@property (nonatomic, assign) BOOL showDistance;

@property (nonatomic, assign) id<UMComUserOperationFinishDelegate> userOperationFinishDelegate;

//但第一次登录时会进入推荐用户页面， 推荐用户页面点击完成操作时会调用这个block
@property (nonatomic, copy) void (^completion)(UIViewController *viewController);

@property (nonatomic, copy) UMComUserTableViewCallBackBlock callbackBlock;

- (id)initWithCompletion:(void (^)(UIViewController *viewController))completion;

- (void)insertUserToTableView:(UMComUser *)user;

- (void)deleteUserFromTableView:(UMComUser *)user;

@end





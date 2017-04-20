//
//  UMComFavouratesViewController.m
//  UMCommunity
//
//  Created by Gavin Ye on 8/12/15.
//  Copyright (c) 2015 Umeng. All rights reserved.
//

#import "UMComFavouratesViewController.h"
#import <UMComDataStorage/UMComFeed.h>
#import "UMComLoginManager.h"
#import "UMComShowToast.h"
#import "UMComFeedListDataController.h"

@interface UMComFavouratesViewController ()

@end

@implementation UMComFavouratesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UMComClickActionDelegate

- (void)customObj:(id)obj clickOnFavouratesFeed:(UMComFeed *)feed
{
    BOOL isFavourite = ![[feed has_collected] boolValue];
    __weak typeof(self) weakSelf = self;
    [UMComLoginManager performLogin:self completion:^(id responseObject, NSError *error) {
        if (!error) {
            [(UMComFeedFavoriteDataController *)self.dataController favouriteFeed:feed completion:^(id responseObject, NSError *error) {
                if ([feed.has_collected intValue] == 1) {
                    [weakSelf insertFeedStyleToDataArrayWithFeed:feed];
                }else{
                    [weakSelf deleteFeedFromList:feed];
                }
                [UMComShowToast favouriteFeedFail:error isFavourite:isFavourite];
            }];
        }
    }];
}


#pragma mark - notification 

@end

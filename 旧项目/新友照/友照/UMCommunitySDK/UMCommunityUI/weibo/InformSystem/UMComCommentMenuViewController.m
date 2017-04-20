//
//  UMComCommentMenuViewController.m
//  UMCommunity
//
//  Created by umeng on 15/12/23.
//  Copyright © 2015年 Umeng. All rights reserved.
//

#import "UMComCommentMenuViewController.h"
#import "UMComHorizonCollectionView.h"
#import "UMComCommentTableViewController.h"
#import <UMCommunitySDK/UMComSession.h>
#import <UMComDataStorage/UMComUnReadNoticeModel.h>
#import "UIViewController+UMComAddition.h"
#import "UMComCommentListDataController.h"
#import <UMComFoundation/UMComKit+Color.h>

@interface UMComCommentMenuViewController ()<UMComHorizonCollectionViewDelegate>

@property (nonatomic, strong) UMComHorizonCollectionView *menuView;

@end

@implementation UMComCommentMenuViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self setForumUITitle:UMComLocalizedString(@"um_com_comment", @"评论")];
    self.view.backgroundColor = UMComTableViewSeparatorColor;
    
    [self createSubControllers];
    
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    if (!self.menuView) {
        UMComHorizonCollectionView *menuView = [[UMComHorizonCollectionView alloc]initWithFrame:CGRectMake(0, 2, self.view.frame.size.width, 49) itemCount:2];
        menuView.cellDelegate = self;
        menuView.itemSpace = 0;
        menuView.indicatorLineHeight = 3;
        menuView.scrollIndicatorView.backgroundColor = UMComColorWithHexString(@"#008BEA");
        menuView.indicatorLineWidth = UMComWidthScaleBetweenCurentScreenAndiPhone6Screen(74);
        menuView.indicatorLineLeftEdge = UMComWidthScaleBetweenCurentScreenAndiPhone6Screen(56);
        [self.view addSubview:menuView];
        self.menuView = menuView;
        [self.view bringSubviewToFront:self.menuView];
    }
}

#pragma mark - UMComHorizonCollectionViewDelegate
- (void)horizonCollectionView:(UMComHorizonCollectionView *)collectionView reloadCell:(UMComHorizonCollectionCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        cell.label.text = UMComLocalizedString(@"um_com_receiveComment", @"收到的评论");
    }else{
        cell.label.text = UMComLocalizedString(@"um_com_sendComment", @"发出的评论");
    }
    if (indexPath.row == collectionView.currentIndex) {
        cell.label.textColor = UMComColorWithHexString(@"#008BEA");
    }else{
        cell.label.textColor = UMComColorWithHexString(@"#999999");
    }
}

- (void)horizonCollectionView:(UMComHorizonCollectionView *)collectionView didSelectedColumn:(NSInteger)column
{
    [self transitionFromIndex:collectionView.lastIndex toIndex:column];
}

- (void)createSubControllers
{
    CGRect commonFrame = self.view.frame;
    commonFrame.origin.y = 52;
    commonFrame.size.height = commonFrame.size.height - commonFrame.origin.y;
//    CGFloat centerY = commonFrame.size.height/2+commonFrame.origin.y;
    UMComCommentTableViewController *hotPostListController = [[UMComCommentTableViewController alloc] init];
    
    UMComUserReceivedCommentListDataController*  receivedCommentListDataController = [[UMComUserReceivedCommentListDataController alloc] initWithCount:UMCom_Limit_Page_Count];
    hotPostListController.dataController = receivedCommentListDataController;
    hotPostListController.dataController.isReadLoacalData = YES;
    hotPostListController.dataController.isSaveLoacalData = YES;
    [self addChildViewController:hotPostListController];
    [self.view addSubview:hotPostListController.view];
    hotPostListController.view.frame = commonFrame;

     UMComCommentTableViewController *recommendPostListController = [[UMComCommentTableViewController alloc] init];
    UMComUserSentCommentListDataController* sentCommentListDataController = [[UMComUserSentCommentListDataController alloc] initWithCount:UMCom_Limit_Page_Count];
    recommendPostListController.dataController = sentCommentListDataController;
    recommendPostListController.dataController.isReadLoacalData = YES;
    recommendPostListController.dataController.isSaveLoacalData = YES;
    [self addChildViewController:recommendPostListController];
    recommendPostListController.view.frame = commonFrame;
    [self transitionFromIndex:0 toIndex:0];
}

- (void)transitionFromIndex:(NSInteger)fromIndex toIndex:(NSInteger)toIndex
{
    UMComRequestTableViewController *requestTableVc = self.childViewControllers[toIndex];
    if (requestTableVc.dataController.dataArray.count == 0 && requestTableVc.isLoadFinish) {
        requestTableVc.refreshSeverDataCompletionHandler = ^(NSArray *data, NSError *error){
            if (toIndex == 0) {
                [UMComSession sharedInstance].unReadNoticeModel.notiByCommentCount = 0;
            }
        };
    }
    [self transitionFromViewControllerAtIndex:fromIndex toViewControllerAtIndex:toIndex animations:nil completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 重置childViewController的Rect

-(void) resetFrameForChildViewControllers
{
    NSArray *childViewControllers = self.childViewControllers;
    if (childViewControllers && childViewControllers.count > 0) {
        CGRect viewFrame =  self.view.frame;
        for (int i = 0; i < childViewControllers.count > 0; i++) {
            UIViewController*  childViewController = self.childViewControllers[i];
            if (childViewController) {
                CGRect childViewControllerRC =  childViewController.view.frame;
                childViewControllerRC.size.height = viewFrame.size.height - self.menuView.frame.size.height;
                childViewController.view.frame = childViewControllerRC;
            }
        }
    }
}


- (void)viewDidAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self resetFrameForChildViewControllers];
}

@end

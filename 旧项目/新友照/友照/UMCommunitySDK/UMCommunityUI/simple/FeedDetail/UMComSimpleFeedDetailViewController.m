//
//  UMComSimpleFeedDetailViewController.m
//  UMCommunity
//
//  Created by umeng on 16/5/17.
//  Copyright © 2016年 Umeng. All rights reserved.
//

#import "UMComSimpleFeedDetailViewController.h"
#import <UMComDataStorage/UMComComment.h>
#import "UMComFeedDetailCommentCell.h"
#import "UMComCommentListDataController.h"
#import "UMComFeedDetailTableViewCell.h"
#import "UIViewController+UMComAddition.h"
#import "UMComNavigationController.h"
#import <UMCommunitySDK/UMComSession.h>
#import "UMComLoginManager.h"
#import "UMComiToast.h"
#import <UMComDataStorage/UMComFeed.h>
#import <UMComDataStorage/UMComUser.h>
#import "UMComResouceDefines.h"
#import "UMComSimpleCommentEditView.h"
#import "UMComFeedDetailDataController.h"
#import "UMComSimplicityUserCenterViewController.h"
#import "UMComShowToast.h"
#import <UMCommunitySDK/UMComDataTypeDefine.h>
#import "UMComSimpleTopicFeedTableViewController.h"
#import "UMComLargeImageTableViewCell.h"
#import "UMComImageView.h"
#import <UMComDataStorage/UMComImageUrl.h>
#import "UMComLikeButtonTableViewCell.h"
#import "UMComWebViewController.h"
#import <UMComFoundation/UMComKit+Color.h>
#import "UMComNotificationMacro.h"
#import "UMComRefreshView.h"


static NSString *kUMComFeedCommentCellIdentifier = @"UMComFeedDetailCommentCell";
static NSString *kUMComFeedContentDetailCellIdentifier = @"UMComFeedDetailTableViewCell";
static NSString *kUMComFeedLargeImageCellIdentifier = @"UMComLargeImageTableViewCell";
static NSString *kUMComFeedLikeButtonCellIdentifier = @"UMComLikeButtonTableViewCell";


@interface UMComSimpleFeedDetailViewController ()<UMComFeedClickActionDelegate,UMComClickCommentActionDelegate,UIActionSheetDelegate>
{
    UMComFeed* _feed;
}

@property (nonatomic, strong) NSString *wakedCommentID;

@property (nonatomic, strong) NSMutableDictionary *commentHeightInfo;

@property (nonatomic, strong) NSMutableDictionary *imageSizeInfo;


@property (nonatomic, strong) UMComFeedDetailTableViewCell *cachedFeedBodyCell;

@property (nonatomic, strong) UMComFeedDetailCommentCell *commentBaseCell;

@property (nonatomic, strong) UIButton *favNavButton;

@property (nonatomic, strong) NSDictionary *viewExtra;

@property (strong, nonatomic) UMComSimpleCommentEditView *commentEditView;

@property (nonatomic, assign) CGFloat feedCellHeight;

@property (nonatomic, strong) UMComFeedDetailDataController *feedDetailDataController;


- (void)resetLikeButtomImage:(UIButton *)likeButton;
- (void)resetFavoriteButtomImage:(UIButton *)favoriteButton;

@property (nonatomic,strong)UIImage* placeHolderImageForIMGCell;//默认占位图片
@property (nonatomic,assign)CGFloat placeHolderImageHeight;//默认占位图片的高度

@end



@implementation UMComSimpleFeedDetailViewController

- (instancetype)initWithFeed:(UMComFeed *)feed
{
    self = [self init];
    if (self) {
        [self creatFeedDetailDataControllerWithFeed:feed];
        [self creatCommentListDataControllerWithFeed:feed];
    }
    return self;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.hidesBottomBarWhenPushed = YES;
        self.placeHolderImageForIMGCell = UMComSimpleImageWithImageName(@"um_com_defaultAvatar");
        
        [self createTopBarItems];
        self.commentHeightInfo = [NSMutableDictionary dictionary];
        self.imageSizeInfo = [NSMutableDictionary dictionary];
    }
    return self;
}


- (void)viewDidLoad {
    
    self.isAutoStartLoadData = NO;//基类不会自动发请求
    [super viewDidLoad];
    
    self.tableView.rowHeight = 100;
    UIEdgeInsets inset = self.tableView.contentInset;
    inset.bottom = inset.bottom + 50;
    self.refreshHeadView.scrollViewOriginalInset = inset;
    self.refreshFootView.scrollViewOriginalInset = inset;
    self.tableView.contentInset = inset;
    self.tableView.backgroundColor = [UIColor whiteColor];
    [self setForumUITitle:@"正文详情"];
    
    [self createTopBarItems];
    [self createBottomBar];
    UINib *commentCellNib = [UINib nibWithNibName:@"UMComFeedDetailCommentCell" bundle:nil];
    [self.tableView registerNib:commentCellNib forCellReuseIdentifier:kUMComFeedCommentCellIdentifier];
    
    
    UINib *feedCellNib = [UINib nibWithNibName:@"UMComFeedDetailTableViewCell" bundle:nil];
    [self.tableView registerNib:feedCellNib forCellReuseIdentifier:kUMComFeedContentDetailCellIdentifier];
    
    
    UINib *imageCellNib = [UINib nibWithNibName:@"UMComLargeImageTableViewCell" bundle:nil];
    [self.tableView registerNib:imageCellNib forCellReuseIdentifier:kUMComFeedLargeImageCellIdentifier];
    
    UINib *likeCellNib = [UINib nibWithNibName:@"UMComLikeButtonTableViewCell" bundle:nil];
    [self.tableView registerNib:likeCellNib forCellReuseIdentifier:kUMComFeedLikeButtonCellIdentifier];
    
    NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"UMComFeedDetailCommentCell" owner:self options:nil];
    _commentBaseCell = [array objectAtIndex:0];
    
    self.doNotShowNodataNote = YES;
    
    [self refreshData];
}

- (void)setFeed:(UMComFeed *)feed
{
    _feed = feed;
    [self creatFeedDetailDataControllerWithFeed:feed];
    [self creatCommentListDataControllerWithFeed:feed];
}

-(UMComFeed*) feed
{
    return _feed;
}

- (void)creatFeedDetailDataControllerWithFeed:(UMComFeed *)feed
{
    if (!self.feedDetailDataController) {
        self.feedDetailDataController = [[UMComFeedDetailDataController alloc] init];
    }
    self.feedDetailDataController.feed = feed;
}

- (void)creatCommentListDataControllerWithFeed:(UMComFeed *)feed
{
    if (!self.dataController) {
        UMComFeedCommnetListDataController *feedCommentDataController = [[UMComFeedCommnetListDataController alloc] initWithCount:UMCom_Limit_Page_Count feedId:self.feed.feedID commentUserId:nil order:UMComCommentSortType_Default];
        self.dataController = feedCommentDataController;
        //[self refreshData];
    }else{
        UMComFeedCommnetListDataController *feedCommentDataController = (UMComFeedCommnetListDataController *)self.dataController;
        feedCommentDataController.feedId = feed.feedID;
    }
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if (self.autoShowCommentEditView) {
        self.autoShowCommentEditView = NO;
        [self.commentEditView presentEditView];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self createBottomBar];
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self.commentEditView removeAllEditView];
    
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)goBack
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UI
- (void)createTopBarItems
{
    
    UIButton *menuItemButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [menuItemButton addTarget:self action:@selector(clickOnMoreButton:) forControlEvents:UIControlEventTouchUpInside];
    menuItemButton.frame = CGRectMake(0.f, 0.f, 20.f, 20.f);
    UIImage *image = [UIImage imageNamed:@"下箭头"];
    [menuItemButton setImage:image forState:UIControlStateNormal];
    menuItemButton.tintColor = [UIColor whiteColor];
    UIBarButtonItem *menuItem = [[UIBarButtonItem alloc] initWithCustomView:menuItemButton];
    
    UIBarButtonItem *spaceItem = [[UIBarButtonItem alloc]init];
    UIView *spaceView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 8, 20)];
    spaceView.backgroundColor = [UIColor clearColor];
    [spaceItem setCustomView:spaceView];
    
    NSArray<UIBarButtonItem *> *items = [NSArray arrayWithObjects:menuItem, spaceItem, nil];
    [self.navigationItem setRightBarButtonItems:items];
}


- (void)createBottomBar
{
    if (!self.commentEditView) {
        __weak typeof(self) weakSelf = self;
        UMComSimpleCommentEditView *commentEditView = [[UMComSimpleCommentEditView alloc] initWithSuperView:[UIApplication sharedApplication].keyWindow];
        commentEditView.clickOnLikeButtonBlock = ^(UIButton *likeButton){
            [weakSelf clickOnLikeButton:likeButton];
        };
        commentEditView.clickOnFavoriteButtonBlock = ^(UIButton *favoriteButton){
            [weakSelf clickOnFavoriteButton:favoriteButton];
        };
        commentEditView.SendCommentHandler = ^(NSString *conttent){
            [weakSelf sendCommentWithContent:conttent];
        };
        
        [self resetFavoriteButtomImage:commentEditView.favoriteButton];
        
        [self resetLikeButtomImage:commentEditView.likeButton];
        self.commentEditView = commentEditView;
    }
    
    [self.commentEditView addAllEditView];
}

- (void)resetLikeButtomImage:(UIButton *)likeButton
{
    UMComFeed *feed = self.feedDetailDataController.feed;
    if ([feed.liked boolValue]) {
        [likeButton setImage:UMComSimpleImageWithImageName(@"um_like_circle_highlight") forState:UIControlStateNormal];
    }else{
        [likeButton setImage:UMComSimpleImageWithImageName(@"um_like_circle_nomal") forState:UIControlStateNormal];
    }
}

- (void)resetFavoriteButtomImage:(UIButton *)favoriteButton
{
    UMComFeed *feed = self.feedDetailDataController.feed;
    UIImage *buttonImage = nil;
    if ([feed.has_collected boolValue]) {
        buttonImage = UMComSimpleImageWithImageName(@"um_favorite_circle_highlight");
    }else{
        buttonImage = UMComSimpleImageWithImageName(@"um_favorite_circle_nomal");
    }
    [favoriteButton setImage:buttonImage forState:UIControlStateNormal];
}

- (void)handleDataWhenCommentSucceedWithComment:(UMComComment *)comment
{
    if ([comment isKindOfClass:[UMComComment class]]) {
        [self.dataController.dataArray insertObject:comment atIndex:0];
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:3];
        [self.tableView beginUpdates];
        [self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        [self.tableView endUpdates];
        [self.tableView reloadData];
    }
    
    UMComFeed *feed = self.feedDetailDataController.feed;
    if (self.feedOperationDelegate && [self.feedOperationDelegate respondsToSelector:@selector(feedCommentSendSucceedWithComment:feed:)]) {
        [self.feedOperationDelegate feedCommentSendSucceedWithComment:comment feed:feed];
    }
}

#pragma mark - data request

- (void)refreshData
{
    [self refreshCurrentFeed];
    [super refreshData];
}

- (void)refreshCurrentFeed
{
    __weak typeof(self) weakSelf = self;

    [self.feedDetailDataController refreshFeedWithCompletion:^(id responseObject, NSError *error) {
        weakSelf.feedCellHeight = 0;
        if ([responseObject isKindOfClass:[UMComFeed class]]) {
            weakSelf.feedDetailDataController.feed = responseObject;
            [weakSelf reloadFeed];
        }else{
            YZLog(@"error is %@", error);
            [UMComShowToast showFetchResultTipWithError:error];
            if (error && error.code == ERR_CODE_FEED_UNAVAILABLE) {

                //如果刷新的feed已经删除，就直接通知其他界面kUMComFeedDeletedFinishNotification并返回到上一个界面
                [[NSNotificationCenter defaultCenter] postNotificationName:kUMComFeedDeletedFinishNotification object:weakSelf.feedDetailDataController.feed];
                //在此做一个1秒的延迟来保证一个新的runloop刷新，安全退出，不然会出现崩溃
                //http://www.cnblogs.com/tiechui/archive/2013/05/10/3071499.html
                //http://stackoverflow.com/questions/5301014/ios-popviewcontroller-unexpected-behavior
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [weakSelf.navigationController popViewControllerAnimated:YES];
                });
                return;
            }
        }
    

    }];
}

#pragma mark - Feed Actions

- (void)clickOnLikeButton:(UIButton *)likeButton
{
    __weak typeof(self) weakSelf = self;
    [UMComLoginManager performLogin:self completion:^(id responseObject, NSError *error) {
        if (!error) {
            [weakSelf.feedDetailDataController likeFeedWithCompletion:^(id responseObject, NSError *error) {
                UMComFeed *feed = weakSelf.feedDetailDataController.feed;
                
                [weakSelf handleDataWhenLikeStatusChangeWithFeed:feed error:error];
            }];
        }
    }];

}

- (void)clickOnFavoriteButton:(UIButton *)favoriteButton
{
    __weak typeof(self) weakSelf = self;
    
    [UMComLoginManager performLogin:self completion:^(id responseObject, NSError *error) {
        if (!error) {
            [weakSelf.feedDetailDataController favoriteFeedWithCompletion:^(id responseObject, NSError *error) {
                if (error) {
                    [UMComShowToast showFetchResultTipWithError:error];
                }else{
                    [weakSelf resetFavoriteButtomImage:favoriteButton];
                    if (weakSelf.feedOperationDelegate && [weakSelf.feedOperationDelegate respondsToSelector:@selector(feedFavourateStatusChangeWithFeed:)]){
                        [weakSelf.feedOperationDelegate feedFavourateStatusChangeWithFeed:weakSelf.feedDetailDataController.feed];
                    }
                    
                    //取修改后的feed的has_collected的字段来确定提示语
                    BOOL isFavoriteAfter = [weakSelf.feedDetailDataController.feed.has_collected boolValue];
                    [UMComShowToast favouriteFeedFail:nil isFavourite:isFavoriteAfter];
                }
            }];
        }
    }];
}

- (void)sendCommentWithContent:(NSString *)content
{
    __weak typeof(self) weakSelf = self;
    [UMComLoginManager performLogin:self completion:^(id responseObject, NSError *error) {
        if (weakSelf.commentEditView.isReply == YES) {
            [weakSelf.feedDetailDataController replyCommentFeedWithComment:weakSelf.feedDetailDataController.currentComment content:content images:nil completion:^(id responseObject, NSError *error) {
                if (error) {
                    [UMComShowToast showFetchResultTipWithError:error];
                    return;
                }else{
                    
                    [UMComShowToast replyCommentSuccess];
                    [weakSelf handleDataWhenCommentSucceedWithComment:responseObject];
                    weakSelf.commentEditView.commentTextField.text = @"";
                    weakSelf.commentEditView.isReply = NO;
                }
            }];
        }else{
            [weakSelf.feedDetailDataController commentFeedWithContent:content images:nil completion:^(id responseObject, NSError *error) {
                if (error) {
                    [UMComShowToast showFetchResultTipWithError:error];
                    return;
                }else{
                    [UMComShowToast replyFeedSuccess];
                    [weakSelf handleDataWhenCommentSucceedWithComment:responseObject];
                    weakSelf.commentEditView.commentTextField.text = @"";
                }
            }];
        }
    }];
}

- (void)clickOnMoreButton:(id)sender {
    
    NSMutableArray *itemTitles = [NSMutableArray array];
    NSString *title = @"";
    if ([[UMComSession sharedInstance] isPermissionDeleteFeed:self.feedDetailDataController.feed]) {
        title = UMComLocalizedString(@"deleted", @"删除");
        [itemTitles addObject:title];
        if (![self.feedDetailDataController.feed.creator.uid isEqualToString:[UMComSession sharedInstance].uid]) {
            title = UMComLocalizedString(@"spam_user", @"举报用户");
            [itemTitles addObject:title];
            title = UMComLocalizedString(@"copy_feed", @"复制");
            [itemTitles addObject:title];
        }
        //不管有没有权限，都显示复制菜单
        else{
            title = UMComLocalizedString(@"copy_feed", @"复制");
            [itemTitles addObject:title];
        }
    }else{
        title = UMComLocalizedString(@"spam_user", @"举报用户");
        [itemTitles addObject:title];
        title = UMComLocalizedString(@"spam_feed", @"举报内容");
        [itemTitles addObject:title];
        title = UMComLocalizedString(@"copy_feed", @"复制");
        [itemTitles addObject:title];
    }
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:nil];
    for (NSString *title in itemTitles) {
        [actionSheet addButtonWithTitle:title];
    }
    [actionSheet showInView:self.view];
}


- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString *title = [actionSheet buttonTitleAtIndex:buttonIndex];
    
    if ([title isEqualToString:UMComLocalizedString(@"deleted", @"删除")]) {
        [self deleteFeed];
    }else if ([title isEqualToString:UMComLocalizedString(@"spam_user", @"举报用户")]){
        [self spamFeedCreator];
    }else if ([title isEqualToString:UMComLocalizedString(@"spam_feed", @"举报内容")]){
        [self spamFeedFeed];
    }else if ([title isEqualToString:UMComLocalizedString(@"copy_feed", @"复制")]){
        [self copyFeed];
    }
}

- (void)spamFeedCreator
{
    __weak typeof(self) weakSelf = self;
    [UMComLoginManager performLogin:self completion:^(id responseObject, NSError *error) {
        if (!error) {
            [weakSelf.feedDetailDataController spamUser:self.feed.creator completion:^(id responseObject, NSError *error) {
                [UMComShowToast spamUser:error];
            }];
        }
    }];
}


- (void)deleteFeed
{
    __weak typeof(self) weakSelf = self;
    [UMComLoginManager performLogin:self completion:^(id responseObject, NSError *error) {
        if (!error) {
            [weakSelf.feedDetailDataController deletedFeedWithCompletion:^(id responseObject, NSError *error) {
                if (error) {
                    [UMComShowToast showFetchResultTipWithError:error];
                    return;
                }else{
                    [UMComShowToast deleteFeedSuccess];
//                    if (weakSelf.feedOperationDelegate && [weakSelf.feedOperationDelegate respondsToSelector:@selector(feedDeletedWithFeed:)]) {
//                        [weakSelf.feedOperationDelegate feedDeletedWithFeed:weakSelf.feedDetailDataController.feed];
//                    }
                    [[NSNotificationCenter defaultCenter] postNotificationName:kUMComFeedDeletedFinishNotification object:weakSelf.feedDetailDataController.feed];
                    [weakSelf goBack];
                }
            }];
        }
    }];
}


- (void)spamFeedFeed
{
    __weak typeof(self) weakSelf = self;
    [UMComLoginManager performLogin:self completion:^(id responseObject, NSError *error) {
        if (!error) {
            [weakSelf.feedDetailDataController spamFeedWithCompletion:^(id responseObject, NSError *error) {
                [UMComShowToast spamSuccess:error];
            }];
        }
    }];
}

- (void)copyFeed
{
    UMComFeed *feed = self.feedDetailDataController.feed;
    NSMutableArray *strings = [NSMutableArray arrayWithCapacity:1];
    NSMutableString *string = [[NSMutableString alloc]init];
    if (feed.text) {
        [strings addObject:feed.text];
        [string appendString:feed.text];
    }
    if (feed.origin_feed.text) {
        [strings addObject:feed.origin_feed.text];
        [string appendString:feed.origin_feed.text];
    }
    UIPasteboard *pboard = [UIPasteboard generalPasteboard];
    pboard.strings = strings;
    pboard.string = string;
    
    [UMComShowToast copySuccess];
}
#pragma mark -Feed Action Delegate

- (void)customObj:(id)obj clickOnFeedCreator:(UMComUser *)user
{
    UMComSimplicityUserCenterViewController *userCenterVc = [[UMComSimplicityUserCenterViewController alloc] initWithNibName:@"UMComSimplicityUserCenterViewController" bundle:nil];
    userCenterVc.user = user;
    [self.navigationController pushViewController:userCenterVc animated:YES];
}

- (void)customObj:(UMComFeedDetailTableViewCell *)obj clickOnLikeFeed:(UMComFeed *)feed
{
    __weak typeof(self) weakSelf = self;
    [UMComLoginManager performLogin:self completion:^(id responseObject, NSError *error) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        [strongSelf.feedDetailDataController likeFeedWithCompletion:^(id responseObject, NSError *error) {
            [strongSelf handleDataWhenLikeStatusChangeWithFeed:weakSelf.feedDetailDataController.feed error:error];
        }];
    }];
}

- (void)customObj:(id)obj clickOnTopic:(UMComTopic *)topic
{
    UMComSimpleTopicFeedTableViewController *topicFeedVc = [[UMComSimpleTopicFeedTableViewController alloc] init];
    topicFeedVc.topic = topic;
    [self.navigationController pushViewController:topicFeedVc animated:YES];
}

-(void) refreshLikeButton:(UMComFeed *)feed error:(NSError *)error
{
    if (!error ||
        error.code == ERR_CODE_LIKE_HAS_BEEN_CANCELED ||
        error.code == ERR_CODE_FEED_HAS_BEEN_LIKED ) {
        
        if ([feed.liked boolValue]) {
            [self.commentEditView.likeButton setImage:UMComSimpleImageWithImageName(@"um_like_circle_highlight") forState:UIControlStateNormal];
        }else{
            [self.commentEditView.likeButton setImage:UMComSimpleImageWithImageName(@"um_like_circle_nomal") forState:UIControlStateNormal];
        }
        
        [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:0 inSection:2]] withRowAnimation:UITableViewRowAnimationNone];
        //回调到feed列表刷新点赞数据
        if (self.feedOperationDelegate && [self.feedOperationDelegate respondsToSelector:@selector(feedLikeStatusChangeWithFeed:)]) {
            [self.feedOperationDelegate feedLikeStatusChangeWithFeed:feed];
        }
    }
}

- (void)handleDataWhenLikeStatusChangeWithFeed:(UMComFeed *)feed error:(NSError *)error
{
    if (error) {
        [self refreshLikeButton:feed error:error];
        [UMComShowToast showFetchResultTipWithError:error];
        return;
    }
    
    [self refreshLikeButton:feed error:error];

    if ([feed.liked boolValue]) {
        [UMComShowToast likeFeedSuccess];
    }else{
        [UMComShowToast unlikeFeedSuccess];
    }
}

#pragma mark -UMCommment Action Delegate

- (void)customObj:(id)obj clickOnURL:(NSString *)urlSring
{
    UMComWebViewController *webViewController = [[UMComWebViewController alloc] initWithUrl:urlSring];
    [self.navigationController pushViewController:webViewController animated:YES];
}


//调用父类实现的代理方法
- (void)customObj:(id)obj clickOnCommentUser:(UMComUser *)user
{
    UMComSimplicityUserCenterViewController *userCenter = [[UMComSimplicityUserCenterViewController alloc] init];
    userCenter.user = user;
    [self.navigationController pushViewController:userCenter animated:YES];
}

- (void)customObj:(id)obj clickOnSpamUser:(UMComUser *)user
{
    __weak typeof(self) weakSelf = self;
    [UMComLoginManager performLogin:self completion:^(id responseObject, NSError *error) {
        [weakSelf.feedDetailDataController spamUser:user completion:^(id responseObject, NSError *error) {
            [UMComShowToast spamUser:error];
        }];
    }];
}

- (void)customObj:(id)obj clickOnDeleteComment:(UMComComment *)comment
{
    __weak typeof(self) weakSelf = self;
    UMComFeedCommnetListDataController *commentListDataController = (UMComFeedCommnetListDataController *)self.dataController;
    [UMComLoginManager performLogin:self completion:^(id responseObject, NSError *error) {
        [commentListDataController deletedComment:comment completion:^(NSError *error) {
            if (error) {
                [UMComShowToast showFetchResultTipWithError:error];
            }else{
                [UMComShowToast deleteCommentSuccess];
                [weakSelf.tableView reloadData];
                if (weakSelf.feedOperationDelegate && [weakSelf.feedOperationDelegate respondsToSelector:@selector(feedCommentDeletedWithComment:feed:)]) {
                    [self.feedOperationDelegate feedCommentDeletedWithComment:comment feed:self.feed];
                }
            }
        }];
    }];
}

- (void)customObj:(id)obj clickOnSpamComment:(UMComComment *)comment
{
//    __weak typeof(self) weakSelf = self;
    UMComFeedCommnetListDataController *commentListDataController = (UMComFeedCommnetListDataController *)self.dataController;
    [UMComLoginManager performLogin:self completion:^(id responseObject, NSError *error) {
        [commentListDataController spamComment:comment completion:^(NSError *error) {
            [UMComShowToast spamComment:error];
        }];
    }];
}

- (void)customObj:(id)obj clickOnCopyComment:(UMComComment *)comment
{
    NSMutableArray *strings = [NSMutableArray arrayWithCapacity:1];
    NSMutableString *string = [[NSMutableString alloc]init];
    if (comment.content) {
        [strings addObject:comment.content];
        [string appendString:comment.content];
    }
    UIPasteboard *pboard = [UIPasteboard generalPasteboard];
    pboard.strings = strings;
    pboard.string = string;
    [UMComShowToast copySuccess];
}


- (void)customObj:(id)obj clickOnReplyComment:(UMComComment *)comment
{
    __weak typeof(self) weakSelf = self;
    self.feedDetailDataController.currentComment = comment ;
    [UMComLoginManager performLogin:self completion:^(id responseObject, NSError *error) {
        weakSelf.commentEditView.isReply = YES;
        weakSelf.commentEditView.commentTextField.placeholder = [NSString stringWithFormat:@"回复%@：",comment.creator.name];
        [weakSelf.commentEditView presentEditView];
    }];
}


#pragma mark - Tableview Delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSUInteger count = 0;
    switch (section) {
        case 0:
            count = 1;
            break;
        case 1:
            count = self.feedDetailDataController.feed.image_urls.count;
            break;
        case 2:
            count = 1;
            break;
        case 3:
            count = self.dataController.dataArray.count ;
            break;
        default:
            break;
    }
    return count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height = 0;
    switch (indexPath.section) {
        case 0:
            height = [self heightForInitializedFeedContentCell];
            break;
        case 1:
        {
            UMComImageUrl *imageUrl = self.feedDetailDataController.feed.image_urls[indexPath.row];
            NSValue *sizeValue = [self.imageSizeInfo valueForKey:imageUrl.midle_url_string];
            if (sizeValue) {
                CGSize size = [sizeValue CGSizeValue];
                height = size.height + 10;
            }else{
                
                if (self.placeHolderImageHeight > 0) {
                    return self.placeHolderImageHeight;
                }
                else{
                    
                    CGFloat placeHolderImagePreferHeight = 0;
                    CGSize placeHolderImageForIMGCellSize =  self.placeHolderImageForIMGCell.size;
                    
                    //默认是一个正方形的
                    CGFloat suggestHeight =  tableView.frame.size.width - 30+10;
                    if (placeHolderImageForIMGCellSize.width > suggestHeight) {
                        placeHolderImagePreferHeight = suggestHeight;
                    }
                    else
                    {
                        placeHolderImagePreferHeight = placeHolderImageForIMGCellSize.height;
                    }
                    
                    self.placeHolderImageHeight = placeHolderImagePreferHeight;
                    
                    return self.placeHolderImageHeight;
                }
            }
        }
            break;
        case 2:
            height = 40;
            break;
        case 3:
            height = [self heightForInitializedFeedCommentCellWithIndex:indexPath];
            break;
        default:
            break;
    }
    return height;

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *retCell = nil;
    
    switch (indexPath.section) {
        case 0:
        {
            UMComFeedDetailTableViewCell *cell = [self feedContentTableViewCellWithIndexPath:indexPath];
            retCell = cell;
        }
            break;
        case 1:
        {
            UMComLargeImageTableViewCell *cell = [self imageTableViewCellWithIndexPath:indexPath];
            retCell = cell;
        }
            break;
        case 2:
        {
            UMComLikeButtonTableViewCell *cell =  [tableView dequeueReusableCellWithIdentifier:kUMComFeedLikeButtonCellIdentifier];
            __weak typeof(self) weakSelf = self;
            cell.clickOnLikeButton = ^(UIButton *likeButton){
                [weakSelf customObj:likeButton clickOnLikeFeed:weakSelf.feedDetailDataController.feed];
            };
            [cell.likeButton setTitle:countString(weakSelf.feedDetailDataController.feed.likes_count) forState:UIControlStateNormal];
            if ([self.feedDetailDataController.feed.liked boolValue]) {
                [cell.likeButton setImage:UMComSimpleImageWithImageName(@"um_like_white") forState:UIControlStateNormal];
                [cell.likeButton setBackgroundColor:UMComColorWithHexString(@"#469EF8")];
                [cell.likeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            }else{
                [cell.likeButton setImage:UMComSimpleImageWithImageName(@"um_like_blue") forState:UIControlStateNormal];
                [cell.likeButton setBackgroundColor:[UIColor whiteColor]];
                [cell.likeButton setTitleColor:UMComColorWithHexString(@"#469EF8") forState:UIControlStateNormal];
            }
            retCell = cell;
        }
            break;
        case 3:
        {
            UMComComment *comment = self.dataController.dataArray[indexPath.row];
            UMComFeedDetailCommentCell *cell = [self createFeedCommentCellWithComment:comment];
            retCell = cell;
        }
            break;
        default:
            break;
    }
    
    return retCell;
}

#pragma mark - Pre calc cell

- (UMComFeedDetailTableViewCell *)feedContentTableViewCellWithIndexPath:(NSIndexPath *)indexPath
{
    UMComFeedDetailTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:kUMComFeedContentDetailCellIdentifier];
    
    if (!cell) {
        cell = [self.tableView dequeueReusableCellWithIdentifier:@"UMComFeedDetailTableViewCell"];
    }
    if (!cell) {
        NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"UMComFeedDetailTableViewCell" owner:self options:nil];
        if (array.count > 0) {
            cell = [array objectAtIndex:0];
        }
    }
    cell.isHideTopicName = self.isHideTopicName;
    cell.clickActionDelegate = self;
    [cell reloadCellWithFeed:self.feedDetailDataController.feed];
    [cell setNeedsUpdateConstraints];
    [cell updateConstraintsIfNeeded];
    return cell;
}

- (UMComLargeImageTableViewCell *)imageTableViewCellWithIndexPath:(NSIndexPath *)indexPath
{
    UMComLargeImageTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:kUMComFeedLargeImageCellIdentifier];
//    NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"UMComLargeImageTableViewCell" owner:self options:nil];
//    cell = [array objectAtIndex:0];
    __weak typeof(self) weakSelf = self;
    __weak typeof(cell) weakCell = cell;
    cell.umImageView.loadedImageBlock = ^(UMComImageView *imageView){
        dispatch_async(dispatch_get_main_queue(), ^{
           [weakSelf imageCell:weakCell loadedImage:imageView];
        });
    };
    cell.imageUrlArray = self.feedDetailDataController.feed.image_urls;
    
    if (!cell.umImageView.image) {
        cell.umImageView.image = self.placeHolderImageForIMGCell;
    }

    if (cell.imageUrlArray.count > indexPath.row) {
        UMComImageUrl *imageUrl = cell.imageUrlArray[indexPath.row];
        UIImage *placeholderImage = self.placeHolderImageForIMGCell;
        [cell.umImageView setImageURL:imageUrl.midle_url_string placeHolderImage:placeholderImage];
        
        [cell.umImageView performSelectorOnMainThread:@selector(setImageURLString:) withObject:imageUrl.midle_url_string waitUntilDone:NO modes:@[NSRunLoopCommonModes]];

        NSValue *sizeValue = [self.imageSizeInfo valueForKey:imageUrl.midle_url_string];
        if (sizeValue) {
            CGSize size = [sizeValue CGSizeValue];
            CGRect imageViewFrame = cell.umImageView.frame;
            imageViewFrame.size.width = size.width;
            CGFloat imageBgViewWidth = self.tableView.bounds.size.width - cell.imageBgView.frame.origin.x*2;
            imageViewFrame.origin.x = (imageBgViewWidth - imageViewFrame.size.width)/2;
            cell.umImageView.frame = imageViewFrame;
            CGRect imageBgViewFrame = cell.imageBgView.frame;
            imageBgViewFrame.size.width = imageBgViewWidth;
            imageBgViewFrame.size.height = imageViewFrame.size.height;
            cell.imageBgView.frame = imageBgViewFrame;
        }else{
            cell.umImageView.frame = cell.imageBgView.bounds;
        }
    }
    
    return cell;
}

//图片加载完成回调方法
- (void)imageCell:(UMComLargeImageTableViewCell *)cell loadedImage:(UMComImageView *)imageView
{
    UIImage *image = imageView.image;
    CGSize imageSize = image.size;
    
    CGFloat imageBgViewWidth = self.tableView.bounds.size.width - cell.imageBgView.frame.origin.x*2;
    
    if (imageSize.width > imageBgViewWidth) {
        imageSize.height = image.size.height * imageBgViewWidth/image.size.width;
        imageSize.width = imageBgViewWidth;
    }
    if (![self.imageSizeInfo valueForKey:[imageView.imageURL absoluteString]]) {
        [self.imageSizeInfo setValue:[NSValue valueWithCGSize:imageSize] forKey:[imageView.imageURL absoluteString]];
        [self.tableView reloadData];
    }
    CGRect imageFrame = cell.umImageView.frame;
    imageFrame.size = imageSize;
    cell.umImageView.frame = imageFrame;
}

- (UMComFeedDetailCommentCell *)createFeedCommentCellWithComment:(UMComComment *)comment
{
    UMComFeedDetailCommentCell *cell = [self.tableView dequeueReusableCellWithIdentifier:kUMComFeedCommentCellIdentifier];
    if (!cell) {
        NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"UMComFeedDetailCommentCell" owner:self options:nil];
        cell = [array objectAtIndex:0];
    }
    [cell reloadCellWithComment:comment];
    cell.commentActionDelegate = self;
    [cell setNeedsUpdateConstraints];
    [cell updateConstraintsIfNeeded];
    
    return cell;
}

#pragma mark - cell height calculate

- (CGFloat)heightForInitializedFeedCommentCellWithIndex:(NSIndexPath *)indexPath
{
    NSUInteger height = 0;
    UMComComment *comment = self.dataController.dataArray[indexPath.row];
    NSString *heightKey = [NSString stringWithFormat:@"commentID_%@",comment.commentID];
    
    if ([_commentHeightInfo objectForKey:heightKey]) {
        height = [[_commentHeightInfo objectForKey:heightKey] integerValue];
    } else {
        if (!_commentBaseCell) {
            return 90;
        }
        UMComFeedDetailCommentCell *cell = self.commentBaseCell;//
        
        cell.bounds = CGRectMake(0.0f, 0.0f, CGRectGetWidth(self.tableView.bounds), CGRectGetHeight(cell.bounds));
        [cell setNeedsLayout];
        [cell layoutIfNeeded];
        
        [cell reloadCellWithComment:comment];
        
        [cell setNeedsUpdateConstraints];
        [cell updateConstraintsIfNeeded];
        
        // Get the actual height required for the cell
        CGFloat height = [cell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
        height += 1;
        [self.commentHeightInfo setValue:@(height) forKey:heightKey];
    }
    return height;
}

- (CGFloat)heightForInitializedFeedContentCell
{
    CGFloat height = 0;
    if (self.feedCellHeight == 0) {
    
        UMComFeedDetailTableViewCell *cell = _cachedFeedBodyCell;
        if (!cell) {
            NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"UMComFeedDetailTableViewCell" owner:self options:nil];
            cell = [array objectAtIndex:0];
            _cachedFeedBodyCell = cell;
        }
        cell.bounds = CGRectMake(0.0f, 0.0f, CGRectGetWidth(self.tableView.bounds), CGRectGetHeight(cell.bounds));
        [cell setNeedsLayout];
        [cell layoutIfNeeded];
    
        [cell reloadCellWithFeed:self.feedDetailDataController.feed];
        
        [cell setNeedsUpdateConstraints];
        [cell updateConstraintsIfNeeded];
        height = [cell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
        height += 1;
        self.feedCellHeight = height;
    }else{
        height = self.feedCellHeight;
    }
    return height;
}


#pragma mark -
- (void)reloadFeed
{
//    [self.tableView reloadData]
    
    [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
                   // [self.tableView reloadData];
    
    //http://stackoverflow.com/questions/19357874/assertion-failure-uitableview-endcellanimationswithcontext
//    [self.tableView beginUpdates];
//    [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
//    [self.tableView endUpdates];
}


#pragma mark - Notification
- (void)onReceiveFeedDeleteNotification:(NSNotification *)note
{
    UMComFeed *feed = [note object];
    if (![feed isKindOfClass:[UMComFeed class]] || ![feed.feedID isEqualToString:self.feedDetailDataController.feed.feedID]) {
        return;
    }
    [self.navigationController popViewControllerAnimated:YES];
}


@end

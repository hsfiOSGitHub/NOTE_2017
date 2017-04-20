//
//  UMComForumFindViewController.m
//  UMCommunity
//
//  Created by umeng on 15/11/17.
//  Copyright © 2015年 Umeng. All rights reserved.
//

#import "UMComSimplicityDiscoverViewController.h"
#import "UMComSimplicityFindTableViewCell.h"
#import "UMComSimpleProfileSettingController.h"
#import "UIViewController+UMComAddition.h"
#import <UMCommunitySDK/UMComSession.h>
#import "UMComSimplicityUserInfoBar.h"
#import "UMComLoginManager.h"
#import "UMComResouceDefines.h"
#import "UMComSimpleNoticeTableViewController.h"

#import "UMComSimpleFeedTableViewController.h"
#import "UMComSimpleCommentViewController.h"
#import "UMComSimpleLikeMyFeedViewController.h"
#import "UMComFeedListDataController.h"
#import "UMComLoginManager.h"

#import <UMCommunitySDK/UMComSession.h>
#import <UMComDataStorage/UMComUnReadNoticeModel.h>
#import "UMComNotificationMacro.h"


@interface UMComSimplicityDiscoverViewController ()<UITableViewDataSource, UITableViewDelegate>


@property (nonatomic, strong) UIView *systemNotificationView;

@property (nonatomic, strong) UIView *userMessageView;

@property (nonatomic, strong) UIView *userMessageViewComment;//评论的小红点
@property (nonatomic, strong) UIView *userMessageViewLike;//赞的小红点
@property (nonatomic, strong) UIView *userMessageViewNotice;//通知的小红点

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) UMComSimplicityUserInfoBar *userInfoBar;

@end

@implementation UMComSimplicityDiscoverViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setForumUIBackButtonWithImage:UMComSimpleImageWithImageName(@"um_forum_back_gray@2x.png")];
    [self setForumUITitle:UMComLocalizedString(@"um_com_find", @"我的")];
    
    self.tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
    self.tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleTopMargin;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)])
    {
        [self.tableView setLayoutMargins:UIEdgeInsetsZero];
    }
    [self.tableView registerNib:[UINib nibWithNibName:@"UMComSimplicityFindTableViewCell" bundle:nil] forCellReuseIdentifier:@"FindTableViewCell"];
    self.tableView.rowHeight = 55.0f;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.tableFooterView = [[UIView alloc] init];
    self.tableView.scrollEnabled = NO;
    
    [self.view addSubview:self.tableView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshNoticeItemViews) name:kUMComUnreadNotificationRefreshNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshMessageData:) name:UIApplicationWillEnterForegroundNotification object:nil];
    [self refreshNoticeItemViews];
    /**
     * 获取初始化数据和更新未读消息数
     *
     * @param completion 初始化数据结果，`responseObject`的key`config.feed_length`为设置最大feed文字内容 `responseObject`的key`msg_box`是各个未读消息数，`msg_box`下面的`total`为所有未读通知数，key为`notice`为管理员未读通知数，`comment`为被评论未读通知数，`at`为被@未读通知数，`like`为被点赞未读通知数
     * @warning 这些数据都会保存在UMComSession单利里面 `config.feed_lenght`对应的UMComSession的maxFeedLength属性，`message_box`保存在UMComSession的unReadNoticeModel属性里面，unReadNoticeModel是`UMComUnReadNoticeModel`类的对象，
     
     
     */
    [[UMComDataRequestManager defaultManager] fetchConfigDataWithCompletion:^(NSDictionary *responseObject, NSError *error) {
        
        YZLog(@"%@",responseObject);
        
        if ([responseObject[@"msg_box"][@"comment"] intValue]>0)
        {
            self.userMessageViewComment.hidden = NO;
        }
        else
        {
            self.userMessageViewComment.hidden = YES;
        }
        if ([responseObject[@"msg_box"][@"at"] intValue]+[responseObject[@"msg_box"][@"notice"] intValue]>0)
        {
            self.userMessageViewNotice.hidden = NO;
        }
        else
        {
            self.userMessageViewNotice.hidden = YES;
        }
        if ([responseObject[@"msg_box"][@"like"] intValue]>0)
        {
            self.userMessageViewLike.hidden = NO;
        }
        else
        {
            self.userMessageViewLike.hidden = YES;
        }
        
    }];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)refreshMessageData:(id)sender
{
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];

}
- (void)refreshNoticeItemViews
{
    [self.tableView reloadData];
}

- (UIView *)creatNoticeViewWithOriginX:(CGFloat)originX
{
    CGFloat noticeViewWidth = 7;
    UIView *itemNoticeView = [[UIView alloc]initWithFrame:CGRectMake(originX,0, noticeViewWidth, noticeViewWidth)];
    itemNoticeView.backgroundColor = [UIColor redColor];
    itemNoticeView.layer.cornerRadius = noticeViewWidth/2;
    itemNoticeView.clipsToBounds = YES;
    itemNoticeView.hidden = YES;
    return itemNoticeView;
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 0;
    } else if (section == 1) {
        return 0;
    } else if (section == 2) {
        return 5;
    } else {
//        return 1;
        return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"FindTableViewCell";
    UMComSimplicityFindTableViewCell *cell = (UMComSimplicityFindTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellID forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    if (indexPath.section == 0 || indexPath.section == 1) {
        
    } else if (indexPath.section == 2) {
        switch (indexPath.row) {
            case 0: {
                cell.titleImageView.image = UMComSimpleImageWithImageName(@"wodedongtai");
                cell.titleNameLabel.text = UMComLocalizedString(@"um_news_notice", @"我的动态");
            }
                break;
            case 1: {
                cell.titleImageView.image = UMComSimpleImageWithImageName(@"um_favorite");
                cell.titleNameLabel.text = UMComLocalizedString(@"um_com_user_collection", @"我的收藏");
            }
                break;
            case 2: {
                cell.titleImageView.image = UMComSimpleImageWithImageName(@"pinglun");
                cell.titleNameLabel.text = UMComLocalizedString(@"um_com_comment", @"评论");
                
                if (!self.userMessageViewComment) {
                    CGFloat padding = 2;
                    CGFloat defaultNoticeViewOriginX = 115;
                    CGSize nameSize = [cell.titleNameLabel.text sizeWithFont:cell.titleNameLabel.font];
                    CGFloat noticeViewOriginX = cell.titleNameLabel.frame.origin.x + nameSize.width + padding;
                    if (noticeViewOriginX >= cell.contentView.bounds.size.width) {
                        //大于cell的宽度就减去padding
                        noticeViewOriginX = cell.contentView.bounds.size.width - padding;
                    }
                    else if (noticeViewOriginX <= 0)
                    {
                        //小于0就用默认
                        noticeViewOriginX = defaultNoticeViewOriginX;
                    }
                    else{}
                    self.userMessageViewComment = [self creatNoticeViewWithOriginX:noticeViewOriginX];
                    self.userMessageViewComment.center = CGPointMake(self.userMessageViewComment.center.x, cell.titleNameLabel.frame.origin.y+11);
                    [cell.contentView addSubview:self.userMessageViewComment];
                } else {
                    if (self.userMessageViewComment.superview != cell.contentView) {
                        [self.userMessageViewComment removeFromSuperview];
                        [cell.contentView addSubview:self.userMessageViewComment];
                    }
                }
                
                UMComUnReadNoticeModel *unReadNotice = [UMComSession sharedInstance].unReadNoticeModel;
                if (unReadNotice.notiByCommentCount <= 0) {
                    self.userMessageViewComment.hidden = YES;
                }else{
                    self.userMessageViewComment.hidden = NO;
                }
            }
                break;
            case 3: {
                cell.titleImageView.image = UMComSimpleImageWithImageName(@"thumb-blue");
                cell.titleNameLabel.text = UMComLocalizedString(@"um_com_be_liked", @"赞我的");
                
                
                if (!self.userMessageViewLike) {
                    CGFloat padding = 2;
                    CGFloat defaultNoticeViewOriginX = 115;
                    CGSize nameSize = [cell.titleNameLabel.text sizeWithFont:cell.titleNameLabel.font];
                    CGFloat noticeViewOriginX = cell.titleNameLabel.frame.origin.x + nameSize.width + padding;
                    if (noticeViewOriginX >= cell.contentView.bounds.size.width) {
                        //大于cell的宽度就减去padding
                        noticeViewOriginX = cell.contentView.bounds.size.width - padding;
                    }
                    else if (noticeViewOriginX <= 0)
                    {
                        //小于0就用默认
                        noticeViewOriginX = defaultNoticeViewOriginX;
                    }
                    else{}
                    self.userMessageViewLike = [self creatNoticeViewWithOriginX:noticeViewOriginX];
                    self.userMessageViewLike.center = CGPointMake(self.userMessageViewLike.center.x, cell.titleNameLabel.frame.origin.y+11);
                    [cell.contentView addSubview:self.userMessageViewLike];
                } else {
                    if (self.userMessageViewLike.superview != cell.contentView) {
                        [self.userMessageViewLike removeFromSuperview];
                        [cell.contentView addSubview:self.userMessageViewLike];
                    }
                }

                UMComUnReadNoticeModel *unReadNotice = [UMComSession sharedInstance].unReadNoticeModel;
                if (unReadNotice.notiByLikeCount <= 0) {
                    self.userMessageViewLike.hidden = YES;
                }else{
                    self.userMessageViewLike.hidden = NO;
                }
            }
                break;
            case 4: {
                cell.titleImageView.image = UMComSimpleImageWithImageName(@"tongzhi");
                cell.titleNameLabel.text = UMComLocalizedString(@"um_com_notification", @"通知");
                
                if (!self.userMessageViewNotice) {
                    CGFloat padding = 2;
                    CGFloat defaultNoticeViewOriginX = 115;
                    CGSize nameSize = [cell.titleNameLabel.text sizeWithFont:cell.titleNameLabel.font];
                    CGFloat noticeViewOriginX = cell.titleNameLabel.frame.origin.x + nameSize.width + padding;
                    if (noticeViewOriginX >= cell.contentView.bounds.size.width) {
                        //大于cell的宽度就减去padding
                        noticeViewOriginX = cell.contentView.bounds.size.width - padding;
                    }
                    else if (noticeViewOriginX <= 0)
                    {
                        //小于0就用默认
                        noticeViewOriginX = defaultNoticeViewOriginX;
                    }
                    else{}
                    self.userMessageViewNotice = [self creatNoticeViewWithOriginX:noticeViewOriginX];
                    self.userMessageViewNotice.center = CGPointMake(self.userMessageViewNotice.center.x, cell.titleNameLabel.frame.origin.y+11);
                    [cell.contentView addSubview:self.userMessageViewNotice];
                } else {
                    if (self.userMessageViewNotice.superview != cell.contentView) {
                        [self.userMessageViewNotice removeFromSuperview];
                        [cell.contentView addSubview:self.userMessageViewNotice];
                    }
                }

                UMComUnReadNoticeModel *unReadNotice = [UMComSession sharedInstance].unReadNoticeModel;
                if (unReadNotice.notiByAdministratorCount <= 0) {
                    self.userMessageViewNotice.hidden = YES;
                }else{
                    self.userMessageViewNotice.hidden = NO;
                }

            }
                break;
            default:
                break;
        }
        if (indexPath.row == 0) {
            [cell setCellStyleForLine:UMComSimplicityCellLineStyleTop | UMComSimplicityCellLineStyleMiddle];
        } else if (indexPath.row == 4) {
            [cell setCellStyleForLine:UMComSimplicityCellLineStyleBottom];
        } else {
            [cell setCellStyleForLine:UMComSimplicityCellLineStyleMiddle];
        }
    } else {
        switch (indexPath.row) {
            case 0: {
                cell.titleImageView.image = UMComSimpleImageWithImageName(@"shezhi");
                cell.titleNameLabel.text = UMComLocalizedString(@"um_com_setting", @"设置");
                [cell setCellStyleForLine:UMComSimplicityCellLineStyleTop | UMComSimplicityCellLineStyleBottom];
            }
                break;
            default:
                break;
        }
    }
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIEdgeInsets edge = UIEdgeInsetsMake(tableView.rowHeight - 1, 15, 0, 0);
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.tableView setSeparatorInset:edge];
    }
    if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)])
    {
        [self.tableView setLayoutMargins:edge];
    }
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
//        return 15.f;
        return 0.1;
    }else if (section == 1) {
//        return 110.1f;
        return 0.1;
    } else if (section == 2) {
        return 15.0f;
    }else {
        return 15.0f;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.1;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 1) {
//        NSArray *xibs = [[NSBundle mainBundle] loadNibNamed:@"UMComSimplicityUserInfoBar" owner:self options:nil];
//        self.userInfoBar = xibs[0];
//        
//        [_userInfoBar refresh];
//        [_userInfoBar addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(prepareToUserCenter)]];
//        return _userInfoBar;
    } else {

    }
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    __weak typeof(self) ws = self;
    [UMComLoginManager performLogin:self completion:^(id responseObject, NSError *error) {
        if (!error) {
            [ws.userInfoBar refresh];
            
            if (indexPath.section == 0) {
                
            } else if (indexPath.section == 1) {

            } else if (indexPath.section == 2) {
                switch (indexPath.row) {
                    case 0:
                    {
                        [ws tranToUserFeedFlow];
                    }
                        break;
                    case 1:
                        [ws tranToUsersFavourites];
                        break;
                    case 2:
                        [ws tranToComment];
                        break;
                    case 3:
                        [ws tranToBeLiked];
                        break;
                    case 4:
                        [ws tranToNotification];
                        break;
                        
                    default:
                        break;
                }
            }else if(indexPath.section == 3){
                switch (indexPath.row) {
                    case 0:
                    {
                        [ws tranToSetting];
                    }
                        break;
                        
                    default:
                        break;
                }
            }
        }
    }];
}

- (void)prepareToUserCenter
{
    if ([[UMComSession sharedInstance] isLogin]) {

    } else {
        __weak typeof(self) ws = self;
        [UMComLoginManager performLogin:self completion:^(id responseObject, NSError *error) {
            if (!error) {
                [ws.userInfoBar refresh];
            }
        }];
        
    }
}

- (void)tranToUserFeedFlow
{
    UMComSimpleFeedTableViewController *VC = [[UMComSimpleFeedTableViewController alloc] init];
    VC.dataController = [[UMComFeedTimeLineDataController alloc] initWithCount:UMCom_Limit_Page_Count userID:[UMComSession sharedInstance].loginUser.uid timeLineFeedListType:UMComUserTimeLineFeedType_Default];
    VC.titleName = UMComLocalizedString(@"um_com_user_feed_flow", @"我的动态");
    [self.navigationController pushViewController:VC animated:YES];
}

- (void)tranToUsersFavourites
{
    UMComSimpleFeedTableViewController *VC = [[UMComSimpleFeedTableViewController alloc] init];
    VC.dataController = [[UMComFeedFavoriteDataController alloc] initWithCount:UMCom_Limit_Page_Count];
    VC.feedType = UMComFeedType_Favorite;
    VC.titleName = UMComLocalizedString(@"um_com_fav_feed", @"我的收藏");
    [self.navigationController pushViewController:VC animated:YES];
}


- (void)tranToComment
{
    UMComSimpleCommentViewController *VC = [[UMComSimpleCommentViewController alloc] init];
    [self.navigationController pushViewController:VC animated:YES];
}

- (void)tranToBeLiked
{
    UMComSimpleLikeMyFeedViewController *VC = [[UMComSimpleLikeMyFeedViewController alloc] init];
    [self.navigationController pushViewController:VC animated:YES];
}

- (void)tranToNotification
{
    UMComSimpleNoticeTableViewController *noticeVc = [[UMComSimpleNoticeTableViewController alloc] init];
    [self.navigationController pushViewController:noticeVc animated:YES];
}

- (void)tranToSetting
{
    UMComSimpleProfileSettingController *settingVc = [[UMComSimpleProfileSettingController alloc] init];
    [self.navigationController pushViewController:settingVc animated:YES];
}

- (void)tranToUserCenter
{
}

@end

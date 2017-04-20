//
//  UMComFeedDetailViewController.m
//  UMCommunity
//
//  Created by Gavin Ye on 11/13/14.
//  Copyright (c) 2014 Umeng. All rights reserved.
//

#import "UMComFeedDetailViewController.h"
#import "UIViewController+UMComAddition.h"
#import <UMCommunitySDK/UMComSession.h>
#import "UMComShareCollectionView.h"
#import "UMComFeedStyle.h"
#import "UMComEditViewController.h"
#import "UMComNavigationController.h"
#import "UMComScrollViewDelegate.h"
#import "UMComFeedsTableViewCell.h"
#import "UMComFeedOperationFinishDelegate.h"
#import "UMComClickActionDelegate.h"
#import "UMComImageView.h"
#import "UMComMutiStyleTextView.h"
#import "UMComMicLikeUserTableViewCell.h"
#import "UMComHorizonCollectionView.h"
#import "UMComCommentTableViewCell.h"
#import "UMComUserCenterViewController.h"
#import "UMComWebViewController.h"
#import "UMComResouceDefines.h"
#import "UMComHtmlFeedStyle.h"
#import "UMComFeedDetailViewHtmlBodyCell.h"
#import <UMComDataStorage/UMComFeed.h>
#import "UMComFeedDetailDataController.h"
#import "UMComLikeListDataController.h"
#import "UMComCommentListDataController.h"
#import <UMComDataStorage/UMComImageUrl.h>
#import <UMComDataStorage/UMComComment.h>
#import <UMComDataStorage/UMComLike.h>
#import "UMComLoginManager.h"
#import "UMComShowToast.h"
#import <UMComFoundation/UMComKit+Color.h>
#import <UMComFoundation/UMComDefines.h>
#import "UMComNotificationMacro.h"
#import "UMComRefreshView.h"

#define kUMComComment @"UMComComment"
#define kUMComCommentMutitext  @"UMComCommentMutitext"
#define UMCom_Feed_Exceed_Height  35


typedef NS_ENUM(NSInteger, UMComFeedDetailChildViewType)
{
    UMComFeedDetailChildViewType_Comment,
    UMComFeedDetailChildViewType_Like,
};

typedef void(^LoadFinishBlock)(NSError *error);

@interface UMComFeedDetailViewController ()<UIActionSheetDelegate, UMComClickActionDelegate, UMComHorizonCollectionViewDelegate,UMComHtmlBodyCellDelegate>

#pragma mark - property
@property (nonatomic, copy) NSString *feedId;

@property (nonatomic, strong) UMComFeed *feed;

@property (nonatomic, strong) UMComFeedStyle *feedStyle;

@property (nonatomic, strong) UMComShareCollectionView *shareListView;

@property (nonatomic, strong) NSDictionary * viewExtra;

@property (strong, nonatomic) UIView *menuView;

@property (nonatomic, assign) NSInteger lastIndex;

@property (nonatomic, strong) NSMutableArray *commentArray;

@property (nonatomic, strong) NSMutableArray *likeArray;

@property (nonatomic, strong) UMComComment *selectedComment;

@property (nonatomic, strong) UMComHorizonCollectionView *cellMenuView;

@property (nonatomic, strong) UIView *cellMenuBgView;


@property (nonatomic, strong) UIButton *collectionButton;

@property (nonatomic, assign) CGRect navigationOriginFrame;

- (void)requestPostData;

//html的富文本
@property(nonatomic,strong) UMComHtmlFeedStyle* htmlFeedStyle;
- (void)resetHtmlFeedStyle;
//是否为html的feed
-(BOOL) isHtmlData;

@property(nonatomic,strong)UMComFeedDetailDataController* feedDetailDataController;
@property(nonatomic,strong)UMComFeedLikeListDataController* likeListDataController;
@property(nonatomic,strong)UMComFeedCommnetListDataController* feedCommnetListDataController;
-(void) createDataControllers;

@property (nonatomic, strong) NSArray *dataArray;

@property(nonatomic,assign)UMComFeedDetailChildViewType childViewType;

@end

@implementation UMComFeedDetailViewController
{
    BOOL _tableviewConsumeCachedCellFlag;
}

#pragma mark - UIViewController method

- (id)initWithFeed:(UMComFeed *)feed
{
    self = [super init];
    if (self) {
        self.feed = feed;
        self.feedId = feed.feedID;
    }
    return self;
}

- (id)initWithFeed:(NSString *)feedId
         viewExtra:(NSDictionary *)viewExtra
{
    self = [self initWithFeed:nil];
    if (self) {
        self.feedId = [viewExtra valueForKey:@"feed_id"];
        self.viewExtra = viewExtra;
    }
    return self;
}

- (id)initWithFeed:(UMComFeed *)feed showFeedDetailShowType:(UMComFeedDetailShowType)type
{
    self = [self initWithFeed:feed];
    if (self) {
        self.feedId = feed.feedID;
        self.showType = type;
    }
    return self;
}

-(void) createDataControllers
{
    self.feedDetailDataController = [[UMComFeedDetailDataController alloc] initWithFeed:self.feed viewExtra:self.viewExtra];
    self.feedDetailDataController.feed = self.feed;
    
    self.likeListDataController = [[UMComFeedLikeListDataController alloc] initWithFeedId:self.feed.feedID count:UMCom_Limit_Page_Count];
    
    self.feedCommnetListDataController = [[UMComFeedCommnetListDataController alloc] initWithCount:UMCom_Limit_Page_Count feedId:self.feedId commentUserId:nil order:UMComCommentSortType_Default];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(postFeedCompleteSucceed:) name:kNotificationPostFeedResultNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(feedDeletedCompletion:) name:kUMComFeedDeletedFinishNotification object:nil];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    //当从搜索界面进入详情页面的时候，navigationbar的范围会变化,导致view高度变大，所以需要强行通过navigation和statusbar的高度，来统一限制self.view的高度--begin
    CGRect navigationBarRC = self.navigationController.navigationBar.frame;
    CGRect statusBarRC = [[UIApplication sharedApplication] statusBarFrame];
    CGRect viewFrame = self.view.frame;
    viewFrame.size.height = self.view.window.bounds.size.height - navigationBarRC.size.height - statusBarRC.size.height;
    self.view.frame = viewFrame;
    //当从搜索界面进入详情页面的时候，navigationbar的范围会变化,导致view高度变大，所以需要强行通过navigation和statusbar的高度，来统一限制self.view的高度--end
    
    if (!self.menuView) {
        [self createMuneView];
        self.navigationOriginFrame = self.navigationController.navigationBar.frame;
    }else{
        self.navigationController.navigationBar.frame = self.navigationOriginFrame;
    }
    if (self.menuView.superview != self.navigationController.view) {
        [self.view.window addSubview:self.menuView];
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.menuView removeFromSuperview];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kNotificationPostFeedResultNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kUMComFeedDeletedFinishNotification object:nil];
}


- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)]) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    self.doNotShowNodataNote = YES;
    [self.tableView registerNib:[UINib nibWithNibName:@"UMComFeedsTableViewCell" bundle:nil] forCellReuseIdentifier:@"UMComFeedsTableViewCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"UMComCommentTableViewCell" bundle:nil] forCellReuseIdentifier:@"UMComCommentTableViewCell"];
    
    UIEdgeInsets contentInset = self.tableView.contentInset;
    contentInset.bottom += 50;
    self.tableView.contentInset = contentInset;
    self.refreshHeadView.scrollViewOriginalInset = contentInset;
    self.refreshFootView.scrollViewOriginalInset = contentInset;
    
    [self setTitleViewWithTitle:UMComLocalizedString(@"um_com_feedDetailTitle", @"正文内容")];
    if (self.navigationController.viewControllers.count <= 1) {
        [self setLeftButtonWithImageName:@"Backx" action:@selector(goBack)];
    }
    self.commentArray = [NSMutableArray array];
    self.likeArray = [NSMutableArray array];
    
    
    [self createDataControllers];
     self.isAutoStartLoadData = NO;
    [self requestPostData];
    
    if (self.feed) {
        if ([self isHtmlData]) {
           [self resetHtmlFeedStyle];
        }
        else{
           [self resetFeedStyle];
        }
    }
    [self createTopBarItems];
}

#pragma mark - subviews

- (void)createMuneView
{
    CGFloat menuViewHeight = 46;
    UIView *menuView = [[UIView alloc]initWithFrame:CGRectMake(0, self.view.window.bounds.size.height - menuViewHeight, self.view.frame.size.width, menuViewHeight)];
    menuView.backgroundColor = UMComColorWithHexString(@"#DEDEDE");
    [[UIApplication sharedApplication].keyWindow addSubview:menuView];
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 0.5)];
    line.backgroundColor = [UIColor lightGrayColor];
    [menuView addSubview:line];
    menuView.backgroundColor = [UIColor whiteColor];
    CGFloat buttonHeight = 44;
    CGFloat buttonWidth = 65;
    CGRect buttonFrame = CGRectMake(0, (menuViewHeight - buttonHeight)/2, buttonWidth, buttonHeight);
    for (int index = 0; index < 3; index ++) {
        NSString *title = nil;
        NSString *imageName = nil;
        SEL action;
        if (index == 0) {
            title = @"转发";
            imageName = @"um_micro_forward_normal";
            action = @selector(didClickOnForward:);
            buttonFrame.origin.x = self.view.frame.size.width/4-buttonWidth;
        }else if (index == 1){
            action = @selector(didClickOnLike:);
            title = @"点赞";
            if ([self.feed.liked boolValue]) {
                title = UMComLocalizedString(@"um_com_cancel", @"取消");
                imageName = @"um_micro_like_highlight";
            }else{
                imageName = @"um_micro_like_normal";
            }
            buttonFrame.origin.x = self.view.frame.size.width/2 - buttonWidth/2;
        }else if (index == 2){
            title = UMComLocalizedString(@"um_com_comment", @"评论");
            imageName = @"um_micro_comment_normal";
            action = @selector(didClikeOnComment:);
            buttonFrame.origin.x = self.view.frame.size.width -self.view.frame.size.width/4;
        }
        
        UIButton *button = [self createNewButtonWithImageName:imageName title:title action:action frame:buttonFrame];
        [menuView addSubview:button];
    }
    for (int index = 1; index<3; index++) {
        UIView *spaceLine = [[UIView alloc] initWithFrame:CGRectMake(self.view.frame.size.width/3*index-0.5, 0, 1, menuView.frame.size.height)];
        spaceLine.backgroundColor = UMComColorWithHexString(@"#DEDEDE");
        [menuView addSubview:spaceLine];
    }
    self.menuView = menuView;
}

- (UIButton *)createNewButtonWithImageName:(NSString *)imageName
                                     title:(NSString *)title
                                    action:(SEL)action
                                     frame:(CGRect)frame;
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = frame;
    button.backgroundColor = [UIColor whiteColor];
    [button addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    button.titleLabel.font = UMComFontNotoSansLightWithSafeSize(14);
    [button setTitleColor:UMComColorWithHexString(@"#666666") forState:UIControlStateNormal];
    [button setTitle:title forState:UIControlStateNormal];
    [button setImage:UMComImageWithImageName(imageName) forState:UIControlStateNormal];
    CGFloat imageWidth = 16;
    CGFloat imageHight = 14;
    CGFloat imageEdge = 5;
    CGFloat imageTopEdge = frame.size.height/2 - imageHight/2;
    [button setImageEdgeInsets:UIEdgeInsetsMake(imageTopEdge, imageEdge, imageTopEdge, frame.size.width - imageWidth - imageEdge)];
    
    return button;
}


- (void)createTopBarItems
{
    UIButton *_favNavButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_favNavButton addTarget:self action:@selector(collectFeed:) forControlEvents:UIControlEventTouchUpInside];
    _favNavButton.frame = CGRectMake(0.f, 0.f, 20.f, 20.f);
    UIImage *image = nil;
    if ([self.feed.has_collected boolValue]) {
        image = UMComImageWithImageName(@"um_forum_collection_highlight");
    }else{
        image = UMComImageWithImageName(@"um_forum_collection_normal");
    }
    [_favNavButton setImage:image forState:UIControlStateNormal];
    
    UIBarButtonItem *favItem = [[UIBarButtonItem alloc] initWithCustomView:_favNavButton];
    self.collectionButton = _favNavButton;
    _favNavButton.selected = [self.feed.has_collected boolValue];
    
    UIButton *menuItemButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [menuItemButton addTarget:self action:@selector(displayMoreMenu:) forControlEvents:UIControlEventTouchUpInside];
    menuItemButton.frame = CGRectMake(0.f, 0.f, 20.f, 4.f);
    image = UMComImageWithImageName(@"um_forum_more_gray");
    [menuItemButton setImage:image forState:UIControlStateNormal];
    UIBarButtonItem *menuItem = [[UIBarButtonItem alloc] initWithCustomView:menuItemButton];
    
    UIBarButtonItem *spaceItem = [[UIBarButtonItem alloc]init];
    UIView *spaceView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 8, 20)];
    spaceView.backgroundColor = [UIColor clearColor];
    [spaceItem setCustomView:spaceView];
    
    NSArray<UIBarButtonItem *> *items = [NSArray arrayWithObjects:menuItem, spaceItem, favItem, nil];
    [self.navigationItem setRightBarButtonItems:items];
}

#pragma mark - UITableViewDelegate And UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 1;
    }else{
        return self.dataArray.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    UITableViewCell *cell = nil;
    if (indexPath.section == 0) {
        if ([self isHtmlData]) {
            cell =  [self htmlfeedCellForRowAtIndexPath:indexPath];
        }
        else{
            cell = [self feedCellForRowAtIndexPath:indexPath];
        }
        
    }else{
        if (self.dataController == self.feedCommnetListDataController ) {
            _tableviewConsumeCachedCellFlag = YES;
            cell = [self commentCellForRowAtIndexPath:indexPath];
        }else if (self.dataController == self.likeListDataController){
            cell = [self likeCellForRowAtIndexPath:indexPath];
        }else{
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        }
    }
    return cell;
}

#pragma mark - cell
- (UITableViewCell *)htmlfeedCellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * cellIdentifier = @"UMComFeedDetailViewHtmlBodyCell";
    UMComFeedDetailViewHtmlBodyCell* cell = [self.tableView  dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[UMComFeedDetailViewHtmlBodyCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.delegate = self;
    cell.UMComHtmlBodyCellDelegate = self;
    [cell layoutFeedWithfeedStyle:self.htmlFeedStyle tableView:self.tableView cellForRowAtIndexPath:indexPath];
    return cell;
}

- (UITableViewCell *)feedCellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * cellIdentifier = @"UMComFeedsTableViewCell";
    UMComFeedsTableViewCell * cell = [self.tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    cell.moreButton.hidden = YES;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.delegate = self;
    cell.cellSubViewTopEdge = 20;
    
    
    [cell reloadFeedWithfeedStyle:self.feedStyle tableView:self.tableView cellForRowAtIndexPath:indexPath];
    CGRect dateFrame = cell.dateLabel.frame;
    dateFrame.origin.y = cell.nameLabel.frame.origin.y + cell.nameLabel.frame.size.height;
    dateFrame.origin.x = cell.nameLabel.frame.origin.x;
    cell.dateLabel.frame = dateFrame;
    cell.feedBgView.layer.cornerRadius = 0;
    cell.feedBgView.layer.borderColor = [UIColor whiteColor].CGColor;
    CGRect feedBgViewFrame = cell.feedBgView.frame;
    feedBgViewFrame.origin.x = 0;
    feedBgViewFrame.origin.y = 5;
    feedBgViewFrame.size.width = self.tableView.frame.size.width;
    feedBgViewFrame.size.height = self.feedStyle.totalHeight - 5;
    cell.feedBgView.frame = feedBgViewFrame;
    [cell.locationDistance removeFromSuperview];
    [cell.bottomMenuBgView removeFromSuperview];
    CGFloat madelWidth = 0;
    if (self.feed.creator.medal_list.count > 0) {
        madelWidth = 16;
    }

    return cell;
}

- (void)resetFeedStyle
{
    if (!self.feedStyle) {
        self.feedStyle = [[UMComFeedStyle alloc] initWithDetailFeed:self.feed viewWidth:self.tableView.frame.size.width];
        self.feedStyle.isDisplayAllContent = YES;
    }
    [self.feedStyle resetWithFeed:self.feed];
    if (self.feed.text.length > 0) {
        self.feedStyle.totalHeight -= UMCom_Feed_Exceed_Height;
    }else{
        self.feedStyle.totalHeight -= 10;
    }
    if (self.feed.origin_feed) {
        self.feedStyle.totalHeight += 10;
    }
    self.feedStyle.totalHeight += 20;
    [self.tableView reloadData];
}


- (UITableViewCell *)commentCellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"UMComCommentTableViewCell";
    UMComCommentTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:cellID forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (indexPath.row < self.commentArray.count) {
        NSDictionary *dict = self.commentArray[indexPath.row];
        UMComComment *comment = [dict valueForKey:kUMComComment];
        UMComMutiText *mutiText = [dict valueForKey:kUMComCommentMutitext];
        [cell reloadWithComment:comment commentStyleView:mutiText];
    }
    __weak typeof(self) weakSelf = self;
    cell.clickOnCommentContent = ^(UMComComment *comment){
        weakSelf.selectedComment = comment;
        [self clickOnCommentCell:comment];
    };
    cell.delegate = self;
    return cell;
}

- (UITableViewCell *)likeCellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"UMComMicLikeUserTableViewCell";
    UMComMicLikeUserTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[UMComMicLikeUserTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId cellSize:CGSizeMake(self.tableView.frame.size.width, 60)];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell.portrait.layer.cornerRadius = cell.portrait.frame.size.width/2;
    cell.portrait.clipsToBounds = YES;
    if (self.likeArray.count > indexPath.row) {
        UMComUser *user = self.likeArray[indexPath.row];
        cell.user = user;
        cell.delegate = self;
        cell.nameLabel.text = user.name;
        NSString *iconUrl = [user iconUrlStrWithType:UMComIconSmallType];
        [cell.portrait setImageURL:iconUrl placeHolderImage:[UMComImageView placeHolderImageGender:user.gender.integerValue]];
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        if ([self isHtmlData])
        {
            return self.htmlFeedStyle.totalHeight;
        }
        else
        {
            return self.feedStyle.totalHeight;
        }
        
    }else{
        if (self.dataController == self.feedCommnetListDataController) {
            CGFloat commentTextViewHeight = 0;
            commentTextViewHeight = [self heightForCommentCellWithIndex:indexPath];
            return commentTextViewHeight;
        }else if (self.dataController == self.likeListDataController){
            return 60;
        }

    }
    return 0;
}

- (NSUInteger)heightForCommentCellWithIndex:(NSIndexPath *)indexPath
{
    
    NSUInteger height = 0;
    UMComComment *comment = [[_commentArray objectAtIndex:indexPath.row] valueForKey:kUMComComment];
    UMComMutiText *commentMutiText = [[_commentArray objectAtIndex:indexPath.row] valueForKey:kUMComCommentMutitext];
    height += UMCom_Micro_Comment_TopEdge*2 + commentMutiText.textSize.height + UMCom_Micro_Comment_TimeHeight + UMCom_Micro_Comment_NameHeight + UMCom_Micro_Comment_TopEdge;
    if (comment.image_urls.count > 0) {
        height += 92;
    }
    return height;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 1) {
        return 45;
    }
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 1) {
        return [self creatCellMenuBgView];
    }
    return nil;
}

- (UIView *)creatCellMenuBgView
{
    if (!self.cellMenuBgView) {
        UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, 45)];
        headView.backgroundColor = [UIColor whiteColor];
        CGFloat menuViewLeftEdge = 150;
        UMComHorizonCollectionView *collectionMenuView = [[UMComHorizonCollectionView alloc]initWithFrame:CGRectMake(menuViewLeftEdge, 0, headView.frame.size.width - menuViewLeftEdge, 40) itemCount:3];
        collectionMenuView.cellDelegate = self;
        collectionMenuView.indicatorLineHeight = 2;
        collectionMenuView.indicatorLineWidth = UMComWidthScaleBetweenCurentScreenAndiPhone6Screen(collectionMenuView.frame.size.width/3-20);
        collectionMenuView.indicatorLineLeftEdge = 10;
        collectionMenuView.scrollIndicatorView.backgroundColor = UMComColorWithHexString(FontColorBlue);
        collectionMenuView.backgroundColor = [UIColor clearColor];
        [headView addSubview:collectionMenuView];
        [collectionMenuView startIndex:2];
        self.cellMenuView = collectionMenuView;
        UIView *spaceView = [[UIView alloc] initWithFrame:CGRectMake(0, 40, headView.frame.size.width, 5)];
        spaceView.backgroundColor = UMComTableViewSeparatorColor;
        [headView addSubview:spaceView];
        self.cellMenuBgView = headView;
    }else{
        [self.cellMenuView reloadData];
    }
    return self.cellMenuBgView;
}

#pragma mark - menuView delegate
- (void)horizonCollectionView:(UMComHorizonCollectionView *)collectionView reloadCell:(UMComHorizonCollectionCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    cell.label.font = UMComFontNotoSansLightWithSafeSize(12);
    if (indexPath.row == 0) {
        cell.userInteractionEnabled = NO;
    }else{
        cell.userInteractionEnabled= YES;
    }
    if (collectionView.currentIndex == indexPath.row) {
        cell.label.textColor = UMComColorWithHexString(@"#666666");
    }else{
        cell.label.textColor = UMComColorWithHexString(UMCom_Micro_Feed_ButtonTitleCollor);
    }
}

- (void)horizonCollectionView:(UMComHorizonCollectionView *)collectionView didSelectedColumn:(NSInteger)column
{
    self.dataArray = nil;
    if (column == 1) {
        self.childViewType = UMComFeedDetailChildViewType_Like;
        if (self.isLoadFinish && self.likeListDataController.dataArray.count <= 0) {
            
            self.dataController = self.likeListDataController;
            [self refreshData];
        }
        else{
            self.dataController = self.likeListDataController;
            self.dataArray = self.likeArray;
        }

    }else if (column == 2){
        
        self.childViewType = UMComFeedDetailChildViewType_Comment;
        if (self.isLoadFinish && self.feedCommnetListDataController.dataArray.count <= 0) {
             self.dataController = self.feedCommnetListDataController;
             [self refreshData];
        }
        else{
            self.dataController = self.feedCommnetListDataController;
            self.dataArray = self.commentArray;
        }
    }
    [self.tableView reloadData];
}

- (NSString *)horizonCollectionView:(UMComHorizonCollectionView *)collectionView titleForIndexPath:(NSIndexPath *)indexPath
{
    
    NSString *title = nil;
    if (indexPath.row == 0) {
        title = [NSString stringWithFormat:@"转发 %@",countString(self.feed.forward_count)];
    }else if (indexPath.row == 1) {
        title = [NSString stringWithFormat:@"点赞 %@",countString(self.feed.likes_count)];
    }else if (indexPath.row == 2) {
        title = [NSString stringWithFormat:@"评论 %@",countString(self.feed.comments_count)];
    }
    return title;
}


#pragma mark - data handle

- (void)handleLocalData:(NSArray *)data error:(NSError *)error
{
    self.dataArray = nil;
    if (!error && [data isKindOfClass:[NSArray class]]) {
        if (self.dataController == self.feedCommnetListDataController) {
            [self.commentArray removeAllObjects];
            [self.tableView reloadData];
            [self setCommentArrWithComments:data];
            self.dataArray = self.commentArray;
        }else if (self.dataController == self.likeListDataController){
            [self.likeArray removeAllObjects];
            [self.tableView reloadData];
            for (UMComLike *like in data) {
                if (like.creator) {
                    [self.likeArray addObject:like.creator];
                }
            }
            self.dataArray = self.likeArray;
        }
        [self.tableView reloadData];
    }
}

- (void)handleFirstPageData:(NSArray *)data error:(NSError *)error
{
    
    self.dataArray = nil;
    if (!error && [data isKindOfClass:[NSArray class]]) {
        if (self.dataController == self.feedCommnetListDataController) {
            [self.commentArray removeAllObjects];
            [self.tableView reloadData];
            [self setCommentArrWithComments:data];
            self.dataArray = self.commentArray;
        }else if (self.dataController == self.likeListDataController){
            [self.likeArray removeAllObjects];
            [self.tableView reloadData];
            for (UMComLike *like in data) {
                if (like.creator) {
                    [self.likeArray addObject:like.creator];
                }
            }
            self.dataArray = self.likeArray;
        }
        [self.tableView reloadData];
    }
}

- (void)handleNextPageData:(NSArray *)data error:(NSError *)error
{
    if (!error && [data isKindOfClass:[NSArray class]]) {
        if (self.dataController == self.feedCommnetListDataController) {
            [self setCommentArrWithComments:data];
            self.dataArray = self.commentArray;
        }else if(self.dataController == self.likeListDataController){
            for (UMComLike *like in data) {
                if (like.creator) {
                    [self.likeArray addObject:like.creator];
                }
            }
            self.dataArray = self.likeArray;
        }
    }
    [self.tableView reloadData];
}

- (void)setCommentArrWithComments:(NSArray *)reloadComments
{
    for (UMComComment *comment in reloadComments) {
        if ([comment.status integerValue] ) {
            continue;
        }
        NSDictionary *dict = [self dictWithComment:comment];
        if (dict) {
            [self.commentArray addObject:dict];
        }
    }
}

- (NSDictionary *)dictWithComment:(UMComComment *)comment
{
    if (![comment isKindOfClass:[UMComComment class]] || [comment.status intValue] > 1) {
        return nil;
    }
    NSMutableString * replayStr = [NSMutableString stringWithString:@""];
    NSMutableArray *checkWords = nil; //[NSMutableArray arrayWithCapacity:1];
    if (comment.reply_user) {
        [replayStr appendString:UMComLocalizedString(@"um_com_replyComment", @"回复")];
        checkWords = [NSMutableArray arrayWithObject:[NSString stringWithFormat:UserNameString,comment.reply_user.name]];
        [replayStr appendFormat:UserNameString,comment.reply_user.name];
        [replayStr appendFormat:@"："];
    }
    if (comment.content) {
        [replayStr appendFormat:@"%@",comment.content];
    }
    UMComMutiText *commentMutiText =  [UMComMutiText mutiTextWithSize:CGSizeMake(self.view.frame.size.width-UMCom_Micro_Comment_LeftEdge-UMCom_Micro_Comment_RightEdge, MAXFLOAT) font:UMComFontNotoSansLightWithSafeSize(UMCom_Micro_Comment_TextFontSize) string:replayStr lineSpace:2 checkWords:checkWords textColor:UMComColorWithHexString(UMCom_Micro_Comment_TextCollor)];
    CGSize textSize = commentMutiText.textSize;
    textSize.height = commentMutiText.textSize.height + 10;
    commentMutiText.textSize = textSize;
    NSMutableDictionary *commentDict = [NSMutableDictionary dictionary];
    [commentDict setValue:comment forKey:kUMComComment];
    [commentDict setValue:commentMutiText forKey:kUMComCommentMutitext];
    return commentDict;
}


#pragma mark - button action

- (void)didClickOnLike:(UIButton *)sender {
    __weak typeof(self) weakSelf = self;
    UMComFeed* feed =  self.feed;
    [UMComLoginManager performLogin:self completion:^(id responseObject, NSError *error) {
        if (!error) {
            [self.feedDetailDataController likeFeedWithCompletion:^(id responseObject, NSError *error) {
                
                if (!error) {
                    NSDictionary* dic =  (NSDictionary*)responseObject;
                    if (dic && [dic isKindOfClass:[NSDictionary class]]) {
                        
                        id feedLikeValue =  [dic valueForKey:UMComModelFeedLikeKey];
                        if (feedLikeValue && [feedLikeValue isKindOfClass:[NSNumber class]]) {
                            feed.liked = feedLikeValue;
                            if (feed.liked.boolValue) {
                                [UMComShowToast likeFeedSuccess];
                            }
                            else{
                                [UMComShowToast unlikeFeedSuccess];
                            }
                            //[weakSelf.tableView reloadData];
                        }
                    }
                }else{
                    if (ERR_CODE_LIKE_HAS_BEEN_CANCELED == error.code ||
                        ERR_CODE_FEED_HAS_BEEN_LIKED == error.code) {
                        //[weakSelf.tableView reloadData];
                    }
                    [UMComShowToast showFetchResultTipWithError:error];
                }
                
                UIImage *image = nil;
                NSString *title = nil;
                UMComUser *loginUser = [UMComSession sharedInstance].loginUser;
                if ([weakSelf.feed.liked boolValue]) {
                    title = UMComLocalizedString(@"um_com_cancel", @"取消");
                    image =  UMComImageWithImageName(@"um_micro_like_highlight");
                    if ([loginUser isKindOfClass:[UMComUser class]]) {
                        if (![weakSelf.likeArray containsObject:loginUser]) {
                            [weakSelf.likeArray insertObject:loginUser atIndex:0];
                        }
                    }

                }else{
                    title = UMComLocalizedString(@"cancel", @"点赞");
                    image = UMComImageWithImageName(@"um_micro_like_normal");
                    if ([loginUser isKindOfClass:[UMComUser class]]) {
                        if ([weakSelf.likeArray containsObject:loginUser]) {
                            [weakSelf.likeArray removeObject:loginUser];
                        }
                    }
                }
                [sender setImage:image forState:UIControlStateNormal];
                
                if (weakSelf.childViewType == UMComFeedDetailChildViewType_Like) {
                    weakSelf.dataArray = weakSelf.likeArray;
                }
                [weakSelf.tableView reloadData];
                if (weakSelf.feedOperationFinishDelegate && [weakSelf.feedOperationFinishDelegate respondsToSelector:@selector(reloadDataWhenFeedOperationFinish:)]) {
                    [weakSelf.feedOperationFinishDelegate reloadDataWhenFeedOperationFinish:weakSelf.feed];
                }
            }];
        }
    }];
}

- (void)didClickOnForward:(UIButton *)sender {
    __weak typeof(self) weakself = self;
    [UMComLoginManager performLogin:self completion:^(id responseObject, NSError *error) {
        if (!error) {
            UMComEditViewController *editViewController = [[UMComEditViewController alloc] initWithForwardFeed:weakself.feed];
            editViewController.feedOperationFinishDelegate = weakself.feedOperationFinishDelegate;
            UMComNavigationController *editNaviController = [[UMComNavigationController alloc] initWithRootViewController:editViewController];
            [weakself presentViewController:editNaviController animated:YES completion:nil];
        }
    }];
}

- (void)didClikeOnComment:(UIButton *)sender
{
    __weak typeof(self) weakself = self;
    [UMComLoginManager performLogin:self completion:^(id responseObject, NSError *error) {
        if (!error) {
            [weakself showCommentEditViewWithComment:nil feed:self.feed];
        }
    }];
}




#pragma mark - showActionView
- (void)displayMoreMenu:(UIButton *)sender
{
    [self showActionSheetWithFeed:self.feed];
}



#pragma mark - UIAlertView
- (void)showSureActionMessage:(NSString *)message
{
    [[[UIAlertView alloc]initWithTitle:nil message:message delegate:self cancelButtonTitle:UMComLocalizedString(@"um_com_cancel", @"取消") otherButtonTitles:UMComLocalizedString(@"um_com_yes", @"是"), nil] show];
}

/****************UMComClickActionDelegate**********************************/

#pragma mark - UMComClickActionDelegate
- (void)willPresentActionSheet:(UIActionSheet *)actionSheet;
{
    UIImageView *imageView = [[UIImageView alloc]initWithImage:UMComImageWithImageName(@"spam")];
    [actionSheet addSubview:imageView];
}


- (void)customObj:(id)obj clickOnFeedText:(UMComFeed *)feed
{

}

- (void)customObj:(id)obj clickOnLikeComment:(UMComComment *)comment
{
    __weak typeof(self) weakSelf = self;
    [UMComLoginManager performLogin:self completion:^(id responseObject, NSError *error) {
        if (!error) {
            [weakSelf.feedCommnetListDataController likeComment:comment completion:^(NSError *error) {
                [UMComShowToast like:error liked:comment.liked.boolValue];
                
               [weakSelf.tableView reloadData];
               if (weakSelf.feedOperationFinishDelegate && [weakSelf.feedOperationFinishDelegate respondsToSelector:@selector(reloadDataWhenFeedOperationFinish:)]) {
                   [weakSelf.feedOperationFinishDelegate reloadDataWhenFeedOperationFinish:weakSelf.feed];
               }
                
            }];
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark -

- (void)postFeedCompleteSucceed:(NSNotification *)notification
{
    [self.tableView reloadData];
}

- (void)feedDeletedCompletion:(NSNotification *)notification
{
    UMComFeed *feed = notification.object;
    [self.navigationController popViewControllerAnimated:YES];
    if (self.feedOperationFinishDelegate && [self.feedOperationFinishDelegate respondsToSelector:@selector(deleteFeedFinish:)]) {
        [self.feedOperationFinishDelegate deleteFeedFinish:feed];
    }
}


#pragma mark - CommentAction

- (void)clickOnCommentCell:(UMComComment *)comment
{
    //    self.selectdIndexPath = [self.tableView indexPathForCell:obj];
    self.selectedComment = comment;
    __weak typeof(self) weakSelf = self;
    NSMutableArray *titles = [NSMutableArray array];
    NSString *title = UMComLocalizedString(@"um_com_spamContent", @"举报内容");
    if (![comment.creator.uid isEqualToString:[UMComSession sharedInstance].uid]) {
        [titles addObject:title];
    }
    //当前feed的用户和登陆用户是一样的，不管comment是登陆用户还是自己评论的，不需要举报
    if (([[UMComSession sharedInstance].uid isEqualToString:self.feed.creator.uid]) /*&&  (![comment.creator.uid isEqualToString:[UMComSession sharedInstance].uid])*/) {
        //直接删除上面的加入的举报字段
        [titles removeAllObjects];
    }
    //如果当前是全局管理员,不需要举报
    NSNumber* typeNumber = [UMComSession sharedInstance].loginUser.atype;
    if(typeNumber && typeNumber.shortValue == 1)
    {
        //直接删除上面的加入的举报字段
        [titles removeAllObjects];
    }
    if ([[UMComSession sharedInstance] isPermissionDeleteComment:comment]) {//zhangjunhua
        title = UMComLocalizedString(@"um_com_delete", @"删除");
        [titles addObject:title];
    }
    title = UMComLocalizedString(@"um_com_replyComment", @"回复");
    [titles addObject:title];
    
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:nil
                                                       delegate:self
                                              cancelButtonTitle:UMComLocalizedString(@"um_com_cancel", @"取消")
                                         destructiveButtonTitle:nil
                                              otherButtonTitles:nil];
    for (int i = 0; i < titles.count; ++i) {
        [sheet addButtonWithTitle:titles[i]];
    }
    sheet.tag = 10001;
    [sheet showInView:[UIApplication sharedApplication].keyWindow];
}

- (void)replyContent:(NSString *)content toPost:(UMComFeed *)feed fromComment:(UMComComment *)comment imageList:(NSArray *)imageList
{
    if ((content.length == 0 && imageList.count == 0) || !feed) {
        return;
    }
    
    __weak typeof(self) weakself = self;
    if (comment) {
        //回复评论
        
        [self.feedCommnetListDataController replyCommentFeed:self.feed comment:comment content:content images:imageList completion:^(id responseObject, NSError *error) {
            if (error) {
                [UMComShowToast showFetchResultTipWithError:error];
            } else {
                [UMComShowToast fetchFailWithNoticeMessage:UMComLocalizedString(@"um_com_commentSuccess", @"评论成功")];
                UMComComment *comment = responseObject;
                NSDictionary *dic = [self dictWithComment:comment];
                if ([dic isKindOfClass:[NSDictionary class]]) {
                    [weakself.commentArray insertObject:dic atIndex:0];
                    if (weakself.childViewType == UMComFeedDetailChildViewType_Comment) {
                        weakself.dataArray = self.commentArray;
                    }
                    [self.tableView reloadData];
                }
                
            }
            if (self.feedOperationFinishDelegate && [self.feedOperationFinishDelegate respondsToSelector:@selector(reloadDataWhenFeedOperationFinish:)]) {
                [self.feedOperationFinishDelegate reloadDataWhenFeedOperationFinish:feed];
            }
            if (UMComSystem_Version_Greater_Than_Or_Equal_To(@"7.0")) {
                [self setNeedsStatusBarAppearanceUpdate];
            }
            
        }];
    }
    else
    {
        //回复feed
        [self.feedCommnetListDataController commentFeed:self.feed content:content images:imageList completion:^(id responseObject, NSError *error) {
            
            if (error) {
                [UMComShowToast showFetchResultTipWithError:error];
            } else {
                [UMComShowToast fetchFailWithNoticeMessage:UMComLocalizedString(@"um_com_commentSuccess", @"评论成功")];
                UMComComment *comment = responseObject;
                NSDictionary *dic = [self dictWithComment:comment];
                if ([dic isKindOfClass:[NSDictionary class]]) {
                    [weakself.commentArray insertObject:dic atIndex:0];
                    if (weakself.childViewType == UMComFeedDetailChildViewType_Comment) {
                        weakself.dataArray = self.commentArray;
                    }
                    [self.tableView reloadData];
                }
                
            }
            if (self.feedOperationFinishDelegate && [self.feedOperationFinishDelegate respondsToSelector:@selector(reloadDataWhenFeedOperationFinish:)]) {
                [self.feedOperationFinishDelegate reloadDataWhenFeedOperationFinish:feed];
            }
            if (UMComSystem_Version_Greater_Than_Or_Equal_To(@"7.0")) {
                [self setNeedsStatusBarAppearanceUpdate];
            }
        }];
    }
    

}


- (void)showActionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex;
{
    if (actionSheet.tag == 10001) {
        if ([[actionSheet buttonTitleAtIndex:buttonIndex] isEqualToString:UMComLocalizedString(@"um_com_delete", @"删除")]) {
            [self deleteComment];
        }else if ([[actionSheet buttonTitleAtIndex:buttonIndex] isEqualToString:UMComLocalizedString(@"um_com_report", @"举报")]){
            [self spamComment];
        }else if ([[actionSheet buttonTitleAtIndex:buttonIndex] isEqualToString:UMComLocalizedString(@"um_com_replyComment", @"回复")]){
            [self showCommentEditViewWithComment:self.selectedComment feed:self.feed];
        }
    }
}


#pragma mark - comment  Action
- (void)deleteComment
{
    __weak typeof(self) weakSelf = self;
    [UMComLoginManager performLogin:self completion:^(id responseObject, NSError *error) {
        if (!error) {
            
            weakSelf.feedDetailDataController.feed =  weakSelf.feed;
            [weakSelf.feedCommnetListDataController deletedComment:weakSelf.selectedComment completion:^(NSError *error) {
                [weakSelf.commentArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    NSDictionary *dict = obj;
                    UMComComment *comment = [dict valueForKey:kUMComComment];
                    if ([comment.commentID isEqualToString:weakSelf.selectedComment.commentID]) {
                        *stop = YES;
                        [weakSelf.commentArray removeObject:dict];
                        if (weakSelf.childViewType == UMComFeedDetailChildViewType_Comment) {
                            weakSelf.dataArray =  weakSelf.commentArray;
                            [weakSelf.tableView reloadData];
                        }

                        if (weakSelf.feedOperationFinishDelegate && [weakSelf.feedOperationFinishDelegate respondsToSelector:@selector(reloadDataWhenFeedOperationFinish:)]) {
                            [weakSelf.feedOperationFinishDelegate reloadDataWhenFeedOperationFinish:weakSelf.feed];
                        }
                    }
                }];
            }];
        }
    }];
}

- (void)spamComment
{
    __weak typeof(self) weakself = self;
    [UMComLoginManager performLogin:self completion:^(id responseObject, NSError *error) {
        if (!error) {
            [weakself.feedCommnetListDataController spamComment:self.selectedComment completion:^(NSError *error) {
                [UMComShowToast spamComment:error];
            }];
        }
    }];
}

#pragma mark - feed请求
- (void)requestPostData
{
    if (self.feedId.length == 0) {
        return;
    }
    
    [self.feedDetailDataController refreshFeedWithCompletion:^(id responseObject, NSError *error) {
        
        if ([responseObject isKindOfClass:[UMComFeed class]]) {
            self.feed = (UMComFeed*)responseObject;
            [self resetFeedStyle];
        }
        else
        {
            [UMComShowToast showFetchResultTipWithError:error];
        }
        [self.tableView reloadData];
    }];
}

#pragma mark - 重写下拉刷新的函数
- (void)refreshData
{
    [self requestPostData];
    [super refreshData];
}


- (void)resetHtmlFeedStyle
{
    if (!self.htmlFeedStyle) {
        self.htmlFeedStyle = [[UMComHtmlFeedStyle alloc] initWithFeed:self.feed viewWidth:self.tableView.frame.size.width];
    }
    [self.htmlFeedStyle resetWithFeed:self.feed];
}

-(BOOL) isHtmlData
{
    if (self.feed.media_type.intValue == 1 &&  self.feed.rich_text && self.feed.rich_text.length > 0) {
        return YES;
    }
    return NO;
}

#pragma mark - UMComHtmlBodyCellDelegate
-(void)UMComHtmlBodyCellDidFinishLoad:(UMComFeedDetailViewHtmlBodyCell*)cell
{
    [self resetHtmlFeedStyle];
    [self.tableView reloadData];
}

#pragma mark - feed operation

- (void)deleteFeed:(UMComFeed *)feed
{
    if (!feed) {
        return;
    }
    __weak typeof(self) weakself = self;
    [UMComLoginManager performLogin:self completion:^(id responseObject, NSError *error) {
        if (!error) {
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
            [weakself.feedDetailDataController deletedFeedWithCompletion:^(id responseObject, NSError *error) {
                if (error){
                    [UMComShowToast showFetchResultTipWithError:error];
                }
            }];
        }
    }];
}

- (void)collectFeed:(id)sender
{
    UMComFeed *feed = nil;
    if ([sender isKindOfClass:[UMComFeed class]]) {
        feed = sender;
    }else{
        feed = self.feed;
    }
    __weak typeof(self) weakSelf = self;
    BOOL isFavourite = ![[feed has_collected] boolValue];
    [UMComLoginManager performLogin:self completion:^(id responseObject, NSError *error) {
        if (!error) {
            
            [weakSelf.feedDetailDataController favoriteFeedWithCompletion:^(id responseObject, NSError *error) {
                [UMComShowToast favouriteFeedFail:error isFavourite:isFavourite];
                UIImage *image = nil;
                if ([weakSelf.feed.has_collected boolValue]) {
                    image = UMComImageWithImageName(@"um_forum_collection_highlight");
                }else{
                    image = UMComImageWithImageName(@"um_forum_collection_normal");
                }
                [weakSelf.collectionButton setImage:image forState:UIControlStateNormal];
                if (weakSelf.feedOperationFinishDelegate && [weakSelf.feedOperationFinishDelegate respondsToSelector:@selector(reloadDataWhenFeedOperationFinish:)]) {
                    [weakSelf.feedOperationFinishDelegate reloadDataWhenFeedOperationFinish:feed];
                }
            }];
        }
    }];
}

- (void)shareFeed:(UMComFeed *)feed
{
    if (!feed) {
        return;
    }
    self.shareListView = [[UMComShareCollectionView alloc]initWithFrame:CGRectMake(0, self.view.window.frame.size.height, self.view.window.frame.size.width,120)];
    self.shareListView.feed = feed;
    self.shareListView.shareViewController = self;
    [self.shareListView shareViewShow];
}

- (void)spamUser:(UMComUser *)user
{
    __weak typeof(self) weakSelf = self;
    [UMComLoginManager performLogin:self completion:^(id responseObject, NSError *error) {
        if (!error) {
            [weakSelf.feedDetailDataController spamUser:user completion:^(id responseObject, NSError *error) {
                [UMComShowToast spamUser:error];
            }];
        }
    }];
}

- (void)spamFeed:(UMComFeed *)feed
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


- (void)copyFeed:(UMComFeed *)feed
{
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


@end



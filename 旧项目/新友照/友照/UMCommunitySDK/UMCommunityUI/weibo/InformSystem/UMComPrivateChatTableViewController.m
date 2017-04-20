//
//  UMComForumPrivateChatTableViewController.m
//  UMCommunity
//
//  Created by umeng on 15/12/1.
//  Copyright © 2015年 Umeng. All rights reserved.
//

#import "UMComPrivateChatTableViewController.h"
#import <UMComDataStorage/UMComUser.h>
#import "UMComCommentEditView.h"
#import <UMCommunitySDK/UMComSession.h>
#import "UMComImageView.h"
#import "UMComMutiStyleTextView.h"
#import "UMComResouceDefines.h"
#import <UMComDataStorage/UMComPrivateMessage.h>
#import "UIViewController+UMComAddition.h"
#import <UMComDataStorage/UMComPrivateLetter.h>
#import "UMComEditTextView.h"
#import "UMComUserCenterViewController.h"
#import "UIViewController+UMComAddition.h"
#import <UMComDataStorage/UMComImageUrl.h>
#import "UMComShowToast.h"
#import <UMComDataStorage/UMComUnReadNoticeModel.h>
#import "UMComChatRecodTableViewCell.h"
#import "UMComPrivateMessageListDataController.h"
#import "UMComUserDataController.h"
#import "UMComRefreshView.h"
#import <UMComFoundation/UMComKit+Color.h>

NSString *const kUMComMutitext = @"mutitext";
NSString *const kUMComPrivateMessage = @"privateMessage";


@interface UMComPrivateChatTableViewController ()

@property (nonatomic, strong) UMComPrivateLetter *privateLetter;

@property (nonatomic, strong) UMComEditTextView *chatEditTextView;

@property (nonatomic, strong) UIView *chatEditTextBgView;

@property (nonatomic, strong) NSMutableArray *chatDataArray;

@property (nonatomic, strong) UMComUser *chatUser;

@property (nonatomic, strong) UIView *bgView;

@property (nonatomic, assign) UIEdgeInsets scrollViewOriginalInset;

@property(nonatomic,strong)UMComUserDataController* userDataController;

-(void) changeOriginArray:(NSArray*)originArray;


@end

@implementation UMComPrivateChatTableViewController


- (instancetype)initWithUser:(UMComUser *)user
{
    self = [super init];
    if (self) {
        _chatUser = user;
    }
    return self;
}
- (instancetype)initWithPrivateLetter:(UMComPrivateLetter *)privateLetter
{
    self = [self initWithUser:privateLetter.user];
    if (self) {
        _privateLetter = privateLetter;
       self.dataController =  [[UMComPrivateMessageListDataController alloc] initWithCount:UMCom_Limit_Page_Count privateLetter:self.privateLetter];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setForumUITitle:self.chatUser.name];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.view.backgroundColor = UMComColorWithHexString(UMCom_Forum_Chat_Cell_BgColor);
    
    [self setTitleViewWithTitle:self.privateLetter.user.name];
    self.chatDataArray = [NSMutableArray array];
    
    self.isAutoStartLoadData = NO;
    
    //初始化聊天窗口
    [self initChatData];
    
    //重置刷新控件
    [self resetRefreshView];
    
    //创建发送编辑框
    [self creatSenderEditFrameViews];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        UIEdgeInsets contentInset = self.tableView.contentInset;
        contentInset.bottom = contentInset.bottom + UMCom_Forum_Chat_SendFrame_Heigt;
        self.tableView.contentInset = contentInset;
        self.scrollViewOriginalInset = self.tableView.contentInset;
    });

    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hiddenKeyBoard:)];
    [self.view addGestureRecognizer:tap];
    
    // Do any additional setup after loading the view.
}

- (void)setScrollViewOriginalInset:(UIEdgeInsets)scrollViewOriginalInset
{
    _scrollViewOriginalInset = scrollViewOriginalInset;
    self.refreshHeadView.scrollViewOriginalInset = scrollViewOriginalInset;
    self.refreshFootView.scrollViewOriginalInset = scrollViewOriginalInset;
}

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
}

- (void)initChatData
{
    __weak typeof(self) weakSelf = self;
    self.refreshSeverDataCompletionHandler = ^(NSArray *data, NSError *error){
        [UMComSession sharedInstance].unReadNoticeModel.notiByPriMessageCount -= [weakSelf.privateLetter.unread_count integerValue];
        weakSelf.privateLetter.unread_count = @0;
    };
    if (self.privateLetter) {
        
        if (!self.dataController) {
            self.dataController =  [[UMComPrivateMessageListDataController alloc] initWithCount:UMCom_Limit_Page_Count privateLetter:self.privateLetter];
        }
        
        [self.dataController refreshNewDataCompletion:^(NSArray *responseData, NSError *error) {
            [UMComSession sharedInstance].unReadNoticeModel.notiByPriMessageCount -= [weakSelf.privateLetter.unread_count integerValue];
            weakSelf.privateLetter.unread_count = @0;
            [weakSelf changeOriginArray:weakSelf.dataController.dataArray];
            [weakSelf.tableView reloadData];
        }];
    }else{
        if (!self.userDataController) {
            
            self.userDataController  = [UMComUserDataController userDataControllerWithUser:self.chatUser];
        }
        
        [self.userDataController  creatChartBoxWithCompletion:^(UMComPrivateLetter* responseObject, NSError *error) {
            if (error) {
                [UMComShowToast showFetchResultTipWithError:error];
                [weakSelf.navigationController popViewControllerAnimated:YES];
            }
            else
            {
                if ([responseObject isKindOfClass:[UMComPrivateLetter class]]) {
                    weakSelf.privateLetter = responseObject;
                    
                    if (!weakSelf.dataController) {
                        weakSelf.dataController =  [[UMComPrivateMessageListDataController alloc] initWithCount:UMCom_Limit_Page_Count privateLetter:weakSelf.privateLetter];
                        [weakSelf.dataController refreshNewDataCompletion:^(NSArray *responseData, NSError *error) {
                            [UMComSession sharedInstance].unReadNoticeModel.notiByPriMessageCount -= [weakSelf.privateLetter.unread_count integerValue];
                            weakSelf.privateLetter.unread_count = @0;
                            [weakSelf changeOriginArray:weakSelf.dataController.dataArray];
                            [weakSelf.tableView reloadData];
                        }];
                    }
                }
            }
            
        }];
    }
}

- (void)resetRefreshView
{
    self.refreshFootView.noticeForLoadStatusBlock = ^(UMLoadStatus loadStatus){
        switch (loadStatus) {
            case UMNomalStatus:
                return @"刷新完成";
                break;
            case UMPullingStatus:
                return @"上拉可以刷新";
                break;
            case UMPreLoadStatus:
                return @"松手即可刷新";
                break;
            case UMLoadingStatus:
                return @"正在刷新";
                break;
            case UMNoMoredStatus:
                return @"已经是最新数据了";
                break;
            default:
                break;
        }
    };
    [self.refreshHeadView.dateLable removeFromSuperview];
    self.refreshHeadView.dateLable = nil;
    self.refreshHeadView.noticeForLoadStatusBlock = ^(UMLoadStatus loadStatus){
        switch (loadStatus) {
            case UMNomalStatus:
                return @"加载完成";
                break;
            case UMPullingStatus:
                return @"下拉可以加载更多历史聊天记录";
                break;
            case UMPreLoadStatus:
                return @"松手即可加载更多";
                break;
            case UMLoadingStatus:
                return @"正在加载";
                break;
            case UMNoMoredStatus:
                return @"已经是最后一页数据了";
                break;
            default:
                break;
        }
    };
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHidden:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self hiddenKeyBoard:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)creatSenderEditFrameViews
{
    CGFloat chatEditTextBgViewHeight = UMCom_Forum_Chat_SendFrame_Heigt;
    CGFloat itemSpace = UMCom_Forum_Chat_SendFrame_ViewsSpace;
    CGFloat  buttonWidth = UMCom_Forum_Chat_SendButton_Width;
    
    _chatEditTextBgView = [[UIView alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height-chatEditTextBgViewHeight, self.view.frame.size.width, chatEditTextBgViewHeight)];
    _chatEditTextBgView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
    UIView *topLine = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 1)];
    _chatEditTextBgView.backgroundColor = UMComColorWithHexString(UMCom_Forum_Chat_Cell_BgColor);
    topLine.backgroundColor = UMComColorWithHexString(UMCom_Forum_Chat_SendFrame_LineColor);
    [_chatEditTextBgView addSubview:topLine];
    _chatEditTextView = [[UMComEditTextView alloc]initWithFrame:CGRectMake(itemSpace, itemSpace, self.view.frame.size.width-buttonWidth-itemSpace*3, chatEditTextBgViewHeight-itemSpace*2)];
    _chatEditTextView.font = UMComFontNotoSansLightWithSafeSize(UMCom_Forum_Chat_Message_Font);
    _chatEditTextView.layer.cornerRadius = 5;

    _chatEditTextView.backgroundColor = [UIColor whiteColor];
    
    [_chatEditTextBgView addSubview:_chatEditTextView];
    [self.view addSubview:_chatEditTextBgView];
    
    UIButton *senderBt = [UIButton buttonWithType:UIButtonTypeCustom];
    senderBt.frame = CGRectMake(self.view.frame.size.width - buttonWidth - itemSpace, itemSpace, buttonWidth, chatEditTextBgViewHeight-itemSpace*2);
    senderBt.layer.cornerRadius = 5;
    senderBt.clipsToBounds = YES;
    [senderBt setTitleColor:UMComColorWithHexString(@"#FFFFFF") forState:UIControlStateNormal];
    [senderBt setTitle:@"发送" forState:UIControlStateNormal];
    senderBt.backgroundColor = UMComColorWithHexString(UMCom_Forum_Chat_SendButton_NomalColor);
    [senderBt addTarget:self action:@selector(didClickOnSendButton:) forControlEvents:UIControlEventTouchUpInside];
    [_chatEditTextBgView addSubview:senderBt];
}

#pragma mark -

- (void)hiddenKeyBoard:(id)sender
{
    [self.chatEditTextView resignFirstResponder];
}

- (void)keyboardWillShow:(NSNotification *)notification
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [UIView animateWithDuration:0.1 animations:^{
            CGRect keybordFrame = [[[notification userInfo] objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue];
            float endheight = keybordFrame.size.height;
            CGRect editFrame = self.chatEditTextBgView.frame;
            editFrame.origin.y = self.view.frame.size.height - endheight - editFrame.size.height;
            self.chatEditTextBgView.frame = editFrame;
            
            UIEdgeInsets contentInset = self.tableView.contentInset;
            contentInset.bottom = endheight+editFrame.size.height;
            self.tableView.contentInset = contentInset;
            self.refreshHeadView.scrollViewOriginalInset = self.tableView.contentInset;
            self.refreshFootView.scrollViewOriginalInset = self.tableView.contentInset;
            [self resetTableViewContentOffset];
            
        }];
    });

}

- (void)keyboardWillHidden:(NSNotification *)notification
{
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:0.2 animations:^{
        CGRect editFrame = weakSelf.chatEditTextBgView.frame;
        editFrame.origin.y = weakSelf.view.frame.size.height - editFrame.size.height;
        weakSelf.chatEditTextBgView.frame = editFrame;
        weakSelf.tableView.contentInset = weakSelf.scrollViewOriginalInset;
        weakSelf.refreshHeadView.scrollViewOriginalInset = weakSelf.scrollViewOriginalInset;
        weakSelf.refreshFootView.scrollViewOriginalInset = weakSelf.scrollViewOriginalInset;
        [weakSelf resetTableViewContentOffset];
    }];
}

- (void)resetTableViewContentOffset
{
    if (self.chatDataArray.count > 0) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.chatDataArray.count-1 inSection:0];
        [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:NO];
    }else{
        if (self.tableView.contentSize.height > self.tableView.frame.size.height) {
            [self.tableView setContentOffset:CGPointMake(self.tableView.contentOffset.x,  self.tableView.contentSize.height - self.tableView.frame.size.height)];
        }
    }
}

#pragma mark - UITableViewDeleagte
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.chatDataArray.count > 0) {
        self.noDataTipLabel.hidden = YES;
    }else{
        self.noDataTipLabel.hidden = NO;
    }
    return self.chatDataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UMComMutiText *mutiText = [self.chatDataArray[indexPath.row] valueForKey:kUMComMutitext];
    return mutiText.textSize.height + UMCom_Forum_Chat_DateMessage_Space*2 + UMCom_Forum_Chat_Message_ShortEdge *2 + UMCom_Forum_Chat_DateLabel_Height + UMCom_Forum_Chat_Cell_Space;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UMComPrivateMessage *privateMessage = [self.chatDataArray[indexPath.row] valueForKey:kUMComPrivateMessage];
    UMComChatRecodTableViewCell *cell = nil;
    if (![privateMessage.creator.uid isEqualToString:[UMComSession sharedInstance].uid]) {//!
        static NSString *leftcellID = @"leftcellID";
        cell = [tableView dequeueReusableCellWithIdentifier:leftcellID];
        if (!cell) {
            cell = [[UMComChatReceivedTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:leftcellID];
        }
    }else{
        static NSString *rightCellID = @"rightCellID";
        cell = [tableView dequeueReusableCellWithIdentifier:rightCellID];
        if (!cell) {
            cell = [[UMComChatSendTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:rightCellID];
        }
    }
    UMComMutiText *mutiText = [self.chatDataArray[indexPath.row] valueForKey:kUMComMutitext];
    __weak typeof(self) weakSelf = self;
    cell.clickOnUser = ^(){
        UMComUserCenterViewController *userCenter = [[UMComUserCenterViewController alloc]initWithUser:privateMessage.creator];
        [weakSelf.navigationController pushViewController:userCenter animated:YES];
    };
    if (indexPath.row < self.chatDataArray.count) {
        [cell reloadTabelViewCellWithMessage:privateMessage mutiText:mutiText cellSize:CGSizeMake(tableView.frame.size.width, mutiText.textSize.height+40)];
    }
    return cell;
}

//请求下一页
- (void)refreshData
{
    if (self.dataController == nil || self.dataController.haveNextPage == NO) {
        [self.refreshHeadView noMoreData];
        return;
    }
    
    if (self.isLoadFinish == NO) {
        return;
    }
    self.isLoadFinish = NO;
    __weak typeof(self) weakSelf = self;
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    [self.dataController loadNextPageDataWithCompletion:^(NSArray *responseData, NSError *error) {
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        weakSelf.isLoadFinish = YES;
        if (weakSelf.dataController.haveNextPage) {
            [weakSelf.refreshHeadView endLoading];
        }else{
            [weakSelf.refreshHeadView noMoreData];
        }
        [weakSelf.refreshFootView endLoading];
        [weakSelf handleNextPageData:responseData error:error];
        if (responseData) {
            [weakSelf.tableView reloadData];
        }
    }];
    

}

//上拉刷新
- (void)loadMoreData
{
    if (self.isLoadFinish == NO) {
        return;
    }
    if (self.dataController == nil) {
        [self.refreshFootView noMoreData];
        return;
    }
    
    if (self.dataController.isReadLoacalData) {
        //设置NO只会第一次下拉刷新取本地数据
        self.dataController.isReadLoacalData = NO;
        [self fetchLocalData];
    }
    else{
        [self refreshDataFromServer];
    }
}

-(void)refreshDataFromServer
{
    if (self.isLoadFinish == NO) {
        return;
    }
    self.isLoadFinish = NO;
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    __weak typeof(self) weakSelf = self;
    [self.dataController refreshNewDataCompletion:^(NSArray *responseData, NSError *error) {
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        if (weakSelf.dataController.haveNextPage) {
            [weakSelf.refreshHeadView endLoading];
        }else{
            [weakSelf.refreshHeadView noMoreData];
        }
        [weakSelf.refreshFootView endLoading];
        weakSelf.isLoadFinish = YES;
        if (weakSelf.refreshSeverDataCompletionHandler) {
            weakSelf.refreshSeverDataCompletionHandler(responseData, error);
        }
        [weakSelf handleFirstPageData:responseData error:error];
        [weakSelf.tableView reloadData];
    }];
}

#pragma mark - data handle
- (void)handleLocalData:(NSArray *)data error:(NSError *)error
{
    if (!error && [data isKindOfClass:[NSArray class]]) {
        for (UMComPrivateMessage *privateMessage in data) {
            [self insertCellWithPrivateMessage:privateMessage isMore:NO];
        }
    }
}

- (void)handleFirstPageData:(NSArray *)data error:(NSError *)error
{
    if (!error && [data isKindOfClass:[NSArray class]]) {
        [self.chatDataArray removeAllObjects];
        [self.tableView reloadData];
        
        for (UMComPrivateMessage *privateMessage in data) {
            [self insertCellWithPrivateMessage:privateMessage isMore:NO];
        }
    }
    [self resetTableViewContentOffset];

}

- (void)handleNextPageData:(NSArray *)data error:(NSError *)error
{
    if (!error && [data isKindOfClass:[NSArray class]]) {
        for (UMComPrivateMessage *privateMessage in data) {
            [self insertCellWithPrivateMessage:privateMessage isMore:YES];
        }
    }
}

- (void)insertCellWithPrivateMessage:(UMComPrivateMessage *)privateMessage isMore:(BOOL)isMore
{
    CGFloat textWidth = self.view.frame.size.width-(UMCom_Forum_Chat_Icon_Edge*2+UMCom_Forum_Chat_Icon_Width + UMCom_Forum_Chat_Message_ShortEdge*2 + UMCom_Forum_Chat_Message_LongEdge);
    UMComMutiText *mutiText = [UMComMutiText mutiTextWithSize:CGSizeMake(textWidth, MAXFLOAT) font:UMComFontNotoSansLightWithSafeSize(UMCom_Forum_Chat_Message_Font) string:privateMessage.content lineSpace:2 checkWords:nil textColor:UMComColorWithHexString(UMCom_Forum_Chat_ReceivedMsg_TextColor)];
    NSMutableDictionary *dataDict = [NSMutableDictionary dictionary];
    [dataDict setValue:privateMessage forKey:kUMComPrivateMessage];
    [dataDict setValue:mutiText forKey:kUMComMutitext];
    CGFloat index = 0;
    if (!isMore) {
        [self.chatDataArray addObject:dataDict];
        index = self.chatDataArray.count - 1;
    }else{
        [self.chatDataArray insertObject:dataDict atIndex:0];
    }
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
    [self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationNone];
    [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:NO];
}


#pragma mark - sender chat message

- (void)didClickOnSendButton:(UIButton *)sender
{
    [sender setBackgroundColor:UMComColorWithHexString(UMCom_Forum_Chat_SendButton_HighLightColor)];
    __weak typeof(self) weakSelf = self;
    if (!self.chatEditTextView.text || self.chatEditTextView.text.length == 0) {
           [sender setBackgroundColor:UMComColorWithHexString(UMCom_Forum_Chat_SendButton_NomalColor)];
        return;
    }else{
        [((UMComPrivateMessageListDataController*)self.dataController) sendMessageToUser:self.privateLetter.user  message:self.chatEditTextView.text completion:^(id responseObject, NSError *error) {
            [sender setBackgroundColor:UMComColorWithHexString(UMCom_Forum_Chat_SendButton_NomalColor)];
            if (!error) {
                weakSelf.chatEditTextView.text = nil;
                [weakSelf insertCellWithPrivateMessage:responseObject isMore:NO];
            }else{
                [weakSelf.chatEditTextView resignFirstResponder];
                [UMComShowToast showFetchResultTipWithError:error];
            }
        }];
    }

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) changeOriginArray:(NSArray*)originArray
{
    for (UMComPrivateMessage *privateMessage in originArray) {
        [self insertCellWithPrivateMessage:privateMessage isMore:NO];
    }
}

@end


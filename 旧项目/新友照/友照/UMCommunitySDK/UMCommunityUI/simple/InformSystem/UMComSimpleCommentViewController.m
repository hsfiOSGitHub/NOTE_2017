//
//  UMComSimpleCommentViewController.m
//  UMCommunity
//
//  Created by wyq.Cloudayc on 5/25/16.
//  Copyright © 2016 Umeng. All rights reserved.
//

#import "UMComSimpleCommentViewController.h"
#import "UIViewController+UMComAddition.h"
#import "UMComResouceDefines.h"
#import "UMComSimpleSubCommentViewController.h"
#import "UMComCommentListDataController.h"
#import "UMComFeedClickActionDelegate.h"
#import "UMComSimpleFeedDetailViewController.h"
#import "UMComSimplicityUserCenterViewController.h"
#import <UMCommunitySDK/UMComSession.h>
#import <UMComDataStorage/UMComUnReadNoticeModel.h>
#import "UMComWebViewController.h"
#import <UMComDataStorage/UMComModelObjectHeader.h>
#import <UMComFoundation/UMComKit+Color.h>

@interface UMComSimpleCommentViewController ()
<UMComFeedClickActionDelegate>

@property (nonatomic, strong) UIButton *sentCommentButton;
@property (nonatomic, strong) UIButton *receivedCommentButton;
@property (nonatomic, strong) CALayer *lineLayer;
@property (nonatomic, weak) UIViewController *currentVC;

@property (nonatomic, strong) UMComSimpleSubCommentViewController *sentCommentVC;
@property (nonatomic, strong) UMComSimpleSubCommentViewController *receivedCommentVC;

@end

@implementation UMComSimpleCommentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [self setForumUITitle:UMComLocalizedString(@"um_com_my_comment", @"评论")];
    
    [self initButton];
    
    [self initController];
    
    [self switchToReceivedComment];
    self.view.backgroundColor = UMComColorWithHexString(@"#e8eaee");
    
    [UMComSession sharedInstance].unReadNoticeModel.notiByCommentCount = 0;
}

- (void)initButton
{
    self.sentCommentButton = [self getButtonWithName:UMComLocalizedString(@"um_com_sent_comment", @"发出的评论") selector:@selector(switchToSentComment)];
    CGSize viewSize = self.view.frame.size;
    _sentCommentButton.frame = CGRectMake(viewSize.width / 2.f, 0.f, viewSize.width / 2.f, 44.f);
    
    self.receivedCommentButton = [self getButtonWithName:UMComLocalizedString(@"um_com_received_comment", @"收到的评论") selector:@selector(switchToReceivedComment)];
    _receivedCommentButton.frame = CGRectMake(0.f, 0.f, viewSize.width / 2.f, 44.f);
    
    CALayer *bottomLineLayer = [[CALayer alloc] init];
    bottomLineLayer.backgroundColor = UMComColorWithHexString(@"#dfdfdf").CGColor;
    bottomLineLayer.frame = CGRectMake(0.f, _sentCommentButton.frame.size.height - 1.f, viewSize.width, 1.f);
    
    self.lineLayer = [[CALayer alloc] init];
    _lineLayer.frame = CGRectMake(0.f, _sentCommentButton.frame.size.height - 2.f, viewSize.width / 2.f, 2.f);
    _lineLayer.backgroundColor = UMComColorWithHexString(@"469ef8").CGColor;
    
    [self.view addSubview:_sentCommentButton];
    [self.view addSubview:_receivedCommentButton];
    
    [self.view.layer addSublayer:bottomLineLayer];
    
    [self.view.layer addSublayer:_lineLayer];
}

- (void)initController
{
    self.sentCommentVC = [[UMComSimpleSubCommentViewController alloc] init];
   UMComUserSentCommentListDataController*  sentCommentDataContrller = [[UMComUserSentCommentListDataController alloc] initWithCount:UMCom_Limit_Page_Count];
    sentCommentDataContrller.pageRequestType = UMComRequestType_UserSendComment;
    _sentCommentVC.dataController = sentCommentDataContrller;
    _sentCommentVC.delegate = self;
    [self addChildViewController:_sentCommentVC];

    self.receivedCommentVC = [[UMComSimpleSubCommentViewController alloc] init];
    UMComUserReceivedCommentListDataController* receivedCommentListDataController = [[UMComUserReceivedCommentListDataController alloc] initWithCount:UMCom_Limit_Page_Count];
    receivedCommentListDataController.pageRequestType = UMComRequestType_UserReceiveComment;
    _receivedCommentVC.dataController = receivedCommentListDataController;
    _receivedCommentVC.delegate = self;
    [self addChildViewController:_receivedCommentVC];
}

- (void)constraintControllerView:(UIView *)view withHeight:(CGFloat)height
{
    [view setTranslatesAutoresizingMaskIntoConstraints:NO];
    NSDictionary *dict1 = NSDictionaryOfVariableBindings(view);
    NSDictionary *metrics = @{@"hPadding":@0,@"vPadding":@0,@"buttonPadding":[NSNumber numberWithFloat:height]};
    NSString *vfl = @"|-hPadding-[view]-hPadding-|";
    NSString *vfl0 = @"V:|-buttonPadding-[view]-vPadding-|";
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:vfl options:0 metrics:metrics views:dict1]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:vfl0 options:0 metrics:metrics views:dict1]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIButton *)getButtonWithName:(NSString *)name selector:(SEL)sel
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:name forState:UIControlStateNormal];
    [button setTitleColor:UMComColorWithHexString(@"999999") forState:UIControlStateNormal];
    [button setTitleColor:UMComColorWithHexString(@"469ef8") forState:UIControlStateSelected];
    [button setTitleColor:UMComColorWithHexString(@"469ef8") forState:UIControlStateHighlighted];
    [button setBackgroundColor:[UIColor whiteColor]];
    [button.titleLabel setFont:UMComFontNotoSansLightWithSafeSize(14.f)];
    [button addTarget:self action:sel forControlEvents:UIControlEventTouchUpInside];
    return button;
}

- (void)switchToSentComment
{
    _sentCommentButton.selected = YES;
    _receivedCommentButton.selected = NO;
    CGRect frame = _lineLayer.frame;
    frame.origin.x = _sentCommentButton.frame.origin.x;
    _lineLayer.frame = frame;
    
    [self switchFromVC:_receivedCommentVC toVC:_sentCommentVC];
}

- (void)switchToReceivedComment
{
    _sentCommentButton.selected = NO;
    _receivedCommentButton.selected = YES;
    CGRect frame = _lineLayer.frame;
    frame.origin.x = _receivedCommentButton.frame.origin.x;
    _lineLayer.frame = frame;
    
    [self switchFromVC:_sentCommentVC toVC:_receivedCommentVC];
}

- (void)switchFromVC:(UIViewController *)fromVC toVC:(UIViewController *)toVC
{
    if (_currentVC == toVC) {
        return;
    }
    [self addChildViewController:toVC];
    [fromVC willMoveToParentViewController:nil];
    
    __weak typeof(self) ws = self;
    [self transitionFromViewController:fromVC toViewController:toVC duration:.2f options:UIViewAnimationOptionTransitionNone animations:^{
        [self.view addSubview:toVC.view];
        [self constraintControllerView:toVC.view withHeight:_sentCommentButton.frame.size.height];
    } completion:^(BOOL finished) {
        if (finished) {
            [fromVC.view removeFromSuperview];
            [fromVC removeFromParentViewController];
            [toVC didMoveToParentViewController:ws];
            ws.currentVC = toVC;
        }
    }];
}

#pragma mark - actionDeleagte
- (void)customObj:(id)obj clickOnFeedText:(UMComFeed *)feed
{
    if (![feed isKindOfClass:[UMComFeed class]]) {
        return;
    }
    if ([feed.status isKindOfClass:[NSNumber class]] && feed.status.integerValue >= 2) {
        //代表feed被删除
        return;
    }
    UMComSimpleFeedDetailViewController *detailVc = [[UMComSimpleFeedDetailViewController alloc] init];
    detailVc.feed = feed;
    [self.navigationController pushViewController:detailVc animated:YES];
}

- (void)customObj:(id)obj clickOnFeedCreator:(UMComUser *)user;
{
    UMComSimplicityUserCenterViewController *userCenterVc = [[UMComSimplicityUserCenterViewController alloc] init];
    userCenterVc.user = user;
    [self.navigationController pushViewController:userCenterVc animated:YES];
}

- (void)customObj:(id)obj clickOnURL:(NSString *)urlSring
{
    UMComWebViewController *webVC = [[UMComWebViewController alloc] initWithUrl:urlSring];
    [self.navigationController pushViewController:webVC animated:YES];
}

- (void)customObj:(id)obj clickOnImageView:(UIImageView *)imageView complitionBlock:(void (^)(UIViewController *currentViewController))block
{
    if (block) {
        block(self);
    }
}


@end

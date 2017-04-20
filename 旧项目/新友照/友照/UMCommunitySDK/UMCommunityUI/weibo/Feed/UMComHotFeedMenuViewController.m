//
//  UMComHotFeedMenuViewController.m
//  UMCommunity
//
//  Created by umeng on 16/1/20.
//  Copyright © 2016年 Umeng. All rights reserved.
//

#import "UMComHotFeedMenuViewController.h"
#import "UMComFeedTableViewController.h"
#import <UMComDataStorage/UMComTopic.h>
#import "UIViewController+UMComAddition.h"
#import "UMComSegmentedControl.h"
#import "UMComFeedWithTopicTableViewController.h"
#import "UMComFeedListDataController.h"
#import <UMComFoundation/UMComKit+Color.h>
#import "UMComResouceDefines.h"

@interface UMComHotFeedMenuViewController ()

@property (nonatomic, assign) NSInteger lastPage;

@property(nonatomic,strong)UMComSegmentedControl *segmentedControl;

@end

@implementation UMComHotFeedMenuViewController

- (instancetype)initWithTopic:(UMComTopic *)topic
{
    self = [super init];
    if (self) {
        _topic = topic;
    }
    return self;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];

    if ([self respondsToSelector:@selector(edgesForExtendedLayout)]) {
        [self setEdgesForExtendedLayout:UIRectEdgeNone];
    }
    if (!self.topic) {
        [self createHotFeedsSubViewControllers];
    }else{
        [self createTopicHotFeedsSubViewControllers];
    }
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    for (int i  = 0; i < self.childViewControllers.count; i++) {
        UIViewController* viewController = self.childViewControllers[i];
        if (viewController) {
            if (!self.segmentedControl) {
                viewController.view.frame = self.view.bounds;
            }
            else{
                //判断话题下，最热的tablview的范围
                CGRect viewFrame =  self.view.bounds;
                viewFrame.origin.y += self.segmentedControl.frame.origin.y + self.segmentedControl.frame.size.height;
                viewFrame.size.height -= self.segmentedControl.bounds.size.height;
                viewController.view.frame  = viewFrame;
            }
            
        }
    }
}

- (void)setPage:(NSInteger)page
{
    _lastPage = _page;
    _page = page;
    [self transitionFromViewControllers];
}

- (void)transitionFromViewControllers
{
    [self transitionFromViewControllerAtIndex:_lastPage toViewControllerAtIndex:_page animations:nil completion:nil];
}

//全局热门Feed列表
- (void)createHotFeedsSubViewControllers
{
    CGRect commonFrame = self.view.bounds;
    for (int index = 0; index < 4; index ++) {
        UMComFeedTableViewController *feedTableViewC = [[UMComFeedTableViewController alloc] init];
        feedTableViewC.feedCellBgViewTopEdge = 0;
        feedTableViewC.isShowEditButton = YES;
        UMComFeedHotDataController* hotDataController =  [[UMComFeedHotDataController alloc] initWithCount:UMCom_Limit_Page_Count];
        hotDataController.isReadLoacalData = YES;
        hotDataController.isSaveLoacalData = YES;
        
        //添加置顶类---begin
        hotDataController.topFeedListDataController = [[UMComTopTopicFeedListDataController alloc] init];
        feedTableViewC.topFeedType = UMComTopFeedType_TopicTopFeed;
        //添加置顶类---end
        if (index == 0) {
            feedTableViewC.isAutoStartLoadData = YES;
            hotDataController.hotDay = 1;
            [self.view addSubview:feedTableViewC.view];
        }else if (index == 1){
             hotDataController.hotDay = 3;
        }else if (index == 2){
             hotDataController.hotDay = 7;
        }else if (index == 3){
            hotDataController.hotDay = 30;
        }
        feedTableViewC.dataController = hotDataController;
        feedTableViewC.view.frame = commonFrame;
        feedTableViewC.view.autoresizingMask = UIViewAutoresizingFlexibleHeight;
        [self addChildViewController:feedTableViewC];
    }
    [self transitionFromViewControllers];
}

//话题热门feed列表
- (void)createTopicHotFeedsSubViewControllers
{
    UMComSegmentedControl *segmentedControl = [[UMComSegmentedControl alloc]initWithItems:[NSArray arrayWithObjects:@"1天内",@"3天内",@"7天内",@"30天内", nil]];
    segmentedControl.frame = CGRectMake(40, 0, self.view.frame.size.width - 80, 27);
    [self.view addSubview:segmentedControl];
    [segmentedControl addTarget:self action:@selector(didSelectedHotFeedPage:) forControlEvents:UIControlEventValueChanged];
    segmentedControl.selectedSegmentIndex = 3;
    segmentedControl.tintColor = UMComColorWithHexString(@"#008BEA");
    [segmentedControl setfont:UMComFontNotoSansLightWithSafeSize(14) titleColor:UMComColorWithHexString(@"#008BEA") selectedColor:[UIColor whiteColor]];
    [self.view addSubview:segmentedControl];
    self.segmentedControl = segmentedControl;
    
    CGRect commonFrame = self.view.bounds;
    commonFrame.origin.y = segmentedControl.frame.size.height + segmentedControl.frame.origin.y + UMCom_Micro_Feed_Cell_Space;
    commonFrame.size.height = self.view.frame.size.height - commonFrame.origin.y;
    for (int index = 0; index < 4; index ++) {
        UMComFeedTableViewController *feedTableViewC = [[UMComFeedWithTopicTableViewController alloc] initWithTopic:self.topic];
        feedTableViewC.isShowEditButton = YES;
        feedTableViewC.feedCellBgViewTopEdge = 2;
        UMComFeedTopicHotDataController* hotTopicFeedDataController =  [[UMComFeedTopicHotDataController alloc] initWithCount:UMCom_Limit_Page_Count topicId:self.topic.topicID hotDay:1];
        if (index == 0) {
            feedTableViewC.isAutoStartLoadData = YES;
            hotTopicFeedDataController.hotDay = 1;
            [self.view addSubview:feedTableViewC.view];
        }else if (index == 1){
            hotTopicFeedDataController.hotDay = 3;
        }else if (index == 2){
            hotTopicFeedDataController.hotDay = 7;
        }else if (index == 3){
            hotTopicFeedDataController.hotDay = 30;
        }
        feedTableViewC.dataController = hotTopicFeedDataController;
        feedTableViewC.view.frame = commonFrame;
        [self addChildViewController:feedTableViewC];
    }
    self.page = segmentedControl.selectedSegmentIndex;
    [self transitionFromViewControllers];
}


- (void)didSelectedHotFeedPage:(UISegmentedControl *)sender
{
    [self setPage:sender.selectedSegmentIndex];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

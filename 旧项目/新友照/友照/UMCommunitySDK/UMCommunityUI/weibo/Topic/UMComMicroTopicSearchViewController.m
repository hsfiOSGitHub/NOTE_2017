//
//  UMComMicroTopicSearchViewController.m
//  UMCommunity
//
//  Created by umeng on 16/2/4.
//  Copyright © 2016年 Umeng. All rights reserved.
//

#import "UMComMicroTopicSearchViewController.h"
#import "UMComSearchBar.h"
#import "UMComResouceDefines.h"
#import "UMComNavigationController.h"
#import "UMComBarButtonItem.h"
#import "UMComTopicListDataController.h"

@interface UMComMicroTopicSearchViewController ()<UISearchBarDelegate>

@property (nonatomic, strong) UISearchBar *searchBar;

@property (nonatomic, assign) CGRect navigationBarOriginFrame;

@property (nonatomic, assign) CGRect naviOriginViewFrame;

@property (nonatomic, assign) BOOL firstTime;

@end

@implementation UMComMicroTopicSearchViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.firstTime = YES;
    UISearchBar *searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 35)];
    searchBar.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    searchBar.placeholder = UMComLocalizedString(@"um_com_searchTopic", @"搜索话题");
    searchBar.delegate = self;
    searchBar.backgroundImage = [[UIImage alloc] init];
    [self.navigationItem setTitleView:searchBar];
    _searchBar = searchBar;
    self.navigationController.navigationBar.backgroundColor = [UIColor colorWithPatternImage:UMComImageWithImageName(@"search_frame")];
    
    UMComBarButtonItem *rightButtonItem = [[UMComBarButtonItem alloc] initWithTitle:UMComLocalizedString(@"um_com_cancel", @"取消") target:self action:@selector(goBack:)];
    rightButtonItem.customButtonView.frame = CGRectMake(10, 0, 40, 30);
    rightButtonItem.customButtonView.titleLabel.font = UMComFontNotoSansLightWithSafeSize(17);
    UIBarButtonItem *spaceItem = [[UIBarButtonItem alloc]init];
    spaceItem.width = 5;
    [self.navigationItem setRightBarButtonItems:@[spaceItem,rightButtonItem,spaceItem]];
    [_searchBar becomeFirstResponder];
    // Do any additional setup after loading the view.
    //搜索框左边为空，让其不显示
    self.navigationItem.leftBarButtonItems = nil;
    self.navigationItem.leftBarButtonItem = nil;
    
    //设置不自动加载
    self.isAutoStartLoadData = NO;
    
    self.dataController = [[UMComTopicsSearchDataController alloc] initWithCount:UMCom_Limit_Page_Count withKeyWord:@""];
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.noDataTipLabel.hidden = YES;
    self.noDataTipLabel.text = nil;
    if (!_firstTime) {
        self.navigationController.view.frame = self.naviOriginViewFrame;
        self.navigationController.navigationBar.frame = self.navigationBarOriginFrame;
    }
    if (_firstTime) {
        _firstTime = NO;
        self.naviOriginViewFrame = self.navigationController.view.frame;
        self.navigationBarOriginFrame = self.navigationController.navigationBar.frame;
    }
    self.tableView.frame = self.navigationController.view.bounds;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    CGRect naviViewFrame = self.navigationController.view.frame;
    CGRect navigationBarFrame = self.navigationBarOriginFrame;
    if (self.navigationController.viewControllers.count > 1) {
        naviViewFrame.origin.y = 0;
        navigationBarFrame.origin.y = [UIApplication sharedApplication].statusBarFrame.size.height;
        naviViewFrame.size.height = self.navigationController.view.frame.size.height - navigationBarFrame.size.height;
    }else{
        naviViewFrame = self.naviOriginViewFrame;
    }
    self.navigationController.navigationBar.frame = navigationBarFrame;
    self.navigationController.view.frame = naviViewFrame;
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar;
{
    [self.searchBar resignFirstResponder];
    self.noDataTipLabel.hidden = NO;
    self.noDataTipLabel.text = UMComLocalizedString(@"um_com_searchBarNoDataTip", @"没有找到相关的话题");
    /*
     self.fetchRequest.keywords = searchBar.text;
     [self loadAllData:nil fromServer:nil];
     */
    ((UMComTopicsSearchDataController*)self.dataController).keyWord = searchBar.text;
    [self refreshData];
}

- (void)goBack:(id)sender
{
    if (self.dismissBlock) {
        self.dismissBlock();
    }
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

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger count =  self.dataController.dataArray.count;
    if (count > 0) {
        self.noDataTipLabel.hidden = YES;
    }
    else{
        self.noDataTipLabel.hidden = NO;
    }
    return count;
}
@end

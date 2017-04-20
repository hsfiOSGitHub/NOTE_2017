//
//  UMComSelectTopicViewController.m
//  UMCommunity
//
//  Created by 张军华 on 16/5/18.
//  Copyright © 2016年 Umeng. All rights reserved.
//

#import "UMComSelectTopicViewController.h"
#import "UMComTopicListDataController.h"
#import "UMComResouceDefines.h"
#import <UIKit/UIKit.h>
#import <UMComDataStorage/UMComTopic.h>
#import "UMComChangeBorderBtn.h"
#import "UMComShowToast.h"
#import "UMComiToast.h"
#import "UMComSelectTopicCell.h"
#import <UMComFoundation/UMComKit+Color.h>

const CGFloat g_template_selectTopic_closeViewHeight = 60.f;//关闭view的高度
const CGFloat g_template_selectTopic_closeBTNHeight = 44.f;//关闭按钮的高度
const CGFloat g_template_selectTopic_closeBTNWidth = 44.f;//关闭按钮的高度

const CGFloat g_template_selectTopic_cellWidth = 120;//cell的宽度
const CGFloat g_template_selectTopic_cellHeight = 32;//cell的高度
const CGFloat g_template_selectTopic_horizonSpace = 10;//同一行cell的间隔
const CGFloat g_template_selectTopic_verticalSpace = 10;//同一列cell的间隔

NSString*  const UMComSelectTopicCollectionCellIdentifier = @"UMComSelectTopicCollectionCellIdentifier";


@interface UMComSelectTopicViewController ()<UITableViewDataSource,UITableViewDelegate,UMComSelectTopicTableViewCellDelegate>

@property(nonatomic)UMComTopicsAllDataController* topicsAllDataController;

@property(nonatomic,readwrite,strong)UIView* closeView;
@property(nonatomic,readwrite,strong)UIButton* closeBtn;
@property (weak, nonatomic) IBOutlet UIImageView *imgHeader;
@property (weak, nonatomic) IBOutlet UILabel *laberheader1;
@property (weak, nonatomic) IBOutlet UILabel *labelheader2;
@property (weak, nonatomic) IBOutlet UIView *headerView;

//@property (weak, nonatomic) IBOutlet UITableView *tableView;


-(void) initHeaderView;

-(void) createCloseViewIfNoExist;
-(void) handleCloseBtn:(id)target;

-(void) createTableView;

@end

@implementation UMComSelectTopicViewController

-(void) initHeaderView
{
    self.imgHeader.image = UMComSimpleImageWithImageName(@"um_com_cheers");
    self.imgHeader.backgroundColor = [UIColor clearColor];
    
    self.laberheader1.text = @"为内容选个贴切的版块";
    self.labelheader2.text = @"会找到志同道和的人哦";
    self.laberheader1.font = UMComFontNotoSansLightWithSafeSize(14);
    self.laberheader1.textColor = UMComColorWithHexString(@"#FFFFFF");
    
    self.labelheader2.font = UMComFontNotoSansLightWithSafeSize(14);
    self.labelheader2.textColor = UMComColorWithHexString(@"#FFFFFF");
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.navigationController setNavigationBarHidden:YES];
    [self initHeaderView];
    [self createTableView];
    self.topicsAllDataController = [[UMComTopicsAllDataController alloc] initWithRequestType:UMComRequestType_AllTopic count:30];;
    self.dataController = self.topicsAllDataController;
    __weak typeof(self) weakself = self;
    [self.dataController refreshNewDataCompletion:^(NSArray *responseData, NSError *error) {
        if (error) {
             [UMComShowToast showFetchResultTipWithError:error];
        }
        [weakself.tableView reloadData];
    }];
}

- (void)updateTableviewConstraints
{
    UITableView *tableView = self.tableView;
    UIView* headerView = self.headerView;
    
    [tableView setTranslatesAutoresizingMaskIntoConstraints:NO];
    NSDictionary *dict1 = NSDictionaryOfVariableBindings(tableView,headerView);
    NSDictionary *metrics = @{@"hPadding":@0,@"vPadding":@(10)};
    NSString *vfl = @"|-hPadding-[tableView]-hPadding-|";
    NSString *vfl0 = @"V:|-0-[headerView]-vPadding-[tableView]-0-|";
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:vfl options:0 metrics:metrics views:dict1]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:vfl0 options:0 metrics:metrics views:dict1]];
}

-(void) viewDidAppear:(BOOL)animated
{
    [self createCloseViewIfNoExist];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) dealloc
{
    //YZLog(@"UMComSelectTopicViewController_dealloc");
}


-(void) createCloseViewIfNoExist
{
    if (!self.closeView) {
        self.closeView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.bounds.size.height - g_template_selectTopic_closeViewHeight, self.view.bounds.size.width, g_template_selectTopic_closeViewHeight)];
        
        self.closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        
        self.closeBtn.frame = CGRectMake(0,0,g_template_selectTopic_closeBTNWidth,g_template_selectTopic_closeBTNHeight);
        self.closeBtn.center = CGPointMake(self.closeView.bounds.size.width/2, self.closeView.bounds.size.height/2);
        [self.closeView addSubview:self.closeBtn];
        
        [self.closeBtn setImage:UMComSimpleImageWithImageName(@"um_com_close") forState:UIControlStateNormal];
        [self.closeBtn setImage:UMComSimpleImageWithImageName(@"um_com_close_click") forState:UIControlStateHighlighted];
        
        self.closeView.backgroundColor = UMComColorWithHexString(@"#e8eaee");
        self.closeView.alpha = 0.8;
        [self.view addSubview:self.closeView];
        
        [self.closeBtn addTarget:self action:@selector(handleCloseBtn:) forControlEvents:UIControlEventTouchUpInside];
    }
}


-(void) handleCloseBtn:(id)target
{
    [self.navigationController setNavigationBarHidden:NO];
    
    if (self.closeTopicViewAction) {
        self.closeTopicViewAction();
    }
    else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}

-(void) createTableView
{
    //设置tableview
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.tableView setSeparatorColor:[UIColor clearColor]];
    [self.tableView setAllowsSelection:NO];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    
//    //设置上来加载控件的frame
//    CGRect loadMoreStatusViewRC =  self.loadMoreStatusView.frame;
//    CGFloat cellWidth =  [UIScreen mainScreen].bounds.size.width;
//    loadMoreStatusViewRC.origin.x = cellWidth/2 - g_template_selectTopic_cellWidth - g_template_selectTopic_horizonSpace - g_template_selectTopic_horizonSpace;
//    
//    loadMoreStatusViewRC.size.width = g_template_selectTopic_cellWidth*2 + g_template_selectTopic_horizonSpace;
//    self.loadMoreStatusView.frame = loadMoreStatusViewRC;
    
}


#pragma mark - UMComSelectTopicCollectionCellDelegate

-(void)layouttableViewCell:(UMComSelectTopicCell*)cell indexPath:(NSIndexPath *)indexPath
{
    NSInteger cellRow = indexPath.row;
    NSInteger rowCount =  (self.topicsAllDataController.dataArray.count + 1)/2;
    if (cellRow >= rowCount) {
        return;
    }
    
    NSInteger leftDataIndex = cellRow*2;
    NSInteger rightDataIndex = cellRow*2 + 1;
    
    NSString* leftTopicName = nil;
    if (leftDataIndex >=0 && leftDataIndex < self.topicsAllDataController.dataArray.count) {
        
       UMComTopic* leftTopic =  self.topicsAllDataController.dataArray[leftDataIndex];
        if (leftTopic && [leftTopic isKindOfClass:[UMComTopic class]]) {
            leftTopicName = leftTopic.name;
        }
    }
    
    NSString* rightTopicName = nil;
    if (rightDataIndex > 0 && rightDataIndex < self.topicsAllDataController.dataArray.count) {
        
        UMComTopic* rightTopic =  self.topicsAllDataController.dataArray[rightDataIndex];
        if (rightTopic && [rightTopic isKindOfClass:[UMComTopic class]]) {
            rightTopicName = rightTopic.name;
        }
    }
    
    [cell refresCellWithLeftTopicName:leftTopicName withRightTopicName:rightTopicName withCellRow:cellRow];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return g_template_selectTopic_cellHeight + g_template_selectTopic_horizonSpace;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return  (self.topicsAllDataController.dataArray.count + 1)/2;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *kUMComSelectTopicTableViewCellIdentifier = @"kUMComSelectTopicTableViewCellIdentifier";
    
    UMComSelectTopicCell* cell =  [tableView dequeueReusableCellWithIdentifier:kUMComSelectTopicTableViewCellIdentifier];
    
    if (!cell) {
        cell = [[UMComSelectTopicCell alloc] initWithStyle:UITableViewCellStyleDefault  reuseIdentifier:kUMComSelectTopicTableViewCellIdentifier];
    }
    
    cell.selectTopicTableViewCellDelegate = self;
    [self layouttableViewCell:cell indexPath:indexPath];
    return cell;
}

#pragma mark - UMComSelectTopicTableViewCellDelegate

-(void) handleClickedTopicTableViewCell:(NSInteger)dataRowIndex
{
    if (dataRowIndex < 0) {
        return;
    }
    
    if (dataRowIndex < self.topicsAllDataController.dataArray.count) {
        
        UMComTopic* topic =  self.topicsAllDataController.dataArray[dataRowIndex];
        if (topic && [topic isKindOfClass:[UMComTopic class]]) {
            
            //YZLog(@"handleClickTopicCollectionCell:name = %@. index = %@",topic.name,indexPath);
            [self.navigationController setNavigationBarHidden:NO];
            if (self.selectTopicViewFinishAction) {
                self.selectTopicViewFinishAction(topic);
            }
        }
    }
}


@end

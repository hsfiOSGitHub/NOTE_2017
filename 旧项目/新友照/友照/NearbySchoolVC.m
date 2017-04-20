//
//  NearbySchoolVC.m
//  友照
//
//  Created by monkey2016 on 16/11/22.
//  Copyright © 2016年 ZX_XPH. All rights reserved.
//

#import "NearbySchoolVC.h"
#import "NearbySchoolCell.h"
#import "SchoolDetailVC.h"
#import "SearchSchoolVC.h"

@interface NearbySchoolVC ()<UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate>

//标题
@property (weak, nonatomic) IBOutlet UIView *titleView;
@property (weak, nonatomic) IBOutlet UIButton *titleBtn1;
@property (weak, nonatomic) IBOutlet UIButton *titleBtn2;
@property (weak, nonatomic) IBOutlet UIButton *titleBtn3;
@property (weak, nonatomic) IBOutlet UIButton *titleBtn4;
@property (weak, nonatomic) IBOutlet UIView *baselineView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *baselineViewLeftCons;//左边约束
//内容
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UITableView *tableView1;
@property (weak, nonatomic) IBOutlet UITableView *tableView2;
@property (weak, nonatomic) IBOutlet UITableView *tableView3;
@property (weak, nonatomic) IBOutlet UITableView *tableView4;
//数据源
@property (nonatomic,strong) NSMutableArray *source_schoolLocation;//所在城市驾校的地理位置
@property (nonatomic,strong) NSMutableArray *source_nearbySchool;
@property (nonatomic,strong) NSMutableArray *source_lowestPriceSchool;
@property (nonatomic,strong) NSMutableArray *source_bestCommentSchool;
@property (nonatomic,strong) NSMutableArray *source_highestPassSchool;
//page
@property (nonatomic,assign) int page_nearbySchool;
@property (nonatomic,assign) int page_lowestPriceSchool;
@property (nonatomic,assign) int page_bestCommentSchool;
@property (nonatomic,assign) int page_highestPassSchool;
//防止下拉刷新时频繁请求
@property (nonatomic,assign) BOOL isLoadingNew_nearbySchool;
@property (nonatomic,assign) BOOL isLoadingNew_lowestPriceSchool;
@property (nonatomic,assign) BOOL isLoadingNew_bestCommentSchool;
@property (nonatomic,assign) BOOL isLoadingNew_highestPassSchool;
//防止上拉加载更多时频繁请求
@property (nonatomic,assign) BOOL isLoadingMore_nearbySchool;
@property (nonatomic,assign) BOOL isLoadingMore_lowestPriceSchool;
@property (nonatomic,assign) BOOL isLoadingMore_bestCommentSchool;
@property (nonatomic,assign) BOOL isLoadingMore_highestPassSchool;
//刷新时的动画
@property (nonatomic,strong) NSArray *idleImages;
@property (nonatomic,strong) NSArray *pullingImages;
@property (nonatomic,strong) NSArray *refreshingImages;
//判断是否为第一次加载数据
@property (nonatomic,assign) BOOL loadFirstTime_nearbySchool;
@property (nonatomic,assign) BOOL loadFirstTime_lowestPriceSchool;
@property (nonatomic,assign) BOOL loadFirstTime_bestCommentSchool;
@property (nonatomic,assign) BOOL loadFirstTime_highestPassSchool;
//第一次加载时的加载中动画
@property (nonatomic,strong) HSFLodingView *loadingView_nearbySchool;
@property (nonatomic,strong) HSFLodingView *loadingView_lowestPriceSchool;
@property (nonatomic,strong) HSFLodingView *loadingView_bestCommentSchool;
@property (nonatomic,strong) HSFLodingView *loadingView_highestPassSchool;
@property (nonatomic,strong) NSArray *loadingImageArr;
//数据为空的占位图
@property (nonatomic,strong) HSFLodingView *loadFailureView_nearbySchool;
@property (nonatomic,strong) HSFLodingView *loadFailureView_lowestPriceSchool;
@property (nonatomic,strong) HSFLodingView *loadFailureView_bestCommentSchool;
@property (nonatomic,strong) HSFLodingView *loadFailureView_highestPassSchool;
@property (nonatomic,strong) NSArray *loadFailureImageArr;
//驾校ID
@property (nonatomic, copy) NSString *school_ids;
@property (nonatomic,assign) CGFloat percent;//百分比（星星评价）
@property(nonatomic)int schoolid;

@end

static NSString *identifierCell = @"identifierCell";
@implementation NearbySchoolVC
//初始化方法
-(instancetype)init{
    if (self = [super init]) {
        self.hidesBottomBarWhenPushed = YES;
    }
    return self;
}
#pragma mark -懒加载
//加载中动画
-(NSArray *)loadingImageArr{
    if (!_loadingImageArr) {
        NSMutableArray *imgArr = [NSMutableArray array];
        for (int i = 1; i < 5; i++) {
            UIImage *img = [UIImage imageNamed:[NSString stringWithFormat:@"car%d.png",i]];
            [imgArr addObject:img];
        }
        _loadingImageArr = imgArr;
    }
    return _loadingImageArr;
}
//加载失败图
-(NSArray *)loadFailureImageArr{
    if (!_loadFailureImageArr) {
        NSMutableArray *imgArr = [NSMutableArray array];
        UIImage *img = [UIImage imageNamed:[NSString stringWithFormat:@"卡通"]];
        [imgArr addObject:img];
        _loadFailureImageArr = imgArr;
    }
    return _loadFailureImageArr;
}
//数据源
-(NSMutableArray *)source_schoolLocation{
    if (!_source_schoolLocation) {
        _source_schoolLocation = [NSMutableArray arrayWithArray:[ZXUD objectForKey:@"jl"]];
    }
    return _source_schoolLocation;
}
-(NSMutableArray *)source_nearbySchool{
    if (!_source_nearbySchool) {
        _source_nearbySchool = [NSMutableArray array];
    }
    return _source_nearbySchool;
}
-(NSMutableArray *)source_lowestPriceSchool{
    if (!_source_lowestPriceSchool) {
        _source_lowestPriceSchool = [NSMutableArray array];
    }
    return _source_lowestPriceSchool;
}
-(NSMutableArray *)source_bestCommentSchool{
    if (!_source_bestCommentSchool) {
        _source_bestCommentSchool = [NSMutableArray array];
    }
    return _source_bestCommentSchool;
}
-(NSMutableArray *)source_highestPassSchool{
    if (!_source_highestPassSchool) {
        _source_highestPassSchool = [NSMutableArray array];
    }
    return _source_highestPassSchool;
}
//刷新时的动画
-(NSArray *)idleImages{
    if (!_idleImages) {
        NSMutableArray *imgArr = [NSMutableArray array];
        for (int i = 1; i < 5; i++) {
            NSString *imgName = [NSString stringWithFormat:@"car%d",i];
            UIImage *img = [UIImage imageNamed:imgName];
            [imgArr addObject:img];
        }
        _idleImages = imgArr;
    }
    return _idleImages;
}
-(NSArray *)pullingImages{
    if (!_pullingImages) {
        NSMutableArray *imgArr = [NSMutableArray array];
        for (int i = 1; i < 5; i++) {
            NSString *imgName = [NSString stringWithFormat:@"car%d",i];
            UIImage *img = [UIImage imageNamed:imgName];
            [imgArr addObject:img];
        }
        _pullingImages = imgArr;
    }
    return _pullingImages;
}
-(NSArray *)refreshingImages{
    if (!_refreshingImages) {
        NSMutableArray *imgArr = [NSMutableArray array];
        for (int i = 1; i < 5; i++) {
            NSString *imgName = [NSString stringWithFormat:@"car%d",i];
            UIImage *img = [UIImage imageNamed:imgName];
            [imgArr addObject:img];
        }
        _refreshingImages = imgArr;
    }
    return _refreshingImages;
}


#pragma mark -viewDidLoad
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSearch target:self action:@selector(searchSchool)];
    self.navigationItem.rightBarButtonItem.tintColor = [UIColor whiteColor];
    self.title = @"附近驾校";
    _schoolid=0;
    //配置scrollView
    [self setUpScrollView];
    //配置tablView
    [self setUpTableView];
    //runtime
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        //添加加载中动画
        self.loadingView_nearbySchool = [HSFLodingView showLodingViewInView:self.bgView andRect:self.tableView1.frame imgArr:self.loadingImageArr message:@"网络加载中"];
        self.loadingView_nearbySchool.center = CGPointMake(self.tableView1.centerX, self.tableView1.centerY - (64 + 44)/2);
        [self loadData_nearbySchool];

        self.loadFirstTime_nearbySchool = YES;
    });
}

//搜索驾校
- (void)searchSchool {
    SearchSchoolVC *seachVC = [[SearchSchoolVC alloc] init];
    [self.navigationController pushViewController:seachVC animated:YES];
}
//配置scrollView
-(void)setUpScrollView{
    self.scrollView.delegate = self;//设置代理 
}
//配置tablView
-(void)setUpTableView
{
    //数据源代理
    self.tableView1.dataSource = self;
    self.tableView1.delegate = self;
    self.tableView2.dataSource = self;
    self.tableView2.delegate = self;
    self.tableView3.dataSource = self;
    self.tableView3.delegate = self;
    self.tableView4.dataSource = self;
    self.tableView4.delegate = self;
    _tableView1.showsVerticalScrollIndicator = NO;
    _tableView2.showsVerticalScrollIndicator = NO;
    _tableView3.showsVerticalScrollIndicator = NO;
    _tableView4.showsVerticalScrollIndicator = NO;
    //高度
    self.tableView1.estimatedRowHeight = 44;
    self.tableView1.rowHeight = UITableViewAutomaticDimension;
    self.tableView2.estimatedRowHeight = 44;
    self.tableView2.rowHeight = UITableViewAutomaticDimension;
    self.tableView3.estimatedRowHeight = 44;
    self.tableView3.rowHeight = UITableViewAutomaticDimension;
    self.tableView4.estimatedRowHeight = 44;
    self.tableView4.rowHeight = UITableViewAutomaticDimension;
    //注册cell
    [self.tableView1 registerNib:[UINib nibWithNibName:NSStringFromClass([NearbySchoolCell class]) bundle:nil] forCellReuseIdentifier:identifierCell];
    [self.tableView2 registerNib:[UINib nibWithNibName:NSStringFromClass([NearbySchoolCell class]) bundle:nil] forCellReuseIdentifier:identifierCell];
    [self.tableView3 registerNib:[UINib nibWithNibName:NSStringFromClass([NearbySchoolCell class]) bundle:nil] forCellReuseIdentifier:identifierCell];
    [self.tableView4 registerNib:[UINib nibWithNibName:NSStringFromClass([NearbySchoolCell class]) bundle:nil] forCellReuseIdentifier:identifierCell];
    //添加下拉刷新，上拉加载更多
    [self addRefreshLoadNew];
    [self addRefreshLoadMore];
}
//下拉刷新，
-(void)addRefreshLoadNew{
    //离我最近
    self.tableView1.mj_header = [HSFRefreshGifHeader headerWithRefreshingBlock:^{
        if (!self.isLoadingNew_nearbySchool) {
            self.isLoadingNew_nearbySchool = YES;
            self.page_nearbySchool = 0;
            _schoolid=0;
            [self loadData_nearbySchool];
        }else{
            [self.tableView1.mj_header endRefreshing];
        }
    }];
    //价格最低
    self.tableView2.mj_header = [HSFRefreshGifHeader headerWithRefreshingBlock:^{
        if (!self.isLoadingNew_lowestPriceSchool) {
            self.isLoadingNew_lowestPriceSchool = YES;
            self.page_lowestPriceSchool = 0;
            [self loadData_lowestPriceSchool];
        }else{
            [self.tableView2.mj_header endRefreshing];
        }
    }];
    //评价最好
    self.tableView3.mj_header = [HSFRefreshGifHeader headerWithRefreshingBlock:^{
        if (!self.isLoadingNew_bestCommentSchool) {
            self.isLoadingNew_bestCommentSchool = YES;
            self.page_bestCommentSchool = 0;
            [self loadData_bestCommentSchool];
        }else{
            [self.tableView3.mj_header endRefreshing];
        }
    }];
    //通过率高
    self.tableView4.mj_header = [HSFRefreshGifHeader headerWithRefreshingBlock:^{
        if (!self.isLoadingNew_highestPassSchool) {
            self.isLoadingNew_highestPassSchool = YES;
            self.page_highestPassSchool = 0;
            [self loadData_highestPassSchool];
        }else{
            [self.tableView4.mj_header endRefreshing];
        }
    }];
}
//上拉加载更多
-(void)addRefreshLoadMore{
    self.tableView1.mj_footer = [HSFRefreshAutoGifFooter footerWithRefreshingBlock:^{
        if (!self.isLoadingMore_nearbySchool) {
            self.isLoadingMore_nearbySchool = YES;
            self.page_nearbySchool++;
            [self loadData_nearbySchool];
        }else{
            [self.tableView1.mj_footer endRefreshing];
        }
    }];
    self.tableView2.mj_footer = [HSFRefreshAutoGifFooter footerWithRefreshingBlock:^{
        if (!self.isLoadingMore_lowestPriceSchool) {
            self.isLoadingMore_lowestPriceSchool = YES;
            self.page_lowestPriceSchool++;
            [self loadData_lowestPriceSchool];
        }else{
            [self.tableView2.mj_footer endRefreshing];
        }
    }];
    self.tableView3.mj_footer = [HSFRefreshAutoGifFooter footerWithRefreshingBlock:^{
        if (!self.isLoadingMore_bestCommentSchool) {
            self.isLoadingMore_bestCommentSchool = YES;
            self.page_bestCommentSchool++;
            [self loadData_bestCommentSchool];
        }else{
            [self.tableView3.mj_footer endRefreshing];
        }
    }];
    self.tableView4.mj_footer = [HSFRefreshAutoGifFooter footerWithRefreshingBlock:^{
        if (!self.isLoadingMore_highestPassSchool) {
            self.isLoadingMore_highestPassSchool = YES;
            self.page_highestPassSchool++;
            [self loadData_highestPassSchool];
        }else{
            [self.tableView4.mj_footer endRefreshing];
        }
    }];
}


#pragma mark -UITableViewDelegate,UITableViewDataSource
//组数
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
//行数
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView == self.tableView1) {
        return self.source_nearbySchool.count;
    }else if (tableView == self.tableView2) {
        return self.source_lowestPriceSchool.count;
    }else if (tableView == self.tableView3) {
        return self.source_bestCommentSchool.count;
    }else if (tableView == self.tableView4) {
        return self.source_highestPassSchool.count;
    }
    return 0;
}
//行内容
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NearbySchoolCell *cell = [tableView dequeueReusableCellWithIdentifier:identifierCell forIndexPath:indexPath];
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    //配置cell
    if (tableView == self.tableView1) {
        SchoolListModel *model = self.source_nearbySchool[indexPath.row];
        cell.schoolListModel = model;
        cell.distance.text = [self getOtherTypeSchoolistanceWithSchoolID:model.school_id];
    }else if (tableView == self.tableView2) {
        SchoolListModel *model = self.source_lowestPriceSchool[indexPath.row];
        cell.schoolListModel = model;
        cell.distance.text = [self getOtherTypeSchoolistanceWithSchoolID:model.school_id];
    }else if (tableView == self.tableView3) {
        SchoolListModel *model = self.source_bestCommentSchool[indexPath.row];
        cell.schoolListModel = model;
        cell.distance.text = [self getOtherTypeSchoolistanceWithSchoolID:model.school_id];
    }else if (tableView == self.tableView4) {
        SchoolListModel *model = self.source_highestPassSchool[indexPath.row];
        cell.schoolListModel = model;
        cell.distance.text = [self getOtherTypeSchoolistanceWithSchoolID:model.school_id];
    }
    return cell;
}
//点击cell
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    SchoolDetailVC *schoolDetail_VC = [[SchoolDetailVC alloc]init];
    SchoolListModel *model;
    if (tableView == self.tableView1) {
        model = self.source_nearbySchool[indexPath.row];
    }else if (tableView == self.tableView2) {
        model = self.source_lowestPriceSchool[indexPath.row];
    }else if (tableView == self.tableView3) {
        model = self.source_bestCommentSchool[indexPath.row];
    }else if (tableView == self.tableView4) {
        model = self.source_highestPassSchool[indexPath.row];
    }
    schoolDetail_VC.sid = [NSString stringWithFormat:@"%@",model.school_id];
    schoolDetail_VC.schoolName = model.name;
    [self.navigationController pushViewController:schoolDetail_VC animated:YES];
}

#pragma mark -点击标题
- (IBAction)titleBtnAction:(UIButton *)sender {
    switch (sender.tag) {
        case 100:{//离我最近
            //第一次加载数据
            if (!self.loadFirstTime_nearbySchool) {
                //runtime
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    //添加加载中动画
                    self.loadingView_nearbySchool = [HSFLodingView showLodingViewInView:self.bgView andRect:self.tableView1.frame imgArr:self.loadingImageArr message:@"网络加载中"];
                    self.loadingView_nearbySchool.center = CGPointMake(self.tableView1.centerX, self.tableView1.centerY - (64 + 44)/2);
                    [self loadData_nearbySchool];
                    self.loadFirstTime_nearbySchool = YES;
                });
            }
            [self.scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
        }
            break;
        case 200:{//价格最低
            //第一次加载数据
            if (!self.loadFirstTime_lowestPriceSchool) {
                //runtime
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    //添加加载中动画
                    self.loadingView_lowestPriceSchool = [HSFLodingView showLodingViewInView:self.bgView andRect:self.tableView2.frame imgArr:self.loadingImageArr message:@"网络加载中"];
                    self.loadingView_lowestPriceSchool.center = CGPointMake(self.tableView2.centerX, self.tableView2.centerY - (64 + 44)/2);
                    [self loadData_lowestPriceSchool];
                    self.loadFirstTime_lowestPriceSchool = YES;
                });
            }
            [self.scrollView setContentOffset:CGPointMake(KScreenWidth, 0) animated:YES];
        }
            break;
        case 300:{//评价最好
            //第一次加载数据
            if (!self.loadFirstTime_bestCommentSchool) {
                //runtime
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    //添加加载中动画
                    self.loadingView_bestCommentSchool = [HSFLodingView showLodingViewInView:self.bgView andRect:self.tableView3.frame imgArr:self.loadingImageArr message:@"网络加载中"];
                    self.loadingView_bestCommentSchool.center = CGPointMake(self.tableView3.centerX, self.tableView3.centerY - (64 + 44)/2);
                    [self loadData_bestCommentSchool];
                    self.loadFirstTime_bestCommentSchool = YES;
                });
            }
            [self.scrollView setContentOffset:CGPointMake(KScreenWidth * 2, 0) animated:YES];
        }
            break;
        case 400:{//通过率高
            //第一次加载数据
            if (!self.loadFirstTime_highestPassSchool) {
                //runtime
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    //添加加载中动画
                    self.loadingView_highestPassSchool = [HSFLodingView showLodingViewInView:self.bgView andRect:self.tableView4.frame imgArr:self.loadingImageArr message:@"网络加载中"];
                    self.loadingView_highestPassSchool.center = CGPointMake(self.tableView4.centerX, self.tableView4.centerY - (64 + 44)/2);
                    [self loadData_highestPassSchool];
                    self.loadFirstTime_highestPassSchool = YES;
                });
            }
            [self.scrollView setContentOffset:CGPointMake(KScreenWidth * 3, 0) animated:YES];
        }
            break;
        default:
            break;
    }
}

#pragma mark -UIScrollViewDelegate
//不管是 手动左右滑动切换 还是 点击标题切换 都会执行该方法
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
}
//点击标题切换
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView{
    if (scrollView == self.scrollView) {
        NSInteger index = scrollView.contentOffset.x / scrollView.frame.size.width;
        CGFloat baselineViewWidth = self.baselineView.frame.size.width;
        self.baselineViewLeftCons.constant = baselineViewWidth * index;
        [self.baselineView setNeedsLayout];
    }
}
//手动左右滑动切换
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    if (scrollView == self.scrollView) {
        NSInteger index = scrollView.contentOffset.x / scrollView.frame.size.width;
        CGFloat baselineViewWidth = self.baselineView.frame.size.width;
        self.baselineViewLeftCons.constant = baselineViewWidth * index;
        [self.baselineView setNeedsLayout];
        //第一次加载数据
        if (index == 0) {
            if (!self.loadFirstTime_nearbySchool) {
                //runtime
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    //添加加载中动画
                    self.loadingView_nearbySchool = [HSFLodingView showLodingViewInView:self.bgView andRect:self.tableView1.frame imgArr:self.loadingImageArr message:@"网络加载中"];
                    self.loadingView_nearbySchool.center = CGPointMake(self.tableView1.centerX, self.tableView1.centerY - (64 + 44)/2);
                    [self loadData_nearbySchool];
                    self.loadFirstTime_nearbySchool = YES;
                });
            }
        }else if (index == 1) {
            if (!self.loadFirstTime_lowestPriceSchool) {
                //runtime
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    //添加加载中动画
                    self.loadingView_lowestPriceSchool = [HSFLodingView showLodingViewInView:self.bgView andRect:self.tableView2.frame imgArr:self.loadingImageArr message:@"网络加载中"];
                    self.loadingView_lowestPriceSchool.center = CGPointMake(self.tableView2.centerX, self.tableView2.centerY - (64 + 44)/2);
                    [self loadData_lowestPriceSchool];
                    self.loadFirstTime_lowestPriceSchool = YES;
                });
            }
        }else if (index == 2) {
            if (!self.loadFirstTime_bestCommentSchool) {
                //runtime
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    //添加加载中动画
                    self.loadingView_bestCommentSchool = [HSFLodingView showLodingViewInView:self.bgView andRect:self.tableView3.frame imgArr:self.loadingImageArr message:@"网络加载中"];
                    self.loadingView_bestCommentSchool.center = CGPointMake(self.tableView3.centerX, self.tableView3.centerY - (64 + 44)/2);
                    [self loadData_bestCommentSchool];
                    self.loadFirstTime_bestCommentSchool = YES;
                });
            }
        }else if (index == 3) {
            if (!self.loadFirstTime_highestPassSchool) {
                //runtime
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    //添加加载中动画
                    self.loadingView_highestPassSchool = [HSFLodingView showLodingViewInView:self.bgView andRect:self.tableView4.frame imgArr:self.loadingImageArr message:@"网络加载中"];
                    self.loadingView_highestPassSchool.center = CGPointMake(self.tableView4.centerX, self.tableView4.centerY - (64 + 44)/2);
                    [self loadData_highestPassSchool];
                    self.loadFirstTime_highestPassSchool = YES;
                });
            }
        }
    }
    
}
#pragma mark -网络请求


//离我最近
-(void)loadData_nearbySchool
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSMutableSet *set = [NSMutableSet setWithSet:manager.responseSerializer.acceptableContentTypes];
    [set addObject:@"text/html"];
    manager.responseSerializer.acceptableContentTypes = set;
    NSDictionary *parameters = @{@"m":@"school_list",
                                 @"rndstring":[ZXDriveGOHelper getCurrentTimeStamp],
                                 @"sort":@"",
                                 @"page":@"",
                                 @"name":@"",
                                 @"school_ids":[self getSchool_ids],
                                 @"city":_city};
    [manager POST:ZX_URL parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
            
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //网络请求成功
        //用于防止频繁刷新
        self.isLoadingNew_nearbySchool = NO;
        self.isLoadingMore_nearbySchool = NO;
        //移除数据为空占位图
        [self.loadFailureView_nearbySchool dismiss];
        
        NSString *res = responseObject[@"res"];
        NSString *msg = responseObject[@"msg"];
        if ([res isEqualToString:@"1001"]) {//请求成功
            NSArray *arr = responseObject[@"school_list"];
            //再排序
            NSMutableArray* mab = [NSMutableArray array];
            NSArray* wz = [_school_ids componentsSeparatedByString:@","];
            for(int j = 0; j < wz.count; j ++)
            {
                for (int i = 0; i < arr.count; i ++)
                {
                    if ([arr[i][@"id"] isEqualToString:wz[j]])
                    {
                        [mab addObject:arr[i]];
                    }
                }
            }
            if (mab != nil && [mab isKindOfClass:[NSArray class]] && ![mab isEqual:@""] && mab.count>0)
            {
                //数据转模型
                NSMutableArray *tempArr = [NSMutableArray array];
                for (NSDictionary *dic in mab)
                {
                    SchoolListModel *model = [SchoolListModel modelWithDic:dic];
                    [tempArr addObject:model];
                }
                //判断刷新第一页时先将数据源置空
                if (self.page_nearbySchool == 0)
                {
                    [self.source_nearbySchool removeAllObjects];
                }
                //给数据源赋值
                [self.source_nearbySchool addObjectsFromArray:tempArr];
            }
            else
            {
                //page不增加
                if (self.page_nearbySchool == 0)
                {
                    self.page_nearbySchool = 0;
                }
                else
                {
                    self.page_nearbySchool--;
                }
                //重置－－不可以加载数据了
                self.isLoadingMore_nearbySchool = YES;
                [MBProgressHUD showBottomHUD:@"没有更多数据了！"];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    self.isLoadingMore_nearbySchool = NO;
                });
            }
            //判断数据为空时
            if (self.source_nearbySchool.count == 0)
            {
                self.loadFailureView_nearbySchool = [HSFLodingView showLoadFailureViewInView:self.tableView1 andRect:self.tableView1.bounds img:@"卡通" message:@"加载的数据为空!"];
                self.loadFailureView_nearbySchool.center = CGPointMake(self.tableView1.width/2, self.tableView1.centerY - (64 + 44)/2);
            }
        }
        else if ([res isEqualToString:@"1004"])
        {
            //请求过于频繁
            [MBProgressHUD showError:msg];
        }
        else if ([res isEqualToString:@"1005"])
        {
            //缺少必选参数
            [MBProgressHUD showError:msg];
        }
        else if ([res isEqualToString:@"1006"])
        {
            //排序参数错误
            [MBProgressHUD showError:msg];
        }
        //停止加载中动画
        [self.loadingView_nearbySchool dismiss];
        //停止刷新
        [self.tableView1.mj_header endRefreshing];
        [self.tableView1.mj_footer endRefreshing];
        //刷表
        [self.tableView1 reloadData];
        YZLog(@"%@",responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error)
    {
        //网络请求失败!
        [MBProgressHUD showError:@"网络请求失败!"];
        //停止刷新
        [self.tableView1.mj_header endRefreshing];
        [self.tableView1.mj_footer endRefreshing];
    }];
}

//价格最低
-(void)loadData_lowestPriceSchool{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSMutableSet *set = [NSMutableSet setWithSet:manager.responseSerializer.acceptableContentTypes];
    [set addObject:@"text/html"];
    manager.responseSerializer.acceptableContentTypes = set;
    NSDictionary *parameters = @{@"m":@"school_list",
                                 @"rndstring":[ZXDriveGOHelper getCurrentTimeStamp],
                                 @"sort":@"price",
                                 @"page":[NSString stringWithFormat:@"%d",self.page_lowestPriceSchool],
                                 @"name":@"",
                                 @"school_ids":@"",
                                 @"city":_city};
    [manager POST:ZX_URL parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //网络请求成功
        //用于防止频繁刷新
        self.isLoadingNew_lowestPriceSchool = NO;
        self.isLoadingMore_lowestPriceSchool = NO;
        //移除数据为空占位图
        [self.loadFailureView_lowestPriceSchool dismiss];
        
        NSString *res = responseObject[@"res"];
        NSString *msg = responseObject[@"msg"];
        if ([res isEqualToString:@"1001"]) {//请求成功
            NSArray *arr = responseObject[@"school_list"];
            if (arr != nil && [arr isKindOfClass:[NSArray class]] && ![arr isEqual:@""] && arr.count>0) {
                //数据转模型
                NSMutableArray *tempArr = [NSMutableArray array];
                for (NSDictionary *dic in arr) {
                    SchoolListModel *model = [SchoolListModel modelWithDic:dic];
                    [tempArr addObject:model];
                }
                //判断刷新第一页时先将数据源置空
                if (self.page_lowestPriceSchool == 0) {
                    [self.source_lowestPriceSchool removeAllObjects];
                }
                //给数据源赋值
                [self.source_lowestPriceSchool addObjectsFromArray:tempArr];
            }else{//page不增加
                if (self.page_lowestPriceSchool == 0) {
                    self.page_lowestPriceSchool = 0;
                }else{
                    self.page_lowestPriceSchool--;
                }
                //重置－－不可以加载数据了
                self.isLoadingMore_lowestPriceSchool = YES;
                [MBProgressHUD showBottomHUD:@"没有更多数据了！"];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    self.isLoadingMore_lowestPriceSchool = NO;
                });
            }
            //判断数据为空时
            if (self.source_lowestPriceSchool.count <= 0) {
                self.loadFailureView_lowestPriceSchool = [HSFLodingView showLoadFailureViewInView:self.tableView2 andRect:self.tableView2.bounds img:@"卡通" message:@"加载的数据为空!"];
                self.loadFailureView_lowestPriceSchool.center = CGPointMake(self.tableView2.width/2, self.tableView2.centerY - (64 + 44)/2);
            }
        }else if ([res isEqualToString:@"1004"]) {//请求过于频繁
            [MBProgressHUD showError:msg];
        }else if ([res isEqualToString:@"1005"]) {//缺少必选参数
            [MBProgressHUD showError:msg];
        }else if ([res isEqualToString:@"1006"]) {//排序参数错误
            [MBProgressHUD showError:msg];
        }
        //停止加载中动画
        [self.loadingView_lowestPriceSchool dismiss];
        //停止刷新
        [self.tableView2.mj_header endRefreshing];
        [self.tableView2.mj_footer endRefreshing];
        //刷表
        [self.tableView2 reloadData];
        YZLog(@"%@",responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        //网络请求失败!
        [MBProgressHUD showError:@"网络请求失败!"];
        //停止刷新
        [self.tableView1.mj_header endRefreshing];
        [self.tableView1.mj_footer endRefreshing];
    }];
}
//评价最好
-(void)loadData_bestCommentSchool{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSMutableSet *set = [NSMutableSet setWithSet:manager.responseSerializer.acceptableContentTypes];
    [set addObject:@"text/html"];
    manager.responseSerializer.acceptableContentTypes = set;
    NSDictionary *parameters = @{@"m":@"school_list",
                                 @"rndstring":[ZXDriveGOHelper getCurrentTimeStamp],
                                 @"sort":@"score",
                                 @"page":[NSString stringWithFormat:@"%d",self.page_bestCommentSchool],
                                 @"name":@"",
                                 @"school_ids":@"",
                                 @"city":_city};
    [manager POST:ZX_URL parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //网络请求成功
        //用于防止频繁刷新
        self.isLoadingNew_bestCommentSchool = NO;
        self.isLoadingMore_bestCommentSchool = NO;
        //移除数据为空占位图
        [self.loadFailureView_bestCommentSchool dismiss];
        NSString *res = responseObject[@"res"];
        NSString *msg = responseObject[@"msg"];
        if ([res isEqualToString:@"1001"]) {//请求成功
            NSArray *arr = responseObject[@"school_list"];
            if (arr != nil && [arr isKindOfClass:[NSArray class]] && ![arr isEqual:@""] && arr.count>0) {
                //数据转模型
                NSMutableArray *tempArr = [NSMutableArray array];
                for (NSDictionary *dic in arr) {
                    SchoolListModel *model = [SchoolListModel modelWithDic:dic];
                    [tempArr addObject:model];
                }
                //判断刷新第一页时先将数据源置空
                if (self.page_bestCommentSchool == 0) {
                    [self.source_bestCommentSchool removeAllObjects];
                }
                //给数据源赋值
                [self.source_bestCommentSchool addObjectsFromArray:tempArr];
            }else{//page不增加
                if (self.page_bestCommentSchool == 0) {
                    self.page_bestCommentSchool = 0;
                }else{
                    self.page_bestCommentSchool--;
                }
                //重置－－不可以加载数据了
                self.isLoadingMore_bestCommentSchool = YES;
                [MBProgressHUD showBottomHUD:@"没有更多数据了！"];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    self.isLoadingMore_bestCommentSchool = NO;
                });
            }
            //判断数据为空时
            if (self.source_bestCommentSchool.count <= 0) {
                self.loadFailureView_bestCommentSchool = [HSFLodingView showLoadFailureViewInView:self.tableView3 andRect:self.tableView3.bounds img:@"卡通" message:@"加载的数据为空!"];
                self.loadFailureView_bestCommentSchool.center = CGPointMake(self.tableView3.width/2, self.tableView3.centerY - (64 + 44)/2);
            }
        }else if ([res isEqualToString:@"1004"]) {//请求过于频繁
            [MBProgressHUD showError:msg];
        }else if ([res isEqualToString:@"1005"]) {//缺少必选参数
            [MBProgressHUD showError:msg];
        }else if ([res isEqualToString:@"1006"]) {//排序参数错误
            [MBProgressHUD showError:msg];
        }
        //停止加载中动画
        [self.loadingView_bestCommentSchool dismiss];
        //停止刷新
        [self.tableView3.mj_header endRefreshing];
        [self.tableView3.mj_footer endRefreshing];
        //刷表
        [self.tableView3 reloadData];
        YZLog(@"%@",responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        //网络请求失败!
        [MBProgressHUD showError:@"网络请求失败!"];
        //停止刷新
        [self.tableView1.mj_header endRefreshing];
        [self.tableView1.mj_footer endRefreshing];
    }];
}
//通过率高
-(void)loadData_highestPassSchool{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSMutableSet *set = [NSMutableSet setWithSet:manager.responseSerializer.acceptableContentTypes];
    [set addObject:@"text/html"];
    manager.responseSerializer.acceptableContentTypes = set;
    NSDictionary *parameters = @{@"m":@"school_list",
                                 @"rndstring":[ZXDriveGOHelper getCurrentTimeStamp],
                                 @"sort":@"avg_rate",
                                 @"page":[NSString stringWithFormat:@"%d",self.page_highestPassSchool],
                                 @"name":@"",
                                 @"school_ids":@"",
                                 @"city":_city};
    [manager POST:ZX_URL parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //网络请求成功
        //用于防止频繁刷新
        self.isLoadingNew_highestPassSchool = NO;
        self.isLoadingMore_highestPassSchool = NO;
        //移除数据为空占位图
        [self.loadFailureView_highestPassSchool dismiss];
        
        NSString *res = responseObject[@"res"];
        NSString *msg = responseObject[@"msg"];
        if ([res isEqualToString:@"1001"]) {//请求成功
            NSArray *arr = responseObject[@"school_list"];
            if (arr != nil && [arr isKindOfClass:[NSArray class]] && ![arr isEqual:@""] && arr.count>0) {
                //数据转模型
                NSMutableArray *tempArr = [NSMutableArray array];
                for (NSDictionary *dic in arr) {
                    SchoolListModel *model = [SchoolListModel modelWithDic:dic];
                    [tempArr addObject:model];
                }
                //判断刷新第一页时先将数据源置空
                if (self.page_highestPassSchool == 0) {
                    [self.source_highestPassSchool removeAllObjects];
                }
                //给数据源赋值
                [self.source_highestPassSchool addObjectsFromArray:tempArr];
            }else{//page不增加
                if (self.page_highestPassSchool == 0) {
                    self.page_highestPassSchool = 0;
                }else{
                    self.page_highestPassSchool--;
                }
                //重置－－不可以加载数据了
                self.isLoadingMore_highestPassSchool = YES;
                [MBProgressHUD showBottomHUD:@"没有更多数据了！"];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    self.isLoadingMore_highestPassSchool = NO;
                });
            }
            //判断数据为空时
            if (self.source_highestPassSchool.count <= 0) {
                self.loadFailureView_highestPassSchool = [HSFLodingView showLoadFailureViewInView:self.tableView4 andRect:self.tableView4.bounds img:@"卡通" message:@"加载的数据为空!"];
                self.loadFailureView_highestPassSchool.center = CGPointMake(self.tableView4.width/2, self.tableView4.centerY - (64 + 44)/2);
            }
        }else if ([res isEqualToString:@"1004"]) {//请求过于频繁
            [MBProgressHUD showError:msg];
        }else if ([res isEqualToString:@"1005"]) {//缺少必选参数
            [MBProgressHUD showError:msg];
        }else if ([res isEqualToString:@"1006"]) {//排序参数错误
            [MBProgressHUD showError:msg];
        }
        //停止加载中动画
        [self.loadingView_highestPassSchool dismiss];
        //停止刷新
        [self.tableView4.mj_header endRefreshing];
        [self.tableView4.mj_footer endRefreshing];
        //刷表
        [self.tableView4 reloadData];
        YZLog(@"%@",responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        //网络请求失败!
        [MBProgressHUD showError:@"网络请求失败!"];
        //停止刷新
        [self.tableView1.mj_header endRefreshing];
        [self.tableView1.mj_footer endRefreshing];
    }];
}


//取出10条school拼接school_ids
-(NSString *)getSchool_ids{
    NSString* str=@"";
    if (_schoolid!=self.source_schoolLocation.count)
    {

        int i=_schoolid+10;
        if (self.source_schoolLocation.count > 0)
        {
            for (int j=_schoolid; j<i; j++)
            {
               
                if (_schoolid==i-1 || _schoolid==self.source_schoolLocation.count-1)
                {
                    str=[str stringByAppendingString:[NSString stringWithFormat:@"%@",self.source_schoolLocation[_schoolid][@"bh"]]];
                     _schoolid++;
                                       break;
                }
                else
                {
                    str=[str stringByAppendingString:[NSString stringWithFormat:@"%@,",self.source_schoolLocation[_schoolid][@"bh"]]];
                    _schoolid++;
                   
                }
            }
            _school_ids=str;
            return  str;
        }
    }
   
    _school_ids=str;
    return str;
}

//驾校距离
-(NSString *)getOtherTypeSchoolistanceWithSchoolID:(id)ID{
    
   
    for (int i=0; i<self.source_schoolLocation.count; i++)
    {
        if ([self.source_schoolLocation[i][@"bh"] isEqualToString:ID])
        {
            if([self.source_schoolLocation[i][@"jl"] integerValue]==0)
            {
                return @"--";
            }
            if ([self.source_schoolLocation[i][@"jl"] floatValue]>1000)
            {
                return [NSString stringWithFormat:@"%0.2f千米",[self.source_schoolLocation[i][@"jl"] floatValue]/1000.0];
            }
            else
            {
                 return [NSString stringWithFormat:@"%.2f米",[self.source_schoolLocation[i][@"jl"] floatValue]];
            }
        }
    }
    return @"--";
}


#pragma mark -didReceiveMemoryWarning
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}



@end

//
//  HSFNestVC.m
//  HSFDemo
//
//  Created by JuZhenBaoiMac on 2017/6/23.
//  Copyright © 2017年 JuZhenBaoiMac. All rights reserved.
//

#import "HSFNestVC.h"

#import "HSFTableView.h"
#import "HSFTableCell.h"
#import "MLMSegmentManager.h"
#import "HSFBaseTableVC.h"
#import "UIImage+color.h"



@interface HSFNestVC ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic,strong) HSFTableCell *cell;

@property (nonatomic,strong) NSArray *childVCs;
@property (nonatomic,strong) NSArray *categoryTitles;



@property (nonatomic,assign) BOOL canScroll;//默认刚开始是YES
@property (nonatomic,assign) CGFloat offset_y;

//header
@property (nonatomic,assign) BOOL isHaveHeader;
@property (nonatomic,strong) UIView *header;
@property (nonatomic,strong) UIImageView *headerImgView;
//segHead 的 moreBtn
@property (nonatomic,assign) BOOL isHaveMoreBtn;
@property (nonatomic,strong) UIView *moreBtn;

@property (nonatomic,assign) CGPoint offset;

@end

@implementation HSFNestVC

#pragma mark -只要调用这3个方法就可以了  titles: ->  @[@{@"title":@"", @"icon":@""}]
-(void)setUpWithVCs:(NSArray*)VCs titles:(NSArray *)titles{
    self.childVCs = VCs;
    self.categoryTitles = titles;
    [self.tableView reloadData];
}
-(void)setUpHeaderImg:(NSString *)imgName{
    self.isHaveHeader = YES;
    self.tableView.tableHeaderView = self.header;
    self.headerImgView.image = [UIImage imageNamed:imgName];
    [self.tableView reloadData];
}
-(void)setUpMoreBtn:(UIView *)moreBtn{
    self.isHaveMoreBtn = YES;
    self.moreBtn = moreBtn;
    [self.tableView reloadData];
}

#pragma mark -懒加载
-(UIView *)header{
    if (!_header) {
        _header = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, k_Header_Height)];
        _header.backgroundColor = [UIColor lightGrayColor];
        self.headerImgView = [[UIImageView alloc]initWithFrame:_header.bounds];
        self.headerImgView.contentMode = UIViewContentModeScaleAspectFill;
        self.headerImgView.layer.masksToBounds = YES;
        [_header addSubview:self.headerImgView];
    }
    return _header;
}
#pragma mark -viewDidLoad
- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.view.backgroundColor = [UIColor whiteColor];
    //配置tableView
    [self setUpTableView];
    //默认刚开始是YES
    self.canScroll = YES;
    //通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeVCScrollState:) name:@"changeVCScrollState" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeSegScrollEnable:) name:@"changeSegScrollEnable" object:nil];
}
//配置tableView
-(void)setUpTableView{
    self.tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    self.tableView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [self.view addSubview:self.tableView];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.estimatedRowHeight = 44;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.directionalLockEnabled = YES;
    self.tableView.bounces = NO;
    //注册cell
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([HSFTableCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([HSFTableCell class])];
}
#pragma mark -UITableViewDelegate,UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    self.cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HSFTableCell class]) forIndexPath:indexPath];
    [self setUpSegment];
    return self.cell;
}
//cell 高度
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.isClearNavi) {
        return tableView.frame.size.height - 64;
    }else{
        return tableView.frame.size.height;
    }
}


#pragma mark - 添加子控制器
- (void)setUpSegment {
//    NSArray *list = @[@"商品",
//                      @"商家信息",
//                      @"评价"];
    
    NSArray *list = self.categoryTitles;
    _segHead = [[MLMSegmentHead alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.segHead_height) titles:list headStyle:SegmentHeadStyleLine layoutStyle:MLMSegmentLayoutDefault];
    if (self.isHaveMoreBtn) {
        _segHead.moreButton = self.moreBtn;
        _segHead.moreButton_width = self.moreBtn.width;
    }
    _segHead.fontScale = 1.0;
    _segHead.fontSize = 14;
    _segHead.deSelectColor = [UIColor lightGrayColor];
    _segHead.selectColor = [UIColor redColor];
    _segHead.lineScale = 1;
    _segHead.lineColor = [UIColor redColor];
    
    _segScroll = [[MLMSegmentScroll alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_segHead.frame), SCREEN_WIDTH, self.tableView.frame.size.height - _segHead.height - 64) vcOrViews:[self vcArr:list.count]];
    _segScroll.loadAll = YES;
    _segScroll.showIndex = 0;
    _segScroll.directionalLockEnabled = YES;
    
    [MLMSegmentManager associateHead:_segHead withScroll:_segScroll completion:^{
        [_segHead removeFromSuperview];
        [_segScroll removeFromSuperview];
        [self.cell.contentView addSubview:_segHead];
        [self.cell.contentView addSubview:_segScroll];
    }];
}

- (NSArray *)vcArr:(NSInteger)count {
    NSMutableArray *arr = [NSMutableArray array];
    for (int i = 0; i < self.childVCs.count; i++) {
        HSFBaseTableVC *vc = self.childVCs[i];
        [arr addObject:vc];
    }
    return arr;
}
#pragma mark -通知
-(void)changeVCScrollState:(NSNotification *)sender{
    self.canScroll = YES;
    for (int i = 0; i < self.childVCs.count; i++) {
        id vc = self.childVCs[i];
        if ([vc isKindOfClass:[HSFBaseTableVC class]]) {
            HSFBaseTableVC *vc_new = (HSFBaseTableVC *)vc;
            vc_new.vcCanScroll = NO;
        }else if ([vc isKindOfClass:[HSFBaseCollectionVC class]]) {
            HSFBaseCollectionVC *vc_new = (HSFBaseCollectionVC *)vc;
            vc_new.vcCanScroll = NO;
        }
        
    }
}
-(void)changeSegScrollEnable:(NSNotification *)sender{
//    NSDictionary *userInfo = sender.userInfo;
//    NSString *enable = userInfo[@"enable"];
//    
//    if ([enable isEqualToString:@"0"]) {
//        [self.segScroll setScrollEnabled:NO];
//    }else if ([enable isEqualToString:@"1"]) {
//        [self.segScroll setScrollEnabled:YES];
//    }
}

#pragma mark -UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    if (scrollView == self.tableView) {
        
        self.offset_y = scrollView.contentOffset.y;
        NSLog(@"offset_y = %f",self.offset_y);
        //下拉放大header
        if (self.isHaveHeader) {
            CGFloat deta = ABS(self.offset_y);
            if (self.offset_y <= 0) {
                self.headerImgView.frame = CGRectMake(0, -deta, self.view.frame.size.width, k_Header_Height + deta);
            }
        }
        
        //渐变色
        CGFloat changeSpace = 100;//颜色变化的范围 必须 <= k_headerHeight
        CGFloat start_y = k_headerHeight - changeSpace;
        CGFloat alpha = 0;
        alpha = (self.offset_y - start_y)/changeSpace;
        if (self.isClearNavi) {
            [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:[k_themeColor colorWithAlphaComponent:alpha]] forBarMetrics:UIBarMetricsDefault];
        }
        
        
        /* 关键 */
        CGFloat headerOffset = 0.0;
        if (self.isClearNavi) {
            if (self.isHaveHeader) {
                headerOffset = k_Header_Height - 64;
            }else{
                headerOffset = 64;
            }
        }else{
            if (self.isHaveHeader) {
                headerOffset = k_Header_Height;
            }else{
                headerOffset = 0.0;
            }
        }
        
        if (self.offset_y >= headerOffset) {
            scrollView.contentOffset = CGPointMake(0, headerOffset);
            if (self.canScroll) {
                self.canScroll = NO;
                for (int i = 0; i < self.childVCs.count; i++) {
                    HSFBaseTableVC *vc = self.childVCs[i];
                    vc.vcCanScroll = YES;
                }
            }
        }else{
            if (!self.canScroll) {
                scrollView.contentOffset = CGPointMake(0, headerOffset);
            }
        }
        self.tableView.showsVerticalScrollIndicator = _canScroll?YES:NO;
    }
    
    
}
//- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset NS_AVAILABLE_IOS(5_0){
//     [self.segScroll setScrollEnabled:YES];
//     [self.tableView setScrollEnabled:YES];
//}





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

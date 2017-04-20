//
//  KnCellType1VC.m
//  yuntangyi
//
//  Created by yuntangyi on 16/8/30.
//  Copyright © 2016年 yuntangyi. All rights reserved.
//

#import "KnCellType1VC.h"

#import "SZBNetDataManager+KnowLedgeNetData.h"
#import "KnMeetingInfoModel.h"
#import "KnCellType1_1Cell.h"
#import "KnCellType1_2Cell.h"
#import "KnSignUpDetailVC.h"
#import "UINavigationBar+Background.h"
#import "SZBAlertView.h"
#import "MeetingDetailVC.h"


@interface KnCellType1VC ()<UITableViewDelegate,UITableViewDataSource,RemoveSelf,KnSignUpDetailVCDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;//
@property (weak, nonatomic) IBOutlet UIButton *signNameBtn;//报名按钮
@property (nonatomic,strong) NSString *message;//立即报名信息
@property (nonatomic,strong) NSArray *iconAndTitleArr;//图标和标题
@property (nonatomic,strong) KnMeetingInfoModel *meetingInfoModel;//数据源模型
@property (nonatomic,strong) SZBAlertView *AlertV;

@property (nonatomic,strong) LoadingView *loadingView;//加载中动画
@property (nonatomic,strong) NetworkLoadFailureView *loadFailureView;//加载失败图片
@property (nonatomic, strong)KongPlaceHolderView *placeholdView;//数据为空图片

@property (nonatomic,assign) BOOL showDetail;//是否显示会议详情
@property (nonatomic,assign) BOOL signAndBack;//是否点击过报名 并返回
@end


static NSString *identifierCell1 = @"identifierCell1";
static NSString *identifierCell2 = @"identifierCell2";
@implementation KnCellType1VC
//初始化方法
-(instancetype)init{
    if (self = [super init]) {
        self.hidesBottomBarWhenPushed = YES;
    }
    return self;
}
#pragma mark -网络请求
//会议详情
-(void)loadMeeting_infoDataWith:(NSString *)ID{
    self.loadFailureView.userInteractionEnabled = NO;
    [self.loadFailureView.loadAgainBtn setBackgroundColor:[UIColor whiteColor]];
    [self.loadFailureView.loadAgainBtn setTitleColor:KRGB(0, 172, 204, 1) forState:UIControlStateNormal];
    [self.loadFailureView.loadAgainBtn setTitle:@"努力加载中.." forState:UIControlStateNormal];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(10 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.loadFailureView.userInteractionEnabled = YES;
        [self.loadFailureView.loadAgainBtn setBackgroundColor:KRGB(0, 172, 204, 1)];
        [self.loadFailureView.loadAgainBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.loadFailureView.loadAgainBtn setTitle:@"重新加载" forState:UIControlStateNormal];
    });
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSMutableSet *set = [NSMutableSet setWithSet:manager.responseSerializer.acceptableContentTypes];
    [set addObject:@"text/html"];
    NSLog(@"%@", [NSString stringWithFormat:SMeeting_info_Url, ID, [ToolManager getCurrentTimeStamp], [ZXUD objectForKey:@"ident_code"]]);
    manager.responseSerializer.acceptableContentTypes = set;
    manager.responseSerializer.acceptableContentTypes = set;
    [manager GET:[NSString stringWithFormat:SMeeting_info_Url, ID, [ToolManager getCurrentTimeStamp], [ZXUD objectForKey:@"ident_code"]] parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [self.loadFailureView removeFromSuperview];//移除加载失败图片
        //网络请求成功
        if ([responseObject[@"res"] isEqualToString:@"1001"]) {
            //数据转模型
            NSDictionary *resultDict = responseObject[@"resault"];
            _meetingInfoModel = [KnMeetingInfoModel modelWithDict:resultDict];
            
            //是否可以报名
            if ([_meetingInfoModel.status isEqual:@0]) {
                self.signNameBtn.userInteractionEnabled = YES;
                [self.signNameBtn setBackgroundColor:KRGB(0, 172, 204, 1)];
            }else if ([_meetingInfoModel.status isEqual:@1]) {
                self.signNameBtn.userInteractionEnabled = NO;
                [self.signNameBtn setBackgroundColor:[UIColor lightGrayColor]];
            }
        }else if ([responseObject[@"res"] isEqualToString: @"1005"] || [responseObject[@"res"] isEqualToString: @"1004"]) {
            
        }else{
            NSString *message = responseObject[@"msg"];
            [MBProgressHUD showError:message];
        }
        [self.loadingView dismiss];//加载动画停止
        [_tableView reloadData];//刷新tableView
        NSLog(@"%@",responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        //网络加载失败
        [self.loadingView dismiss];//加载动画停止
        [self.loadFailureView removeFromSuperview];//移除加载失败图片
        [self.view addSubview:self.loadFailureView];//加载失败图片
        [self.loadFailureView.loadAgainBtn addTarget:self action:@selector(loadAgainBtnAction) forControlEvents:UIControlEventTouchUpInside];
    }];
}
//点击重新加载
-(void)loadAgainBtnAction{
    [self loadMeeting_infoDataWith:self.meetingID];
}
#pragma mark -懒加载
-(NSArray *)iconAndTitleArr{
    if (!_iconAndTitleArr) {
        _iconAndTitleArr = @[@{@"icon":@"kn_meeting_host",@"title":@"会议演讲人"},
                             @{@"icon":@"kn_meeting_location",@"title":@"会议地点"},
                             @{@"icon":@"kn_meeting_time",@"title":@"会议时间"},
                             @{@"icon":@"kn_meeting_people",@"title":@"会议人数"},
                             @{@"icon":@"kn_meeting_note",@"title":@"报名须知"}];
    }
    return _iconAndTitleArr;
}
#pragma mark -导航栏设置
-(void)setUpNavi{
    //解决无故偏移的问题
    self.automaticallyAdjustsScrollViewInsets = NO;
    //返回按钮
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"返回"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStyleDone target:self action:@selector(backAction)];
}
//返回
-(void)backAction{

    // 用户点击过报名按钮
    if (self.signAndBack) {
        //更新meeting UI
        NSString *doType;
        //是否可以报名
        if ([_meetingInfoModel.status isEqual:@0]) {//可以报名
            if ([_meetingInfoModel.is_exist integerValue]) {//有报名
                doType = @"0";
            }else{//没有报名
                doType = @"";
            }
        }else if ([_meetingInfoModel.status isEqual:@1]) {//不可以报名
            doType = @"";
        }
        [self.delegate updateMeetingWithDoType:doType andIndex:self.index];
    }else{
        [self.delegate updateMeetingUIWithIndex:self.index];//更新meeting UI
    }

    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark -viewWillAppear
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.barTintColor = KRGB(253, 254, 255, 1);
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSFontAttributeName:[UIFont systemFontOfSize:20],NSForegroundColorAttributeName:KRGB(0, 172, 204, 1)}];
    self.navigationItem.title = @"会议详情";
//    //透明设置
//    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
//    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
//    [self.tableView setContentOffset:CGPointMake(0, 0) animated:NO];//回到顶部
}
#pragma mark - viewDidLoad
- (void)viewDidLoad {
    [super viewDidLoad];
    //标题
    //配置导航栏
    [self setUpNavi];
    //配置报名按钮
    [self setUpSignNameBtn];
    //配置tableView
    [self setUpTableView];
    //网络加载图片（加载中  加载失败  空数据）
    _loadingView = [[LoadingView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight)];
    _loadingView.center = CGPointMake(KScreenWidth/2, KScreenHeight/2);
    _loadFailureView = [[NetworkLoadFailureView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight)];
    _loadFailureView.center = CGPointMake(KScreenWidth/2, KScreenHeight/2);
    //加载数据
    [self.view addSubview:self.loadingView];
    [self loadMeeting_infoDataWith:self.meetingID];
}

#pragma mark -viewWillDisappear
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.tableView.mj_header endRefreshing];
//    [self.navigationController.navigationBar cnReset];
    self.showDetail = NO;
}
//配置报名按钮
-(void)setUpSignNameBtn{
    [_signNameBtn setTitle:@"立即报名" forState:UIControlStateNormal];
    [_signNameBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.signNameBtn.userInteractionEnabled = NO;
    [self.signNameBtn setBackgroundColor:[UIColor lightGrayColor]];
}
//配置tableView
-(void)setUpTableView{
    //设置代理
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    //注册cell/header
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([KnCellType1_1Cell class]) bundle:nil] forCellReuseIdentifier:identifierCell1];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([KnCellType1_2Cell class]) bundle:nil] forCellReuseIdentifier:identifierCell2];
    //添加tableView的footerView
    UILabel *footer = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 0, 40)];
    footer.textAlignment = NSTextAlignmentCenter;
    footer.textColor = [UIColor lightGrayColor];
    footer.font = [UIFont systemFontOfSize:15];
    footer.backgroundColor = [UIColor whiteColor];
    footer.text = @"——— 继续上拉查看更多详情 ————";
    self.tableView.tableFooterView = footer;
    //高度
    self.tableView.estimatedRowHeight = 44;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.sectionFooterHeight = 10;
}

#pragma mark -UITableViewDelegate,UITableViewDataSource
//组数
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 6;
}
//行数
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
//行内容
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        KnCellType1_1Cell *cell1 = [tableView dequeueReusableCellWithIdentifier:identifierCell1 forIndexPath:indexPath];
        cell1.doType = self.doType;
        cell1.meetingInfoModel = self.meetingInfoModel;
        
        return cell1;
    }else {
        KnCellType1_2Cell *cell2 = [tableView dequeueReusableCellWithIdentifier:identifierCell2 forIndexPath:indexPath];
        cell2.iconAndTitleDic = self.iconAndTitleArr[indexPath.section - 1];
        //配置数据
        if (indexPath.section == 1) {//会议演讲人
            cell2.content.text = self.meetingInfoModel.actor;
        }else if (indexPath.section == 2) {//会议地址
            cell2.content.text = self.meetingInfoModel.address;
        }else if (indexPath.section == 3) {//会议时间
            cell2.content.text = self.meetingInfoModel.start_time;
        }else if (indexPath.section == 4) {//会议人数
            NSString *signedNum = self.meetingInfoModel.entered_num;
            NSNumber *lastNum = self.meetingInfoModel.surplus_num;
            if (!signedNum) {
                signedNum = @"0";
            }
            if (!lastNum) {
                lastNum = @0;
            }
            cell2.content.text = [NSString stringWithFormat:@"可报名：%@，剩余人数：%@", signedNum, lastNum];
        }else if (indexPath.section == 5) {//报名须知
            cell2.content.text = self.meetingInfoModel.note;
        }
        return cell2;
    }
    return nil;
}
- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath{
    return NO;
}
//-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    [tableView deselectRowAtIndexPath:indexPath animated:NO];
//}
//Header高度
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.1;
}
//footer高度
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 10;
}
//点击立即报名
- (IBAction)signNameAction:(UIButton *)sender {
    _AlertV = [[SZBAlertView alloc]initWithFrame:self.view.frame];
    _AlertV.agency = self;
    _AlertV.type = SZBAlertType1;
    NSString *meetingName;
    if (!_meetingInfoModel.meeting_name || [_meetingInfoModel.meeting_name isKindOfClass:[NSNull class]] || [_meetingInfoModel.meeting_name isEqualToString:@""]) {
        meetingName = @" ";
    }else{
        meetingName = _meetingInfoModel.meeting_name;
    }
    NSDictionary *contentDic = @{@"title":@"报名",@"message":[NSString stringWithFormat:@"您确认报名会议－《%@》吗？",meetingName]};
    _AlertV.contentDic = contentDic;
    [self.view addSubview:_AlertV];
    //注册通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cancelAction) name:SZBAlertView1Noti_cancel object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(okAction) name:SZBAlertView1Noti_ok object:nil];
}
//点击确认
-(void)okAction{
    KnSignUpDetailVC *signUpDetail_VC = [[KnSignUpDetailVC alloc]init];
    signUpDetail_VC.mid = self.meetingInfoModel.mid;
    signUpDetail_VC.delegate = self;
    signUpDetail_VC.doType = self.doType;
    UINavigationController *navi = [[UINavigationController alloc]initWithRootViewController:signUpDetail_VC];
    [self presentViewController:navi animated:YES completion:nil];
    [_AlertV removeFromSuperview];
}
//点击取消
-(void)cancelAction{
    [_AlertV removeFromSuperview];
}
//取消报名
-(void)removeSelfAction{
    [_AlertV removeFromSuperview];
}

#pragma mark -导航栏渐变效果
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    self.showDetail = YES;
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
//    if (scrollView.contentOffset.y <= 10) {
//        [self.navigationController.navigationBar setTitleTextAttributes:
//         @{NSFontAttributeName:[UIFont systemFontOfSize:19],NSForegroundColorAttributeName:[UIColor clearColor]}];
//    }else{
//        [self.navigationController.navigationBar setTitleTextAttributes:
//         @{NSFontAttributeName:[UIFont systemFontOfSize:19],NSForegroundColorAttributeName:KRGB(0, 172, 204, 1)}];
//    }
//    UIColor *color = KRGB(253, 254, 255, 1);
//    CGFloat alpha = MIN(1, scrollView.contentOffset.y / 200);
//    if (scrollView.contentOffset.y > 0) {
//        [self.navigationController.navigationBar cnSetBackgroundColor:[color colorWithAlphaComponent:alpha]];
//    }else{
//        [self.navigationController.navigationBar cnSetBackgroundColor:[color colorWithAlphaComponent:0]];
//    }
    
    if (self.showDetail) {
        //继续上拉显示会议详情
        CGFloat deta = self.tableView.contentSize.height - self.tableView.frame.size.height;
        if (scrollView.contentOffset.y > deta + 80) {
            MeetingDetailVC *meetingDetail_VC = [[MeetingDetailVC alloc]init];
            meetingDetail_VC.content_url = self.meetingInfoModel.content_url;
            UINavigationController *navi = [[UINavigationController alloc]initWithRootViewController:meetingDetail_VC];
            [self presentViewController:navi animated:YES completion:nil];
        }
    }
    

}

-(void)returnSignUpStatus:(NSNumber *)is_exist{
    //是否报名该会议
    _meetingInfoModel.is_exist = is_exist;
    //是否可以报名
    if ([_meetingInfoModel.status isEqual:@0]) {
        if ([_meetingInfoModel.is_exist integerValue]) {
            self.signNameBtn.userInteractionEnabled = NO;
            [self.signNameBtn setBackgroundColor:[UIColor lightGrayColor]];
        }else{
            self.signNameBtn.userInteractionEnabled = YES;
            [self.signNameBtn setBackgroundColor:KRGB(0, 172, 204, 1)];
        }
    }else if ([_meetingInfoModel.status isEqual:@1]) {
        self.signNameBtn.userInteractionEnabled = NO;
        [self.signNameBtn setBackgroundColor:[UIColor lightGrayColor]];
    }
    self.signAndBack = YES;
    [self.tableView reloadData];
    
//    //加载数据
//    [self.view addSubview:self.loadingView];
//    [self loadMeeting_infoDataWith:self.meetingID];
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
